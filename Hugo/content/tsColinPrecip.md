---
author: Lindsay R Carr
date: 2016-06-09
slug: ts-colin-precip
type: post
title: Visualizing Tropical Storm Colin Precipitation using geoknife
categories:
  - r
  -geoknife
---
Tropical Storm Colin (TS Colin) made landfall on June 6 in western Florida. The storm moved up the east coast, hitting Georgia, South Carolina, and North Carolina. We can explore the impacts of TS Colin using open data and R. Using the USGS-R `geoknife` package, we can pull precipitation data by county.

### First, we created two functions. One to fetch data and one to map data.

Function to retrieve precip data using [`geoknife`](github.com/USGS-R/geoknife):

``` r
getPrecip <- function(states, startDate, endDate){
  
  wg_s <- webgeom(geom = 'derivative:US_Counties', attribute = 'STATE')
  wg_c <- webgeom(geom = 'derivative:US_Counties', attribute = 'COUNTY')
  wg_f <- webgeom(geom = 'derivative:US_Counties', attribute = 'FIPS')
  county_info <- data.frame(state = query(wg_s, 'values'), county = query(wg_c, 'values'), 
                            fips = query(wg_f, 'values'), stringsAsFactors = FALSE) %>% 
    unique() 
  
  counties_fips <- county_info %>% filter(state %in% states) %>%
    mutate(state_fullname = tolower(state.name[match(state, state.abb)])) %>%
    mutate(county_mapname = paste(state_fullname, tolower(county), sep=",")) %>%
    mutate(county_mapname = unlist(strsplit(county_mapname, split = " county")))
  
  stencil <- webgeom(geom = 'derivative:US_Counties',
                     attribute = 'FIPS',
                     values = counties_fips$fips)
  
  fabric <- webdata(url = 'http://cida.usgs.gov/thredds/dodsC/stageiv_combined', 
                    variables = "Total_precipitation_surface_1_Hour_Accumulation", 
                    times = c(as.POSIXct(startDate), 
                              as.POSIXct(endDate)))
  
  job <- geoknife(stencil, fabric, wait = TRUE, REQUIRE_FULL_COVERAGE=FALSE)
  check(job)
  precipData <- result(job, with.units=TRUE)
  precipData2 <- precipData %>% 
    select(-variable, -statistic, -units) %>% 
    gather(key = fips, value = precipVal, -DateTime) %>% 
    left_join(counties_fips, by="fips")
  
  return(precipData2)
  
}
```

Function to map cumulative precipitation data using R package `maps`:

``` r
precipMap <- function(precipData, startDate, endDate){
  cols <- colorRampPalette(brewer.pal(9,'Blues'))(9)
  precip_breaks <- c(seq(0,80,by = 10), 200)
  
  precipData_cols <- precipData %>% 
    group_by(state_fullname, county_mapname) %>% 
    summarize(cumprecip = sum(precipVal)) %>% 
    mutate(cols = cut(cumprecip, breaks = precip_breaks, labels = cols, right=FALSE)) %>% 
    mutate(cols = as.character(cols))
  
  par(mar = c(0,0,3,0))
  
  # png('tsColin.png', width = 7, height = 5, res = 150, units = 'in')
  m1 <- map('county', regions = precipData_cols$state_fullname, col = "lightgrey")
  m2 <- map('state', regions = precipData_cols$state_fullname, 
            add = TRUE, lwd = 1.5, col = "darkgrey")
  
  # some county names are mismatched, only plot the ones that maps library 
  # knows about and then order them the same as the map
  precipData_cols <- precipData_cols %>%
    mutate(county_mapname = gsub(x = county_mapname, pattern = 'saint', replacement = 'st')) %>%
    mutate(county_mapname = gsub(x = county_mapname, pattern = 'okaloosa',
                                 replacement = 'okaloosa:main')) %>%
    filter(county_mapname %in% m1$names)
  precipData_cols <- precipData_cols[na.omit(match(m1$names, precipData_cols$county_mapname)),]
  
  m3 <- map('county', regions = precipData_cols$county_mapname, 
            add = TRUE, fill = TRUE, col = precipData_cols$cols)
  
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

statesTSColin <- c('FL', 'AL', 'GA', 'SC', 'NC')
startTSColin <- "2016-06-06 05:00:00"
endTSColin <- "2016-06-08 05:00:00"

precipData <- getPrecip(states = statesTSColin, 
                        startDate = startTSColin, 
                        endDate = endTSColin)
precipMap(precipData, 
          startDate = startTSColin, 
          endDate = endTSColin)
```

<img src='/static/ts-colin-precip/use-functions-1.png'/>
