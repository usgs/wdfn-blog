# Decommissioning Groundwater Watch 

## What are you decommissioning?

In September of 2022, the USGS is shutting down (decommissioning) the
[Groundwater
Watch](https://groundwaterwatch.usgs.gov/usgsgwnetworks.asp)
application. This web application has served groundwater level data and
statistics since 2006. Popular features of this product include
individual site pages for wells and springs, maps of current conditions,
and graphs showing the statistical context of recent measurements; major
functionality of Groundwater Watch is pictured in Figure 1.

![Shape Description automatically
generated](media\image1.jpg){width="6.5in"
height="5.6673600174978125in"}However, the application's architecture,
aging code base, and other factors make it difficult to update and keep
secure. In the coming year, modern software replacements of the unique
groundwater functionality will be developed by USGS Water. In the
meantime, users can access other USGS products with similar
functionality. You can determine which products best suit your needs as
described below.

## 

## Where can I find water level data after the application is turned off?

![](media\image2.jpeg){width="5.8858267716535435in"
height="3.1145833333333335in"}

Unprocessed groundwater level data are always available on [Water Data
for the Nation](https://waterdata.usgs.gov/nwis/gw); this website is the
best place to get our most recent, uninterpreted data. Users can search
and download water-level data on Water Data for the Nation, or
programmatically access these data via
[WaterServices](https://waterservices.usgs.gov/). Users can
interactively explore water-level data for individual sites on our
[Next-Generation Monitoring Location
Pages](https://waterdata.usgs.gov/blog/how-to-use-nextgen-pages/).

One of the features users like about Groundwater Watch is that it
combines two sets of water level data, instrumented data and field visit
data, into one data stream. Two new tools also offer access to this
consolidated data set: the HASP package in R and the [Best Available
Time Series service](https://waterdata.usgs.gov/blog/gw_bats/). Both
options allow users to access consolidated data sets that are not
available directly from Water Data for the Nation. The [National
Groundwater Monitoring Network (NGWMN) Data
Portal](https://cida.usgs.gov/ngwmn/index.jsp) uses the Best Available
Time Series (BATS) service to populate data for USGS groundwater sites
in the National Groundwater Monitoring Network; this product also offers
[web services](https://cida.usgs.gov/ngwmn/web-services.jsp) and another
method of accessing the consolidated data set, but at a smaller set of
USGS wells.

## Where can I find groundwater level maps after the application is turned off?

![Diagram Description automatically generated with low
confidence](media\image3.jpg){width="6.5in"
height="3.1006944444444446in"}

Users have come to rely on Groundwater Watch to deliver simple maps that
display the statistical context of recent measurements through colored
dots. Animations of these dots over time are a feature that has been
used to show changing conditions over time. This feature was so popular
that aspects of it are replicated in the [NGWMN Data
Portal](https://cida.usgs.gov/ngwmn/provider/statistics-methods/) and in
the [National Water
Dashboard](https://dashboard.waterdata.usgs.gov/app/nwd/?aoi=default).
In each of these products, a site is represented by a symbol indicating
the status of the most recent measurement, if enough data are available
at that site.

The USGS VizLab produced a [visualization of current conditions of
wells](https://labs.waterdata.usgs.gov/visualizations/gw-conditions/index.html#/?utm_source=drupal&utm_medium=home&utm_campaign=gw_conditions)
that have continuous data and at least three years of available data.
The current iteration of the animation contains about 2,300 wells. The
visualization will be updated over time, and the [code behind it
is](https://github.com/usgs-vizlab/gw-conditions) publicly available to
be used by anyone.

## Where can I find groundwater level statistics and graphs after the application is turned off?

![A picture containing text, businesscard Description automatically
generated](media\image4.jpg){width="6.5in" height="2.4125in"}

The detailed statistics and graphical representation of water-level data
on site pages are some of Groundwater Watch's most popular features.
Groundwater Watch allows users to explore various views of data,
including a graph showing the period of record, a daily data plot
(showing the range of approved daily minimum and maximum data), and a
graph showing recent measurements as compared to monthly statistics from
the period of record.

The [Hydrologic AnalySis Package](https://usgs-r.github.io/HASP/) (HASP)
was created to replicate these graphics and statistics. Users can select
a site and produce statistics and graphics on any USGS site of their
choosing. Users can also produce hydrographs for entire aquifers using
the Composite Workflows. HASP also allows users to produce some
water-quality cross-plots. This package can be accessed via RStudio and
interacted with through a clickable Shiny application.

The [NGWMN Data Portal](https://cida.usgs.gov/ngwmn/index.jsp) allows
access to interactive hydrographs and advanced statistics on individual
site pages. This application serves data not available elsewhere on
other USGS systems, representing data from over 37 contributing
organizations.

### What if I use another feature that was not listed above?

We acknowledge there might be additional functionality of Groundwater
Watch that cannot easily be replicated in another product. We're sorry.
We hope to develop modernized software for the core Groundwater Watch
functionality in the next several years. We will keep everyone informed
as we work on the modernized software and publicize as new products and
functionality are available.

## Water Data for the Nation and Webservices

Unprocessed groundwater level data are available on ; this website is
the best place to get our most recent, uninterpreted data. Users can
search and download water-level data on Water Data for the Nation, or
programmatically access these data via
[WaterServices](https://waterservices.usgs.gov/). Users can
interactively explore water-level data for individual sites on our
[Next- Generation Monitoring Location
Pages](https://waterdata.usgs.gov/blog/how-to-use-nextgen-pages/).

GWW alternatives:

-   Raw data feed consumption

-   Data access at thousands of sites

# NGWMN Data Portal

[NGWMN Data Portal](https://cida.usgs.gov/ngwmn/) serves data from the
National Groundwater Monitoring Network (NGWMN). This product serves
site information, water-quality information, and water-level
information, as well as a dot-map indicating the statistical condition
of the most recent water-level measurement. More detailed statistical
calculations and an interactive hydrograph are available on site pages.

A more limited number of USGS sites are available on this application
due to sites needing to meet National Groundwater Monitoring Network
criteria. The NGWMN statistics microservice has been tested to match the
statistical calculations in Groundwater Watch; the color ramp used in
this application also matches that used in Groundwater Watch.

GWW alternatives:

-   Site Pages with Statistics and Graphics of Groundwater Conditions

-   Maps with symbols indicating recent conditions

-   Raw Data Feed Consumption

-   Downloading Statistics for Groundwater Levels

# Hydrologic Analysis Package 

The [Hydrologic AnalySis Package
(HASP)](https://code.usgs.gov/water/stats/hasp) is a USGS authored,
peer-reviewed R package designed to create GWW-style graphs and
statistics in the R environment. Data can be explored for a single site
or group of sites in the same aquifer. If sites are classified in a
national aquifer, HASP can produce statistics and graphics at the
national-aquifer level. Plots can be generated in an R-Shiny
application, which is user-friendly and allows users to click through
the same site-specific or aquifer-specific graphics that would appear on
Groundwater Watch. Users must have R and R Studio on their computers to
access this package and associated R Shiny application.

GWW alternatives:

-   Site Pages with Statistics and Graphics of Groundwater Conditions

-   Downloading Statistics for Groundwater Levels

# National Water Dashboard

The [USGS National Water
Dashboard](https://dashboard.waterdata.usgs.gov/app/nwd/?aoi=default)
(NWD) offers a groundwater-level layer that shows current conditions at
about 1,800 instrumented and real-time sites nation-wide. The NWD map
contains many of the same sites as the GWW Real-Time Groundwater Level
Network, but uses a different statistical method to generate percentile
classes. Methodological improvement of percentile classes in the NWD
will be a priority in FY23.

GWW alternatives:

-   Maps with symbols indicating recent conditions

# U.S. Groundwater Conditions Data Viz

The USGS VizLab team created a [data visualization of U.S. Groundwater
Conditions](https://labs.waterdata.usgs.gov/visualizations/gw-conditions/index.html#/?utm_source=drupal&utm_medium=home&utm_campaign=gw_conditions)
showing current conditions of wells with continuous data and at least
three years of data available. Currently, this viz includes about 2,300
wells and the plans are to run the code to update this map quarterly.

GWW alternatives:

-   Maps with symbols indicating recent conditions

-   National Animations of Groundwater Conditions

# Best Available Time Series for Groundwater Levels Service

The [Best Available Time Series (BATS) for Groundwater
Levels](https://waterdata.usgs.gov/blog/gw_bats/) was built to deliver a
longer period of record for groundwater-level sites, combining both
discrete and instrumented measurements into one service. This data
source may be used to construct analyses and tools with a simpler data
stream. Analyses using this service should be similar to those produced
by GWW.

GWW alternatives:

-   Raw Data Feed Consumption

### What is the timeline?

We will turn this application off on September 1, 2022. After that,
users will be directed to Water Data for the Nation from the legacy URL.

In future years, USGS Water plans to build out modernized software and
tools to replace some unique GroundWater Watch functionality. Stay tuned
to this blog for more information.

## What if these suggestions don't meet my needs?

We want to hear your feedback on how you access and use groundwater
data. Please contact <WDFN@usgs.gov>with questions or to request more
information on the products mentioned in this

Any use of trade, firm, or product names is for descriptive purposes
only and does not imply endorsement by the U.S. Government.
