---
author: Laura DeCicco
date: 2016-10-06
slug: daily-discrete-join
draft: True
title: Merging Daily and Discrete Data
type: post
categories: Data Science
image: static/daily-discrete-join/plot-1.png
tags: 
  - R
  - dataRetrieval
  - water-quality
description: Using the R-package dataRetrieval, a simple discription on now to combine daily discharge and discrete water-quality measurements.
keywords:
  - R
  - dataRetrieval
  - water-quality
 
 
---
Water Quality Data Analysis
===========================

The `dataRetrieval` package makes it easy to import US water-quality and hydrologic data into R. There are many tasks that have a common theme in water-quality data analysis.

This post will show a few simple ways to join discrete water-quality data with continuous streamflow data. The reason that this task is often needed is that water-quality measurements are often made by collecting a water sample, and sending that sample to a labratory for analysis (admittedly there are more-and-more water quality sensors, but the field is still mostly discrete samples). On the other hand, streamflow measurements (usually measured in cubic feet per second) have been collected via sensors for decades. The discharge data is often reported via web services on a 15-minute time scale. In the USGS, this is called either "instantaneous" or "unit" data. The unit data is aggregated to a daily mean. The daily means are also available via web services, and these values can go back decades.

One simple, yet very common case is to want to get a column in the discrete sample data that is the daily mean discharge for the day of sample collection.

In this example, we'll have 5 USGS sites that collected discharge (parameter code 00060), total suspended solids (00530), and specific conductance (00095).

First we get the data:

``` r
library(dataRetrieval)

#Retrieve daily Q
siteNumber<-c("02369800","02450250","02327100","02212600","02178400")
dailyQ <- readNWISdv(siteNumber,"00060") 

parameterCd <- c("00530","00095")
dailySC_SS <- readNWISqw(siteNumber,parameterCd)

dailyQ <- renameNWISColumns(dailyQ)
```

Next, since we only need to join the data on the day scale, let's use the `dplyr` package to join by dates:

``` r
library(dplyr)
simpleDailyQ <- select(dailyQ, Date, Flow, site_no)

dailySC_SS <- left_join(dailySC_SS, simpleDailyQ, 
                          by=c("sample_dt"="Date",
                               "site_no"="site_no"))
#let's just pull out a few columns:
simpleDailySC_SS <- select(dailySC_SS, site_no, sample_dt, parm_cd, result_va, Flow)
```

The data frame is now set up nicely for `ggplot2` graphs:

``` r
library(ggplot2)
ggplot(data = simpleDailySC_SS) +
  geom_point(aes(x=Flow, y=result_va)) +
  facet_grid(parm_cd ~ site_no,scales = "free") 
```

    ## Warning: Removed 8 rows containing missing values (geom_point).

<img src='/static/daily-discrete-join/unnamed-chunk-3-1.png'/ title='Discharge vs water quality measurements' alt='TODO' class=''/>

Questions
=========

Please direct any questions or comments on `dataRetrieval` to: <https://github.com/USGS-R/dataRetrieval/issues>
