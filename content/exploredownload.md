---
author: Shawna Gregory, Candice Hopkins, Rachel Volentine, Brad Garner, and Nicole Felts
date: 2021-12-21
slug: user_explore_download
draft: True
type: post
title: Explore & Download User Group
categories: 
- water-information 
tags:
  - water-data-for-the-nation
  - public-communication
image: static/plotFlowConc/unnamed-chunk-4-1.png
description: USGS Water Data for the Nation products have many users. Explore & Download users want to check out different sites and download data from some of them. They have a few favorite USGS products they use; read on to find out what they are...
keywords:
  - User research
  - User design
author_email: <wdfn@usgs.gov>
---

As described in the [WDFN user
blog](https://waterdata.usgs.gov/blog/user_wdfn/), we discovered three
key user groups which we use to design our delivery of USGS water
information. Here is a quick recap of the three user groups:

-   [**Operationalized
    Pull:**](https://waterdata.usgs.gov/blog/user_operational_pull/)
    These users pull data from multiple sources, including USGS API
    services, to use via custom dashboards and tools optimized for their
    location and needs. Operationalized Pull users, on average, use the
    most USGS water information, returning repeatedly for refreshed data
    to pull into their own systems.

-   **Explore & Download**: These users find nearby sites, exploring
    what data they collect. Users make ad-hoc or targeted queries to
    download, then alter the data as they need in their preferred tool
    (R, Excel, Python). Explore and Download users usually take their
    time exploring the data visually (maps, hydrographs, etc.) before
    finally downloading the data they find useful.

-   **[Check
    Status](https://waterdata.usgs.gov/blog/user_check_status/):** These
    users perform routine checks of a few parameters for specific sites,
    primarily using the hydrographs. Check Status users are our largest
    user type by number of unique users. Each user generally looks at a
    handful of sites for the latest water conditions.

This post will discuss what we know about our Explore & Download users
right now. As we research, we learn more about our users' needs, identifying patterns that can be used to update our understanding.

# Who are these users?

Explore & Download users are exploring our data, hoping to find
something they can use. Does that sound like you? The way these users approach our data is
diverse, but we can broadly categorize them into three sub-groups:

-   **Scientific data seekers** who access USGS water information at the
    beginning of a new project, such as a research topic or experimental
    model

-   **Professionals** who must respond to requests from the public,
    policymakers, business clients, reporters, or other stakeholders on
    water conditions

-   People **new to USGS water data**, exploring what we have to offer

Each user is unique in their data use and workflow. These user stories help us keep you - our user -
in mind as we design our services.

## Cynthia, the Environmental Restoration Biologist

Cynthia (she/her) is a biologist at the [USGS Washington Water Science
Center](https://www.usgs.gov/centers/washington-water-science-center).
She is seeking grant funding for a project studying how the lifecycle of
aquatic insects, such as mayflies, stoneflies, and caddisflies, is
related to the number of metals and chemicals in the water from mine
discharge. Her project hopes to show that the insect lifecycles increase
as an indicator of metal and chemical clean-up efforts, showing that
**environmental restoration is achievable after mine contamination.** For her
project, she needs historical records of the river area to compare
historical metal and chemical amounts along with her insect data. She
uses USGS
[dataRetrieval](https://waterdata.usgs.gov/blog/dataretrieval/) to pull
the data from NWIS and analyze in R. Her research provides water quality
criteria for chemical and metal conditions that can be present in stream
and river ecosystems. Cynthis says, "Ecosystems are complex, and you
need to consider all possible data available when assessing the health
of an ecosystem. I'm lucky the USGS publicly provides data from as far
back as 1970. This gives me insight into how healthy the ecosystem was
then and how that may affect our environment now."

## Roberto, the Geochemist

Roberto (he/him) works for a large environmental consultant in
California. The state has asked his company to determine how much
groundwater can be used for the water supply. His reporting could have
long-term impacts on California water use, and he needs accurate and
comprehensive data. This is a big job! He uses [NWISweb](https://waterdata.usgs.gov/nwis)
and the [Water Quality Portal](https://www.waterqualitydata.us/) to
search for historical data from all wells located in his region. He
moves those data into an Excel Spreadsheet and then imports data into
Geochemist's Workbench to analyze the geochemical signature of each
sample. Sometimes Roberto is asked by his colleagues to use geochemical
data to validate their conceptual models. Roberto thinks "geochemistry is a bit like the forensics you see on TV. Instead of
analyzing crime scene artifacts, we use the chemicals in water to
understand its unique fingerprint. Thanks to USGS serving stable isotope
data, we can age-date water. It's pretty cool to be able to tell someone
they're drinking 15,000-year-old water put there during a different
climate."

## Dania, the Climate Modeler 

Dania (she/her) is a third year PhD candidate at University of West
Florida. Her dissertation centers on how climate-change induced sea
level rise affects groundwater salinity in coastal areas. She wants to
help forecast how the public supply of drinking water sourced from
groundwater will be affected by increasing sea levels. Dania started
looking for groundwater data by using a search engine and found [USGS's
Groundwater Watch](https://groundwaterwatch.usgs.gov/Default.asp). The
Groundwater Watch map interface helped Dania realize there were many
groundwater sites monitored by the USGS and chose a few sites to add to
her research dataset. Diana downloaded observations from Groundwater
Watch and imported those into Excel so she could correlate water-level
observations with sea-level observations. Dania says "there's so much we
don't know about how sea level rise will affect real people on the
ground. We need to start thinking about our water resources now so we
can plan for mitigation." USGS data allows her to understand how
groundwater has behaved historically and is integrated into her
forecasts.

*Each user story does not represent a real person. The stories reflect real user experiences and are based on our decades-long experience with our users.*

# How do Explore & Download users interact with USGS water information?

Explore & Download users seek to answer a question with USGS data and
leave our website with useful water data. They tend to explore our maps
and data types, making targeted queries into the data until they find
data useful to answer their question(s). Through user research, we've
found that our users approach filtering through our data in many ways.
Common filters for our users include geography, time, parameters, and
site type. For data with extensive metadata, such as water quality, we
have found that our users use this metadata as nuanced filters to sift
through the data.

> "I use [NWIS
> Mapper](https://maps.waterdata.usgs.gov/mapper/index.html) to see
> where old/inactive sites are. I never search by county, I just
> use the map or ask others in the center about unfamiliar
> locations."
>
> -a Water Science Center staff member

As Explore & Download users evaluate USGS data, they are primarily
looking at the summary of the data collected *before* making the decision
to download the data for a closer look. Very rarely do these users
access [visualizations](https://labs.waterdata.usgs.gov/visualizations/vizlab-home) on our USGS sites to look at the data provided in
more detail. In most cases, these users have post-processing that they
do on the data including potentially cleaning out unwanted records or
reformatting it to match their custom tools. Many users pull the
downloaded data into scientific software suites made in R or Python.
They may then put downloaded data into context by graphically plotting
it, using it in models, comparing it to benchmarks, or interpreting it
in other ways.

The key distinction between [Operationalized
Pull](https://waterdata.usgs.gov/blog/user_operational_pull/) and
Explore & Download users is that Operationalized Pull users have used
scripts or software to repeatedly access USGS API services to refresh
their data sources as new data comes in. Many Operationalized Pull users
start out as Explore & Download users as they familiarize themselves
with USGS water information. Once they know exactly what they want to
download from USGS, many find the [programmatic APIs](https://waterservices.usgs.gov/) helpful so they
transition into purely [Operationalized Pull users](https://waterdata.usgs.gov/blog/user_operational_pull/).

# Key USGS Products

Explore & Download users gravitate toward tools they can use to explore
our data. If you think you're an explore and download user, you might be interested in

-   [NWISmapper](https://maps.waterdata.usgs.gov/mapper/index.html)

-   [NWISweb](https://waterdata.usgs.gov/nwis)

-   [National Water
    Dashboard](https://dashboard.waterdata.usgs.gov/app/nwd/?aoi=default)

-   [Water Quality Portal](https://www.waterqualitydata.us/)

# #EnGageWithUSGS
Connect with us! Connect with us! Follow us on [Twitter](https://twitter.com/USGS_water) and [Instagram](https://www.instagram.com/usgs_streamgages/).
We are learning more about Explore & Download users as we
continue our work improving the developer experience with accessing USGS
water data. If you want to share your own workflow and feedback on the process, email [wdfn@usgs.gov](mailto:wdfn@usgs.gov),
or if you'd be interested in participating in our user research process,
please email [wdfn_usabilitytesting@usgs.gov](mailto:wdfn_usabilitytesting@usgs.gov).

[Subscribe to the new Water Data for the Nation newsletter](https://usgs.us17.list-manage.com/subscribe?u=e9827ec090cef00a4355db5cb&id=5a8a7e2d2f) to stay up to date with our product offerings, events, and other ways to connect with us.

*Quotes in this blog post have been lightly edited for grammar and
clarity only.*
