---
author: David Watkins
date: 2016-06-23
slug: stats-service-map
status: draft
title: Using the dataRetrieval Stats Service
tags: 
  - dataRetrieval
  - R
categories: Data Science
image: static/stats-service-map/plot-1.png

---
This script utilizes the new `dataRetrieval` package access to the [USGS Statistics Web Service](http://waterservices.usgs.gov/rest/Statistics-Service.html). We will be pulling daily mean data using the daily value service in `readNWISdata`, and using the stats service data to put it in context of the site's history. At the time of this writing (June 23rd) a storm system had just passed through the OH-WV-PA tri-state area, and the map below shows the increased stream discharges.

Get the data
------------

There are two separate `dataRetrieval` calls here — one to retrieve the daily discharge data, and one to retrieve the historical discharge statistics. The data frames are joined by site number via [dplyr's](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html) `left_join` function. Then we add a column to the final data frame to hold the color value for each station.

``` r
#example stats service map, comparing real-time current discharge to history for each site
#reusable for other state(s)
#David Watkins June 2016

library(dataRetrieval)
library(maps)
library(dplyr)
library(lubridate)

#pick state(s)
states <- c("OH","WV","PA")
storm.date <- "2016-06-23"

for(st in states){

  stDV <- renameNWISColumns(readNWISdata(service="dv",
                                       parameterCd="00060",
                                       stateCd = st,
                                       startDate = storm.date,
                                       endDate = storm.date))
  if(st != states[1]){
    storm.data <- full_join(storm.data,stDV)
    sites <- full_join(sites, attr(stDV, "siteInfo"))
  } else {
    storm.data <- stDV
    sites <- attr(stDV, "siteInfo")
  }
}

#retrieve stats data, dealing with 10 site limit to stat service requests
reqBks <- seq(1,nrow(sites),by=10)
statData <- data.frame()
for(i in reqBks) {
  getSites <- sites$site_no[i:(i+9)]
  currentSites <- readNWISstat(siteNumbers = getSites,
                               parameterCd = "00060", 
                    statReportType="daily",
                    statType=c("p10","p25","p50","p75","p90","mean"))
  statData <- rbind(statData,currentSites)
}

statData.storm <- statData[statData$month_nu == month(storm.date) & 
                            statData$day_nu == day(storm.date),]

finalJoin <- left_join(storm.data,statData.storm)
finalJoin <- left_join(finalJoin,sites)

finalJoin <- finalJoin[!is.na(finalJoin$Flow),] #remove sites without current data

#classify current discharge values
finalJoin$class <- NA
finalJoin$class <- ifelse(is.na(finalJoin$p25), 
                          ifelse(finalJoin$Flow > finalJoin$p50_va, "cyan","yellow"),
                          ifelse(finalJoin$Flow < finalJoin$p25_va, "red2",
                          ifelse(finalJoin$Flow > finalJoin$p75_va, "navy","green4")))
```

Make the plot
-------------

The base map consists of two plots. The first makes the county lines with a gray background, and the second overlays the heavier state lines. After that we add the points for each stream gage, colored by the column we added to `finalJoin`. In the finishing details, `grconvertXY` is a handy function that converts your inputs from a normalized (0-1) coordinate system to the actual map coordinates, which allows the legend and scale to stay in the same relative location on different maps.

``` r
states <- c("Ohio","West Virginia","Pennsylvania")
map('county',regions=states,fill=TRUE, col="gray87", lwd=0.5)
map('state',regions=states,fill=FALSE, lwd=2, add=TRUE)
points(finalJoin$dec_lon_va,
       finalJoin$dec_lat_va,
       col=finalJoin$class, pch=19)
box(lwd=2)
title(paste("Daily discharge value percentile rank\n",storm.date),line=1)
par(mar=c(5.1, 4.1, 4.1, 6), xpd=TRUE)
legend("bottomright",inset=c(0.01,.01),
       legend=c("Q > P50*","Q < P50*","Q < P25","P25 < Q < P75","Q > P75"),
       pch=19,cex = 0.75,pt.cex = 1.2,
       col = c("cyan","yellow","red2","green4","navy"),
       ncol = 2)
map.scale(ratio=FALSE,cex = 0.75,
          grconvertX(0.08,"npc"), 
          grconvertY(-0.01, "npc"))
text("*Other percentiles not available for these sites", cex=0.75,
     x=grconvertX(0.8,"npc"), 
     y=grconvertY(-0.01, "npc"))
```

<img src='/static/stats-service-map/plot-1.png'/>
