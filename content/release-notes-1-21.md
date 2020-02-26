---
author: Jim Kreft
date: 2020-01-03
slug: release-notes-2020-01-03
draft: True
type: post
image: /static/release-notes-2020-01-03/monitoring_camera_zoom.png
title: "Release Notes for January 21, 2020"
author_github: jkreft-usgs
author_staff: james-m-kreft
author_email: <jkreft@usgs.gov>
categories:
  - Applications
description: A summary of new features and tools released on or before January 3, 2020
keywords:
  - water information
tags:
  - Water Data for the Nation
  - Release Notes

---

## What have we been up to?

The last several months have been exciting.  We have been able to finish off work that 

* Cloud migration of the Water Quality Portal
* Deployment of a new, experimental monitoring location service
* Building a new, cloud native data transformation and loading toolchain for observations data
* Building a building a new, standards-focused tool for presenting observations data.
* Extensions of the graph API


## Cloud migration of the Water Quality Portal

Of of the most notable releases since the last set of release notes is one that our users barely noticed. One of the products of the Water Data for the Nation Team is the [Water Quality Portal](https://www.waterqualitydata.us/portal/), a cooperative project between the U.S. Geological Survey and the Environmental Protection Agency that makes discrete water quality data available in a single, standards-driven way.  The Water Quality Portal has grown from a proof of concept pilot project to a tool that organizations depend on, and from making 150 million rows of data available to nearly 400 million rows of data from over 400 partner agencies.  As the application grew, it became clear that its existing hosting solutions in an on premise data system, based on Oracle, were not going to be able to scale to meet the needs of of its users.  On January 16th, with only a few small hiccups, the Water Quality Portal was transitioned to a cloud-hosted tool with a postgres backing store.  

Moving the WQP was not an insignificant effort.  Rather than attempt a "lift and shift" based approach, we did our best to turn the Water Quality Portal into a cloud-native application.  In its on-premise version, the WQP runs on five virtual machines, backed by a 16 core beast of a database.  In the cloud version, the applications are all containerized, running in in a cluster of "containers as a service," backed by a postgres database running in a database as a service.  The lessons learned in this migration have ben applied to everything else that we have been doing. The transition o the WQP is a blogpost unto itself. 


## Cloud migration of the Hydro Network Linked Data Index

The [Hydro Network Linked Data Index](https://labs.waterdata.usgs.gov/about-nldi/) has finally been publically deployed to the cloud.  While we have been quietly using the NLDI for a while for upstream-downstream quieries on the monitoring location pages, we have not been able to publicly announce it for a variety of reasons.  Similar to the Water Quality Portal, NLDI was transformed from an on-premise application running into a cloud native application.   

{{< figure src="/static/nldi/up_down_09380000.png" alt="A map showing gages as orange dots, upstream lines as dark blue, and downstream lines as light blue. There is a text pop-up noting the name and number of the next upstream site" caption="Map showing the gages 200 miles upstream and downstream on the main stream of the Colorado River from monitoring location 09380000, Colorado River at Lee's Ferry, AZ" >}}

 

## New features and tools

In addition to 


### graph image API

#### custom periods for the graph image API

**_User Story:_** **

As we add features to the new monitoring location pages hydrograph, we need to make sure that it is possible to also add those features to the the static graph image API.  Hence, when we added custom periods to the graph, we needed to be able to also add those same periods to the graph image API. In addition, since these graphs may be presented without context, it is important to allow for adding the title of the monitoring location and its number, so that users can determine when and where the image came from.


### Monitoring Location pages

#### More effective display of multiple time series with the same parameter

**_User Story:_** *As a water manager, I want to be able to choose between different time series that are collected for the same parameter so that I can better understand the state of the river.*





#### Toggling the median


**_User story:_** *As a hydrologist, I want to be able to see the median daily average so that I can understand how the current data compares to the past.*



#### Monitoring location cameras



## What is coming up for next sprint

Here’s what else you can look forward to next time:

* 


Disclaimer
==========
Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.