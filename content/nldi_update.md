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

lorum ipsum

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
<figure src='/static/nldi_update/unnamed-chunk-2-1.png' title='TODO' alt='TODO' >
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
<col width="2%" />
<col width="30%" />
<col width="51%" />
<col width="1%" />
<col width="4%" />
<col width="9%" />
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
<td align="left">Base Flow Index (BFI), The BFI is a ratio of base flow to total streamflow, expressed as a percentage and ranging from 0 to 100. Base flow is the sustained, slowly varying component of streamflow, usually attributed to ground-water discharge to a stream.</td>
<td align="left">Base Flow Index (BFI), The BFI is a ratio of base flow to total streamflow, expressed as a percentage and ranging from 0 to 100. Base flow is the sustained, slowly varying component of streamflow, usually attributed to ground-water discharge to a stream.</td>
<td align="left">46</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5669a8e3e4b08895842a1d4f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_PET</td>
<td align="left">Mean-annual potential evapotranspiration (PET), estimated using the Hamon (1961) equation.</td>
<td align="left">Mean-annual potential evapotranspiration (PET), estimated using the Hamon (1961) equation.</td>
<td align="left">512.18</td>
<td align="left">mm/year</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f96ed1e4b0a6037df06a2d">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_CONTACT</td>
<td align="left">Subsurface flow contact time index. The subsurface contact time index estimates the number of days that infiltrated water resides in the saturated subsurface zone of the basin before discharging into the stream.</td>
<td align="left">Subsurface flow contact time index. The subsurface contact time index estimates the number of days that infiltrated water resides in the saturated subsurface zone of the basin before discharging into the stream.</td>
<td align="left">137.57</td>
<td align="left">days</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f96fc5e4b0a6037df06b12">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_EWT</td>
<td align="left">Average depth to water table relatice to the land surface(meters)</td>
<td align="left">Average depth to water table relatice to the land surface(meters)</td>
<td align="left">-21.62</td>
<td align="left">meters</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f97456e4b0a6037df06b50">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_IEOF</td>
<td align="left">Percentage of Horton overland flow as a percent</td>
<td align="left">Percentage of Horton overland flow as a percent</td>
<td align="left">2.29</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f974e2e4b0a6037df06b55">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_RECHG</td>
<td align="left">Runoff (mm/yr) delivered to the stream network for every month for the years 1945 - 2013 divided by 12 to derive annual runoff.</td>
<td align="left">Mean annual natural ground-water recharge in millimeters per year</td>
<td align="left">336.26</td>
<td align="left">mm/yr</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f97577e4b0a6037df06b5a">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_SATOF</td>
<td align="left">Percentage of Dunne overland flow as a percent</td>
<td align="left">Percentage of Dunne overland flow as a percent</td>
<td align="left">3.3</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f97acbe4b0a6037df06b6a">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_TWI</td>
<td align="left">Topographic wetness index, ln(a/S); where ln is the natural log, a is the upslope area per unit contour length and S is the slope at that point. See <a href="http://ks.water.usgs.gov/Kansas/pubs/reports/wrir.99-4242.html" class="uri">http://ks.water.usgs.gov/Kansas/pubs/reports/wrir.99-4242.html</a> and Wolock and McCabe, 1995 for more detail</td>
<td align="left">Topographic wetness index, ln(a/S); where ln is the natural log, a is the upslope area per unit contour length and S is the slope at that point. See <a href="http://ks.water.usgs.gov/Kansas/pubs/reports/wrir.99-4242.html" class="uri">http://ks.water.usgs.gov/Kansas/pubs/reports/wrir.99-4242.html</a> and Wolock and McCabe, 1995 for more detail</td>
<td align="left">11.55</td>
<td align="left">ln(m)</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56f97be4e4b0a6037df06b70">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_WB5100_ANN</td>
<td align="left">Estimated watershed annual runoff, mm/year, mean for the period 1951-2000. From Wolock and McCabe (1999) water balance model. Estimates the effects of precip and temperature, but not other factors (land use, water use, regulation, etc.)</td>
<td align="left">unknown</td>
<td align="left">643.08</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56fd5bd0e4b0c07cbfa40473">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_FUNGICIDE</td>
<td align="left">Average kilograms per square kilometer of fungicide use on agricultural land, 2009</td>
<td align="left">unknown</td>
<td align="left">0.4</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/56fd610fe4b022712b81bf9f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_OLSON_PERM</td>
<td align="left">Estimated mean lithological compressive strength, measured as uniaxial compressive strength (in megaPascals, MPa) of surface or near surface geology per NHDPlusV2 catchment.</td>
<td align="left">Rock hydraulic conductivity (10^-6 m/s).</td>
<td align="left">0.12</td>
<td align="left">10^-6 m/s</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5703e35be4b0328dcb825562">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HERBICIDE</td>
<td align="left">Average kilograms per square kilometer of herbicide use on agricultural land, 2009</td>
<td align="left">unknown</td>
<td align="left">0.32</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57052ba4e4b0d4e2b756ab85">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_INSECTICIDE</td>
<td align="left">Average kilograms per square kilometer of insecticide use on agricultural land, 2009</td>
<td align="left">unknown</td>
<td align="left">0.08</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57052c47e4b0d4e2b756ac39">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_N97</td>
<td align="left">Estimate of nitrogen from fertilizer and manure, from Census of Ag 1997 and AAPFCO</td>
<td align="left">Estimate of nitrogen from fertilizer and manure, from Census of Ag 1997 and AAPFCO</td>
<td align="left">127.44</td>
<td align="left">kg/sqkm</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57053205e4b0d4e2b756b353">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NEMATICIDE</td>
<td align="left">Average kilograms per square kilometer of nematicide use on agricultural land, 2009</td>
<td align="left">unknown</td>
<td align="left">0</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/570535aae4b0d4e2b756b78c">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_P97</td>
<td align="left">Estimate of phosphorous from fertilizer and manure, from Census of Ag 1997 and AAPFCO</td>
<td align="left">Estimate of phosphorous from fertilizer and manure, from Census of Ag 1997 and AAPFCO</td>
<td align="left">20.06</td>
<td align="left">kg/sqkm</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57053749e4b0d4e2b756b969">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ET</td>
<td align="left">Mean-annual actual evapotranspiration (ET), estimated using regression equation of Sanford and Selnick (2013)</td>
<td align="left">Mean-annual actual evapotranspiration (ET), estimated using regression equation of Sanford and Selnick (2013)</td>
<td align="left">468</td>
<td align="left">mm/year</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5705491be4b0d4e2b756cf8a">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_RH</td>
<td align="left">Watershed average relative humidity (percent), from 2km PRISM, derived from 30 years of record (1961-1990).</td>
<td align="left">Watershed average relative humidity (percent), from 2km PRISM, derived from 30 years of record (1961-1990).</td>
<td align="left">68.48</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57054a24e4b0d4e2b756d0e7">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_TAV7100_ANN</td>
<td align="left">Watershed average of minimum monthly air temperature (degrees C) from 800m PRISM, derived from 30 years of record (1971-2000).</td>
<td align="left">Watershed average of monthly air temperature (degrees C) from 800m PRISM, derived from 30 years of record (1971-2000).</td>
<td align="left">4.13</td>
<td align="left">degrees C</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57054bf2e4b0d4e2b756d364">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_DITCHES92</td>
<td align="left">Percent of watershed subjected to ditches for the year 1992</td>
<td align="left">Percent of watershed subjected to ditches for the year 1992</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57067257e4b03f95a075ab0c">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_TILES92</td>
<td align="left">Percent of watershed subjected to tile drains for the year 1992</td>
<td align="left">Percent of watershed subjected to tile drains for the year 1992</td>
<td align="left">0.0005</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57067469e4b03f95a075ad3e">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGA</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group A soil. -9999 denotes NODATA, usually water. Hydrologic group A soils have high infiltration rates. Soils are deep and well drained and, typically, have high sand and gravel content.</td>
<td align="left">4.47</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGAC</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group AC soil. -9999 denotes NODATA, usually water. Hydrologic group AC soils have group A characteristics (high infiltration rates) when artificially drained and have group C characteristics (slow infiltration rates) when not drained.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGAD</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group AD soil. -9999 denotes NODATA, usually water. Hydrologic group AD soils have group A characteristics (high infiltration rates) when artificially drained and have group D characteristics (very slow infiltration rates) when not drained.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGB</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group B soil. -9999 denotes NODATA, usually water. Hydrologic group B soils have moderate infiltration rates. Soils are moderately deep, moderately well drained, and moderately coarse in texture.</td>
<td align="left">14.2</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGBC</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group BC soil. -9999 denotes NODATA, usually water. Hydrologic group BC soils have group B characteristics (moderate infiltration rates) when artificially drained and have group C characteristics (slow infiltration rates) when not drained.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGBD</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group BD soil. -9999 denotes NODATA, usually water. Hydrologic group BD soils have group B characteristics (moderate infiltration rates) when artificially drained and have group D characteristics (very slow infiltration rates) when not drained.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGC</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group C soil. -9999 denotes NODATA, usually water. Hydrologic group C soils have slow soil infiltration rates. The soil profiles include layers impeding downward movement of water and, typically, have moderately fine or fine texture.</td>
<td align="left">41.66</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGCD</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group CD soil. -9999 denotes NODATA, usually water. Hydrologic group CD soils have group C characteristics (slow infiltration rates) when artificially drained and have group D characteristics (very slow infiltration rates) when not drained.</td>
<td align="left">16.84</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_HGD</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group D soil. -9999 denotes NODATA, usually water. Hydrologic group D soils have very slow infiltration rates. Soils are clayey, have a high water table, or have a shallow impervious layer.</td>
<td align="left">22.83</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_HGVAR</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">Percentage of Hydrologic Group VAR soil. -9999 denotes NODATA, usually water. Hydrologic group VAR soils have variable drainage characteristics.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728d93be4b0b13d3918a99f">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_POPDENS00</td>
<td align="left">Population density in the watershed, persons per sq km, from 2000 Census block data regridded to 100m. This variable is maintained to support models built from original GAGES dataset.</td>
<td align="left">unknown</td>
<td align="left">4.31</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728f532e4b0b13d3918aa0a">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_POPDENS90</td>
<td align="left">Population density in the watershed, persons per sq km, from 1990 Census block data, allocated to 2000 block boundaries, regridded to 100m. This variable is maintained to support models built from original GAGES dataset.</td>
<td align="left">unknown</td>
<td align="left">4.84</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728f609e4b0b13d3918aa0e">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_POPDENS10</td>
<td align="left">Population density in the watershed, persons per sq km, from 2010 Census block data regridded to 100m. This variable is maintained to support models built from original GAGES dataset.</td>
<td align="left">unknown</td>
<td align="left">4.41</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5728f746e4b0b13d3918aa1e">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_PPT7100_ANN</td>
<td align="left">Mean annual precip (mm) for the watershed, from 800m PRISM data. 30 years period of record 1971-2000.</td>
<td align="left">Mean annual precip (mm) for the watershed, from 800m PRISM data. 30 years period of record 1971-2000.</td>
<td align="left">1180.7</td>
<td align="left">mm/year</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/573b70a7e4b0dae0d5e3ae85">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_MIRAD_2002</td>
<td align="left">Percent of watershed in irrigated agriculture, from USGS 2002 250-m MODIS data</td>
<td align="left">Percent of watershed in irrigated agriculture, from USGS 2002 250-m MODIS data</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/573b77afe4b0dae0d5e3aea6">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_MIRAD_2007</td>
<td align="left">Percent of watershed in irrigated agriculture, from USGS 2007 250-m MODIS data</td>
<td align="left">Percent of watershed in irrigated agriculture, from USGS 2007 250-m MODIS data</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/573b7850e4b0dae0d5e3aeb0">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_MIRAD_2012</td>
<td align="left">Percent of watershed in irrigated agriculture, from USGS 2012 250-m MODIS data</td>
<td align="left">Percent of watershed in irrigated agriculture, from USGS 2012 250-m MODIS data</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/573b78aee4b0dae0d5e3aeb7">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_AET</td>
<td align="left">mean-annual evapotranspiration, estimated by Senay and others (2013</td>
<td align="left">mean-annual evapotranspiration, estimated by Senay and others (2013</td>
<td align="left">537.24</td>
<td align="left">millimeters</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57519f16e4b053f0edd03d41">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NLCD01_11</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Open Water: All areas of open water, generally with less than 25 percent cover of vegetation or soil. -9999 denotes NODATA.</td>
<td align="left">2.16</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NLCD01_12</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Perennial Ice/Snow: All areas characterized by a perennial cover of ice and/or snow, generally greater than 25 percent of total cover. -9999 denotes NODATA.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NLCD01_21</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Developed, Open Space: Includes areas with a mixture of some constructed materials, but mostly vegetation in the form of lawn grasses. Impervious surfaces account for less than 20 percent of total cover. These areas most commonly include large-lot single-family housing units, parks, golf courses, and vegetation planted in developed settings for recreation, erosion control, or aesthetic purposes. -9999 denotes NODATA.</td>
<td align="left">1.5</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NLCD01_22</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Developed, Low Intensity: Includes areas with a mixture of constructed materials and vegetation. Impervious surfaces account for 20-49 percent of total cover. These areas most commonly include single-family housing units. -9999 denotes NODATA.</td>
<td align="left">0.47</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NLCD01_23</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Developed, Medium Intensity: Includes areas with a mixture of constructed materials and vegetation. Impervious surfaces account for 50-79 percent of the total cover. These areas most commonly include single-family housing units. -9999 denotes NODATA.</td>
<td align="left">0.12</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NLCD01_24</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Developed, High Intensity: Includes highly developed areas where people reside or work in high numbers. Examples include apartment complexes, row houses, and commercial/industrial. Impervious surfaces account for 80-100 percent of the total cover. -9999 denotes NODATA.</td>
<td align="left">0.04</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NLCD01_31</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Barren Land (Rock/Sand/Clay): Barren areas of bedrock, desert pavement, scarps, talus, slides, volcanic material, glacial debris, sand dunes, strip mines, gravel pits, and other accumulations of earthen material. Generally, vegetation accounts for less than 15 percent of total cover. -9999 denotes NODATA.</td>
<td align="left">0.17</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NLCD01_41</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Deciduous Forest: Areas dominated by trees generally greater than 5 meters tall, and greater than 20 percent of total vegetation cover. More than 75 percent of the tree species shed foliage simultaneously in response to seasonal change. -9999 denotes NODATA.</td>
<td align="left">22.26</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NLCD01_42</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Evergreen Forest: Areas dominated by trees generally greater than 5 meters tall, and greater than 20 percent of total vegetation cover. More than 75 percent of the trees maintain their leaves all year. Canopy is never without green foliage. -9999 denotes NODATA.</td>
<td align="left">20.1</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NLCD01_43</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Mixed Forest: Areas dominated by trees generally greater than 5 meters tall, and greater than 20 percent of total vegetation cover. Neither deciduous nor evergreen species are greater than 75 percent of total tree cover. -9999 denotes NODATA.</td>
<td align="left">33.04</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NLCD01_52</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Shrub/Scrub: Areas dominated by shrubs less than 5 meters tall. Shrub canopy is typically greater than 20 percent of total vegetation. This class includes true shrubs, young trees in an early successional stage or trees stunted from environmental conditions. -9999 denotes NODATA.</td>
<td align="left">9.34</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NLCD01_71</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Grassland/Herbaceous: Areas dominated by graminoid or herbaceous vegetation, generally greater than 80 percent of total vegetation. These areas are not subject to intensive management such as tilling, but can be utilized for grazing. -9999 denotes NODATA.</td>
<td align="left">0.89</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NLCD01_81</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Pasture/Hay: Areas of grasses, legumes, or grass-legume mixtures planted for livestock grazing or the production of seed or hay crops, typically on a perennial cycle. Pasture/hay vegetation accounts for greater than 20 percent of total vegetation. -9999 denotes NODATA.</td>
<td align="left">0.62</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NLCD01_82</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Cultivated Crops: Areas used for the production of annual crops, such as corn, soybeans, vegetables, tobacco, and cotton, and also perennial woody crops such as orchards and vineyards. Crop vegetation accounts for greater than 20 percent of total vegetation. This class also includes all land being actively tilled. -9999 denotes NODATA.</td>
<td align="left">0.96</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NLCD01_90</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Woody Wetlands: Areas where forest or shrubland vegetation accounts for greater than 20 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">7.61</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NLCD01_95</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">land-use and land-cover type Emergent Herbaceous Wetlands: Areas where perennial herbaceous vegetation accounts for greater than 80 percent of vegetative cover and the soil or substrate is periodically saturated with or covered with water. -9999 denotes NODATA.</td>
<td align="left">0.73</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/5761b67de4b04f417c2d30ae">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_RUN7100</td>
<td align="left">Estimated 30-year (1971-2000) average annual runoff in millimeters per year</td>
<td align="left">Estimated 30-year (1971-2000) average annual runoff in millimeters per year</td>
<td align="left">738.61</td>
<td align="left">millimeters per year</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/578f8ad8e4b0ad6235cf6e43">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_STREAMRIVER</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">90.13</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ARTIFICIAL</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">9.87</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_CANALDITCH</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">0</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_CONNECTOR</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">0</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_PIPELINE</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">0</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_BASIN_AREA</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">773.96</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_BASIN_SLOPE</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">8.09</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ELEV_MEAN</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">302.61</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ELEV_MIN</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">109.16</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ELEV_MAX</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">798.33</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_STREAM_SLOPE</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">0.014582</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_STREAM_LENGTH</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">565.76</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_STRM_DENS</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">0.73</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_RDX</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">number of road and stream intersections</td>
<td align="left">237</td>
<td align="left">number of road and stream crossings</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_TOTAL_ROAD_DENS</td>
<td align="left">NHDPlus version 2 flowline's length in kilometers taken directly from NHDPlusv2's NHDflowline shapefile's item, LENGTHKM. -9999 denotes a catchment has no flowline.</td>
<td align="left">unknown</td>
<td align="left">0.88</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57976a0ce4b021cadec97890">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_PLAYA</td>
<td align="left">Percent estuaries.</td>
<td align="left">Percent playas.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57ab4009e4b05e859be1ad26">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ICEMASS</td>
<td align="left">Percent estuaries.</td>
<td align="left">Percent ice mass.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57ab4009e4b05e859be1ad26">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_LAKEPOND</td>
<td align="left">Percent estuaries.</td>
<td align="left">Percent lakes or ponds.</td>
<td align="left">2.3</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57ab4009e4b05e859be1ad26">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_RESERVOIR</td>
<td align="left">Percent estuaries.</td>
<td align="left">Percent reservoirs.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57ab4009e4b05e859be1ad26">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_SWAMPMARSH</td>
<td align="left">Percent estuaries.</td>
<td align="left">Percent swamps or marshes.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57ab4009e4b05e859be1ad26">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ESTUARY</td>
<td align="left">Percent estuaries.</td>
<td align="left">Percent estuaries.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57ab4009e4b05e859be1ad26">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_PEST219</td>
<td align="left">Estimate of agricultural pesticide application (219 types), kg/sq km, from Census of Ag 1997, based on county-wide sales and percent agricultural land cover in watershed</td>
<td align="left">Estimate of agricultural pesticide application (219 types)</td>
<td align="left">2.32</td>
<td align="left">kg/sqkm</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57bf5e62e4b0f2f0ceb75b79">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NPDES_MAJ_DENS</td>
<td align="left">Number of major NPDES sites</td>
<td align="left">Density of major NPDES sites</td>
<td align="left">0.13</td>
<td align="left">sites per 100 square kilometers</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57c9d89ce4b0f2f0cec192da">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NPDES_MAJ</td>
<td align="left">Number of major NPDES sites</td>
<td align="left">Number of major NPDES sites</td>
<td align="left">1</td>
<td align="left">count</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57c9d89ce4b0f2f0cec192da">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_FRESHWATER_WD</td>
<td align="left">freshwater withdrawals from 1995-2000 county-level estimates</td>
<td align="left">freshwater withdrawals from 1995-2000 county-level estimates</td>
<td align="left">0.13</td>
<td align="left">megaliters per square kilometer</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/57c9dc05e4b0f2f0cec192f2">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ROCKTYPE_100</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Other rocks.</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Unconsolidated sand and gravel aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ROCKTYPE_200</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Other rocks.</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Semiconsolidated sand aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ROCKTYPE_300</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Other rocks.</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Sandstone aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ROCKTYPE_400</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Other rocks.</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Carbonate-rock aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ROCKTYPE_500</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Other rocks.</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Sandstone and carbonate-rock aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_ROCKTYPE_600</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Other rocks.</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Igneous and metamorphic-rock aquifers.</td>
<td align="left">0</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_ROCKTYPE_999</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Other rocks.</td>
<td align="left">Estimated percent of catchment that is underlain by the Principal Aquifer rock type, Other rocks.</td>
<td align="left">100</td>
<td align="left">percent</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/582b3855e4b0c253be05fc81">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NDAMS2013</td>
<td align="left">Number of major dams built on or before YYYY in each NHDPlusV2 catchment. Major dams defined as being &gt;= 50 feet in height (15m) or having storage &gt;= 5,000 acre feet</td>
<td align="left">unknown</td>
<td align="left">8</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/58c301f2e4b0f37a93ed915a">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_NID_STORAGE2013</td>
<td align="left">Number of major dams built on or before YYYY in each NHDPlusV2 catchment. Major dams defined as being &gt;= 50 feet in height (15m) or having storage &gt;= 5,000 acre feet</td>
<td align="left">unknown</td>
<td align="left">6986</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/58c301f2e4b0f37a93ed915a">link</a></td>
</tr>
<tr class="odd">
<td align="left">TOT_NORM_STORAGE2013</td>
<td align="left">Number of major dams built on or before YYYY in each NHDPlusV2 catchment. Major dams defined as being &gt;= 50 feet in height (15m) or having storage &gt;= 5,000 acre feet</td>
<td align="left">unknown</td>
<td align="left">4659</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/58c301f2e4b0f37a93ed915a">link</a></td>
</tr>
<tr class="even">
<td align="left">TOT_MAJOR2013</td>
<td align="left">Number of major dams built on or before YYYY in each NHDPlusV2 catchment. Major dams defined as being &gt;= 50 feet in height (15m) or having storage &gt;= 5,000 acre feet</td>
<td align="left">unknown</td>
<td align="left">0</td>
<td align="left">unknown</td>
<td align="left"><a href="https://www.sciencebase.gov/catalog/item/58c301f2e4b0f37a93ed915a">link</a></td>
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
<figure src='/static/nldi_update/unnamed-chunk-3-1.png' title='TODO' alt='TODO' >
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
<figure src='/static/nldi_update/unnamed-chunk-4-1.png' title='TODO' alt='TODO' >
}}

    filter(outlet_total, ID == tot_char)$Value

    ## [1] "336.26"

    filter(cat, FEATUREID == outlet_comid)[[tot_char]]

    ## [1] 336.2556
