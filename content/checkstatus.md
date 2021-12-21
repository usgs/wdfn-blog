---
author: Shawna Gregory, Candice Hopkins, Rachel Volentine, and Nicole Felts
date: 2021-12-21
slug: user_check_status
draft: True
type: post
title: Check Status User Group
categories: water-information 
tags:
  - water-data-for-the-nation
  - public-communication
image: static/plotFlowConc/unnamed-chunk-4-1.png
description: USGS Water Data products have many users. This post breaks down a user who wants to quickly check the status of water data.
keywords:
  - User research
  - User design
author_email: <wdfn@usgs.gov>
---

As described in the [WDFN user
blog](https://waterdata.usgs.gov/blog/user_wdfn/), we discovered three
key user groups which we use to design our delivery of USGS water
information. Here is a quick recap of the three user groups:

-   **[Operationalized
    Pull](https://waterdata.usgs.gov/blog/user_operational_pull/):**
    These users pull data from multiple sources, including USGS API
    services, to use via custom dashboards and tools optimized for their
    location and needs. Operationalized Pull users, on average, use the
    most USGS water information, returning repeatedly for refreshed data
    to pull into their own systems.

-   [**Explore &
    Download**](https://waterdata.usgs.gov/blog/user_explore_download/):
    These users find nearby sites, exploring what data they collect.
    Users make ad-hoc or targeted queries to download, then alter the
    data as they need in their preferred tool (R, Excel, Python).
    Explore and Download users usually take their time exploring the
    data visually (maps, hydrographs, etc.) before finally downloading
    the data they find useful.

-   **Check Status:** These users perform routine checks of a few
    parameters for specific sites, primarily using the hydrographs.
    Check Status users are our largest user type by number of unique
    users. Each user generally looks at a handful of sites for the
    latest water conditions.

> This post will discuss what we know about our Check Status users right
> now. As we research, we learn more about our users' needs and identify
> patterns that can be used to update our understanding.

# Who are Check Status users?

Check Status users are performing checks of a few parameters for
specific sites of interest. The way these users approach our data is
diverse, but we can broadly categorize them into three sub-groups:

-   **General:** These check status users are attracted to our site by
    water events or personal risk. They can be either technical or
    non-technical and are our largest set of users. What the users
    intend to learn from USGS data is diverse. Some users are interested
    in seeing if their roads or bridges are flooding, whereas others are
    determining whether they should go kayak or fish in their favorite
    river.

-   **Download:** These users download or pull the data or hydrograph to
    share the latest water conditions. These users rely on the latest
    USGS water data to keep their stakeholders updated.

-   **Monitor:** These users are water professionals who are responsible
    for monitoring complex water conditions for water systems such as
    dams, aquifers, and levees.

While each user is unique in their data use and workflow, we wanted to
provide a couple of Check Status user personas to help us keep our users
in mind as we design our services.

## User Persona: Homeowner Sally

Sally (she/her) has lived in her home with her husband, two children,
and dog for six years. Her home is located near the Wapsipinicon River
in Iowa. In that time, there have been several minor floods that came
within inches of her house and one year ago there was a major flood
which caused severe damage to the first floor of her property. At the
time Sally, was not prepared for the flood and did not remove personal
goods from the first floor, so she lost several family heirlooms. Sally
is a busy mother with a full-time job and needs a simple and quick way
to get lifesaving information about potential flooding. Sally learned of
two USGS services that can help. First, Sally signed up to receive email
alerts from [Water
Alert](https://maps.waterdata.usgs.gov/mapper/wateralert/) when the
river by her property reaches 12 feet, a minor flood stage. She says "I
feel safer having notifications set up through Water Alert. This warns
me of potential flooding and gives me time to make sure my pets, kids,
and valuables safe." Sally also checks the [Wapsipinicon River
monitoring location
page](https://waterdata.usgs.gov/monitoring-location/05421000/#parameterCode=00065&period=P7D)
when there has been a lot of recent rain. She can see the water level
trends and she gets additional comfort knowing how the rain is affecting
the Wapsipinicon River.

## User Persona: Journalist Aram

Aram (him/his) has been with the Beaumont Enterprise newspaper for
twenty years. Part of his job is reporting on dam releases due to
rainfall or planned event. While dam releases are necessary to keep
water levels safe, they can cause sudden water increases in downstream
areas and affect the safety of swimming, boating, or fishing along the
river. Keeping his community informed and safe is an important part of
his job, and he takes pride in providing the most up-to-date
information. For his report, Aram regularly monitors several NWIS
monitoring location pages in his area. USGS provides the only source of
continuous monitoring, providing updates every 15 minutes. In addition
to looking at the most recent reports, Aram looks at gage height and
discharge over a period of a week or more to help him understand when
the next dam release most likely will occur. Bookmarking those sites to
his phone allows him to quickly look at these trends and stay informed
while he is out in the field reporting other stories. Aram says "Without
access to USGS stream gages, I would not be able to report up-to-date
news. My readers and Social Media followers want to know the minute that
I do when I get important news."

## User Persona: Water Manager Margaret

Margaret (they/their) has been the regional water manager in eastern
Washington for two years. They are responsible for overseeing allocation
of surface water for irrigation. Agriculture uses nearly 90% of the
water in their area, mainly coming from rivers, lakes, and ponds. There
is, however, always more demand for water than there is available water,
so it is important that Margaret be able to closely monitor water levels
and present the information to her stakeholders, including local
agencies and state officials. Margaret relies on the [National Water
Dashboard](https://dashboard.waterdata.usgs.gov/app/nwd/?aoi=default)
and monitoring location pages to monitor conditions in their area and
nearby areas. They often pull the hydrographs from the monitoring
location pages alongside the maps from National Water Dashboard to
support their decisions for surface water allocation. Margaret says
"Decisions in my job can be highly contested, so having highly trusted
and credible data from USGS is very important."

# How do Check Status users interact with USGS water information?

Check Status users routinely check for a few parameters for specific
sites. They come to us with an idea of what locations are useful to
them. Generally, users find USGS web sites by searching the web for
general water terms like "Boise river water level," where USGS sites
tend to be on the first page of results. They then use our tools to find
the closest site(s) for which they want water conditions.

Check Status users come to USGS to gather information to make decisions
according to their needs. Many of these users are concerned about
personal health and safety and seek more information about the current
state of their local water resource. When Check Status users review the
data, usually on a hydrograph, they apply their own thresholds to the
data to decide what action to take (check out
[WaterAlert](https://maps.waterdata.usgs.gov/mapper/wateralert/), a
simple subscription service we offer that notifies you when a threshold
has been reached for locations of your choice). In many cases, our
general check status users develop their thresholds through "guess and
check" patterns where they note the value of the parameter in USGS and
physically go out to the water resource to understand the associated
water conditions. For example, users concerned about flooding may watch
the gage height parameter value for the closest river site and associate
this value with the need to take action to protect themselves and
property. Our professional check status users similarly review
applicable data using hydrographs and tables to understand the status of
the hydrology.

> "We have come to rely heavily on the gage to let us know when it is
> about to flood our bridge, how soon we must evacuate, and when it
> returns to below flood stage. All my staff have signed up for
> WaterAlert. Thank you for the good work you and this gage do!"
>
> \- a user who emailed our help desk

Check Status users value "at-a-glance\" data where it is clear and easy
for them to understand the status of their water conditions. They are
repeatedly accessing USGS web sites, due to reoccurring operational
needs or specific water events. After finding sites that serve the water
data they are interested in, many users will bookmark the webpage in
their browser for easier access the next time they need to look.

Most Check Status users are not downloading or manipulating the data,
except the small subset of Check Status and Download users that have
stakeholders who also want to understand the water conditions.

# Key USGS Products

Explore & Download users gravitate toward tools they can use to explore
our data. Key USGS products used by these users include:

-   [National Water
    Dashboard](https://dashboard.waterdata.usgs.gov/app/nwd/?aoi=default)

-   Water Data for the Nation (example [Monitoring Location
    Page](https://waterdata.usgs.gov/monitoring-location/08078000/#parameterCode=00065&period=P7D))

-   [NWISweb](https://waterdata.usgs.gov/nwis)

-   [Water Watch](https://waterwatch.usgs.gov/)

-   [Ground Water Watch](https://groundwaterwatch.usgs.gov/default.asp)

-   [Water Quality Watch](https://waterwatch.usgs.gov/wqwatch/)

# Want to Connect?

We are continuing to learn more about Check Status users as we continue
our work improving the developer experience with accessing USGS water
data. If you want to share your own workflow and feedback on the process
or you'd be interested in participating in our user research process,
please email <WDFN@usgs.gov>.

*Quotes in this blog post have been lightly edited for grammar and
clarity only.*
