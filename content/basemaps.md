---
author: Jason C Fisher
date: 2017-04-10
slug: basemaps
draft: True
type: post
title: The National Map Base Maps
categories: Data Science
tags:
  - leaflet
  - R
image: static/basemaps/screenshot.png
description: Integrate The National Map services within your own interactive web map using Leaflet for R.
keywords:
  - Leaflet
  - data visualization
  - The National Map
  - dataRetrieval
author_github: jfisher-usgs
author_email: <jfisher@usgs.gov>
---

A number of map services are offered through The National Map ([TNM](https://nationalmap.gov/)).
There are no use restrictions on these [services](https://viewer.nationalmap.gov/services/).
However, map content is limited to the United States and Territories.
This post explains how to integrate TNM services within your own interactive web map using
[Leaflet for R](https://rstudio.github.io/leaflet/).

R packages required for this tutorial include
[leaflet](https://CRAN.R-project.org/package=leaflet),
[rgdal](https://CRAN.R-project.org/package=rgdal), and
[dataRetrieval](https://CRAN.R-project.org/package=dataRetrieval).
Install the required packages from the Comprehensive R Archive Network ([CRAN](https://cran.r-project.org/))
using the following commands:


```r
for (pkg in c("leaflet", "rgdal", "dataRetrieval")) {
  if (!pkg %in% rownames(utils::installed.packages()))
    utils:install.packages(pkg, repos = "https://cloud.r-project.org/")
}
```


The first step is to create a Leaflet map widget:


```r
map <- leaflet::leaflet()
```


In Leaflet, a map layer is used to display a specific dataset.
Map layers are organized by group.
Many layers can belong to the same group, but each layer can only belong to zero or one groups.
For this example, each map layer belongs to a discrete group.
Create a vector of unique group names identifying the five layers to be added to the map widget:


```r
grp <- c("USGS Topo", "USGS Imagery Only", "USGS Imagery Topo",
         "USGS Shaded Relief", "Hydrography")
```

Specify the line of attribution text to display in the map using the Hypertext Markup Language (HTML) syntax:


```r
att <- paste0("<a href='https://www.usgs.gov/'>",
              "U.S. Geological Survey</a> | ",
              "<a href='https://www.usgs.gov/laws/policies_notices.html'>",
              "Policies</a>")
```

Leaflet supports base maps using [map tiles](https://www.mapbox.com/help/how-web-maps-work/).
TNM base maps are available as Web Map Service ([WMS](https://en.wikipedia.org/wiki/Web_Map_Service)) tiles.
Add tiled layers (base maps) that describe topographic information in TNM to the map widget:


```r
GetURL <- function(service, host = "basemap.nationalmap.gov") {
  sprintf("https://%s/arcgis/services/%s/MapServer/WmsServer", host, service)
}
map <- leaflet::addWMSTiles(map, GetURL("USGSTopo"),
                            group = grp[1], attribution = att, layers = "0")
map <- leaflet::addWMSTiles(map, GetURL("USGSImageryOnly"),
                            group = grp[2], attribution = att, layers = "0")
map <- leaflet::addWMSTiles(map, GetURL("USGSImageryTopo"),
                            group = grp[3], attribution = att, layers = "0")
map <- leaflet::addWMSTiles(map, GetURL("USGSShadedReliefOnly"),
                            group = grp[4], attribution = att, layers = "0")
```

The content of these layers is described in the
[TNM Base Maps](https://viewer.nationalmap.gov/help/3.0%20TNM%20Base%20Maps.htm) document.

An overlay map layer adds information, such as river and lake features, to a base map.
Add the tiled overlay for the [National Hydrography Dataset](https://nhd.usgs.gov/) to the map widget:


```r
opt <- leaflet::WMSTileOptions(format = "image/png", transparent = TRUE)
map <- leaflet::addWMSTiles(map, GetURL("USGSHydroCached"),
                            group = grp[5], options = opt, layers = "0")
map <- leaflet::hideGroup(map, grp[5])
```

Point locations, that appear on the map as icons, may be added to a base map using a marker overlay.
In this example, site locations are included for selected wells in the
[USGS Idaho National Laboratory](https://id.water.usgs.gov/INL/)
water-quality observation network.
Create the marker-overlay dataset using the following commands (requires web access):


```r
site_no <- c("USGS 1"    = "432700112470801",
             "USGS 14"   = "432019112563201",
             "USGS 8"    = "433121113115801",
             "USGS 126A" = "435529112471301",
             "USGS 29"   = "434407112285101",
             "USGS 52"   = "433414112554201",
             "USGS 84"   = "433356112574201",
             "TRA 4"     = "433521112574201")
dat <- dataRetrieval::readNWISsite(site_no)
sp::coordinates(dat) <- c("dec_long_va", "dec_lat_va")
sp::proj4string(dat) <- sp::CRS("+proj=longlat +datum=NAD83")
dat <- sp::spTransform(dat, sp::CRS("+init=epsg:4326"))
```

Popups are small boxes containing text that appear when marker icons are clicked.
Specify the text to display in the popups using the HTML syntax:


```r
num <- dat$site_no  # site number
nam <- names(site_no)[match(num, site_no)]  # local site name
url <- sprintf("https://waterdata.usgs.gov/nwis/inventory/?site_no=%s", num)
pop <- sprintf("<b>Name:</b> %s<br/><b>Site No:</b> <a href='%s'>%s</a>",
               nam, url, num)
```


Add the marker overlay to the map widget:


```r
opt <- leaflet::markerClusterOptions(showCoverageOnHover = FALSE)
map <- leaflet::addCircleMarkers(map, radius = 10, weight = 3, popup = pop,
                                 clusterOptions = opt, data = dat)
```

Add a Leaflet control feature that allows users to interactively show and hide base maps:


```r
opt <- leaflet::layersControlOptions(collapsed = FALSE)
map <- leaflet::addLayersControl(map, baseGroups = grp[1:4],
                                 overlayGroups = grp[5], options = opt)
```


Print the map widget to display it in your web browser:


```r
print(map)
```



<iframe seamless src="/static/basemaps/map/index.html" width="100%" height="500"></iframe>

And let's not forget the R session information.


```r
print(utils::sessionInfo())
```

```
## R version 3.3.3 (2017-03-06)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 14393)
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.10        xml2_1.1.1          knitr_1.15.1       
##  [4] magrittr_1.5        hms_0.3             lattice_0.20-35    
##  [7] xtable_1.8-2        R6_2.2.0            plyr_1.8.4         
## [10] stringr_1.2.0       httr_1.2.1          dplyr_0.5.0        
## [13] tools_3.3.3         rgdal_1.2-6         grid_3.3.3         
## [16] DBI_0.6-1           htmltools_0.3.5     crosstalk_1.0.0    
## [19] yaml_2.1.14         dataRetrieval_2.6.7 leaflet_1.1.0      
## [22] digest_0.6.12       assertthat_0.1      tibble_1.3.0       
## [25] shiny_1.0.1         reshape2_1.4.2      readr_1.1.0        
## [28] htmlwidgets_0.8     curl_2.4            evaluate_0.10      
## [31] mime_0.5            sp_1.2-4            stringi_1.1.5      
## [34] jsonlite_1.3        lubridate_1.6.0     httpuv_1.3.3
```
