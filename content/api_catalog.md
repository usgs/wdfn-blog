---
title: A Catalog of USGS Water-Data APIs and Web Services
description: A high-level cataloging of the most prominent USGS water-data APIs, web services, and endpoints.
draft: True
date: 2022-01-10
author: Brad Garner
slug: api_catalog
type: post
image: static/api_catalog/organized_and_systematized.jpg
categories: 
  - api
tags:
  - public communication
  - nextgen
  - ogc
  - open standard
keywords:
  - software development
  - api
author_email: <wdfn@usgs.gov>
---
[^cover] <!--- cover art is public domain but requires Creative commons citation -->

The USGS has published water data on the World Wide Web 
[since 1995](/25-years-of-water-data-on-the-web/).  Millions of people use our websites to 
[check the status](/user_check_status/) of current water conditions or 
[explore water data and download](/user_explore_download/) data they care about.  A 
[smaller group of users](/user_operationalized_pull/) are interested in 
integrating USGS water data into their own software or ongoing workflows.  **If you're someone who wants to incorporate
water data into your own application or website, our water-data web services (APIs) are for you.**

This is a high-level cataloging of our most prominent USGS water-data APIs, web services, and endpoints.  The groupings 
are designed to guide new users to our best and newest flagship APIs, and to help existing users understand the wider
context for the web services they already use (and to perhaps consider some new APIs).

For purposes of this article we define the following conventions:[^semantics]
- _Endpoint._  A Web URL that accepts input arguments and returns data in some machine-friendly format (_i.e.,_ not HTML).
Input arguments and output formats are not necessarily well-documented.  The most basic way to
provide water data on the Web.
- _Web service._  A collection of endpoints whose outputs are in an open-standard format.  Input arguments are documented 
but are not necessarily an open standard.
- _API._  A collection of web services whose input arguments and output formats are
a well-defined open standard, allowing for the highest level of systems interoperability.  This is what USGS is striving
for in its flagship products.


