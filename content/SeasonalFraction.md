---
author: Robert Hirsch and Laura DeCicco
date: 2016-11-05
slug: seasonal-analysis
draft: True
title: Seasonal Analysis in EGRET
type: post
categories: Data Science
image: static/seasonal-analysis/unnamed-chunk-3-1.png
tags: 
  - R
  - EGRET
 
description: Using the R-packages EGRET and EGRETci, investigate seasonal analysis.
keywords:
  - R
  - EGRET
 
 
 
---
Introduction
============

This ducument describes how to obtain information from [EGRET](https://CRAN.R-project.org/package=EGRET) results that describe the seasonal distribution of fluxes. For example, we might want to know the fraction of the load that takes place in the winter season (say that is December, January, and February). We can look at it for a single year, we can look at averages of it over several years, or we can look at it in terms of flow normalized fluxes.

Getting started
===============

First, you need to have loaded the `EGRET` package and you need to have run the `modelEstimation` function and as a result of that, have an `eList` object.

Next, you will need to read in two new function called `setupSeasons` and `setupYearsPlus` designed for this purpose. You can copy them from here and paste them into your workspace (all as a single copy and paste) or you can create an .R file from them that you will source each time you want to use them.

``` r
setupSeasons <- function(localDaily, paLong, paStart){
  SeasonResults <- setupYearsPlus(localDaily, paLong = paLong, paStart = paStart)
  AnnualResults <- setupYearsPlus(localDaily, paLong = 12, paStart = paStart)
  
  divideBy <- 1000000
  
  annualPctResults <- AnnualResults %>%
    mutate(FluxYear = Flux*Counts/divideBy,
           FNFluxYear = FNFlux*Counts/divideBy) %>%
    select(FluxYear, FNFluxYear)
  
  seasonPctResults <- SeasonResults %>%
    mutate(FluxSeason = Flux*Counts/divideBy,
           FNFluxSeason = FNFlux*Counts/divideBy) %>%
    bind_cols(annualPctResults) %>%
    mutate(pctFlux = 100*FluxSeason/FluxYear,
           pctFNFlux = 100*FNFluxSeason/FNFluxYear,
           Year = trunc(DecYear)) %>%
    select(-Q, -Conc, -Flux, -FNFlux, -FNConc, -Counts) %>%
    rename(seasonStart = paStart,
           seasonLong = paLong)
  
  return(seasonPctResults)
}

library(dplyr)

setupYearsPlus <- function (localDaily, paLong = 12, paStart = 10){
  AnnualResults <- setupYears(localDaily = localDaily, paLong = paLong, paStart = paStart)
  
  monthsToUse <- seq(paStart, length=paLong)
  monthsToUse[monthsToUse > 12] <- monthsToUse[monthsToUse > 12] - 12
  
  waterYear <- paLong == 12 & paStart == 10
  
  AnnualResults <- localDaily %>%
    mutate(waterYear = as.integer(format(Date, "%Y"))) %>%
    mutate(waterYear = ifelse(Month >= 10, waterYear + 1, waterYear)) %>%
    filter(Month %in% monthsToUse) %>%
    mutate(Year = ifelse(waterYear, waterYear, as.integer(format(Date, "%Y")))) %>%
    group_by(Year) %>%
      summarise(DecYear = mean(DecYear, na.rm = TRUE),
                Q = mean(Q, na.rm = TRUE),
                Conc = mean(ConcDay, na.rm = TRUE),
                Flux = mean(FluxDay, na.rm = TRUE),
                FNConc = mean(FNConc, na.rm = TRUE),
                FNFlux = mean(FNFlux, na.rm = TRUE),
                Counts = sum(!is.na(ConcDay))) %>%
    mutate(paLong = paLong,
           paStart = paStart) %>%
    select(-Year)
      
  return(AnnualResults)
  
}
```

The next step is to establish what season you are interested in looking at. We do this by specifying `paStart` and `paLong`.

`paStart` is the number of the calendar month that is the start of the season.
`paLong` is the length of the season in months (it can be any number from 1 to 12).

For example lets say we want to consider the winter, defined here as December through February. This code we would use is. This is written with the example data set Choptank\_eList, which comes out of the `EGRET` package. In running this script you would delete the line `eList <- Choptank_eList` and enter the values of `paLong` and `paStart` that you wish to use.

``` r
library(EGRET)
eList <- Choptank_eList
Daily <- eList$Daily
seasonPctResults <- setupSeasons(Daily, paLong = 3, paStart = 12)
```

Looking at your results
=======================

What you now have is a data frame called seasonPctResults. The columns it contains are the following:

<table style="width:93%;">
<colgroup>
<col width="19%" />
<col width="73%" />
</colgroup>
<thead>
<tr class="header">
<th>variable</th>
<th>Definition</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>DecYear</td>
<td>Decimal Year of the mid-date of the season</td>
</tr>
<tr class="even">
<td>Year</td>
<td>Calendary Year of mid-date of the year</td>
</tr>
<tr class="odd">
<td>FluxYear</td>
<td>Estimated flux for the year in millions of kg</td>
</tr>
<tr class="even">
<td>FNFluxYear</td>
<td>Flow Normalized flux for the year in millions of kg</td>
</tr>
<tr class="odd">
<td>FluxSeason</td>
<td>Estimated flux for the season in millions of kg</td>
</tr>
<tr class="even">
<td>FNFluxSeason</td>
<td>Flow Normalized flux for the season in millions of kg</td>
</tr>
<tr class="odd">
<td>pctFlux</td>
<td>Season flux as a percentage of Annual Flux</td>
</tr>
<tr class="even">
<td>pctFNFlux</td>
<td>FlowNormalized Seasonal Flux as a percent of Flow Normalized Annual Flux</td>
</tr>
<tr class="odd">
<td>seasonLong</td>
<td>Length of the Season in Months</td>
</tr>
<tr class="even">
<td>seasonStart</td>
<td>Starting Month of the Season, 1=January</td>
</tr>
</tbody>
</table>

Plotting the time series
========================

We can make a graph showing the percentage flux (estimated annual and flow normalized)

``` r
nYears <- length(seasonPctResults$DecYear)
xlim <- c(seasonPctResults$DecYear[1]-1,seasonPctResults$DecYear[nYears]+1)
xTicks <- pretty(xlim)
ylim <- c(0,100)
yTicks <- seq(0,100,10)
plotTitle = paste("Seasonal Flux as a Percent of Annual Flux\n",
                  eList$INFO$shortName, eList$INFO$paramShortName,
                  "\nSolid line is percentage of flow normalized flux") 
genericEGRETDotPlot(seasonPctResults$DecYear,seasonPctResults$pctFlux,
                    xlim=xlim, ylim=ylim,
                    xTicks=xTicks,yTicks=yTicks,
                    xlab="Year",ylab="Percentage of Annual Flux",
                    plotTitle=plotTitle,xDate=TRUE,cex=1.5)
lines(seasonPctResults$DecYear,seasonPctResults$pctFNFlux,col="green",lwd=2)
```

<img src='/static/seasonal-analysis/unnamed-chunk-3-1.png'/ title='TODO' alt='TODO' class=''/>

We can interpret this example graph as follows. The winter flux of nitrate fluctuates a good deal from year to year. From a low of around 10% to a high of around 60% but the mean percentage hasn't changed much over the years. It is around 35% of the annual total flux.

Computing averages over a period of years
=========================================

Let's say we wanted to answer the question, what percentage of the annual total flux moved in the winter season during the years 2000 through 2010. We can answer that question with a simple set of calculations.

-   Filter the data frame `seasonPctResults` for the years 2000 - 2010.

-   Now we can compute the sum of the annual fluxs for those years and the sum of the seasonal fluxes for those years, and then get our answer by taking the ratio and multiplying by 100.

``` r
years00_10 <- filter(seasonPctResults, Year >= 2000) %>%
  filter(Year <= 2010)

sumYears <- sum(years00_10$FluxYear)
 
sumSeasons <- sum(years00_10$FluxSeason)

avePct <- 100 * sumSeasons / sumYears
```

The total flux for all years in the period of interest in millions of kg is `sumYears` = 1.727799.

The total seasonal flux for all years of the period of interest in millions of kg is `sumSeasons` = 0.6099614.

The percentage of the total flux for the years 2000 through 2010 that was transported in the winter months is `avePct` = 35.302796.

This can be determined for any set of years simply by changing the two numbers inside the brackets to the index numbers of the first and last years of interest.

Questions
---------

Please direct any questions or comments on `EGRET` to: <https://github.com/USGS-R/EGRET/issues>
