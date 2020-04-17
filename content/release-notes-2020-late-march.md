---
author: Charlotte Snow
date: 2020-04-10
slug: release-notes-2020-march
draft: True
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

Much work has been done gathering collections/networks. We've built on that work by adding a Leaflet map with all the sites. The map links to the monitoring location pages.

What is coming up for next sprint?
==================================

-   All monitoring locations will have a link to the networks it is part of in the new monitoring location service.

-   Brush and legend added to Daily Value graphs on site pages

Disclaimer
==========

Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.