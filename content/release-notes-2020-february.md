---
author: Charlotte Snow and Jim Kreft
date: 2020-03-20
slug: release-notes-2020-february-march
draft: True
type: post
image: /static/release-notes-2020-february/image2.png
title: "Release Notes for late February and early March 2020"
author_staff: charlotte-m-snow
author_email: <csnow@usgs.gov>
categories:
  - Applications
description: A summary of new features and tools released in late February and early March, 2020
keywords:
  - water information
tags:
  - Water Data for the Nation
  - Release Notes

---


What have we been up to?
========================

-   Added handles to brush on the monitoring location page hydrograph
-   State of hydrograph saved for bookmarking/linking
-   Display upstream basin from NLDI for each monitoring location
-   A number of additional graph server parameters
-   New data services for monitoring locations

Brush handles added to monitoring location page hydrograph 
-----------------------------------------------------------

Based on user feedback, the team upgraded the brush and zoom capability on the hydrograph by adding handles, making it more apparent that the
zoom functionality is available and making it easier to use. The handles
are also big enough for use on mobile devices.

<div class="grid-row">
    <div class="grid-col-8 grid-offset-2">
    {{< figure src="/static/release-notes-2020-february/Brush_handles.png" caption="Screenshot showing handles added to the hydrograph zoom capability." alt="Screenshot showing dark blue handles on either side of the brush tool to allow for zooming in to a specific place in the hydrograph" >}}
    </div>
</div>



State of hydrograph saved for bookmarking/linking
-------------------------------------------------

WDFN serves a huge range of users. WDFN users are now able to bookmark
and share a hydrograph in the way that they requested it. After
adjusting a hydrograph with custom date ranges and parameters, a person
can copy a link from the address bar, paste it into another browser, and
it will populate with a similar set of things. Users can share custom
hydrographs generated with specific time-series statistics, parameter
codes, dates, and compare settings.  For example, a user may be interested in the changes in gage height at the [USGS gage Colorado River at Lee's Ferry, AZ](https://waterdata.usgs.gov/monitoring-location/09380000/) over the course of the November 2012 [Glen Canyon Dam High Flow Experimental Release](https://www.usbr.gov/uc/rm/gcdHFE/index.html). After choosing a custom time range and the gage height parameter, the [URL in the browser can be used to share or return to the same settings](https://waterdata.usgs.gov/monitoring-location/09380000/#parameterCode=00065&startDT=2012-11-01&endDT=2012-12-01).  

Use NLDI to display upstream basin from each monitoring location
----------------------------------------------------------------

By utilizing the Hydro Network-Linked Data Index
([NLDI](https://waterdata.usgs.gov/blog/nldi-intro/)), monitoring
locations are able to be put in context of a catchment or basin. Each
active stream site has an upstream basin in NLDI, as you can see here:

[https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-05429700/basin/](https://labs.waterdata.usgs.gov/api/nldi/linked-data/nwissite/USGS-05429700/basin/)

A user who is interested in knowing the upstream basin for a site is can
now see it on a monitoring location page map. Showing the upstream basin
allows users to better understand if the contributing basin for a
monitoring location is large or small, or if downstream locations would
be affected by a spill or hazard, among various applications. There are
already upstream and downstream NLDI calls in on the monitoring location
pages.

<div class="grid-row">
    <div class="grid-col-8 grid-offset-2">
    {{< figure src="/static/release-notes-2020-february/image2.png" caption="Screenshot of the upstream basin for monitoring location 05370000, [Eau Galle River at Spring Valley, WI.](https://waterdata.usgs.gov/monitoring-location/05370000/)" alt="Screenshot of the upstream basin for monitoring location 05370000, Eau Galle River at Spring Valley, WI" >}}
    </div>
</div>


New parameters for the graph-images service
-------------------------------------------

One of the most common requests that we get in feedback is that users
want to be able to download an image of the hydrograph. We started on
this work with the [graph image
API](https://labs.waterdata.usgs.gov/about-graph-image-api/), but it
only allowed a single parameter, the parameter code.

Now, the image server supports several additional parameters.

-   Title- allows a title to be placed on the top of the graph
    describing its location:
    <https://labs.waterdata.usgs.gov/api/graph-images/monitoring-location/09380000/?parameterCode=00060&title=true>

-   Width- allows the width of the image to be varied from 300 to 1200
    pixels. This also improves the readability of the graph when the
    image is small.

-   Period- previously, the only option for number of days was the most
    recent 7 days. Now a user can input an arbitrary number of days:
    <https://labs.waterdata.usgs.gov/api/graph-images/monitoring-location/09380000/?parameterCode=00060&title=true&period=p120D>

-   Time ranges- now that users can request a custom time range on the
    monitoring location page, and they can also request that same time
    range on the graph server:
    <https://labs.waterdata.usgs.gov/api/graph-images/monitoring-location/09380000/?parameterCode=00060&title=true&startDT=2019-10-01&endDT=2020-01-10>

Additional features that we are planning to add to the graph server
include

-   Adding the ability to request a specific time series, like you can
    with the [monitoring location pages](https://waterdata.usgs.gov/monitoring-location/07144100/#parameterCode=63680&timeSeriesId=57502)

-   Documenting the API using the OpenAPI standard

-   Updating the date queries to meet international standards

New features and tools
======================

-   We've have taken a first step toward completely reconfiguring how we pull data on the backend, as evidenced by showing the new groundwater daily value graph on the development site.  This will be pushed to production soon!

<div class="grid-row">
    <div class="grid-col-8 grid-offset-2">
    {{< figure src="/static/release-notes-2020-february/groundwater_dv_graph.png" caption="Screenshot of groundwater maximum daily values at [CT-D 117 DURHAM, CT](https://waterdata.usgs.gov/monitoring-location/412825072410501/).  This graph is not yet available on a public site." alt="Screenshot of a graph of groundwater data.  There is an orange line representing provisonal data, and a green line representing approved data." >}}
    </div>
</div>

-   All of the Groundwater Watch networks have been populated in a service, a big step forward on our new networks service:
    [https://labs.waterdata.usgs.gov/api/observations/collections?f=json](https://labs.waterdata.usgs.gov/api/observations/collections?f=json)

What is coming up for next sprint? 
===================================

-   waterdata.usgs.gov/networks -- page will show a list of all networks
    with links to specific network pages

-   Presenting statistical information in a standards-driven format

-   Allowing networks to be populated by a CSV

-   Displaying additional network metadata on network pages

Disclaimer
==========

Any use of trade, firm, or product names is for descriptive purposes
only and does not imply endorsement by the U.S. Government.
