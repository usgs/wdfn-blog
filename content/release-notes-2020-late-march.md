---
author: Charlotte Snow and Jim Kreft
date: 2020-04-10
slug: release-notes-2020-march
draft: False
type: post
image: /static/release-notes-2020-late-march/image2.png
title: "Release Notes for late March 2020"
author_staff: charlotte-m-snow
author_email: <csnow@usgs.gov>
categories:
  - Applications
description: A summary of new features and tools released in late March, 2020
keywords:
  - water information
tags:
  - Water Data for the Nation
  - Release Notes

---

What have we been up to?
========================

-   Image server work

-   Period parameter

-   Axis scaling

-   Networks page

New features and tools
======================

Image export from monitoring location pages
-------------------------------------------

One of the most requested features we receive from users is the ability to export images from the monitoring location pages.

The graph image server now is documented using the OpenAPI 3 standard so that downstream developers and others can more easily use this service. The graph image server will allow outside developers to download or embed an image version of the graphs on the new monitoring location pages.

<https://labs.waterdata.usgs.gov/api/graph-images/api-docs/#/USGS%20Site%20Instantaneous%20Value%20Graph/get_api_graph_images_monitoring_location__siteID__>

Period of record on monitoring location pages
---------------------------------------------

The monitoring location pages also now display the period of record for instantaneous values for a given parameter, making it easier to request a custom time period:

<div class="grid-row">
    <div class="grid-col-14 grid-offset-0">
    {{< figure src="/static/release-notes-2020-late-march/image1.png" caption="A screenshot showing the available parameters with their periods of record." alt="A table with parameter descriptions, preview, number of time series, and the period of record for a parameter at a site" >}}
    </div>
</div>




Axis scaling
------------

Finally, the axis scaling was made more robust, making it easier for users to see when an event of interest occurred:




<div class="grid-row">
    <div class="grid-col-14 grid-offset-0">
    {{< figure src="/static/release-notes-2020-late-march/image2.png" caption="A hydrograph with new, more robust scaling on the y-axis." alt="A hydrograph with new, more robust scaling on the y-axis." >}}
    </div>
</div>




Networks Page
-------------

The USGS collects monitoring locations into networks, but typically these networks have not been part of our core data delivery on waterdata.usgs.gov.  Rather, networks have been presented on ancillary sites, such as [Groundwater Watch](https://groundwaterwatch.usgs.gov/) or sites [dedicated to specific networks](https://cida.usgs.gov/quality/rivers/home).  Sometimes the networks are curated by scientists, such as the [Climate Response Network](https://groundwaterwatch.usgs.gov/CRNHome.asp), while others are based on an algorithm, such as the [Below Normal Groundwater Levels Network](https://groundwaterwatch.usgs.gov/LWLHome.asp), and still others are local or regional and based on cooperative agreements or projects, such as  the [Minnesota Bemidji Toxics Oil Spill Research Site Network](https://groundwaterwatch.usgs.gov/netmapT4L1.asp?ncd=MBT).  Not surprisingly, the USGS is not the only organization to group geospatial features together, and collections are a core part of the Open Geospatial Consortium's new standard for presenting the geospatial features, [OGC API-Features](https://www.ogc.org/standards/ogcapi-features).  OGCAPI-Features is the first of a [growing family](http://www.ogcapi.org/) of new web services standards that is being developed over the next few years. The WDFN team has been building an implementation of OGC API-Features, which you can explore on the [OpenAPI 3](http://spec.openapis.org/oas/v3.0.3) based [API Documentation](https://labs.waterdata.usgs.gov/api/observations/swagger-ui/index.html?url=/api/observations/v3/api-docs). You will also see documenation of a number of different experiments of presenting observation data that are ongoing and we will write about more soon!


All that said, we have harvested a number of the networks from Groundwater Watch to exercise these new services, and you can explore them on a new page dedicated to networks at [https://waterdata.usgs.gov/networks/](https://waterdata.usgs.gov/networks/).  From there, you can explore individual networks, such as the [Minnesota Prairie Island Indian Community Water-Level Network](https://waterdata.usgs.gov/networks/MPI/)

<div class="grid-row">
    <div class="grid-col-14 grid-offset-0">
    {{< figure src="/static/release-notes-2020-late-march/MPI.png" caption="A screenshot of the page for the [Minnesota Prairie Island Indian Community Water-Level Network](https://waterdata.usgs.gov/networks/MPI/)" alt="A Screenshot showing the name of a monitoring location network, a map of the monitoring locaton network, showing the monitoring locations as orange dots, and a table of monitoring locations " >}}
    </div>
</div>

These pages are only the beginning.  Features that we plan to add in the short term include:
* Populating existing networks with descriptions and other metadata
* Cooperator names, links and logos
* Extended descriptions of networks
* Contact information for networks
* Adding additional networks
* Linking back to the networks from each of the monitoring location pages that are part of each network.

Eventually, we are planning on adding a variety of other kinds of networks, including
* networks of monitoring locations with particularly high or low flow
* networks of particular interest, such as the [Federal Priorities Streamgages](https://water.usgs.gov/networks/fps/) 
* short term networks based on specific events, like those that can be seen on the [Flood Event Viewer](https://stn.wim.usgs.gov/FEV/). 

There will be a lot more discussions about networks in the coming months and years! 

What is coming up for next sprint?
==================================

* All monitoring locations will have a link to the networks it is part of in the new monitoring location service.
* Brush and legend added to Daily Value graphs on site pages
* Daily Value Maximum graphs for all groundwater sites with Daily Value levels data.


Disclaimer
==========

Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.