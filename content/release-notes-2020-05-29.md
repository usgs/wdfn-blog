---
author: Charlotte Snow and Jim Kreft
date: 2020-05-29
slug: release-notes-2020-05-29
draft: True
type: post
image: /static/release_notes-2020-05-29/image1.jpg
title: "Release Notes for May 29th, 2020"
author_staff: charlotte-m-snow
author_email: <csnow@usgs.gov>
categories:
  - Applications
description: A summary of new features and tools released on or before May 29, 2020
keywords:
  - water information
tags:
  - Water Data for the Nation
  - Release Notes

---
What have we been up to?
========================

-   Pubs Warehouse moved to the Cloud

-   Behind the scenes work

New features and tools
======================

Pubs Warehouse on the Cloud
---------------------------

The Water Data for the Nation team is the primary development team for
another high profile application, the [USGS Publications
Warehouse](https://pubs.er.usgs.gov/). For the past 17 years, the
Publications Warehouse has been hosted on a variety USGS
Water-associated systems, but on April 6th, 2020, the Water Data for
the Nation team, In collaboration with USGS colleagues in [Science
Analytics and
Synthesis](https://www.usgs.gov/core-science-systems/science-analytics-and-synthesis/about)
moved the Publications Warehouse from on-premise hardware using a
closed-source backing store to an entirely open source stack, on
commercial cloud infrastructure. Rather than a "lift and shift" move,
the application was completely rebuilt to support a cloud-native
architecture, while moving away from a number of home-grown tools in
favor of shared, standards-based approaches for functions like
authorization and authentication. There are a number of benefits to this
move, including:

-   Reducing the licensing burden for closed-source database systems

-   Reducing the operational burden of the on-site infrastructure team
    by cutting the traffic to that infrastructure by 93% (from \~2.2
    million visits a year to \~155,000 visits a year)

-   Allowing the retirement of a legacy, custom
    authentication/authorization application

-   Reducing the operational burden on the WDFN team by providing an
    operational lead and team that is outside the Water Mission Area

-   Increasing the WDFN team\'s expertise in Postgres and in on-premise
    to cloud transitions


<div class="grid-row">
    <div class="grid-col-14 grid-offset-0">
    {{< figure src="/static/release-notes-2020-05-29/image1.jpg" caption="Screenshot of the USGS Publications Warehouse homepage." alt="Screenshot of the USGS Publications Warehouse homepage" >}}
    </div>
</div>


Behind the scenes
-----------------

-   Data flows! Focus on daily values data.

-   Building a new, cloud native data transformation and loading
    toolchain for observations data.

-   Building a new, standards-focused tool for presenting observations
    data.

-   Extensions of the graph API custom periods for the graph image API.

What is coming up for next sprint?
==================================

-   All monitoring locations will have a link to the networks they are
    part of in the new monitoring location service.

Disclaimer
==========

Any use of trade, firm, or product names is for descriptive purposes
only and does not imply endorsement by the U.S. Government.
