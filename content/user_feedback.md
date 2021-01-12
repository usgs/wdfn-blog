---
author: Candice Hopkins
date: 2021-01-11
slug: user-feedback
draft: True
type: post
image: /static/user-feedback/image1.png
title: User Feedback as part of the WDFN Design Process
author_staff: candice-hopkins
author_email: <chopkins@usgs.gov>
categories:
  - Applications
description: Features that we have added or improved based on user feedback
keywords:
  - water information
tags:
  - Water Data for the Nation 

---


User feedback is a vital part of our design process. We’ve asked users
to provide feedback on our
[next-gen](https://waterdata.usgs.gov/blog/wdfn-tng/) monitoring
location pages and they’ve submitted some great ideas! Here are some
things our users have asked for, and how we’ve responded to their
requests:

# Better map

Users asked us to improve the map in a few ways and we responded:

-   They requested a more detailed basemap, showing streets and
    landmarks. We swapped out the old basemap and replaced it with our
    very own [USGS National
    Map](https://www.usgs.gov/core-science-systems/national-geospatial-program/national-map).
    Users can now see details at the local level, including topography
    and local place names.

-   They asked us to show all monitoring locations in the field of view,
    not just other locations on the same stream. We now show all active
    monitoring locations nearby.

-   Another common request was to reduce the opacity of the upstream
    basin to make it easier to see features under the map layer. The
    upstream basin is now projected in a much lighter shade.

<center>
![](/static/ImprovingMonitoringPages/image1.png) **Screenshot of new
improved base map and upstream basin shading for monitoring location
[07016500](https://waterdata.usgs.gov/monitoring-location/07016500/#parameterCode=00065),
Bourbeuse River at Union, MO**
</center>

### 

# Get a snapshot of what data are available at a site

Users wanted to know what data was available on which dates. We added a
section to monitoring location pages that summarizes data availability
for each site. The “Summary of All Available Data” section shows the
start and end date of available data at each site. We grouped parameters
into categories to make the available data easier to understand.

<center>
![](/static/ImprovingMonitoringPages/image2.png) **A screenshot of a
data summary section from monitoring location
[07019130](https://waterdata.usgs.gov/monitoring-location/07019130/#parameterCode=00065),
Meramec River at Valley Park, MO **
</center>

The period of record is also now displayed on the monitoring location
pages for instantaneous values of each parameter, making it easier to
request a custom time period to display on the hydrograph.

<center>

![](/static/ImprovingMonitoringPages/image3.png)

**A screenshot showing the period of record for instantaneous values at
monitoring location
[07019130](https://waterdata.usgs.gov/monitoring-location/07019130/#parameterCode=00065),
Meramec River at Valley Park, MO **
</center>

### 

# Make the hydrograph easier to view and manipulate

-   Users commonly asked for better ways to manipulate the timeline
    displayed on the hydrograph. Our team improved the ways users
    interact with dates by incorporating the [U.S. Web Design System
    date
    picke](https://designsystem.digital.gov/form-controls/05-date-picker/)r
    in the “Custom” date section. Users can now select a custom date
    frame by choosing dates on a calendar or typing dates.

<center>
![](/static/ImprovingMonitoringPages/image4.png) **Screen shot of
updated date picker for hydrograph display**
</center>

-   They asked for easier ways to switch between parameters, especially
    on mobile devices. Our team changed the way that parameters are
    displayed on our pages by adding “radio buttons” so that it was
    easier for users to switch between parameters displayed on the
    hydrograph.

-   Users also asked that we take the parameter code number off the
    display so there is less text on the screen. We shortened the names
    of parameters displayed by moving the USGS parameter codes (commonly
    referred to as “p-codes”) into tool tips, which users access by
    hovering over the icon at the end of the parameter name.

<center>
![](/static/ImprovingMonitoringPages/image5.png) **Example of WaterAlert
Subscription Form for monitoring location
[01458500](https://waterdata.usgs.gov/monitoring-location/01458500/),
Delaware River at Frenchtown, NJ**
</center>

-   Others requested that we switch the colors on the hydrograph so that
    historic and statistical data are easier to view. Our team also
    improved how the hydrograph looks on the page. We changed the color
    and thickness of median data and historic data so that they are
    easier to view.

### 

# Add links to other USGS services

-   Users asked us to add links to make our other services more
    accessible to them. Our team responded by adding links to
    [WaterAlert](https://maps.waterdata.usgs.gov/mapper/wateralert/) for
    parameters of interest at the top of the menu/table where users also
    see the period of record. These links take users directly to a
    subscription form for the site where they set notification
    thresholds.

<center>

![](/static/ImprovingMonitoringPages/Gif.gif)

**Example of XXXXX
[01458500](https://waterdata.usgs.gov/monitoring-location/01458500/),
Delaware River at Frenchtown, NJ**
</center>

-   Users wanted to be able to download data. We added links to
    different methods for downloading data. These links point to data
    available from USGS Water Data Services and are limited to
    instantaneous data available in the hydrograph. We also encourage
    users to use the dataRetrieval package in R, which allows users to
    access an expanded data set for each site.

<center>

![](/static/ImprovingMonitoringPages/image6.png) **Screen capture of
data download section**

### 