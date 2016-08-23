---
author: Laura DeCicco
date: 2016-08-23
slug: 
draft: True
title: Leaflet
categories: Data Science
 
tags: 
  - R
  - dataRetrieval
 
---
Get some data:

``` r
library(dataRetrieval)
pCode <- c("00662","00665")
phWI <- readNWISdata(stateCd="WI", parameterCd=pCode,
                     service="site", seriesCatalogOutput=TRUE)

library(dplyr)
phWI.1 <- filter(phWI, parm_cd %in% pCode) %>%
            filter(count_nu > 300) %>%
            mutate(period = as.Date(end_date) - as.Date(begin_date)) %>%
            filter(period > 15*365)
```

Plot it on a map:

``` r
library(leaflet)
leafMap <- leaflet(data=phWI.1) %>% 
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~dec_long_va,~dec_lat_va,
                   color = "red", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~station_nm)
leafMap
```

Now, run the following code outside of the Knit enviornment (that is, "Run all previous code" followed by "Run current code chunk")

``` r
library(htmlwidgets)
library(htmltools)
library(leaflet)

leafMap <- leaflet(data=phWI.1) %>% 
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~dec_long_va,~dec_lat_va,
                   color = "red", radius=3, stroke=FALSE,
                   fillOpacity = 0.8, opacity = 0.8,
                   popup=~station_nm)
currentWD <- getwd()
setwd("static/leaflet")
saveWidget(leafMap, "leafMap.html")
setwd(currentWD)
```

<iframe seamless src="/static/leaflet/leafMap/index.html" width="100%" height="500">
</iframe>
