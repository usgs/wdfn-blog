---
author: Jim Kreft
date: 2019-09-12
slug: iow_wateryear_2019_sprint_22
draft: True
type: post
title: ""
author_github: jkreft-usgs
author_staff: james-m-kreft
author_email: <jkreft@usgs.gov>
categories:
  - Applications
description: A summary of new features and tools released in this sprint
keywords:
  - water information
tags:
  - Water Data for the Nation
  - Release Notes

---

# Release Notes

## What have we been up to?

This is the first of regular posts that will go over newly released features of projects that are in the Internet of Water family of applications.  The team that generates Internet of Water applications is aiming to get into a pattern of regular releases- every two weeks or less, of small improvements and new features.  The applications that we have been working on include the [Water Quality Portal](https://www.waterqualitydata.us/). the [National Groundwater Monitoring Network](https://cida.usgs.gov/ngwmn/) and the [USGS Publications Warehouse](https://pubs.er.usgs.gov/).

## New features and tools

### Monitoring Location pages

#### Custom Time Ranges
One of the most requested features of the new pages was the ability to display a custom time range, instead of the three current choices of 7 days, 30 days, and one year.  This is now possible- you can choose any time range that you would like.

# screenshot of custom time ranges

This is just the beginning of this feature, and we plan to add additional features such as validation of period of record and letting users know how large of a time range that they could choose would be, as well as more effective tools to allow for navigating

#### Upstream and downstream monitoring locations
Another commonly requested feature is the ability to navigate to upstream and downstream monitoring locations.  We now have this feature for every active surface water site!  if you navigate to the map, we display all monitoring locations upstream and downstream on the main stem of the stream of the current monitoring location.  

# Screenshot of upstream downstream

This feature is made possible by a tool called the [Hydro-Network Linked Data Index](https://labs.waterdata.usgs.gov/about-nldi/) In the near future, we are expecting to extend this feature to include all upstream monitoring locations and basins (as well as basin characteristics).  

#### Flipped axis for Groundwater levels

Groundwater levels at the USGS are typically measured as the water level in feet below the land surface, rather than as a negative elevation.  As a result, the graphs that we have been generating for ground water sites have been effectively "upside down:" when the level of the water when down, the graph would go up- and vice-versa.  We have now taken care of this by simply following the convention of flipping the axis.   

# screenshot of Groundwater before, and groundwater after

Groundwater data display is an area that we expect to significantly extend in the coming months- again, this is a very first step.

#### Real-time cameras at monitoring locations

The USGS has been deploying cameras at monitoring locations for some time, but they have not been a clear part of the monitoring location page or the previous site pages until now.  This implementation is a clear minimum viable product, but it is absolutely a start.  


Cameras are going to play a key role in the future of water data monitoring at the USGS, as we build out the next generation water observing systems.  

### Initial roll-out of Water Data Labs

_While labs will warrant another follow-up post, I will give a quick overview here._  

Water Data Labs is an experimental space where the USGS Internet of Water development team is able to learn how to run new kinds of cloud-native, high performance tools that will form the basis of the future of Water Data for the Nation.  In addition to cloud experimentation, we are planning on using labs to make available a variety of other tools:

* Web services that do not have a stable API
* Experimental visualizations or dashboards
* Data integration prototypes
* Experimental datasets and data integrations

To that end, we have released three initial products on [https://labs.waterdata.usgs.gov].

#### [Tableau Data Connector](https://labs.waterdata.usgs.gov/about-connector/)

A project that was written almost entirely by an internship project coordinated through the Water Resources Research Institutes, the Tableau Data Connector is a bridge between the [waterservices.usgs.gov](https://waterservices.usgs.gov)  instantaneous values service and the Tableau data analysis tool.  

#### [Graph Images API](https://https://labs.waterdata.usgs.gov/about-graph-image-api/)

A common request is to 

* Multiple improvements to monitoring location pages





Disclaimer
==========
Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
