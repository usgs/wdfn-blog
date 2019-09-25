---
author: Jason C Fisher
date: 2017-04-12
slug: basemaps
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
    utils::install.packages(pkg, repos = "https://cloud.r-project.org/")
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



<iframe seamless src="/static/basemaps/map/index.html" width="100%" height="500" frameborder="0"></iframe>

Some users have reported that base maps do not render correctly in the
[RStudio](https://www.rstudio.com/) viewer.
Until RStudio can address this issue, the following workaround is provided:


```r
options(viewer = NULL)
print(map)
```

And let's not forget the R session information.


```
## - Session info ----------------------------------------------------------
##  setting  value                       
##  version  R version 3.5.1 (2018-07-02)
##  os       Windows 10 x64              
##  system   x86_64, mingw32             
##  ui       Rgui                        
##  language (EN)                        
##  collate  English_United States.1252  
##  ctype    English_United States.1252  
##  tz       America/Los_Angeles         
##  date     2018-11-08                  
## 
## - Packages --------------------------------------------------------------
##  package       * version date       lib source        
##  assertthat      0.2.0   2017-04-11 [1] CRAN (R 3.5.1)
##  backports       1.1.2   2017-12-13 [1] CRAN (R 3.5.0)
##  base64enc       0.1-3   2015-07-28 [1] CRAN (R 3.5.0)
##  bindr           0.1.1   2018-03-13 [1] CRAN (R 3.5.1)
##  bindrcpp        0.2.2   2018-03-29 [1] CRAN (R 3.5.1)
##  callr           3.0.0   2018-08-24 [1] CRAN (R 3.5.1)
##  cli             1.0.1   2018-09-25 [1] CRAN (R 3.5.1)
##  crayon          1.3.4   2017-09-16 [1] CRAN (R 3.5.1)
##  crosstalk       1.0.0   2016-12-21 [1] CRAN (R 3.5.1)
##  curl            3.2     2018-03-28 [1] CRAN (R 3.5.1)
##  dataRetrieval   2.7.4   2018-05-09 [1] local         
##  debugme         1.1.0   2017-10-22 [1] CRAN (R 3.5.1)
##  desc            1.2.0   2018-05-01 [1] CRAN (R 3.5.1)
##  devtools        2.0.1   2018-10-26 [1] CRAN (R 3.5.1)
##  digest          0.6.18  2018-10-10 [1] CRAN (R 3.5.1)
##  dplyr           0.7.7   2018-10-16 [1] CRAN (R 3.5.1)
##  evaluate        0.12    2018-10-09 [1] CRAN (R 3.5.1)
##  fs              1.2.6   2018-08-23 [1] CRAN (R 3.5.1)
##  glue            1.3.0   2018-07-17 [1] CRAN (R 3.5.1)
##  hms             0.4.2   2018-03-10 [1] CRAN (R 3.5.1)
##  htmltools       0.3.6   2017-04-28 [1] CRAN (R 3.5.1)
##  htmlwidgets     1.3     2018-09-30 [1] CRAN (R 3.5.1)
##  httpuv          1.4.5   2018-07-19 [1] CRAN (R 3.5.1)
##  httr            1.3.1   2017-08-20 [1] CRAN (R 3.5.1)
##  jsonlite        1.5     2017-06-01 [1] CRAN (R 3.5.1)
##  knitr           1.20    2018-02-20 [1] CRAN (R 3.5.1)
##  later           0.7.5   2018-09-18 [1] CRAN (R 3.5.1)
##  lattice         0.20-38 2018-11-04 [1] CRAN (R 3.5.1)
##  leaflet         2.0.2   2018-08-27 [1] CRAN (R 3.5.1)
##  lubridate       1.7.4   2018-04-11 [1] CRAN (R 3.5.1)
##  magrittr        1.5     2014-11-22 [1] CRAN (R 3.5.1)
##  memoise         1.1.0   2017-04-21 [1] CRAN (R 3.5.1)
##  mime            0.6     2018-10-05 [1] CRAN (R 3.5.1)
##  pillar          1.3.0   2018-07-14 [1] CRAN (R 3.5.1)
##  pkgbuild        1.0.2   2018-10-16 [1] CRAN (R 3.5.1)
##  pkgconfig       2.0.2   2018-08-16 [1] CRAN (R 3.5.1)
##  pkgload         1.0.2   2018-10-29 [1] CRAN (R 3.5.1)
##  plyr            1.8.4   2016-06-08 [1] CRAN (R 3.5.1)
##  prettyunits     1.0.2   2015-07-13 [1] CRAN (R 3.5.1)
##  processx        3.2.0   2018-08-16 [1] CRAN (R 3.5.1)
##  promises        1.0.1   2018-04-13 [1] CRAN (R 3.5.1)
##  ps              1.2.1   2018-11-06 [1] CRAN (R 3.5.1)
##  purrr           0.2.5   2018-05-29 [1] CRAN (R 3.5.1)
##  R6              2.3.0   2018-10-04 [1] CRAN (R 3.5.1)
##  Rcpp            1.0.0   2018-11-07 [1] CRAN (R 3.5.1)
##  readr           1.1.1   2017-05-16 [1] CRAN (R 3.5.1)
##  remotes         2.0.2   2018-10-30 [1] CRAN (R 3.5.1)
##  reshape2        1.4.3   2017-12-11 [1] CRAN (R 3.5.1)
##  rgdal           1.3-6   2018-10-16 [1] CRAN (R 3.5.1)
##  rlang           0.3.0.1 2018-10-25 [1] CRAN (R 3.5.1)
##  rprojroot       1.3-2   2018-01-03 [1] CRAN (R 3.5.1)
##  sessioninfo     1.1.1   2018-11-05 [1] CRAN (R 3.5.1)
##  shiny           1.2.0   2018-11-02 [1] CRAN (R 3.5.1)
##  sp              1.3-1   2018-06-05 [1] CRAN (R 3.5.1)
##  stringi         1.2.4   2018-07-20 [1] CRAN (R 3.5.1)
##  stringr         1.3.1   2018-05-10 [1] CRAN (R 3.5.1)
##  testthat        2.0.1   2018-10-13 [1] CRAN (R 3.5.1)
##  tibble          1.4.2   2018-01-22 [1] CRAN (R 3.5.1)
##  tidyselect      0.2.5   2018-10-11 [1] CRAN (R 3.5.1)
##  usethis         1.4.0   2018-08-14 [1] CRAN (R 3.5.1)
##  withr           2.1.2   2018-03-15 [1] CRAN (R 3.5.1)
##  xml2            1.2.0   2018-01-24 [1] CRAN (R 3.5.1)
##  xtable          1.8-3   2018-08-29 [1] CRAN (R 3.5.1)
##  yaml            2.2.0   2018-07-25 [1] CRAN (R 3.5.1)
## 
## [1] C:/Users/jfisher/Tools/R/R-3.5.1/library
```
