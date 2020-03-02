---
author: Charlotte Snow and Jim Kreft
date: 2020-02-28
slug: release-notes-2020-02-28
draft: True
type: post
image: /static/release_notes-2020-02-28/image2.png
title: "Release Notes for February 28th, 2020"
author_staff: charlotte-m-snow
author_email: <csnow@usgs.gov>
categories:
  - Applications
description: A summary of new features and tools released on or before February 28, 2020
keywords:
  - water information
tags:
  - Water Data for the Nation
  - Release Notes

---
The last several months have been exciting. We have been able to
complete work related to:

-   Cloud migration of the Water Quality Portal

-   Cloud migration of the Network Linked Data Index (NLDI)

-   Brush and zoom capability for hydrographs

## On January 16, 2020 the Water Quality Portal was deployed to the cloud!

One of the most notable releases since the last set of release notes is one that our users barely noticed. One of the products of the Water Data for the Nation Team is the [Water Quality Portal](https://www.waterqualitydata.us), a cooperative project between the U.S. Geological Survey and the Environmental Protection Agency that makes discrete water quality data available in a single, standards-driven way. The Water Quality Portal has grown from a proof of concept pilot project to a tool that organizations depend on, and from making 150 million rows of data available to nearly 400 million rows of data from over 400 partner agencies. As the application grew, it became clear that its existing hosting solutions in an on-premise data system were not going to be able to scale to meet the needs of its users. On January 16th, with only a few small hiccups, the Water Quality Portal was transitioned to a cloud-hosted tool with a postgres backing store.

Moving the WQP was not an insignificant effort. Rather than attempt a "lift and shift" based approach, we did our best to turn the Water Quality Portal into a cloud-native application. In its on-premise version, the WQP runs on five virtual machines, backed by a 16-core beast of a database. In the cloud version, the applications are all containerized, running in in a cluster of "containers as a service," backed by a postgres database running in a database as a service. The lessons learned in this migration have been applied to everything else that we have been doing as we build new services for Water Data for the Nation. Good news for users- the uptime history looks great since the transition! See Figure 1 for more details.

Interested in the technical details? Find the development trail here at
our open-source code repository here: <https://github.com/NWQMC>.

<div class="grid-row">
    <div class="grid-col-8 grid-offset-2">
    {{< figure src="/static/release_notes-2020-02-28/image1.png" caption="Screenshot showing 100% uptime (green dots) for the Water Quality Portal in the days following the January 16<sup>th</sup> transition to the cloud. The [status dashboard](https://uptime.statuscake.com/?TestID=518aEKDbvl) gives the latest view of WQP uptime." alt="Screenshot showing 100% uptime (green dots) for the Water Quality Portal in the days following the January 16th transition to the cloud." >}}
    </div>
</div>


## Cloud migration of the Hydro Network Linked Data Index

The [Hydro Network Linked Data Index](https://labs.waterdata.usgs.gov/about-nldi/) has finally been publicly deployed to the cloud. NLDI gives users the ability to query upstream and downstream on the monitoring location pages. Similar to the Water Quality Portal, NLDI was transformed from an on-premise application into a cloud native application.

<div class="grid-row">
    <div class="grid-col-8 grid-offset-2">
    {{< figure src="/static/release_notes-2020-02-28/image2.png" caption="Map showing the gages 200 miles upstream and downstream on the main stream of the Colorado River from monitoring location 09380000, [Colorado River at Lee's Ferry, AZ](https://waterdata.usgs.gov/monitoring-location/09380000/)" alt="Screenshot of map showing the gages 200 miles upstream and downstream on the main stream of the Colorado River from monitoring location 09380000 as orange dots, with the main gage noted as a blue pin" >}}
    </div>
</div>


## Brush and zoom capability for hydrographs

The new brush and zoom capability allows the user to easily select any part of the hydrograph for closer examination. The user simply selects a desired timeframe on the lower hydrograph which is then reflected in the upper hydrograph.

<div class="grid-row">
    <div class="grid-col-8 grid-offset-2">
    {{< figure src="/static/release_notes-2020-02-28/brush.gif" caption="Hydrograph animation showing a select sub-range (in gray) of streamflow for monitoring location 05427948, [Pheasant Branch at Middleton, WI](https://waterdata.usgs.gov/monitoring-location/05427948/)." alt="Hydrograph animation showing a select sub-range (in gray) of streamflow for monitoring location 05427948, Pheasant Branch at Middleton, WI." >}}
    </div>
</div>


## Other new features and tools

-   Implementation of the OGCAPI-Features standard (stay tuned for a
    blog post on this subject)
-   Repositories page: <https://labs.waterdata.usgs.gov/repositories/>
-   Collapsible legend on NLDI maps within monitoring location pages

## What is coming up for next sprint 

-   Add handles to brush on the monitoring location page hydrograph
-   Bookmarkable state on monitoring location pages
-   Continued work on a Groundwater Daily Value graph
-   Back-end data delivery enhancements   


Disclaimer
==========
Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.