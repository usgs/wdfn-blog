---
author: Jim Kreft
date: 2019-10-08
slug: release-notes-2019-10-09
draft: False
type: post
image: /static/release-notes-2019-10-02/discharge_after.png
title: "Release Notes for October 2, 2019"
author_github: jkreft-usgs
author_staff: james-m-kreft
author_email: <jkreft@usgs.gov>
categories:
  - Applications
description: A summary of new features and tools released on October 2, 2019
keywords:
  - water information
tags:
  - Water Data for the Nation
  - Release Notes

---

## What have we been up to?

This sprint, the team has been working primarily on features that are tied to the cloud version of the [USGS Publications Warehouse](https://pubs.er.usgs.gov).  Unfortunately, these features are not publicly available yet, and as such, we aren't able to share them- there will be an extensive post when the application makes the jump to the cloud and we can share it.  We have been able to add a couple new features to the monitoring location pages, however, which I WILL be able to discuss.

## User Stories

For this sprint, and future sprints, the release notes will include the *user stories* that the development team uses to describe units of work.  User stories help us remember *who* we are doing the work for, *what* we need to do, and *why* it is important.  They are a core part of agile software development, which is how we do our work.

A user story generally takes this form: "As a  ___ *who* ____ I want ____ *what* ______ so that ____ *why* _____"


## New features and tools

### Monitoring Location pages

#### Celsius and Fahrenheit degrees on temperature scales.

**User story:** As an angler, I want to see the temperature displayed in Fahrenheit addition to Celsius, so that I don't have to convert the temperature in my head to a scale I intuitively understand.

In addition to custom time ranges, which we addressed last week, of the [hundreds of comments submitted by users](https://waterdata.usgs.gov/blog/wdfn-firstlook/) on the new real-time data pages, one of the most requested features of the new pages was to convert temperature in degrees Celsius to degrees Fahrenheit. We have responded, and now have a second scale as well as a second value in the temperature display.

#### Better axis scaling

**User story:** As a water manager looking at discharge data, I don't want to see the whole dataset crammed into a small portion of the graph, so that I can better understand what is happening.

Discharge is a core time series dataset that the USGS collects.  You can learn more about discharge at the [USGS Water Science School](https://www.usgs.gov/special-topic/water-science-school/science/how-streamflow-measured). Discharge is highly variable-  it is not uncommon to see a site cover 4 orders of magnitude in less than a day- and because of this huge range, it is one of the hardest time series to effectively plot.  We have to use a log scale, which is confusing in and of itself.  The issue that we were solving here was that the way we had chosen to set the lower bound.  An initial choice was to tie the lower bound to the next lowest order of magnitude.  What I didn't realize was that when we did this, it meant that for sites that, say hovered around 10,000 cfs of discharge, most of the hydrograph would be empty space.

{{< figure src="/static/release-notes-2019-10-02/discharge_before.png" alt="A graph showing discharge on the Colorado river as Lees Ferry. The majority of the data is in the top third of the graph" alt="A hydrograph, with an orange line showing discharge data stacked in the upper third of the graph" title="Discharge for seven days at USGS Monitoring location number 09380000, Colorado River at Lees Ferry, AZ, using the older axis scaling approach" >}}

By changing to a slightly different algorithm, we were able to take advantage of all the space in the hydrograph, making it far easier to make sense of the data.

{{< figure src="/static/release-notes-2019-10-02/discharge_after.png" alt="A graph showing discharge on the Colorado river as Lees Ferry. The data is using most of the area of the graph" title="Discharge for seven days at USGS Monitoring location number 09380000, Colorado River at Lees Ferry, AZ, using the newer axis scaling approach" >}}

#### Feature Flagged Stories

These stories aren't quite ready to be released to production, but we are very excited about them.  We commonly use what are called "feature flags" on a feature that is not quite ready for public consumption, so that we can still release the rest of the project, while setting aside the complexities of complex code management workflows.

##### Monitoring location cameras

Many hundreds of USGS monitoring locations have cameras, which add another dimension of data to the data that the USGS collects. We are working on a first pass solution for putting images and time lapse videos from these cameras on the monitoring location pages. This is an area of significant expansion for the USGS, and we expect quite a bit of additional work on this as we build out the Next Generation Water Observing System.

##### Working with multiple time series data on a single graph.

Historically, USGS time series data systems have been built to handle a single instance of a given parameter code per site.  The reality is that it is often neccessary to collect the same parameter code as multiple sampling locations at the same monitoring location.  For example, it may been needed to taking temperature readings at 4 different depths, or collect discharge data at 4 flood gates, a lock, a fish ladder AND a downstream point at a dam.  At this time, the difference between the various time series is encoded into a string of text that gives more details about what the differences are.  This text has unfortunately not been displayed on the new monitoring location page, and we would just display all the times series on the same graph.  This can get messy:  


When we demoed a first attempt, to just let a user choose a single time series, everyone agreed that there needed to be more work to make things less confusing. We have three more smaller stories in flight this sprint that we hope will make multiple time series for a single parameter code more approachable.  This work has also shown that there is quite a lot of work that we need to do around managing data collected at sub-sampling locations, which is something else that we expect will be more common as the [Next Generation Water Observing System](https://www.usgs.gov/science/usgs-next-generation-water-observing-system-ngwos) (NGWOS) is built out.  For example, it would be extremely valuable to be able to collect and serve precise

## What is coming up for next sprint

Other things that are coming for next sprint:

* Better handling of median lines
* Better time series data display for multiple time series on one parameter






Disclaimer
==========
Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
