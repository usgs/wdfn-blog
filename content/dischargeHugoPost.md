---
author: David Watkins
date: 2016-06-13
slug: ts-colin-discharge
title: Tropical Storm Colin Discharge Plot R Code
categories: Data Science
image: static/ts-colin-discharge/mainPlot-1.png
tags: 
  - R
  - dataRetrieval
 
---
The first piece retrieves the discharge data for Anclote River site, and makes the main plot.

In the next section we make the inset map. The important part there is the `par()` command, which limits the area of the current plot that will be used for the following commands. `plot.window` sets the axis limits, and after that are regular `map()` commands.

``` r
#Tropical Storm Colin discharge

library(dataRetrieval)
library(maps)

#Retrieve the stream gage data for this site from NWIS
siteData <- readNWISdata(service="iv",sites="02310000",
                         startDate="2016-06-04",endDate="2016-06-10")
siteData <- renameNWISColumns(siteData)
loc <- attr(siteData,'siteInfo') #get site lat/lon

#main plot
 
plot(x=siteData$dateTime,y=siteData$Flow_Inst, type="l", 
     col="blue", xlab = "Day", ylab = "Discharge (cfs)",lwd=4,cex.lab=1.5,cex.axis=1.25)
title(loc$station_nm,line=1)
mtext("Tropical Storm Colin 6/4/2016-6/10/2016")
abline(v=as.POSIXct("2016-06-06 03:00:00 UTC",tz="UTC"),col="red",lwd=1.5)
text(x=as.POSIXct("2016-06-06 02:00:00 UTC",tz="UTC"),y=70,label="Precipitation begins early Monday",srt=90,pos=3)

#inset
par(plt=c(0.7,0.9,0.2,0.4),new=TRUE)  
#axis limits for the inset:
plot.window(xlim=c(-88.5,-80),ylim=c(24.5,31))  
map('state',regions="FL",lwd=1.5,
    xlim=c(-88.5,-80),ylim=c(24.5,31),add=TRUE)
#stream gage location
points(loc$dec_lon_va[1],loc$dec_lat_va[1],
       bg='red',col='red',pch=22,cex=1) 
box(lwd=1.5)
```

<img src='/static/ts-colin-discharge/mainPlot-1.png'/ title='Discharge from Tropical Storm Colin' alt='Discharge graph from Tropical Storm Colin' class=''/>

Questions
=========

Please direct any questions or comments on `dataRetrieval` to: <https://github.com/USGS-R/dataRetrieval/issues>
