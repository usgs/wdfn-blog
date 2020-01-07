---
author: Jim Kreft
date: 2020-01-03
slug: release-notes-2020-01-03
draft: True
type: post
image: /static/release-notes-2020-01-03/monitoring_camera_zoom.png
title: "Release Notes for January 3, 2020"
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

Quite a few things! There have not been that many new public releases of code lately, because it turns out that doing new things is hard!  Most notably, we have been working on:

* Cloud migration of the Water Quality Portal
* Deployment of a new, experimental monitoring location service
* Building a new, cloud native data transformation and loading toolchain for observations data
* Building a building a new, standards-focused tool for presenting observations data.
* Other smaller tasks


## Cloud migration of the Water Quality Portal

Of of the most notable releases since the last set of release notes is one that our users barely noticed. One of the products of the water data for the nation Team is the Water Quality Portal, a cooperative project between the US. Geological Survey and US Environmental Protection Agency to amke discrete water quality data available in a single, standards-driven way.  The Water Quality Portal has grown from a proof of concept pilot project to a tool that organizations depend on, and from making 150 million rows of data available to nearly 400 million rows of data from over 400 partner agencies.  As the application grew, it became clear that its existing hosting solutions in an on premise data system, based on Oracle, were not going to be able to scale to meet the needs of of its users.  On December 20th, with only a few small hiccups, the Water Quality Portal was transitioned from an on-premise-based tool to a 

## New features and tools

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
