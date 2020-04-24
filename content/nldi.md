---
author: David Blodgett
date: 2017-05-01
slug: nldi-intro
title: The Hydro Network-Linked Data Index
type: post
categories: Data Science
image: static/nldi-intro/upstream.png
author_twitter: D_Blodgett
author_github: dblodgett-usgs
 
author_researchgate: David_Blodgett3
author_staff: david-blodgett
author_email: dblodgett@usgs.gov

tags: 
  - R
  - leaflet
  - R
description: Access subsets of NHDPlus data and discover sites on the river network with the hydro Network Linked Data Index. Navigation types include upstream mainstem, upstream with tributaries, downstream mainstem and downstream with diversions. Services to provide a basin boundary, linked NWIS stream gage sites, water quality data sites, and twelve digit hydrologic unit code (HUC) watershed outlets.
keywords:
  - R
  - leaflet
  - R
  - hydrography
  - data discovery
---
Introduction
------------

The Hydro [Network-Linked Data Index
(NLDI)](https://labs.waterdata.usgs.gov/about-nldi) is a system that can index
data to [NHDPlus
V2](http://www.horizon-systems.com/NHDPlus/V2NationalData.php)
catchments and offers a search service to discover indexed information.
Data linked to the NLDI includes [active NWIS stream
gages](https://waterdata.usgs.gov/nwis/rt), [water quality portal
sites](https://www.waterqualitydata.us/), and [outlets of HUC12
watersheds](https://www.sciencebase.gov/catalog/item/5762b664e4b07657d19a71ea).
The NLDI is a core product of the [Open Water Data
Initiative](http://acwi.gov/spatial/owdi/) and is being developed as [an
open source project.](https://github.com/ACWI-SSWD) coordinated through
the [Advisory Committee on Water Information (ACWI) Subcommittee on
Spatial Water Data](http://acwi.gov/spatial).

In this blog post, we introduce the basic functions of the NLDI and show
how to use it as a data discovery and access tool in R. The first
section describes the operations available from the [NLDI’s Web
API](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html). The second section
shows how to map NLDI data and how to use the NLDI to discover data to
be accessed with [the dataRetrieval
package.](https://owi.usgs.gov/R/dataRetrieval.html)

Below, text highlighting is used in six ways:

1.  The names of API parameters such as `{featureSource}`  
2.  Example values of API parameters such as: `USGS-08279500`  
3.  API operation names: ***navigation*** and ***basin***  
4.  API request names such as: *getDataSources*  
5.  R functions such as: **readOGR**  
6.  Other specific strings such as “siteNumber”

The NLDI Web API
----------------

The NLDI’s Web API follows a loosely RESTful design and is documented
with [swagger](http://swagger.io/) documentation which can [be found
here.](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html) Every request to get
data from the NLDI starts from a given network linked feature.

### Feature Sources

Available network linked feature sources (`{featureSource}`s) can be
found from the [*getDataSources*
request.](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html#/linked-data-controller/getDataSourcesUsingGET)
(hint: Click the “try it out” button on the swagger page!) These are the
collections of network linked features the NLDI knows about. Think of
them as watershed outlets that can be used as a starting point. For this
demo, we’ll use NWIS Stream Gages as the `{featureSource}`. As a note
for later, `{featureSource}` here is the same as the `{dataSource}`
described below.

### Feature IDs

For now, the particular `{featureID}` to be accessed from a given
`{featureSource}` needs to be found outside the NLDI, so the
[*getFeatures*](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html#/linked-data-controller/getRegisteredFeatureUsingGET)
request doesn’t return anything. So let’s use a [well known NWIS
Streamgage](https://www.usgs.gov/news/first-usgs-streamgage-records-125-years-measuring-new-mexico%E2%80%99s-vital-water-resources)
on the [Rio Grande at Embudo
NM](https://waterdata.usgs.gov/nwis/inventory/?site_no=08279500&agency_cd=USGS)
as our starting point.

![Image of streamgage on the Rio Grande at Embudo. Gage house made of
local stone, cableway for measureing flow, riffles, and kayaker in
river.](/static/nldi-intro/first_streamgage.jpeg "First USGS Stream Gage Rio Grande at Embudo")

### Indexed Features

We can use the
[*getRegisteredFeature*](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html#/linked-data-controller/getRegisteredFeatureUsingGET)
request to see this feature. Enter `nwissite` and `USGS-08279500` in the
`{featureSource}` and `{featureID}`, respectively, in the [swagger demo
page.](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html#/linked-data-controller/getRegisteredFeatureUsingGET)
You can also see this in your browser at this url:  
<https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500>  
The response contains the location of the feature, is in
[geojson](http://geojson.org/), and looks like:

```json

    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [
              -105.9639722,
              36.20555556
            ]
          },
          "properties": {
            "source": "nwissite",
            "sourceName": "NWIS Sites",
            "identifier": "USGS-08279500",
            "name": "RIO GRANDE AT EMBUDO, NM",
            "uri": "https://waterdata.usgs.gov/nwis/inventory?agency_code=USGS&site_no=08279500",
            "comid": "17864756",
            "navigation": "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate"
          }
        }
      ]
    }
```

<iframe seamless src="/static/nldi-intro/map_1/index.html" width="80%" height="500">
</iframe>

### Navigation

The ***navigation*** property of the returned feature is a url for the
[*getNavigationTypes*](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html#/linked-data-controller/getNavigationTypesUsingGET)
request. This request provides four ***navigation*** options as shown
below. Each of these URLs returns the NHDPlus flowlines for the
navigation type.

```json
    {
      "upstreamMain": "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UM",
      "upstreamTributaries": "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UT",
      "downstreamMain": "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/DM",
      "downstreamDiversions": "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/DD"
    }
```

### Get Flowlines from Navigation

Each of the URLs found via the *getNavigationTypes* request is a
complete
[*getFlowlines*](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html#/network-controller/getFlowlinesUsingGET_1)
request. This request has some optional input parameters. The most
useful being `{distance}`, which allows specification of a distance to
navigate in km. So, for example, we can use this to retrieve 150km of
upstream mainstem flowlines from the NWIS gage 08279500 with a request
like:  
<https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UM?distance=150>

<iframe seamless src="/static/nldi-intro/map_2/index.html" width="80%" height="500">
</iframe>
<br>Notice that the flowline goes downstream of the gage because the NLDI is
referenced to whole NHDPlus catchments, not to precise network
locations.

### Get Linked Data from Navigation

Now that we have a `{featureSource}` = `nwissite`, a `{featureID}` =
`USGS-082795001`, the ***navigate*** operation on the feature, and the
`{navigationMode}` = `UM` with `{distance}` = `150`km, we can use the
[*getFeatures*](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html#/linked-data-controller/getFeaturesUsingGET)
request to discover features from any `{featureSource}` which, in the
context of a *getFeatures* request, is called a `{dataSource}`. Setting
the `{dataSource}` = `nwissite`, we can see if there are any active NWIS
streamgages 150km upstream on the main stem with a request that looks
like:  
<https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UM/nwissite?distance=150>  
Note that we could enter `wqp` in place of `nwissite` after `UM` here to
get [water quality portal](https://www.waterqualitydata.us/) sites
instead of NWIS sites. An example of this is shown later in this post.

<iframe seamless src="/static/nldi-intro/map_3/index.html" width="80%" height="500">
</iframe>
<br>Note: Click the black NWIS gage points to see a pop up and link!

### Get the Upstream Basin Boundary

So far, we’ve covered four parameters of the NLDI Web API. The two base
parameters, `{featureSource}` and `{featureID}`, and two that apply to
the ***navigate*** option, `{navigationMode}` and `{distance}`. In
addition to the ***navigate*** option, the NLDI offers a ***basin***
option for any `{featureSource}`/`{featureID}`. The
[*getBasin*](https://labs.waterdata.usgs.gov/api/nldi/linked-data/swagger-ui.html#!/characteristics-controller/getBasinUsingGET)
operation doesn’t require any additional parameters, so a request to get
the basin for our stream gage looks like:  
<https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/basin>.

<iframe seamless src="/static/nldi-intro/map_4/index.html" width="80%" height="500">
</iframe>

### NLDI API Summary

There are a few other options available from the NLDI that are not
covered here. One, that is coming soon, will make catchment (local
incremental NHDPlus catchment) and basin (upstream accumulation)
landscape characteristics available. This functionality and data is
available but is preliminary and subject to change.

Bringing together all the operations summarized above, we can get:  
1) The NWIS site:
<a href="https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500" class="uri">https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500</a>  
2) The basin upstream of the site:
<a href="https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/basin" class="uri">https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/basin</a>  
3) All upstream with tributaries flowlines:
<a href="https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UT" class="uri">https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UT</a>  
4) The upstream mainstem flowlines:
<a href="https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UM" class="uri">https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UM</a>  
5) The downstream mainstem flowlines:
<a href="https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/DM" class="uri">https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/DM</a>  
6) The water quality observation sites in upstream catchments:  
<a href="https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UT/wqp" class="uri">https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UT/wqp</a>  
7) The water quality observations in downstream catchments:  
<a href="https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/DM/wqp" class="uri">https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/DM/wqp</a>

For [QGIS](http://qgis.org/en/site/) users, you can use the NLDI URLs
directly in the “Add Vector Layer” dialogue. The following two
screenshots were rendered by loading the data into QGIS, turning on a
base map with the OpenLayers Plugin, and applying a little styling to
the NLDI layers. No local files needed!

<div class="grid-row">
{{< figure src="/static/nldi-intro/upstream.png" title="Upstream Navigation Results" alt="Image of upstream navigation results. Basin boundary, flowlines, main stem, water quality sites." class="side-by-side" >}}
{{< figure src="/static/nldi-intro/downstream.png" title="Downstream Navigation Results" alt="Image of downstream navigation results. Main stem, water quality sites." class="side-by-side" >}}
</div>

Screenshots of NLDI data loaded into QGIS.

Using the NLDI in R.
--------------------

First, we get all our URLs into a list and use **read\_sf** from the
[sf](https://r-spatial.github.io/sf/) package to download and read all
the data into spatial data types. The end of this code block creates
html for popup text with a web link tag that we’ll use later.

``` r
nldiURLs <- list(site_data = "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500",
             basin_boundary = "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/basin",
             UT = "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UT",
             UM = "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UM",
             DM = "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/DM",
             UTwqp = "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UT/wqp",
             DMwqp = "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/DM/wqp")

nldi_data <- list()

for(n in names(nldiURLs)) {
  nldi_data[n] <- list(sf::read_sf(nldiURLs[n][[1]]))
  print(paste(n, "is of class", class(nldi_data[[n]]), "and has", nrow(nldi_data[[n]]), "features"))
}
```


    ## [1] "site_data is of class sf and has 1 features"        
    ## [2] "site_data is of class tbl_df and has 1 features"    
    ## [3] "site_data is of class tbl and has 1 features"       
    ## [4] "site_data is of class data.frame and has 1 features"
    ## [1] "basin_boundary is of class sf and has 1 features"        
    ## [2] "basin_boundary is of class tbl_df and has 1 features"    
    ## [3] "basin_boundary is of class tbl and has 1 features"       
    ## [4] "basin_boundary is of class data.frame and has 1 features"
    ## [1] "UT is of class sf and has 3371 features"        
    ## [2] "UT is of class tbl_df and has 3371 features"    
    ## [3] "UT is of class tbl and has 3371 features"       
    ## [4] "UT is of class data.frame and has 3371 features"
    ## [1] "UM is of class sf and has 184 features"        
    ## [2] "UM is of class tbl_df and has 184 features"    
    ## [3] "UM is of class tbl and has 184 features"       
    ## [4] "UM is of class data.frame and has 184 features"
    ## [1] "DM is of class sf and has 1367 features"        
    ## [2] "DM is of class tbl_df and has 1367 features"    
    ## [3] "DM is of class tbl and has 1367 features"       
    ## [4] "DM is of class data.frame and has 1367 features"
    ## [1] "UTwqp is of class sf and has 1908 features"        
    ## [2] "UTwqp is of class tbl_df and has 1908 features"    
    ## [3] "UTwqp is of class tbl and has 1908 features"       
    ## [4] "UTwqp is of class data.frame and has 1908 features"
    ## [1] "DMwqp is of class sf and has 2756 features"        
    ## [2] "DMwqp is of class tbl_df and has 2756 features"    
    ## [3] "DMwqp is of class tbl and has 2756 features"       
    ## [4] "DMwqp is of class data.frame and has 2756 features"

``` r
UTwqp_html <- paste('<a href="',
                      nldi_data$UTwqp$uri,
                      '"  target="_blank">',
                      nldi_data$UTwqp$name,
                      '</a>')

DMwqp_html <- paste('<a href="',
                      nldi_data$DMwqp$uri,
                      '"  target="_blank">',
                      nldi_data$DMwqp$name,
                      '</a>')
```

Now that we have all our data, we can use leaflet functions to add the
data to a map. First, let’s map just the upstream data. Note that the
order we add them determines the order the layers are drawn. You can
zoom in on the map shown and click the water quality sites to get a
popup containing a link to the site’s landing page.

**[The `get_base_map()` function is described here](https://waterdata.usgs.gov/blog/basemaps/)** and can be seen in the source [code of this blog post.](https://github.com/usgs/wdfn-blog/blob/master/content/nldi.Rmd)

``` r
map <- get_base_map()

map <- leaflet::addPolygons(map, 
                            data=nldi_data$basin_boundary, 
                            color = "black", 
                            fill = FALSE, 
                            weight = 1,
                            opacity = 1)

map <- leaflet::addPolylines(map, 
                             data = nldi_data$UT,
                             color = "blue",
                             weight = 1,
                             opacity = 1)

map <- leaflet::addPolylines(map,
                             data = nldi_data$UM, 
                             color = "blue", 
                             weight = 3, 
                             opacity = 0.5)

map <- leaflet::addCircleMarkers(map = map,
                                 data = nldi_data$UTwqp,
                                 radius = 1,
                                 color = "black",
                                 opacity = .5,
                                 fill = FALSE, 
                                 popup = UTwqp_html)

map <- leaflet::addCircleMarkers(map, 
                                 data = nldi_data$site_data, 
                                 radius = 5, 
                                 color = "red")
```

<iframe seamless src="/static/nldi-intro/map_5/index.html" width="80%" height="500">
</iframe>
<br>To complete the picture, we can add the downstream main stem and water
quality sites. Now we have an interactive map of all the upstream
tributaries, water quality sites, basin boundary, the entire main stem,
and water quality sites downstream.

``` r
map <- leaflet::addPolylines(map,
                             data = nldi_data$DM, 
                             color = "blue", 
                             weight = 3, 
                             opacity = 0.5)
map <- leaflet::addCircleMarkers(map = map,
                                 data = nldi_data$DMwqp,
                                 radius = 1,
                                 color = "black",
                                 opacity = .5,
                                 fill = FALSE, 
                                 popup = DMwqp_html)
```

<iframe seamless src="/static/nldi-intro/map_6/index.html" width="80%" height="500">
</iframe>
This final map illustrates a very important detail about the NLDI if you
zoom in on the downstream main stem. Notice that the sites are not all
**on** the main stem flowpath. When the system indexes data sources that
aren’t already indexed to particular reachcodes and measures along those
reaches, it links sites (points) by looking at what local catchment
polygon the site is in. This means that sites found through navigation
may not be **on** the main flowpath of a catchment. In the future, we
hope to improve the system such that it would know if indexed data are
**on** or **off** the main flowpath of a catchment, but for now users
need to be aware of this limitation.

### Using the NLDI to discover linked observations data.

The two sources of linked data shown above, `nwissite` and `wqp`, are
both queryable from [the dataRetrieval
package.](https://owi.usgs.gov/blog/tags/dataretrieval/) The
“siteNumber” input of the dataRetrieval functions that start with
“readNWIS” can be found by removing “USGS-” from the “identifier”
attribute of features found using `nwissite` as the `{dataSource}`
input. The following code shows the NLDI identifiers and how to use them
with the dataRetrieval function **readNWISdv**.

``` r
nwis_gage_url <- "https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-08279500/navigate/UM/nwissite?distance=150"
nwis_gages <- sf::read_sf(nwis_gage_url)
nwis_ids <- as.character(nwis_gages$identifier)
print(paste("The NLDI ID for:", nwis_gages$name, "is", nwis_ids))
```

    ## [1] "The NLDI ID for: RIO GRANDE NEAR LOBATOS, CO is USGS-08251500"                      
    ## [2] "The NLDI ID for: RIO GRANDE NEAR CERRO, NM is USGS-08263500"                        
    ## [3] "The NLDI ID for: RIO GRANDE BLW TAOS JUNCTION BRIDGE NEAR TAOS, NM is USGS-08276500"
    ## [4] "The NLDI ID for: RIO GRANDE AT EMBUDO, NM is USGS-08279500"

``` r
nwis_ids <- gsub(pattern = "USGS-", replacement = "", nwis_ids)
print(paste(nwis_gages$name, "has id", nwis_ids))
```

    ## [1] "RIO GRANDE NEAR LOBATOS, CO has id 08251500"                      
    ## [2] "RIO GRANDE NEAR CERRO, NM has id 08263500"                        
    ## [3] "RIO GRANDE BLW TAOS JUNCTION BRIDGE NEAR TAOS, NM has id 08276500"
    ## [4] "RIO GRANDE AT EMBUDO, NM has id 08279500"

``` r
# Now we can use these IDs with dataRetrieval.
dv_data <- dataRetrieval::readNWISdv(siteNumber = nwis_ids[1], parameterCd = '00060')
plot(dv_data$Date, dv_data$X_00060_00003, 
     main = paste("Daily Streamflow for", nwis_gages$name[1]), xlab = "", ylab = "Daily Streamflow (CFS)")
```

{{< figure src="/static/nldi-intro/dv-1.png" alt="Daily Streamflow Plot" title="Daily Streamflow Plot" width="672" >}}


Similarly, we can use identifiers returned using `wqp` as the
`{dataSource}` with the **readWQPqw** function. In this case, the
identifiers can be used without modification as shown below. Note that
the NLDI query for downstream mainstem found 2756 sites and upstream
tributaries found 1908 sites. The query below gets data from just one!
The NLDI is used as a spatial pre-filter in the [Water Quality Portal
user interface](https://www.waterqualitydata.us/portal/), which has a
rich set of filter options in addition to network navigation.

``` r
wqp_site <- list(names = as.character(nldi_data$DMwqp$name), 
                 ids = as.character(nldi_data$DMwqp$identifier))
print(paste(wqp_site$names[1:10], "has id", wqp_site$ids[1:10]))
```

    ##  [1] "RIO GRANDE AT FORT QUITMAN, TX has id USGS-08370500"                          
    ##  [2] "KEYSTONE RESERVIOR INLET, EL PASO, TX has id USGS-314818106323910"            
    ##  [3] "MBOWN-186 - 28S.02E.24.444 (ST-29) has id USGS-315101106410701"               
    ##  [4] "28S.03E.21.441 has id USGS-315112106380101"                                   
    ##  [5] "NEMEXAS DRAIN AT GOMEZ ROAD NEAR CANUTILLO, TX has id USGS-315152106364410"   
    ##  [6] "27S.03E.20.432B has id USGS-315622106391703"                                  
    ##  [7] "TEMP WELL-A INFLOW AT VINTON BRIDGE NR VINTON, TX has id USGS-315732106361610"
    ##  [8] "MBOWN-164 - 27S.03E.17.1414 has id USGS-315737106392501"                      
    ##  [9] "MBOWN-152 - 27S.03E.03.211A (ISC-1A/ISC-1M) has id USGS-315940106372301"      
    ## [10] "26S.03E.29.220 has id USGS-320125106390301"

``` r
wqp_data <- dataRetrieval::readWQPqw(siteNumbers = wqp_site$ids[1:10], parameterCd = "")
print(paste0("Got ", ncol(wqp_data), " samples beween ", min(wqp_data$ActivityStartDate), " and ", max(wqp_data$ActivityStartDate), " for characteristics: ", paste(unique(wqp_data$CharacteristicName), collapse = ", ")))
```

    ## [1] "Got 65 samples beween 1971-03-01 and 2016-09-18 for characteristics: Manganese, Mercury, Cadmium, Suspended Sediment Discharge, Strontium, Hardness, non-carbonate, Suspended sediment concentration (SSC), Sodium adsorption ratio [(Na)/(sq root of 1/2 Ca + Mg)], Sodium, percent total cations, Barium, Lithium, Lead, Suspended Sediment Concentration (SSC), Hardness, Ca, Mg, Carbonate, Fluoride, Zinc, Potassium, Iron, Oxygen, Chloride, Carbon dioxide, Bicarbonate, Total dissolved solids, Selenium, Cobalt, Temperature, water, Chromium, Stream flow, mean. daily, Turbidity, Magnesium, Alkalinity, total, Ethion, Heptachlor epoxide, Silica, Sulfate, Inorganic nitrogen (nitrate and nitrite), pH, Specific conductance, Heptachlor, Sodium, Copper, Calcium, Nitrate, Arsenic, Endrin, Fecal Streptococcus Group Bacteria, Total Coliform, Chlorophyll a, Chlorophyll b, Kjeldahl nitrogen, Ammonia and ammonium, Chlordane, technical, Dieldrin, Biomass, periphyton, Phytoplankton, Nitrite, Organic Nitrogen, Nitrogen, mixed forms (NH3), (NH4), organic, (NO2) and (NO3), Malathion, Methyl parathion, Carbophenothion-methyl, Diazinon, Nickel, Phosphorus, Hydrogen ion, p,p'-DDD, p,p'-DDE, p,p'-DDT, Methoxychlor, Parathion, Carbophenothion, Biochemical oxygen demand, standard conditions, Fecal Coliform, Aluminum, Lindane, Toxaphene, Aldrin, Organic carbon, Boron, Carbon-14, Carbon, isotope of mass 13, Gross-Uranium, Uranium-235, Uranium-234, Nitrogen, Argon, Methane, Silvex, Simazine, 2,4,5-T, 2,4-D, Atrazine, Orthophosphate, Silver, Vanadium, Stream flow, instantaneous, Molybdenum, Hydrogen sulfide, Depth to water level below land surface, Depth, from ground surface to well water level, Tritium, Temperature, air, deg C, Polychlorinated biphenyls, Beryllium, Barometric pressure, Krypton, Xenon, Phosphate-phosphorus, Gage height, Depth, Height, gage, Sodium plus potassium, Oxygen-18, Potassium-40, Flow rate, instantaneous, Antimony, Bromide, Thallium, Dichloroprop, Deuterium, Strontium-87/Strontium-86, ratio, Sulfur-34/Sulfur-32 ratio, Helium, Neon, .alpha.-Endosulfan, Mirex, Ethylan, Chlorinated naphthalenes, RBP High water mark, RBP Stream width, Floating algae mat - severity (choice list), Floating debris - severity (choice list), Floating Garbage Severity (choice List), Detergent, severity (choice list), Odor, atmospheric, Turbidity severity (choice list), Fish Kill, Severity (choice list), Oil and Grease, Total solids"

Summary
-------

In this blog post, we summarized the NLDI’s Web API through links to the
system’s [Swagger](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui.html)
documentation. The primary API parameters, `{featureSource}` and
`{featureID}`, were described. Two functions that operate with any
`{featureID}`, ***navigation*** (and it’s optional `{distance}`
parameter) and ***basin*** were demonstrated. The the ***navigation***
function’s `{dataSource}` parameter, which can be any `{featureSource}`,
was shown by retrieving NWIS (`nwissite`) and WQP (`wqp`) sites upstream
and downstream of an NWIS site.

The post finishes by showing how to use sites found with the NLDI to
download data from the National Water Information System and Water
Quality portal. The potential for extending this use of the NLDI is
vast. As more feature/data sources are indexed and the system evolves,
the NLDI should serve as a major new discovery service for many sources
of observed and modeled data.

The NLDI is an exciting new service that is being implemented in an
incremental and agile development process. Given that, the API will
expand and new versions of the API may have somewhat different design.
The intention is to keep the Web API described here the same, only
changing it by introducing a version identifier as an API parameter. If
you found this useful and plan on using the NLDI as a dependency in a
project of application, we would greatly appreciate hearing about your
use case and can answer any questions you have while implementing your
application.

Please email
<a href="mailto:dblodgett@usgs.gov" class="email">dblodgett@usgs.gov</a>
with questions and feedback.
