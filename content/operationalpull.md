---
author: Shawna Gregory, Candice Hopkins, Rachel Volentine, Brad Garner, and Nicole Felts
date: 2021-12-21
slug: user_operational_pull
draft: True
type: post
title: 'Operationalized Pull: A User Group'
categories: water-information 
tags:
  - water-data-for-the-nation
  - public-communication
image: static/plotFlowConc/unnamed-chunk-4-1.png
description: USGS Water Data products have many users. This post breaks down a user who wants to access data through an automated process.
keywords:
  - User research
  - User design
author_email: <wdfn@usgs.gov>
---

As described in \[WDFN user blog\], we discovered three key user groups
which we use to design our delivery of USGS water information. Here is a
quick recap of the three user groups:

-   **Operationalized Pull:** These users pull data from multiple
    sources, including [USGS Application Programming Interface (API)
    services](https://waterservices.usgs.gov/), to use via custom
    dashboards and tools optimized for their location and needs.
    Operationalized Pull users, on average, use the most USGS water
    information, returning repeatedly for refreshed data to pull into
    their own systems.

-   [**Explore &
    Download**](https://waterdata.usgs.gov/blog/user_explore_download/):
    These users find nearby sites, exploring what data they collect.
    Users make ad-hoc or targeted queries to download, then alter the
    data as they need in their preferred tool (R, Excel, Python).
    Explore and Download users usually take their time exploring the
    data visually (maps, hydrographs, etc.) before finally downloading
    the data they find useful.

-   **[Check
    Status](https://waterdata.usgs.gov/blog/user_check_status/):** These
    users perform routine checks of a few parameters for specific sites,
    primarily using the hydrographs. Check Status users are our largest
    user type by number of unique users. Each user generally looks at a
    handful of sites for the latest water conditions.

This post will discuss what we know about our Operationalized Pull users
right now. As we research, we learn more about our users' needs and
identify patterns that can be used to update our understanding.

# Who are these users?

Anyone can use our APIs to become an Operationalized Pull user.
Currently, people from various backgrounds are regular Operationalized
Pull users:

-   Other federal, state, and local **government agencies** who manage
    or model water resources.

-   **Emergency Managers** who include USGS water data as part of their
    dashboards during emergencies

-   Scientific **modelers** who include USGS water data as a data source
    to power or validate their models

While each user is unique in their data use and workflow, we wanted to
provide a couple of Operationalized Pull user personas to help us keep
our users in mind as we design our services.

## User Persona: Francis, the River Forecaster

Francis (she/her) has worked at the Indianapolis, Indiana National
Weather Service River Forecast Office (RFO) for 10 years focusing on
mainstem river level forecasting. She has gained the respect of her
peers and the public for her clear and accessible writing. Francis has
enjoyed writing ever since winning her high school's short-story
contest. Even though University pursuits led her to the earth sciences,
she sees river forecasting as her way to continue honing her writing
craft. She explains, "USGS water data is an important part of my
writing." The RFO computer system, connected to USGS APIs, provides
Francis with the latest basic river data from USGS monitoring locations,
such as stream flow and gage height. Frances takes the RFO data a step
further by also looking at the history of manual field measurements and
river data, the station metadata, and any images or videos the USGS
provides in her river level forecasting. She says, "These help me
imagine floods better, and they help me think of citizens who live near
the river and are so connected to it." The richness of the data Francis
obtains from USGS allows her to convey her information in an obtainable
and relatable way to her region, including the public and other public
agencies. Francis says she\'d love for all this USGS data to appear in
her custom Geographic Information System instead of having to click
through USGS websites all the time, and she is glad that APIs are making
that more and more possible for someone like herself who is not a
software programmer.

## User Persona: Ted, the Flood Control Officer 

Ted (he/him) oversees a Flood Control District for Harris County, Texas,
one of the most densely populated and low-lying counties in the United
States. His District is responsible for getting the word out quickly
when dangerous flooding situations are about to happen. He grew up in
Harris County and is something of a local news celebrity there and
appears on local news stations during major storm events. From his 52
years in Harris County, he knows from experience that land-use change,
land subsidence, and climate change are making floods more frequent and
severe. Ted recently reflected on how much
[NWISweb](https://waterdata.usgs.gov/nwis) has helped his District
succeed: "When I started here in 1997, we had maybe a dozen river
monitors that literally broadcast an alarm sound in Morse Code on a
shortwave radio system when the sensor was submerged under water. The
system was constantly breaking. Heck, sometimes we just had to drive to
the river and look at it." Since 2003 his district has partnered with
USGS to monitor these rivers. The partnership helps get the live data
directly into their data acquisition system from the USGS website. This
provides real-time notifications of flooding conditions and Ted is more
confident in his job and that he has the latest information. He is not
worried about missing important notifications because the two systems
work seamlessly together.

## User Persona: Maria, the Scientific Modeler

Maria (she/her) recently joined the faculty of her University's earth
sciences department. Maria has a Master's in chemistry and a PhD in
zoology. Her research interests include coastal change and human impacts
in wetland and coastal ecosystems. Maria is starting an ambitious
applied research program studying the Gulf of Mexico hypoxia zone---an
area of the ocean that loses its dissolved oxygen each summer, damaging
the aquatic life there and impacting the livelihoods of millions of
Americans. Her model will require many types of data inputs, including
water quantity and quality information from upstream watersheds. She
intends to develop a state-of-the-art computer model that uses the
supercomputing power of the cloud (maybe even quantum computing). Maria
and her team will access USGS water quality information, such as
nutrient concentrations and temperature measurements, and quantity
information, such as streamflow through [Water Quality Portal's Web
Services](https://www.waterqualitydata.us/webservices_documentation/)
and [USGS's Water Services](https://waterservices.usgs.gov/). They can
then easily incorporate the data into their model, in part because USGS
uses data standards from [Open Geospatial
Consortium](https://www.ogc.org/), which helps standardize the many
sources of data. Maria's research should provide real, practical answers
about the future of the hypoxic zone in the Gulf of Mexico and how
humans' actions hundreds of miles away impact the watershed and offshore
areas. She and her burgeoning research team have many tough problems
ahead, but she is "grateful getting USGS water data into the model will
not be one of the problems."

# How do Operationalized Pull users interact with USGS water information?

We know these users want to easily look at USGS data alongside other
sources of data, including state and local water information. When they
interact with our water data, they are utilizing APIs such as [USGS
Water Services](https://waterservices.usgs.gov/) and
[dataRetrieval](https://usgs-r.github.io/dataRetrieval/) to pull the
data repeatedly into their own data ecosystem. For these users, our data
becomes one part in a rich set of data to power custom dashboards,
visualizations, and data stores based on their organizational mission.

Operationalized Pull users pull more data from USGS than any other user
type, though each user's needs are unique. Some of our users will be
very locally focused on a single hydrologic unit of data, while others
will pull water data nationwide to serve their needs. The key
distinction between Operationalized Pull and Explore and Download users
is that Operationalized Pull users have used scripts or software to
repeatedly access USGS API services to refresh their data sources as new
data comes in.

> "Right now, on one dev system, I'm using ... \[existing state\]
> software but pulling from all 50 states + territories, sequential,
> every 5 minutes."
>
> \- a federal partner

Data Visualizations, statistics, and other types of contextualization of
the data provided by USGS is rarely used by Operationalized Pull users.
As USGS data is just a single part of a larger ecosystem of data, these
users generally are looking at the data in their own tools to customize
their own experience. Here at the USGS, we consider this to be data
interpretation that occurs "post-processing," as in, after the data is
exported from USGS software and tools. We are pleased to know that our
data is valued as a primary data source for so many users.

> "I'm not so much interested in going to USGS web pages to look at
> what's going on - I want to pull it into my mapping system so I can
> use \[USGS data\]."
>
> \- an emergency manager

# Key USGS Products

Operationalized Pull users are primarily accessing our API services. Key
USGS products used by these users include:

-   [USGS Water Services](https://waterservices.usgs.gov/)

-   [dataRetrieval](https://usgs-r.github.io/dataRetrieval/)

-   [WaterWatch Data
    Services](https://waterwatch.usgs.gov/index.php?id=wwds)

-   [Water Data for the Nation Tableau Web Data
    Connector](https://labs.waterdata.usgs.gov/tableau-connector/index.html#/)

# \#EnGageWithUSGS -- Connect with us!

We are continuing to learn more about Operationalized Pull users as we
continue our work improving the developer experience with accessing USGS
water data. If you want to share your own workflow and feedback on the
process or if you'd be interested in participating in our user research
process, please email <WDFN@usgs.gov>.

*Quotes in this blog post have been lightly edited for grammar and
clarity only.*
