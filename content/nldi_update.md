In August 2020, the Hydro Network Linked Data Index (NLDI) was updated
with some new functionality and some changes to the existing Web
Application Programming Interface (API). This post summarizes these
changes and demonstrates Python and R clients available to work with the
functionality.

If you are new to the NLDI, visit the
[nldi-intro](https://waterdata.usgs.gov/blog/nldi-intro/) blog to get up
to speed. This post assumes a basic understanding of the API.

Summary
-------

The new functionality added to the NLDI is the ability to retrieve local
or accumulated catchment characteristics for any `featureSource`
available from the system. A selection of characteristics from [this
data
release](https://www.sciencebase.gov/catalog/item/5669a79ee4b08895842a1d470)
are included. This is detailed further down in this post.

API changes are backward compatible but fairly significant. - If using a
web-browser, `?f=json` needs to be appended to requests to see JSON
content. - The `navigate` endpoint is deprecated in favor of a
`navigation` end point with slightly different behavior. -- previously,
a `navigate/{navigationMode}` request would return flowlines. The
`navigation/{navigationMode}` endpoint now returns available
`dataSources`, treating flowlines as a data source. -- All
`navigationMode`s now require the `distance` query parameter.
Unconstrained navigation queries (the default from the `navigate`
endpoint) were causing system performance problems. Client applications
must now explicitly request very large upstream with tributaries queries
to avoid performance issues due to naive client requests. - All features
in a `featureSource` can now be accessed at the `featureSource`
endpoint. This will allow clients to easily create map-based selection
interfaces. - A `featureSource` can now be queried with a lat/lon point
encoded in `WKT` format.

API Updates Detail
------------------

The API updates were tracked in a [github release
here.](https://github.com/ACWI-SSWD/nldi-services/issues?q=is%3Aissue+milestone%3AV+is%3Aclosed)
These updates aimed to make the API more consistent and improve overall
scalability of the system. The following sections describe the changes
in some detail.

### Media type handling changes.

Previous to the recent release, the NLDI only supported JSON responses.
This caused problems in a browser when an unsuspecting person accessed
an API request that returned a large JSON document in a Web browser. To
protect against this, any request from with Accept headers preferring
text/html content (e.g. from a Web browser) is provided an HTML response
containing a link to the JSON content. An Accept header override --
`?f=json` -- is used for this behavior. If requests are made without an
Accept header, JSON content is returned.

This behavior can be seen at any endpoint exposed by the NLDI. e.g. open
the following url in a browser.
<https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-05429700>

### Navigation end point.

The original NLDI `.../navigate` end point had a design inconsistency
and behavior that led to needless high-cost queries. `.../navigate` has
been deprecated and a `.../navigation` endpoint has been introduced in
its place.

The most significant change is the resource returned from a particular
navigation mode endpoint. e.g.
<https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-05429700/navigation/UM>
is now a JSON document listing available data sources that can be
accessed for the upstream main navigation from the featureID
USGS-05429700 from the nwissite featureSource. In contrast, the
`.../navigate/UM` returns GeoJSON containing flowlines for the upstream
main navigation. The same flowlines GeoJSON is now a dataSource listed
along side the others available for the `.../navigation/UM` end point.

The other significant difference between the `.../navigate` and
`.../navigation` endpoints is that the `distance` (in km) query
parameter is now required. Previously, the internal default was set to
9999 which resulted in many very large requests that may or may not have
been desired. There is no upper limit to the value of the `distance`
parameter, but it must be provided for the navigation end point to
trigger a query to the NLDI's database. Client developers are encouraged
to choose a sensible default such that naive users will not accidentally
trigger very large queries and be aware that the NLDI is capable of
producing result sets with hundreds of thousands of features.

### Feature Source Access

Prior to this release, end points such as:
<https://labs.waterdata.usgs.gov/api/nldi/linked-data/huc12pp> did not
return a resource. This made it difficult to discover available feature
sources. This `featureSource` end point now returns a GeoJSON document
containing all features from the requested feature source. These are
quite large and no further query functions are implemented. In future
releases, an OGC API Features interface may be made available to allow
queries against the feature sources.

Catchment Characteristics
-------------------------

The correspondence between feature sources and NHDPlusV2 catchments is
important to understand for catchment characteristics.

At its core, the NLDI contains the NHDPlusV2 catchment network. As such,
all navigation requests resolve to the nearest catchment and an
equivalent query can be made directly to the COMID that a feature source
is indexed to. e.g.

`https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-05429700/navigation/`

is equivalent to:

`https://labs.waterdata.usgs.gov/api/nldi/linked-data/comid/13297194/navigation/`

because `nwissite/USGS-05429700` is indexed to `comid/13297194`.

Given this, we can access catchment characteristics for a catchment or
an indexed feature with the `local`, `tot`, or `div` end points. e.g.

`https://labs.waterdata.usgs.gov/api/nldi/linked-data/comid/13297194/local`

or

`https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-05429700/local`

provide exactly the same content.

-   The `local` end point provides characteristics for the local
    catchment.
-   The `tot` end point provides total-upstream characteristics.
-   The `div` end point provides divergence-routed upstream
    characteristics.

Documentation for the source dataset and creation methods [can be found
here.](https://www.sciencebase.gov/catalog/item/5669a79ee4b08895842a1d47)

An endpoint to lookup metadata for specific characteristics is available
here:

`https://labs.waterdata.usgs.gov/api/nldi/lookups`

Only selected catchment characteristics from the source data release are
included at this time. More may be added in the future. Please reach out
in a github issue
[here](https://github.com/ACWI-SSWD/nldi-services/issues) to request
additiona characteristics be added.

Python Client Application
-------------------------

Let's use [PyNHD](https://github.com/cheginit/pynhd) to demonstrate new
NLDI's capabilities. Based on a topologically sorted river network
`pynhd.vector_accumulation` function computes the accumulation of an
attribute in the network. We use the upstream river network of
USGS-01031500 station as an example. This station is located in a
natural watershed and is located in Piscataquis County, Maine with a
drainage area of 298 square miles. First, lets use NLDI's navigation
end-point to get all its upstream NHDPlus Common Identifiers (ComIDs).

    from pynhd import NLDI, WaterData
    import pynhd as nhd

    nldi = NLDI()
    comids = nldi.navigate_byid(
        fsource="nwissite",
        fid="USGS-01031500",
        navigation="upstreamTributaries",
        source="flowlines",
        distance=1000,
    ).nhdplus_comid.to_list()

Then, we use
[WaterData](https://labs.waterdata.usgs.gov/geoserver/index.html)
GeoServer to get all the NHDPlus attributes of the these ComIDs.

    wd = WaterData("nhdflowline_network")
    flw = wd.byid("comid", comids)
    flw = nhd.prepare_nhdplus(flw, 0, 0, purge_non_dendritic=False)

Next, we should sort the ComIDs topologically.

    flw = nhd.prepare_nhdplus(flw, 0, 0, purge_non_dendritic=False)

The available characteristic IDs for any of the three characteristic
types (`local`, `tot`, `div`) can be found using `get_validchars` method
of `NLDI` class. For example, let's take a look at the `local`
characteristic type:

    char_ids = nldi.get_validchars("local")
    print(char_ids.head(5))

    ##                                     characteristic_description  ... characteristic_type
    ## CAT_BFI      Base Flow Index (BFI), The BFI is a ratio of b...  ...     localCatch_name
    ## CAT_CONTACT  Subsurface flow contact time index. The subsur...  ...     localCatch_name
    ## CAT_ET       Mean-annual actual evapotranspiration (ET), es...  ...     localCatch_name
    ## CAT_EWT      Average depth to water table relatice to the l...  ...     localCatch_name
    ## CAT_HGA      Percentage of Hydrologic Group A soil. -9999 d...  ...     localCatch_name
    ## 
    ## [5 rows x 7 columns]

Let's pick `CAT_RECHG` attribute which is Mean Annual Groundwater
Recharge in mm/yr, and carry out the accumulation.

    char = "CAT_RECHG"
    area = "areasqkm"

    local = nldi.getcharacteristic_byid(comids, "local", char_ids=char)
    flw = flw.merge(local[char], left_on="comid", right_index=True)

    def runoff_acc(qin, q, a):
        return qin + q * a

    flw_r = flw[["comid", "tocomid", char, area]]
    runoff = nhd.vector_accumulation(flw_r, runoff_acc, char, [char, area])

    def area_acc(ain, a):
        return ain + a

    flw_a = flw[["comid", "tocomid", area]]
    areasqkm = nhd.vector_accumulation(flw_a, area_acc, area, [area])

    runoff /= areasqkm

For plotting the results we need to get the catchments' geometries since
these attributes are catchment-scale.

    wd = WaterData("catchmentsp")
    catchments = wd.byid("featureid", comids)

    c_local = catchments.merge(local, left_on="featureid", right_index=True)
    c_acc = catchments.merge(runoff, left_on="featureid", right_index=True)

Upon merging the accumulated attributes with the catchments dataframe,
we can plot the results.

    import cmocean.cm as cmo
    import matplotlib.pyplot as plt


    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 8), dpi=100)
    cmap = cmo.deep
    norm = plt.Normalize(vmin=c_local.CAT_RECHG.min(), vmax=c_acc.acc_CAT_RECHG.max())

    c_local.plot(ax=ax1, column=char, cmap=cmap, norm=norm)
    flw.plot(ax=ax1, column="streamorde", cmap="Blues", scheme='fisher_jenks')

    ## <AxesSubplot:>

    ax1.set_title("Groundwater Recharge (mm/yr)");

    c_acc.plot(ax=ax2, column=f"acc_{char}", cmap=cmap, norm=norm)
    flw.plot(ax=ax2, column="streamorde", cmap="Blues", scheme='fisher_jenks')

    ## <AxesSubplot:>

    ax2.set_title("Accumulated Groundwater Recharge (mm/yr)")

    cax = fig.add_axes([
        ax2.get_position().x1 + 0.01,
        ax2.get_position().y0,
        0.02,
        ax2.get_position().height
    ])
    sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm)
    fig.colorbar(sm, cax=cax)

    ## <matplotlib.colorbar.Colorbar object at 0x7f9aaa167978>

    plt.show()

R client Application
--------------------

    library(dplyr)
    library(sf)
    library(nhdplusTools)

    nldi_feature <- list(featureSource = "nwissite", 
                         featureID = "USGS-01031500")

    outlet_comid <- discover_nhdplus_id(nldi_feature = nldi_feature)

    data <- plot_nhdplus(nldi_feature, flowline_only = FALSE)

{{
<figure src='/static/nldi_update/unnamed-chunk-10-1.png' title='TODO' alt='TODO' >
}}

    chars <- discover_nldi_characteristics()

    outlet_total <- get_nldi_characteristics(nldi_feature, type = "total")

    outlet_total <- left_join(outlet_total$total, chars$total, 
                              by = "characteristic_id")

    outlet_total <- outlet_total %>%
      select(ID = characteristic_id, 
                           Dataset = dataset_label,
                           Description = characteristic_description, 
                           Value = characteristic_value,
                           Units = units,
                           link = dataset_url) %>%
      mutate(link = paste0('<a href="', link, '">link</a>'))

    knitr::kable(outlet_total)

<table>
<colgroup>
<col width="4%" />
<col width="2%" />
<col width="65%" />
<col width="1%" />
<col width="5%" />
<col width="20%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">ID</th>
<th align="left">Dataset</th>
<th align="left">Description</th>
<th align="left">Value</th>
<th align="left">Units</th>
<th align="left">link</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">TOT_BFI</td>
<td align="left"></td>
<td align="left">Base Flow Index (BFI), The BFI is a ratio of base flow to total streamflow, expressed as a percentage and ranging from 0 to 100. Base flow is the sustained, slowly varying component of streamflow, usually attributed to ground-water discharge to a stream.</td>
<td align="left">46</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5669a8e3e4b08895842a1d4f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_CONTACT</td>
<td align="left"></td>
<td align="left">Subsurface flow contact time index. The subsurface contact time index estimates the number of days that infiltrated water resides in the saturated subsurface zone of the basin before discharging into the stream.</td>
<td align="left">137.57</td>
<td align="left">days</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f96fc5e4b0a6037df06b12">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ET</td>
<td align="left"></td>
<td align="left">Mean-annual actual evapotranspiration (ET), estimated using regression equation of Sanford and Selnick (2013)</td>
<td align="left">468</td>
<td align="left">mm/year</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5705491be4b0d4e2b756cf8a">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_EWT</td>
<td align="left"></td>
<td align="left">Average depth to water table relatice to the land surface(meters)</td>
<td align="left">-21.62</td>
<td align="left">meters</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f97456e4b0a6037df06b50">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGA</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group A soil. -9999 denotes NODATA, usually water. Hydrologic group A soils have high infiltration rates. Soils are deep and well drained and, typically, have high sand and gravel content.</td>
<td align="left">4.47</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGAC</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group AC soil. -9999 denotes NODATA, usually water. Hydrologic group AC soils have group A characteristics (high infiltration rates) when artificially drained and have group C characteristics (slow infiltration rates) when not drained.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGAD</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group AD soil. -9999 denotes NODATA, usually water. Hydrologic group AD soils have group A characteristics (high infiltration rates) when artificially drained and have group D characteristics (very slow infiltration rates) when not drained.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGB</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group B soil. -9999 denotes NODATA, usually water. Hydrologic group B soils have moderate infiltration rates. Soils are moderately deep, moderately well drained, and moderately coarse in texture.</td>
<td align="left">14.2</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGBC</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group BC soil. -9999 denotes NODATA, usually water. Hydrologic group BC soils have group B characteristics (moderate infiltration rates) when artificially drained and have group C characteristics (slow infiltration rates) when not drained.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGBD</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group BD soil. -9999 denotes NODATA, usually water. Hydrologic group BD soils have group B characteristics (moderate infiltration rates) when artificially drained and have group D characteristics (very slow infiltration rates) when not drained.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGC</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group C soil. -9999 denotes NODATA, usually water. Hydrologic group C soils have slow soil infiltration rates. The soil profiles include layers impeding downward movement of water and, typically, have moderately fine or fine texture.</td>
<td align="left">41.66</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGCD</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group CD soil. -9999 denotes NODATA, usually water. Hydrologic group CD soils have group C characteristics (slow infiltration rates) when artificially drained and have group D characteristics (very slow infiltration rates) when not drained.</td>
<td align="left">16.84</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGD</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group D soil. -9999 denotes NODATA, usually water. Hydrologic group D soils have very slow infiltration rates. Soils are clayey, have a high water table, or have a shallow impervious layer.</td>
<td align="left">22.83</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGVAR</td>
<td align="left"></td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_IEOF</td>
<td align="left"></td>
<td align="left">Percentage of Horton overland flow as a percent</td>
<td align="left">2.29</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f974e2e4b0a6037df06b55">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_OLSON_PERM</td>
<td align="left"></td>
<td align="left">Rock hydraulic conductivity (10^-6 m/s).</td>
<td align="left">0.12</td>
<td align="left">10^-6 m/s</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5703e35be4b0328dcb825562">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_PEST219</td>
<td align="left"></td>
<td align="left">Estimate of agricultural pesticide application (219 types), kg/sq km, from Census of Ag 1997, based on county-wide sales and percent agricultural land cover in watershed</td>
<td align="left">2.32</td>
<td align="left">kg/sqkm</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57bf5e62e4b0f2f0ceb75b79">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_PET</td>
<td align="left"></td>
<td align="left">Mean-annual potential evapotranspiration (PET), estimated using the Hamon (1961) equation.</td>
<td align="left">512.18</td>
<td align="left">mm/year</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f96ed1e4b0a6037df06a2d">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_PPT7100_ANN</td>
<td align="left"></td>
<td align="left">Mean annual precip (mm) for the watershed, from 800m PRISM data. 30 years period of record 1971-2000.</td>
<td align="left">1180.7</td>
<td align="left">mm/year</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/573b70a7e4b0dae0d5e3ae85">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_RECHG</td>
<td align="left"></td>
<td align="left">Mean annual natural ground-water recharge in millimeters per year</td>
<td align="left">336.26</td>
<td align="left">mm/yr</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f97577e4b0a6037df06b5a">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_RH</td>
<td align="left"></td>
<td align="left">Watershed average relative humidity (percent), from 2km PRISM, derived from 30 years of record (1961-1990).</td>
<td align="left">68.48</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57054a24e4b0d4e2b756d0e7">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ROCKTYPE_100</td>
<td align="left"></td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Unconsolidated sand and gravel aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ROCKTYPE_200</td>
<td align="left"></td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Semiconsolidated sand aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ROCKTYPE_300</td>
<td align="left"></td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Sandstone aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ROCKTYPE_400</td>
<td align="left"></td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Carbonate-rock aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ROCKTYPE_500</td>
<td align="left"></td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Sandstone and carbonate-rock aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ROCKTYPE_600</td>
<td align="left"></td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Igneous and metamorphic-rock aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ROCKTYPE_999</td>
<td align="left"></td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Other rocks.</td>
<td align="left">100</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_RUN7100</td>
<td align="left"></td>
<td align="left">Estimated 30-year (1971-2000) average annual runoff in millimeters per year</td>
<td align="left">738.61</td>
<td align="left">millimeters per year</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/578f8ad8e4b0ad6235cf6e43">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_SATOF</td>
<td align="left"></td>
<td align="left">Percentage of Dunne overland flow as a percent</td>
<td align="left">3.3</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f97acbe4b0a6037df06b6a">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_TAV7100_ANN</td>
<td align="left"></td>
<td align="left">Watershed average of monthly air temperature (degrees C) from 800m PRISM, derived from 30 years of record (1971-2000).</td>
<td align="left">4.13</td>
<td align="left">degrees C</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57054bf2e4b0d4e2b756d364">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_TWI</td>
<td align="left"></td>
<td align="left">Topographic wetness index, ln(a/S); where ln is the natural log, a is the upslope area per unit contour length and S is the slope at that point. See <a href="http://ks.water.usgs.gov/Kansas/pubs/reports/wrir.99-4242.html" class="uri">http://ks.water.usgs.gov/Kansas/pubs/reports/wrir.99-4242.html</a> and Wolock and McCabe, 1995 for more detail</td>
<td align="left">11.55</td>
<td align="left">ln(m)</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f97be4e4b0a6037df06b70">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_WB5100_ANN</td>
<td align="left"></td>
<td align="left">unknown</td>
<td align="left">643.08</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56fd5bd0e4b0c07cbfa40473">link</a></td>
</tr>
</tbody>
</table>

    characteristic <- "CAT_RECHG"
    tot_char <- "TOT_RECHG"

    all_local <- sapply(data$flowline$COMID, function(x, char) {
      chars <- get_nldi_characteristics(
        list(featureSource = "comid", featureID = as.character(x)), 
        type = "local")
      
      filter(chars$local, characteristic_id == char)$characteristic_value
      
    }, char = characteristic)

    local_characteristic <- data.frame(COMID = data$flowline$COMID)
    local_characteristic[[characteristic]] = as.numeric(all_local)

    cat <- right_join(data$catchment, local_characteristic, by = c("FEATUREID" = "COMID"))

    plot(cat[characteristic])

{{
<figure src='/static/nldi_update/unnamed-chunk-11-1.png' title='TODO' alt='TODO' >
}}

    net <- prepare_nhdplus(data$flowline, 0, 0, 0, purge_non_dendritic = FALSE)

    ## Warning in prepare_nhdplus(data$flowline, 0, 0, 0, purge_non_dendritic = FALSE):
    ## removing geometry

    ## Warning in prepare_nhdplus(data$flowline, 0, 0, 0, purge_non_dendritic = FALSE):
    ## Got NHDPlus data without a Terminal catchment. Attempting to find it.

    ## Warning in prepare_nhdplus(data$flowline, 0, 0, 0, purge_non_dendritic = FALSE): Removed 0 flowlines that don't apply.
    ##  Includes: Coastlines, non-dendritic paths, 
    ## and networks with drainage area less than 0 sqkm, and drainage basins smaller than 0

    net <- select(net, ID = COMID, toID = toCOMID) %>%
      left_join(select(st_drop_geometry(data$flowline), COMID, AreaSqKM), 
                by = c("ID" = "COMID")) %>%
      left_join(local_characteristic, by = c("ID" = "COMID"))


    net[["temp_col"]] <- net[[characteristic]] * net$AreaSqKM

    net[[tot_char]] <- nhdplusTools:::accumulate_downstream(net, "temp_col")
    net$DenTotDASqKM <- nhdplusTools:::accumulate_downstream(net, "AreaSqKM")

    net[[tot_char]] <- net[[tot_char]] / net$DenTotDASqKM

    cat <- right_join(data$catchment, 
                      select(net, -temp_col, -toID, -DenTotDASqKM), 
                      by = c("FEATUREID" = "ID"))

    plot(cat[tot_char], reset = FALSE)
    plot(st_geometry(data$flowline), add = TRUE, lwd = data$flowline$StreamOrde, col = "lightblue")

{{
<figure src='/static/nldi_update/unnamed-chunk-12-1.png' title='TODO' alt='TODO' >
}}

    filter(outlet_total, ID == tot_char)$Value

    ## [1] "336.26"

    filter(cat, FEATUREID == outlet_comid)[[tot_char]]

    ## [1] 336.2556
