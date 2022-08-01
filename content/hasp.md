---
author: Candice Hopkins
date: 2022-07-26
slug: HASP
draft: false
title: Hydrologic Analysis Package Available to Users
type: post
categories: Data Science
image: static/hasp_files/unnamed-chunk-5-1.png
author_staff: candice-hopkins
author_email: <chopkins@usgs.gov>
tags: 
  - R
  - dataRetrieval
description: Introduction to HASP package for groundwater data.
keywords:
  - R
  - dataRetrieval
  - NWIS
---
A new R computational package was created to aggregate and plot USGS
groundwater data, providing users with much of the functionality
provided in Groundwater Watch and the [Florida Salinity
Mapper](https://fl.water.usgs.gov/mapper). The [Hydrologic Analysis
Package (HASP)](https://code.usgs.gov/water/stats/hasp) can retrieve
groundwater level and groundwater quality data, aggregate these data,
plot them, and generate basic statistics. Dcumentation is available in R
or [online](https://rconnect.usgs.gov/HASP_docs/), and users can also
launch a Shiny Application from within the package to generate images in
an interactive user interface.

# Two Data Streams, One Analysis

One of the benefits of HASP is its ability to aggregate two time-series
of data into one record and generate statistics and graphics on that
record. By merging two data sets together, users can view and manipulate
a much longer record of data, similar to how the [new monitoring
location
pages](https://waterdata.usgs.gov/blog/groundwater-field-visits-monitoring-location-pages/)
and the [groundwater data
service](https://waterdata.usgs.gov/blog/gw_bats/) present a longer
record of observations. The explore_site function can pull data for a
site and view a record of all available data at that location, then
combine both instrumented data and field visit data into one record.

``` r
site <- "263819081585801"
pCode <- "62610"
#Field GWL data:
gwl_data <- dataRetrieval::readNWISgwl(site)

# Daily data:
dv <- dataRetrieval::readNWISdv(site,
                                parameterCd = pCode, 
                                statCd = "00001")

gwl_plot_all(gw_level_dv = dv, 
             gwl_data = gwl_data, 
             parameter_cd = pCode,
             plot_title = site)
```

<figure>
<img src="/static/hasp_files/unnamed-chunk-1-1.png" title = "Discrete and daily groundwater levels." alt = "TODO" >
</figure>

Users can download the aggregated record and see basic statistics that
have been calculated with these data. Users also can specify if they
should “flip” the y-axis when working with groundwater data or other
data that should be viewed differently than a traditional y-axis. This
is powerful in allowing users to control how these groundwater data are
contextualized, especially in understanding what values mean in the
subsurface.

|           |                 |
|:----------|:----------------|
| site_no   | 263819081585801 |
| min_site  | 17.83           |
| max_site  | 64.3            |
| mean_site | 39.29886        |
| p10       | 29.575          |
| p25       | 33.2175         |
| p50       | 38.675          |
| p75       | 44.9775         |
| p90       | 49.46           |
| count     | 1398            |

HASP also allows users to plot groundwater level trends in major
aquifers as well. The explore_aquifers function allows users to pull
data from wells classified in Principal Aquifers and synthesize
water-level data to better understand trends. Users can specify a
[Principal
Aquifer](https://www.usgs.gov/mission-areas/water-resources/science/principal-aquifers-united-states)
and view a map of sites in that aquifer. Users can also view a composite
and normalized composite hydrograph for that aquifer for a specified
time frame, allowing them to simply view data from many sites in one
plot.

``` r
library(HASP)
end_date <- "2022-07-08"
state_date <- "1990-12-31"
aquifer_long_name <- "Basin and Range basin-fill aquifers"

aquiferCd <- summary_aquifers$nat_aqfr_cd[summary_aquifers$long_name == aquifer_long_name]

aquifer_data <- get_aquifer_data(aquiferCd, 
                                 state_date, 
                                 end_date)

plot_normalized_data(aquifer_data, 
                     num_years = 30, 
                     plot_title = aquifer_long_name)
```

<figure>
<img src="/static/hasp_files/dataRetrival-1.png" title = "A composite hydrograph for Basin and Range basin-fill aquifers." alt = "TODO" >
</figure>

# Enhanced Graphs for Understand Long-Term Trends

HASP allows users to view aggregated record a weekly view with
associated statistics, or in a daily view with associated statistics.
These two graphical views put recent groundwater measurements into
context by comparing with historical measurements.

``` r
weekly_frequency_plot(gw_level_dv = dv, 
                      plot_title = site,
                      parameter_cd = pCode)
```

<figure>
<img src="/static/hasp_files/unnamed-chunk-3-1.png" title = "A plot of weekly statistics on groundwater data." alt = "TODO" >
</figure>

``` r
daily_gwl_2yr_plot(gw_level_dv = dv, 
                      plot_title = site,
                      parameter_cd = pCode)
```

<figure>
<img src="/static/hasp_files/unnamed-chunk-4-1.png" title = "A plot of daily statistics on groundwater data." alt = "TODO" >
</figure>

Many users want to understand how recent measurements related to monthly
data from past years. HASP also generates a monthly plot along with
associated statistics. Many groundwater data users may be familiar with
this same graphic that has traditionally been generated by Groundwater
Watch.

``` r
monthly_frequency_plot(dv,
                       parameter_cd = pCode,
                       plot_title = site,
                       plot_range = "Past year")
```

<figure>
<img src="/static/hasp_files/unnamed-chunk-5-1.png" title = "A plot of monthly statistics on groundwater data." alt = "TODO" >
</figure>

``` r
monthly_freq_table <- monthly_frequency_table(dv,
                                              parameter_cd = pCode) 
kable(monthly_freq_table, digits = 1)
```

| month |    p5 |   p10 |   p25 |   p50 |   p75 |   p90 |   p95 | nYears | minMed | maxMed |
|------:|------:|------:|------:|------:|------:|------:|------:|-------:|-------:|-------:|
|     1 | -37.9 | -32.4 | -29.0 | -21.4 | -17.7 | -13.8 |  -7.9 |     43 |  -41.8 |   -5.7 |
|     2 | -39.8 | -32.6 | -29.2 | -22.1 | -18.8 | -12.5 |  -7.9 |     43 |  -42.8 |   -7.2 |
|     3 | -40.1 | -36.0 | -29.9 | -24.0 | -20.1 | -12.3 |  -8.0 |     43 |  -45.1 |   -6.9 |
|     4 | -43.2 | -38.9 | -32.2 | -26.2 | -21.9 | -16.3 | -11.2 |     43 |  -48.5 |   -9.3 |
|     5 | -45.8 | -40.1 | -34.9 | -27.9 | -23.4 | -18.6 | -14.2 |     43 |  -49.4 |  -10.0 |
|     6 | -41.7 | -37.0 | -32.9 | -26.7 | -21.1 | -16.7 | -14.3 |     42 |  -42.8 |  -11.0 |
|     7 | -33.1 | -31.1 | -26.3 | -20.5 | -17.7 | -14.5 | -12.1 |     43 |  -37.6 |   -6.8 |
|     8 | -28.9 | -27.4 | -22.5 | -17.6 | -14.1 | -12.2 |  -9.2 |     43 |  -32.5 |   -4.8 |
|     9 | -25.3 | -24.1 | -19.8 | -15.6 | -12.7 |  -9.7 |  -8.8 |     42 |  -32.5 |   -3.2 |
|    10 | -29.2 | -26.5 | -21.3 | -16.2 | -12.6 |  -9.6 |  -6.1 |     44 |  -35.9 |   -4.8 |
|    11 | -34.6 | -31.8 | -25.7 | -20.7 | -16.1 | -10.4 |  -7.6 |     44 |  -41.3 |   -4.5 |
|    12 | -35.9 | -32.6 | -27.7 | -21.4 | -16.9 | -13.2 |  -9.3 |     43 |  -42.4 |   -4.9 |

# See Changes in Water Quality Over Time

Users can also plot basic water-quality data in HASP. Users can plot
chloride concentrations against time and view 5-year trends and 20-year
trends in chloride. HASP allows users to generate this plot for any
water-quality parameter, so users can quickly and easily view trends of
specific analytes over time.

``` r
cl_sc <- c("Chloride", "Specific conductance")
qw_data <- qw_data <- readWQPqw(paste0("USGS-", site),
                                cl_sc)
trend_plot(qw_data, plot_title = site)
```

<figure>
<img src="/static/hasp_files/unnamed-chunk-6-1.png" title = "A plot of chloride and specific conductance." alt = "TODO" >
</figure>

HASP also generates chloride versus specific conductance plots, which
can be useful when examining trends, especially those in coastal areas
where saltwater intrusion is a risk.

``` r
qw_plot(qw_data, "Specific Conductance", 
        CharacteristicName = "Specific conductance")
```

<figure>
<img src="/static/hasp_files/unnamed-chunk-7-1.png" title = "A plot of specific conductance." alt = "TODO" >
</figure>

# Moving Beyond Groundwater

HASP uses the
[dataRetrieval](https://waterdata.usgs.gov/blog/dataretrieval/) package
to retrieve data from USGS sites. Although HASP was written with
groundwater data in mind, it can also be used to analyze USGS surface
water sites. Users can call data from surface water sites using HASP and
access a complete record of all observations at a site over time,
helping users to easily access data and statistics over the entire
period of observation. If you have thoughts about how we can further
enhance this package, email <WDFN@usgs.gov>.

# Disclaimer

Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