| Icon | Significance |
|------|--------------|
|🚀 | Newer, flagship APIs and web services you should consider using preferentially. | 
|👩‍🔬 | Beta experimental APIs and web services from [USGS Water Data Labs](https://labs.waterdata.usgs.gov/).  Please try them, but please understand they may change. |
|🕸 | Legacy web services or endpoints, stable and long in production.  Continue to use for now, but be warned eventually these may be decommissioned. |
|🛑 | Deprecated or decommissioned web services and endpoints.  Do not use these anymore. |


<!--- ACCORDION START -->
<div class="usa-accordion usa-accordion--bordered" aria-multiselectable="true">

<!--- OGC SENSORTHINGS API ACCORDION SECTION START -->
<h2 class="usa-accordion__heading"><button class="usa-accordion__button" aria-expanded="true" aria-controls="a1">
🚀👩‍🔬 OGC SensorThings API <!--- 🚢🛥⛴🚀 -->
</button></h2>
<div id="a1" class="usa-accordion__content">
<!--- ------------- -->

Want the latest real-time water data from a river, groundwater well, or other USGS monitoring location?  This is 
your newest open-standard way to do that.  SensorThings is being designed to help usher in the 
Internet of Things.  It is a simple-to-understand API that encourages software developers to use it in their 
applications (previous open standards like WaterML were thorough and meticulous, but tedious to parse 
to extract the actual data itself)

**Endpoint for our beta OGC SensorThings API implementation: https://labs.waterdata.usgs.gov/sta/v1.1/**

<h3>Getting Started</h3>

Want to try out our SensorThings API?  We are developing a Python Notebook.  In the meantime, here's a super-quick way to 
dive into it:[^jsonview] 
1. Make a web request for one of the _things_ (our things are USGS
monitoring locations).  For example,
[here is the thing for Colorado River at Lees Ferry, Arizona](https://labs.waterdata.usgs.gov/sta/v1.1/Things('USGS-09380000')).
1. Inside this JSON structure are properties for additional URLs that can be pursued to obtain data for this station. Follow
the ```Datastreams@iot.navigationLink``` element in this JSON (which should point 
[here](https://labs.waterdata.usgs.gov/sta/v1.1/Things('USGS-09380000')/Datastreams)).  
1. It returns an array of 
recent time-series data available for this station.  Try iterating through this array searching for the ParameterCode value 
of interest (often, it’s 00060 for Discharge or 00065 for Gage Height).  
1. Following the ```Observations@iot.navigationLink``` 
property’s URL will start returning the data of interest.

You also might like the 
[Internet of Water's SensorThings resources](https://internetofwater.github.io/STA-Resources/), or
for the more stalwart reader there is the 
[official SensorThings specification](http://docs.opengeospatial.org/is/15-078r6/15-078r6.html).

</div>

<!--- OGC API ACCORDION SECTION START -->
<h2 class="usa-accordion__heading"><button class="usa-accordion__button" aria-expanded="true" aria-controls="a2">
🚀👩‍🔬 OGC API <!--- 🚢🛥⛴🚀 -->
</button></h2>
<div id="a2" class="usa-accordion__content">
<!--- ------------- -->

A majority of data collected and exchanged in the world today has a _geographic location_ as a core
attribute.  USGS water data is no exception! So we're adopting the 
[Open Geospatial Consortium's OGC API](https://ogcapi.ogc.org/) as a flagship API.
Our implementation of OGC API offers detailed metadata about multiple stations for easy map 
plotting, and offers certain limited forms of water data.  We've only just begun to use this API 
and we plan to expand our use of it considerably, particularly as OGC API actively continues 
evolving.  Presently we implement its foundational 
[Part 1: Features-Core](https://ogcapi.ogc.org/features/). 

**Endpoint for our beta OGC API implementation: https://labs.waterdata.usgs.gov/api/observations/collections/**

<h3> Getting Started</h3>

Want to try out our OGC API?  We are considering what developer-friendly materials we can provide.
In the meantime, here's a super-quick way to dive into it:[^jsonview] 
1. Make a web request for the 
[Active Groundwater Level collection](https://labs.waterdata.usgs.gov/api/observations/collections/AGL?f=json).  
1. The response provides an overview of this network of USGS monitoring locations, which in OGC API are modeled as _features_
in a _collection_.  The features themselves in this collection (_i.e.,_ the monitoring locations in this network) can be seen
[here](https://labs.waterdata.usgs.gov/api/observations/collections/AGL/items?f=json).  
1. The ```properties``` objects within this response contain helpful monitoring location metadata.
1. More information about any one of these features is available at a more specific URL (_e.g.,_ 
[here is the USGS Winslow, Arizona I-40 well](https://labs.waterdata.usgs.gov/api/observations/collections/AGL/items/USGS-350002110355501?f=json)).
1. Digging one level deeper into the observations associated with any feature may offer certain forms of water data we have 
begun to populate in this API (_e.g.,_ 
[the Winslow I-40 well's observations](https://labs.waterdata.usgs.gov/api/observations/collections/AGL/items/USGS-350002110355501/observations?f=json)
include daily-values and discrete groundwater levels).

</div>


<!--- WATER QUALITY PORTAL ACCORDION SECTION START -->
<h2 class="usa-accordion__heading"><button class="usa-accordion__button" aria-expanded="true" aria-controls="a3">
🚀 Water Quality Portal <!--- 🚢🛥⛴🚀 -->
</button></h2>
<div id="a3" class="usa-accordion__content">
<!--- ------------- -->

Interested in water quality and the laboratory analyses that inform us about the quality of the nation's 
water?  Then the flagship Water Quality Portal.  It is a joint endeavor among 
several government agencies that collect these types of data; you can obtain data from the USGS and also other 
government organizations like the Environmental Protection Agency.

Discrete water-quality data are inherently richer, more complex, and challenging to interpret than 
time-series data.  Accordingly the primary web-service output format is the relatively complex 
Water Quality eXchange (WQX) open standard.  But fret not!  The Water Quality Portal also supports 
the Web Mapping Service (WMS) open-standard API to easily get dots put 
on map tiles and thus on interactive maps.  Even though the underlying data are complex and rich in 
structure, support of WMS allows a low barrier to entry to begin exploring the spatial distribution
of these data.

<h3>Getting Started</h3>

**Read our [documentation for this web service](https://www.waterqualitydata.us/webservices_documentation/).**  It's
about a 15-minute read and should let you begin to understand basic functionality.
Or get started even faster by **[interactively building a search](https://www.waterqualitydata.us/);** after the query is 
built the website will give you code you can place directly into your application.

<span class="usa-tag">NOTE</span>
The WQX output format is long, detailed, nested, and "narrow" as opposed to "wide."  Some of our 
users express interest in a simplified gridded output where constituents define
columns, laboratory samples define rows, and numeric results and qualifiers are in each grid cell.  Water Quality
Portal does not support this as a machine-friendly output format; it simply sacrifices too much essential 
detail.  But certain software libraries (_e.g.,_ [DataRetrieval for R](/dataretrieval)) may enable generation of
such simplified grids by thoughtfully post-processing WQX data.

</div>


<!--- NLDI ACCORDION SECTION START -->
<h2 class="usa-accordion__heading"><button class="usa-accordion__button" aria-expanded="true" aria-controls="a4">
🚀 Hydro Network Linked Data Index (NLDI) Web Service <!--- 🚀 -->
</button></h2>
<div id="a4" class="usa-accordion__content">
<!--- ------------- -->

The NLDI allows your application to programmatically "swim" up and down the river and stream network of the United 
States, discovering USGS monitoring locations along the way.  It also returns shapes that define watershed 
boundaries.  The output format is GeoJSON, making it easy to integrate into web-based maps.
Essentially, it is a web-service interface we have placed in front of the National Hydrography Dataset (NHD).

NLDI is somewhat different from other flagship services.  Instead of providing direct sensor
observations or laboratory-analytical data, NLDI returns metadata about how USGS monitoring locations
are _connected_ (linked) to rivers and streams.  Instead of providing you with
streamflow data, for example, this service conveys what river a monitoring location is associated with,
the watershed catchment area upstream of a monitoring location, and allows traversal up and down the stream network.

<h3>Getting Started</h3>

The best way to understand NLDI is to **[read its overview documentation](https://labs.waterdata.usgs.gov/about-nldi/index.html)**.
Another helpful starting point can be [this overview blog post](/nldi-intro/).

Through some light reverse engineering[^pleasesteal] of [a USGS monitoring location page](https://waterdata.usgs.gov/monitoring-location/09380000/)
courtesy of a browser's network-debugger tool (usually the F12 key), we observe the following calls to NLDI are made:
1. [Upstream flowlines.](https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-09380000/navigation/UM/flowlines?f=json&distance=322)  A
GeoJSON LineString representing the river upstream of the station.  The distance parameter limits draw distance to 322 kilometers for practical performance reasons.
1. [Downstream flowlines.](https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-09380000/navigation/DM/flowlines?f=json&distance=322) Same
as the upstream query, but in a downstream direction.
1. [Watershed catchment area.](https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-09380000/basin?f=json) A GeoJSON MultiPolygon that
draws the watershed boundary upstream of this station.

</div>


<!--- HYDROGRAPH IMAGE ACCORDION SECTION START -->
<h2 class="usa-accordion__heading"><button class="usa-accordion__button" aria-expanded="false" aria-controls="a5">
👩‍🔬 Hydrograph Bitmap Image Web Service<!--- 👩‍🔬⚗🧪 -->
</button></h2>
<div id="a5" class="usa-accordion__content">
<!--- ------------- -->

The simplest way to integrate USGS time-series water data onto own web page or into your own application has been
to embed a bitmap image of a hydrograph.  It's a one-line addition to an HTML file!  Minimally all you need is the USGS
monitoring location identifier (typically an 8-digit number).  The functionality is limited: you cannot customize
the bitmap image beyond the parameters we offer you, and the image is not interactive.  Still, this remains a popular, low-complexity
way to show your favorite river's recent streamflow or other measured data.

<h3> Getting Started </h3>

**Read our [documentation for this web service](https://labs.waterdata.usgs.gov/about-graph-image-api/).**  Or simply paste the following fragment
into your HTML, and modify the reasonably self-explanatory arguments as needed
([the result will look like this](https://labs.waterdata.usgs.gov/api/graph-images/monitoring-location/09380000/?parameterCode=00060&width=640&title=true&period=P14D)):

> ```<img src="https://labs.waterdata.usgs.gov/api/graph-images/monitoring-location/09380000/?parameterCode=00060&width=640&title=true&period=P14D" alt="Hydrograph of recent 14 days of 00060 streamflow at 09380000" >```

</div>


<!--- LEGACY WATERML ACCORDION SECTION START -->
<h2 class="usa-accordion__heading"><button class="usa-accordion__button" aria-expanded="false" aria-controls="a6">
🕸 Legacy Web Services Still Uniquely Valuable <!--- ☎🕸👻 -->
</button></h2>
<div id="a6" class="usa-accordion__content">
<!--- ------------- -->

Around 2007 we launched a generation of web services that output water data in an open-standard 
format known as [WaterML](https://www.ogc.org/standards/waterml).  For years, these 
were our prime web-service offerings for water data.
Although we are striving to phase these aging services out in favor of our new flagship services, they
will yet be around for some time because existing client software already relies on 
them, and not all of their functionality has been conserved in our new
flagship services.  

Each service listed below links to URL generation pages[^openapi] that serve as a form of concise, interactive
documentation (a link to fuller documentation also can be found at the top of each of these pages).

- [__Instantaneous values.__](https://waterservices.usgs.gov/rest/IV-Test-Tool.html)[^ivaka]  <span class="usa-tag">POPULAR</span> These 
are typically 15-minute measurements of phenomena such as gage height, discharge, 
water temperature, and much more.  If you need only the most recent of these data, we recommend our new flagship SensorThings API (above).  But 
if you need these data farther back into the past, this continues to be the service you should use.  Its main output 
formats are tab-delimited file and WaterML.

- [__Daily values.__](https://waterservices.usgs.gov/rest/DV-Test-Tool.html)[^dviv]  From the 1880s until around 2007, continuous 
monitoring of water resources by the USGS typically resulted in one statistically reduced data value per day: the _daily-mean 
value_ (sometimes along with daily minimum and maximum values).  This was a practical[^oneperday] number of data values that could convey 
water-resources in printed publications[^adr] and could be stored digitally up through the 1990s when computer 
storage was still prohibitively expensive.  Some workflows continue to rely on daily values, and any analyses or workflows that go
back in time before around 2007 usually must incorporate daily values to achieve historical continuity.

- [__Discrete groundwater levels.__](https://waterservices.usgs.gov/rest/GW-Levels-Test-Tool.html)[^gwaka] Individual 
manual measurements of groundwater levels made by USGS technicians in the field.  These days the flagship OGC API 
provides these same data in a more modern format.  One key ability in this legacy service not (yet) offered by
our flagship services is an ability to query for multiple monitoring locations at a time.

- [__Sites.__](https://waterservices.usgs.gov/rest/Site-Test-Tool.html)[^siteaka]  Key metadata about 
USGS monitoring locations across the United States, such as latitude and longitude, station name, county location, and 
so forth.  These days, this same metadata is available nearly equally well from SensorThings and OGC API in the 
popular GeoJSON format for getting dots on maps quickly.  But this service continues to offer this information in 
tab-delimited files, as well as Keyhole Markup Language (KML), an XML open standard popular in the early 2000s.  One 
key ability this service offers that our flagship services do not (yet) provide is the ability to query for monitoring 
locations based on the type of data they collect and the time range those data are available. (_e.g.,_ 
[all active monitoring locations in Kansas monitoring real-time water temperature](https://waterservices.usgs.gov/nwis/site/?format=rdb&stateCd=ks&parameterCd=00010&siteStatus=active&hasDataTypeCd=iv)).

- [__Statistical period-of-record data.__](https://waterservices.usgs.gov/rest/Statistics-Service-Test-Tool.html)[^statbeta]  This 
service outputs statistical information about time-series data from a USGS monitoring location.  It is most popularly known as 
the service that examines the full period of approved time-series streamflow at a monitoring location and, for each day of the 
year, calculates the long-term median, maximum, minimum, and other statistical flow percentiles.  
And this same statistical calculation is performed for all other approved time-series data and made
available through this legacy service.

</div>


<!--- LEGACY OTHER ACCORDION SECTION START -->
<h2 class="usa-accordion__heading"><button class="usa-accordion__button" aria-expanded="false" aria-controls="a7">
🕸 Legacy Endpoints Still Uniquely Valuable <!--- ☎🕸👻 -->
</button></h2>
<div id="a7" class="usa-accordion__content">
<!--- ------------- -->

Starting around the year 2000, we began publishing our water data in machine-friendly flat-file formats on a national scale.
These earliest URL endpoints are a primitive form of web service from an earlier time in the history of the Web.  They output
data, not in open-standard formats, but simple tab-delimited files known as 
[RDB files](https://waterdata.usgs.gov/nwis/?tab_delimited_format_info).  The input parameters (URL arguments) are
not formally documented; instead, arguments are discovered by using search tools on web pages, noting the
resulting URL, and cleverly incorporating it into your code by modifying arguments as needed.

**USGS intends to decommission these endpoints in the coming years, but not until adequate replacements have been developed.**  Until
then, although we caution that these old services may be challenging to incorporate into modern software, you may
find them uniquely valuable if they provide the water data your application needs.

- [__Annual-peaks data.__](https://waterdata.usgs.gov/nwis/peak/)  The single highest flow rate and stream water level in a given 
year is a useful statistic for 
engineers and others concerned with planning related to water hazards.  In recent years these peak data values may be 
found directly within the instantaneous-values data records.  But sometimes, particularly at 
streamgages with long periods of record and large historic floods, the one annual-maximum flow and water level are _original, primary
data,_ not a mere statistical derivation of data in some 12-month time window.  In fact, in some cases weeks or even 
months of hydrologic analysis is undertaken to produce a _single_ annual-peak data value!  If your application needs these 
values, use the search tool linked to here, indicate tab-delimited output, and note the resulting URL (_e.g.,_ 
[annual-peak flows and gage height for Colorado River at Lees Ferry, Arizona](https://nwis.waterdata.usgs.gov/az/nwis/peak?site_no=09380000&agency_cd=USGS&format=rdb)).

- [__Rating-curve depot.__](https://waterdata.usgs.gov/nwisweb/get_ratings?help) Most ordinary users
do not need the technical and detailed rating curves used to convert water-level[^wlaka] data to streamflow data; they 
simply need the high-quality streamflow data USGS publishes. But certain key
cooperating agencies like the National Weather Service need rating curves for their computer-modeling needs.  The rating
depot provides this information, as well as a way to detect when rating curves have been updated by USGS staff.
The most popular output table is the expanded, shift-adjusted rating (EXSA), effectively a lookup table for all possible
valid values of gage height in hundredth-of-a-foot increments at a given station
(_e.g.,_ [the EXSA table for Barton Springs at Austin, Texas](https://waterdata.usgs.gov/nwisweb/data/ratings/exsa/USGS.08155500.exsa.rdb)). Only 
stage-discharge ratings are available; index-velocity and slope-area curves are not supported.

- [__Current surface-water conditions in historical context.__](https://waterwatch.usgs.gov/webservices/) If your application 
wishes to create a "dot map" of current streamflow[^dotmap] conditions—to what degree USGS monitoring locations are above and below
historical flow rates—presently your most practical option is the _realtime endpoint_ of this service.  The output format is JSON, but 
not an open-standard format such as GeoJSON (_e.g.,_
[the data needed for a dot-map of Kansas](https://waterwatch.usgs.gov/webservices/realtime?region=ks)).  We
are considering how our flagship service offerings might present this valuable information in an open-standard way.  It is also possible
to [calculate this information yourself](/stats-service-map/) using the legacy statistical period-of-record data service and a service returning
the most recent instantaneous values.

- [__Discrete surface-water field measurements.__](https://waterdata.usgs.gov/nwis/measurements/)[^swaka]  To keep a continuous 
time-series monitoring location operating properly, USGS 
technicians periodically visit the station and manually measure water depths and flow rate.  These data 
help ensure USGS sensors and rating curves are functioning properly and get repaired and updated as needed.  Although typically seen as 
_means-to-an-end_ water data, they may be useful in some circumstances.  If your application needs these 
values, use the search tool linked to here, indicate tab-delimited output, and note the resulting 
URL (_e.g.,_ [all of these measurements for Colorado River at Lees Ferry, Arizona](https://waterdata.usgs.gov/nwis/measurements?site_no=09380000&agency_cd=USGS&format=rdb)).

</div>


<!--- DEPRECATED ACCORDION SECTION START -->
<h2 class="usa-accordion__heading"><button class="usa-accordion__button" aria-expanded="false" aria-controls="a8">
🛑 Deprecated Web Services and Endpoints <!--- 🛑 -->
</button></h2>
<div id="a8" class="usa-accordion__content">
<!--- ------------- -->

For existing users and software, at this time we continue to support these web services and endpoints.  But new and existing 
clients should strongly consider using new flagship or beta services that provide the same water data in more modern formats.

- [__Legacy water-quality data.__](https://waterdata.usgs.gov/nwis/qwdata/)  You can download 
tab-delimited "wide" grid formats of USGS 
water-quality data by using this search interface, indicating tab-delimited output, and noting the resultant 
URL ([example](https://nwis.waterdata.usgs.gov/md/nwis/qwdata/?site_no=01649190&agency_cd=USGS&inventory_output=0&rdb_inventory_output=file&TZoutput=0&pm_cd_compare=Greater%20than&radio_parm_cds=all_parm_cds&qw_attributes=0&format=rdb&qw_sample_wide=wide&rdb_qw_attributes=0&date_format=YYYY-MM-DD&rdb_compression=value&submitted_form=brief_list)).  Although this gridded format
is convenient for certain workflows, we recommend the Water Quality Portal to obtain discrete water-quality 
data. We are in the latter stages of a multi-year modernization effort of our discrete water-quality data systems.  When
that modernization is complete, **we intend to decommission this web endpoint.** <!--- **This endpoint is scheduled to be discontinued January 2023** -->

- [__Legacy hydrograph bitmap.__](https://waterdata.usgs.gov/nwisweb/graph) A URL that generates a standalone bitmap 
of a hydrograph using late 20th-century plotting
technology ([example](https://waterdata.usgs.gov/nwisweb/graph?agency_cd=USGS&site_no=01638500&parm_cd=00060&period=7)).  Please
try using our beta hydrograph bitmap-image service instead, and give us feedback on what you think of it.  **This endpoint is 
[scheduled to be decommissioned](/realtime-pages-replacement/#when-will-live-happen) January 2023.**

</div>

<!--- ACCORDION END -->
</div>

<!--- FOOTNOTES START -->

[^cover]: Cover image adapted from [Alex Proimos from Sydney, Australia](https://commons.wikimedia.org/wiki/File:Book_Shelves_and_Computers_(5914150081).jpg), [CC BY 2.0](https://creativecommons.org/licenses/by/2.0)

[^adr]: The USGS Annual Water Data Report was the definitive published record of water resources measured
by the USGS for decades: one large bound book per year, per state.  By 2014, USGS recognized the Web had 
become the American People's preferred method for obtaining published water data.

[^siteaka]: These days we prefer the term monitoring location, but historically the terms monitoring location, 
station, site, gage, gaging station, and streamgaging station all have been used rather 
interchangeably.  That is why this legacy service is somewhat ambiguously denominated 
the "site service."

[^statbeta]: Officially the period-of-record statistics service is still a beta 👩‍🔬 product!  During and after its 2007 development
we never found a suitable open-standard output format for these statistical data.

[^dviv]: Our users have suffered no end of confusion because of historical "siloing" of instantaneous-values and daily-values 
data.  We are considering ways we might someday provide services that unify these confusing data siloes in a 
no-nonsense ["best available"](/gw_bats/#how-do-we-know-which-record-is-best) way.

[^wlaka]: Water level is the most plainspoken term for this common measurement of a flowing river or waterway.  Here, 
it is synonymous with gage height, stage, river stage, and (in a numerically inverted sense) water depth.

[^dotmap]: There is no comparable web service for generating "dot maps" for groundwater or 
water-quality current conditions, though these may be considered for future incorporation into a flagship API.

[^openapi]: To help with documentation, we are considering implementing OpenAPI specifications for these 
legacy services, which would allow anyone to use modern tools for testing and using these APIs. If you
think this would be helpful for you, please let us know.

[^ivaka]: We prefer the term instantaneous-values data these days, but other 
roughly synonymous terms include continuous data, time-series data,
unit-values data, UV ("you-vee") data, and real-time data (though that term is less about the 
frequency of data measurement and more designative of the fact that measurements are being made
and being relayed to the Web very near the present moment).

[^gwaka]: Discrete groundwater level is the most precise term these days, but these
data also are known colloquially as field measurements or "tape-downs" owing to the 
instrument typically used by technicians to obtain these measurements.

[^oneperday]: For most large rivers and non-fractured groundwater systems, one daily value per day
is adequately if not wholly representative of that water resource--less data but just as informative
as dozens of instantaneous values per day.  But for small rivers and sundry hydrological 
phenomena, a daily value is an expedient trade-off that discards useful information.

[^swaka]: Discrete surface-water field measurements are also known as calibrations, 
gaugings, surface-water measurements, field measurements, or even simply "measurements," as ambiguous as that term may be.

[^jsonview]: Many example URLs in this article return data in JSON format.  There are many ways to
easily parse and view JSON data.  Some web browsers (_e.g.,_ Firefox) have convenient built-in JSON viewers.
Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.

[^pleasesteal]: Reverse engineering is encouraged, as is copying and pasting, forking, etc.  As public civil servants,
our work is done for _you_ and is in the public domain.  For example, the 
[source code for monitoring location pages](https://code.usgs.gov/wma/iow/waterdataui) is publicly viewable.  Working
in the open is part of [how we work](/how-we-work-spring-2021/).

[^semantics]: Generally, the terms endpoint, web service, and API are more or less synonymous.
Only in this article have we strived to enforce a consistent (and perhaps
somewhat arbitrary) distinction.
