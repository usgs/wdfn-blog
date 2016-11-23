---
author: Lindsay R Carr
date: 2016-06-09
slug: ts-colin-precip
title: Visualizing Tropical Storm Colin Precipitation using geoknife
type: post
categories: Data Science
image: static/ts-colin-precip/use-functions-1.png
author_github: lindsaycarr
author_email: <lcarr@usgs.gov>
tags: 
  - R
  - geoknife
description: Using the R package geoknife to plot precipitation by county during Tropical Strom Colin.
keywords:
  - R
  - geoknife
---
Tropical Storm Colin (TS Colin) made landfall on June 6 in western Florida. The storm moved up the east coast, hitting Georgia, South Carolina, and North Carolina. We can explore the impacts of TS Colin using open data and R. Using the USGS-R `geoknife` package, we can pull precipitation data by county.

### First, we created two functions. One to fetch data and one to map data.

Function to retrieve precip data using [`geoknife`](https://github.com/USGS-R/geoknife):

``` r
getPrecip <- function(states, startDate, endDate){
 
  # use fips data from maps package
  counties_fips <- maps::county.fips %>% 
    mutate(statecounty=as.character(polyname)) %>% # character to split into state & county
    tidyr::separate(polyname, c('statename', 'county'), ',') %>%
    mutate(fips = sprintf('%05d', fips)) %>% # fips need 5 digits to join w/ geoknife result
    filter(statename %in% states) 
  
  stencil <- webgeom(geom = 'derivative:US_Counties',
                     attribute = 'FIPS',
                     values = counties_fips$fips)
  
  fabric <- webdata(url = 'http://cida.usgs.gov/thredds/dodsC/stageiv_combined', 
                    variables = "Total_precipitation_surface_1_Hour_Accumulation", 
                    times = c(startDate, endDate))
  
  job <- geoknife(stencil, fabric, wait = TRUE, REQUIRE_FULL_COVERAGE=FALSE)
  check(job)
  precipData_result <- result(job, with.units=TRUE)
  precipData <- precipData_result %>% 
    select(-variable, -statistic, -units) %>% 
    gather(key = fips, value = precipVal, -DateTime) %>%
    left_join(counties_fips, by="fips") #join w/ counties data
  
  return(precipData)
  
}
```

Function to map cumulative precipitation data using R package `maps`:

``` r
precipMap <- function(precipData, startDate, endDate){
  cols <- colorRampPalette(brewer.pal(9,'Blues'))(9)
  precip_breaks <- c(seq(0,80,by = 10), 200)
  
  precipData_cols <- precipData %>% 
    group_by(statename, statecounty) %>% 
    summarize(cumprecip = sum(precipVal)) %>% 
    mutate(cols = cut(cumprecip, breaks = precip_breaks, labels = cols, right=FALSE)) %>%
    mutate(cols = as.character(cols))
  
  par(mar = c(0,0,3,0))
  
  map('county', regions = precipData_cols$statecounty, 
      fill = TRUE, col = precipData_cols$cols, exact=TRUE)
  
  legend(x = "bottomright", fill = cols, cex = 0.7, bty = 'n', 
         title = "Cumulative\nPrecipitation (mm)",
         legend = c(paste('<', precip_breaks[-c(1,length(precip_breaks))]), 
                    paste('>', tail(precip_breaks,2)[1]))) # greater
  graphics::title("Cumulative Precipitation from Tropical Storm Colin",
                  line = 2, cex.main=1.2)  #title was being masked by geoknife
  mtext(side = 3, line = 1, cex = 0.9, 
        text= paste("By county from", startDate, "to", endDate))
}
```

### Now, we can use those functions to fetch data for specific counties and time periods.

TS Colin made landfall on June 6th and moved into open ocean on June 7th. Use these dates as the start and end times in our function (need to account for timezone, +5 UTC). We can visualize the path of the storm by mapping cumulative precipitation for each county.

``` r
library(dplyr)
library(tidyr)
library(geoknife) #order matters because 'query' is masked by a function in dplyr
library(RColorBrewer)
library(maps)

statesTSColin <- c('florida', 'alabama', 'georgia', 
                   'south carolina', 'north carolina')
startTSColin <- "2016-06-06 05:00:00"
endTSColin <- "2016-06-08 05:00:00"

precipData <- getPrecip(states = statesTSColin, 
                        startDate = startTSColin, 
                        endDate = endTSColin)
precipMap(precipData, 
          startDate = startTSColin, 
          endDate = endTSColin)
```

<img src='/static/ts-colin-precip/use-functions-1.png'/ title='Map of precipitation' alt='Map of precipitation' />

Questions
=========

Please direct any questions or comments on `geoknife` to: <https://github.com/USGS-R/geoknife/issues>

*Edited on 11/23. Works with geoknife v1.4.0 on CRAN. Changes to fips retrieval to use US Census data based on changes for [this geoknife issue](https://github.com/USGS-R/geoknife/issues/278).*
