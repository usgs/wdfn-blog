---
author: Jim Kreft
date: 2019-11-07
slug: release-notes-2019-11-07
draft: False
type: post
image: /static/release-notes-2019-11-07/monitoring_camera_zoom.png
title: "Release Notes for November 7, 2019"
author_github: jkreft-usgs
author_staff: james-m-kreft
author_email: <jkreft@usgs.gov>
categories:
  - Applications
description: A summary of new features and tools released on November 7, 2019
keywords:
  - water information
tags:
  - Water Data for the Nation
  - Release Notes

---

## What have we been up to?

This sprint, we have been working on a number of features that are groundwork for exciting things in the future. Most notably, we are working to develop a working monitoring location services system based on the new [Open Geospatial Consortium OGC API-Features standard](https://www.opengeospatial.org/standards/ogcapi-features). Much more on this to come!  In the meantime, we did make make some small improvements to monitoring location pages.

## New features and tools

### Monitoring Location pages

#### More effective display of multiple time series with the same parameter

**User Story:** As a water manager, I want to be able to choose between different time series that are collected for the same parameter so that I ban better understand the state of the river.

It is not uncommon to collect more than one time series with the same parameter code, at a single monitoring location.  Often, this is because there are multiple sampling points at the same monitoring location, such as multiple depths in a river.  The Potomac River at Chain Bridge, for example, collects temperature data at multiple depths.  Other times, the type of equipment that was used to collect the data may be sufficiently different that there are more than one names time series.  At times, this can mean as many as 25 unique time series, such as at Bear Lake in Utah, where a profiler buoy collects water data at 25 different depths.  Other sites may collect discharge at multiple parts of a dam (each floodgate, the lock, the tailrace, etc) On the legacy pages, there was a different graph for each of the time series.  On the new pages, we instead are putting all the time series for a single parameter on one graph.

{{< figure src="/static/release-notes-2019-10-16/bear_lake_temperature.png" alt="A screenshot of a graph showing many orange lines and dots, with text overlaying the lines such that everything is obscured by everything else" caption="**A screenshot showing temperature at monitoring location number  [420407111201201](https://waterdata.usgs.gov/monitoring-location/420407111201201/), Bear Lake 3.6 miles northeast of Fish Haven, Idaho. There are multiple temperature time series each at different depths of the lake.**"
>}}

To address some of these shortcomings, we made a number of additions to the .  Now you can choose one time series at a time to drill into to see details.  The details for that one time series is displayed in the drop down, but also in the title of the hydrograph. All of these changes make it possible to better understand what is going on.

{{< figure src="/static/release-notes-2019-11-07/bear_lake_after.png" alt="A graph showing temperature data as orange lines.  There is one line and many dots.  One series of dots is darker than the others" caption="**A screenshot showing temperature at monitoring location number [420407111201201](https://waterdata.usgs.gov/monitoring-location/420407111201201/), Bear Lake 3.6 miles northeast of Fish Haven, Idaho. A user can now choose a specific temperature time series, in this case seven meters below the surface.**" >}}



#### Toggling the median

**User story:** As a hydrologist, I want to be able to see the median daily average so that I can understand how the current data compares to the past.

The median daily value is a valuable tool to understand if a given instantaneous value is higher or lower than past values.  However, it can also be confusing to a user who just wants to understand what is happening right now. Therefore we decided to make the median display a choice, instead of displayed all the time.

{{< figure src="/static/release-notes-2019-11-07/l_arkansas_median.png" alt="A graph showing discharge data as solid orange line.  There is a dotted orange line that is the median line" caption="**A screenshot showing discharge data at [07144100](https://waterdata.usgs.gov/monitoring-location/07144100/), L ARKANSAS R NR SEDGWICK, KS. The median data is selected, which shows that the current discharge is higher than the median discharge for historical records of this day of the year.**" >}}

#### Monitoring location cameras

Many hundreds of USGS monitoring locations have cameras co-located with other instruments, which add another dimension of data to the data that the USGS collects. We are working on a first pass solution for putting images and time lapse videos from these cameras on the monitoring location pages. This is an area of significant expansion for the USGS, and we expect quite a bit of additional work on this as we build out the [Next Generation Water Observing System](https://www.usgs.gov/science/usgs-next-generation-water-observing-system-ngwos) (NGWOS).  An example location with a camera is on the [Yahara River at East Main Street at Madison, WI](https://waterdata.usgs.gov/monitoring-location/05428500/).

{{< figure src="/static/release-notes-2019-10-16/monitoring_camera.png" alt="A screenshot of the monitoring location section of the new monitoring location pages.  There is a small image of a river on the left side of the image, and several links to more images on the right side." caption="**A screenshot from the development version of the new pages, showing a camera that is located at monitoring location number [05428500](https://waterdata.usgs.gov/monitoring-location/05428500/), Yahara River at East Main Street at Madison, WI**" >}}

## What is coming up for next sprint

Here’s what else you can look forward to next time:

* A new monitoring location service based on the new [Open Geospatial Consortium OGC API-Features standard](https://www.opengeospatial.org/standards/ogcapi-features).

* A cloud-hosted Water Quality Portal


Disclaimer
==========
Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
