---
author: Robert Hirsch and Laura DeCicco
date: 2016-11-05
slug: seasonal-analysis
draft: True
title: Seasonal Analysis in EGRET
type: post
categories: Data Science
image: static/seasonal-analysis/unnamed-chunk-7-1.png
 
 
 
 
 
 

tags: 
  - R
  - EGRET
 
description: Using the R-packages EGRET and EGRETci, investigate seasonal analysis.
keywords:
  - R
  - EGRET
 
  - seasonal analysis
  - surface water
---
Introduction
============

This document describes how to obtain seasonal information from the R package [EGRET](https://CRAN.R-project.org/package=EGRET). For example, we might want to know the fraction of the load that takes place in the winter season (say that is December, January, and February). We can look at the seasonal information for a single year, or averages over several years, or in terms of flow normalized fluxes.

Getting started
===============

First, you need to have installed and loaded the `EGRET` package. Then, you'll need need to create an `eList` object. See the `EGRET` vignette or user guide [here](http://pubs.usgs.gov/tm/04/a10/) for more information on how to use your own water quality data in `EGRET`. Once the `eList` object has been created, run the `modelEstimation` function to create a WRTDS model.

For this post, we will use the Choptank River as an example. There is an example data set included in `EGRET` with measured nitrate in the Choptank River. Here is an example of how to load that example data:

``` r
library(EGRET)
eList <- Choptank_eList
```

The next step is to establish what season you are interested in looking at. All functions in `EGRET` can be done on the "water year" (Oct-Sept), the calendar year (Jan-Dec), or any set of sequential months. To define what period of analysis (PA) to use, there is a function `setPA`. The `setPA` function has two arguments:

-   `paStart` is the number of the calendar month that is the start of the season.
-   `paLong` is the length of the season in months (it can be any number from 1 to 12).

For example let's say we want to consider the winter, defined here as December through February, the starting month (`paStart`) would be 12, and the length (`paLong`) would be 3:

``` r
eList <- setPA(eList, paStart = 12, paLong = 3)
```

Now all `EGRET` function will show results for only December through February. If there is a printed year for that season, it will be the year that ended the season of analysis (for example, year 2000 means December 1999 through February 2000).

Seasonal Changes
================

`EGRET` has a function `tableChange` that displays the change in concentration and flux from a set of years. Let's look at the winter change between 1990 and 2010:

``` r
tableChange(eList, yearPoints = c(1990,2010))
```

    ## 
    ##    Choptank River 
    ##    Inorganic nitrogen (nitrate and nitrite)
    ##    Season Consisting of Dec Jan Feb 
    ## 
    ##            Concentration trends
    ##    time span       change     slope    change     slope
    ##                      mg/L   mg/L/yr        %       %/yr
    ## 
    ##  1990  to  2010      0.24     0.012        18      0.89
    ## 
    ## 
    ##                  Flux Trends
    ##    time span          change        slope       change        slope
    ##                   10^6 kg/yr    10^6 kg/yr /yr      %         %/yr
    ##  1990  to  2010         0.02        0.001           10         0.51

You can compare that to change from the "water year" 1990 to 2010:

``` r
eList <- setPA(eList, paStart = 10, paLong = 12)
tableChange(eList, yearPoints = c(1990,2010))
```

    ## 
    ##    Choptank River 
    ##    Inorganic nitrogen (nitrate and nitrite)
    ##    Water Year 
    ## 
    ##            Concentration trends
    ##    time span       change     slope    change     slope
    ##                      mg/L   mg/L/yr        %       %/yr
    ## 
    ##  1990  to  2010      0.31     0.016        28       1.4
    ## 
    ## 
    ##                  Flux Trends
    ##    time span          change        slope       change        slope
    ##                   10^6 kg/yr    10^6 kg/yr /yr      %         %/yr
    ##  1990  to  2010         0.02      0.00099           15         0.76

In this example, there is is a slight difference in concentration trends if you compare just the winter season to the full water year, but very little difference in flux changes.

What does the seasonal flux trends change actually mean? The default unit "10^6 kg/yr" is mass over time. For these type of seasonal flux changes, it might be more intuitive to think of the changes in mass. December through Feburary has 90 days (31+31+28), so 24.66% of the year. So, the change in the mass of nitrate from Dec- Feb between 1990 and 2010 would be .2466 (0.02) 10^6 = 4,932 kg. And the overall change in mass from 1990 to 2010 would be 20,000 kg.

Seasonal Load Fraction
======================

Next, we can think about the seasonal load fraction.

You will need to read in two new function called `setupSeasons` and `setupYearsPlus` designed for this purpose. You can copy them from here and paste them into your workspace (all as a single copy and paste) or you can create an .R file from them that you will source each time you want to use them.

``` r
library(dplyr)

setupSeasons <- function(eList){
  Daily <- eList$Daily
  
  SeasonResults <- setupYearsPlus(Daily, 
                                  paLong = eList$INFO$paLong, 
                                  paStart = eList$INFO$paStart)
  AnnualResults <- setupYearsPlus(Daily, 
                                  paLong = 12, 
                                  paStart = eList$INFO$paStart) %>%
    filter(Counts >= 365) #To make sure we are getting full years
  
  divideBy <- 1000000
  
  annualPctResults <- AnnualResults %>%
    mutate(FluxYear = Flux*Counts/divideBy,
           FNFluxYear = FNFlux*Counts/divideBy) %>%
    select(FluxYear, FNFluxYear, Year)
  
  seasonPctResults <- SeasonResults %>%
    mutate(FluxSeason = Flux*Counts/divideBy,
           FNFluxSeason = FNFlux*Counts/divideBy) %>%
    left_join(annualPctResults, by="Year") %>%
    mutate(pctFlux = 100*FluxSeason/FluxYear,
           pctFNFlux = 100*FNFluxSeason/FNFluxYear) %>%
    select(-Q, -Conc, -Flux, -FNFlux, -FNConc, -Counts) %>%
    rename(seasonStart = paStart,
           seasonLong = paLong)
  
  return(seasonPctResults)
}

setupYearsPlus <- function (Daily, paLong = 12, paStart = 10){

  monthsToUse <- seq(paStart, length=paLong)
  monthsToUse[monthsToUse > 12] <- monthsToUse[monthsToUse > 12] - 12
  
  crossesYear <- paLong + (paStart - 1) > 12
  
  AnnualResults <- Daily %>%
    mutate(Year =  as.integer(format(Date, "%Y"))) %>%
    filter(Month %in% monthsToUse) %>%
    mutate(Year = if(crossesYear){
      ifelse(Month >= paStart, Year + 1, Year)
    } else {
      Year
    }) %>%
    group_by(Year) %>%
      summarise(DecYear = mean(DecYear, na.rm = TRUE),
                Q = mean(Q, na.rm = TRUE),
                Conc = mean(ConcDay, na.rm = TRUE),
                Flux = mean(FluxDay, na.rm = TRUE),
                FNConc = mean(FNConc, na.rm = TRUE),
                FNFlux = mean(FNFlux, na.rm = TRUE),
                Counts = sum(!is.na(ConcDay))) %>%
    mutate(paLong = paLong,
           paStart = paStart) 
      
  return(AnnualResults)
  
}
```

Simply use the loaded `eList` to calculate these seasonal load fractions. Let's go back to the winter season (Dec-Feb):

``` r
eList <- setPA(eList, paStart = 12, paLong = 3)
seasonPctResults <- setupSeasons(eList)
```

Looking at your results
=======================

What you now have is a data frame called `seasonPctResults`. The columns it contains are the following:

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

<img src='/static/seasonal-analysis/unnamed-chunk-7-1.png'/ title='Seasonal flux as a percentage of annual flux.' alt='Seasonal flux as a percentage of annual flux.' class=''/>

We can interpret this example graph as follows. The winter flux of nitrate fluctuates a good deal from year to year. From a low of around 10% to a high of around 60% but the mean percentage hasn't changed much over the years. It is around 35% of the annual total flux.

Computing averages over a period of years
=========================================

Let's say we wanted to answer the question, what percentage of the annual total flux moved in the winter season during the years 2000 through 2010. We can answer that question with a simple set of calculations.

Keep in mind, the way we are defining "year" is what year the ending year of the period of anaylsis fell. So, for this analysis, the full 2010 "year" is from Dec. 2009 through the end of November 2010.

-   Filter the data frame `seasonPctResults` for the years 2000 - 2010.

-   Now we can compute the sum of the annual fluxes for those years and the sum of the seasonal fluxes for those years, and then get our answer by taking the ratio and multiplying by 100.

``` r
years00_10 <- filter(seasonPctResults, Year >= 2000, Year <= 2010)

sumYears <- sum(years00_10$FluxYear)
 
sumSeasons <- sum(years00_10$FluxSeason)

avePct <- 100 * sumSeasons / sumYears
```

The total flux for all years in the period of interest in millions of kg is `sumYears` = 1.7297595.

The total seasonal flux for all years of the period of interest in millions of kg is `sumSeasons` = 0.6099614.

The percentage of the total flux for the years 2000 through 2010 that was transported in the winter months is `avePct` = 35.2627852.

This can be determined for any set of years simply by changing the two numbers inside the brackets to the index numbers of the first and last years of interest.

Questions
---------

-   Robert Hirsch <a href="mailto:rhirsch@usgs.gov" target="blank"><i class="fa fa-envelope-square fa-2x"></i></a> <a href="https://scholar.google.com/citations?user=Jt5I-0gAAAAJ" target="blank"><i class="ai ai-google-scholar-square ai-2x"></i></a> <a href="https://www.researchgate.net/profile/Robert_Hirsch3" target="blank"><i class="ai ai-researchgate-square ai-2x"></i></a> <a href="https://www.usgs.gov/staff-profiles/robert-hirsch" target="blank"><i class="fa fa-user fa-2x"></i></a>

-   Laura DeCicco <a href="mailto:ldecicco@usgs.gov" target="blank"><i class="fa fa-envelope-square fa-2x"></i></a> <a href="https://twitter.com/DeCiccoDonk" target="blank"><i class="fa fa-twitter-square fa-2x"></i></a> <a href="https://github.com/ldecicco-usgs" target="blank"><i class="fa fa-github-square fa-2x"></i></a> <a href="https://scholar.google.com/citations?hl=en&user=jXd0feEAAAAJ"><i class="ai ai-google-scholar-square ai-2x" target="blank"></i></a> <a href="https://www.researchgate.net/profile/Laura_De_Cicco" target="blank"><i class="ai ai-researchgate-square ai-2x"></i></a> <a href="https://www.usgs.gov/staff-profiles/laura-decicco" target="blank"><i class="fa fa-user fa-2x"></i></a>

Information on USGS-R packages used in this post:

<table style="width:93%;">
<colgroup>
<col width="19%" />
<col width="73%" />
</colgroup>
<tbody>
<tr class="odd">
<td><a href="https://github.com/USGS-R/EGRET" target="_blank"><img src="/images/USGS_R.png" alt="USGS-R image icon" style="width: 75px;" /></a></td>
<td><a href="https://github.com/USGS-R/EGRET/issues" target="_blank">EGRET</a>: Exploration and Graphics for RivEr Trends: An R-package for the analysis of long-term changes in water quality and streamflow, including the water-quality method Weighted Regressions on Time, Discharge, and Season (WRTDS)</td>
</tr>
<tr class="even">
<td><a href="https://github.com/USGS-R/dataRetrieval" target="_blank"><img src="/images/USGS_R.png" alt="USGS-R image icon" style="width: 75px;" /></a></td>
<td><a href="https://github.com/USGS-R/dataRetrieval/issues" target="_blank">dataRetrieval</a>: This R package is designed to obtain USGS or EPA water quality sample data, streamflow data, and metadata directly from web services.</td>
</tr>
</tbody>
</table>
