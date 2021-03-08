---
author: Emily K Read
date: 2021-03-08
slug: how-we-work-spring-2021
draft: True
type: post
title: "How we work on the Water Data for the Nation Team"
author_github: eread-usgs
author_staff: emily-k-read
author_email: <eread@usgs.gov>
author_twitter: emilykararead
categories:
  - data-science
  - web-communication
description: A description of how the Water Data for the Nation software development team works.
keywords:
  - data science
  - web communication
  - hiring
tags:
  - data-science
  - web-communication

---

The USGS Water Mission Area (WMA) is the largest provider of real time
and historical water information in the world. A major part of our work
in the WMA Web Communications Branch is to build modern web applications
and APIs to make these data publicly available. We call our data
delivery product line *Water Data for the Nation* (WDFN). Here's our
product vision:

> **Water Data for the Nation makes high-quality water information discoverable, accessible, and usable for everyone.**

We use a principled approach to accomplishing our goals. Here's more
about how we work:

-   Public service orientation. Our team is dedicated to transforming
    Federal water data delivery and using [technical
    innovations](https://labs.waterdata.usgs.gov/index.html) to do so. 

-   Working in the open. We make our [data and code
    available](https://github.com/usgs), so that others can see it, use
    it, or contribute back. We're committed to [FAIR data
    principles](https://www.go-fair.org/fair-principles/).

-   We use disciplines of product management, user centered design, and
    software engineering to accomplish our work:

    -   Product management. Cyd Harrell's definition of product
        management, as stated in [The Civic Technologist's Practice
        Guide](https://cydharrell.com/book/), is useful: Product management is "*the strategic
        discipline of uniting a team around a product vision and making
        trade-offs across technical, design, and business domains to
        determine how to invest and when to ship."* Enough said.

    -   User-centered design. Our design decisions can impact millions
        of users, so we need evidence to drive feature development. We
        partner with GSA TTS 18F to train up and tackle [major design
        challenges](https://18f.gsa.gov/2020/08/06/doing-user-research-to-design-the-next-gen-wdfn/),
        and use human-centered [design
        methods](https://methods.18f.gov/) frequently in our work.

    -   Software engineering. Our team is not locked into particular
        frameworks, but we do insist on
        - doing our work in the open using [Github](https://github.com/usgs/waterdataui) and [self-hosted tools](https://code.usgs.gov/water)
        - code quality using tools like [Codacy](https://www.codacy.com/) and [SonarQube](https://www.sonarqube.org/)
        - Peer review of all code and all configuration
        - Continous integration using tools like [Jenkins](https://www.jenkins.io/) and [Gitlab CI](https://docs.gitlab.com/ee/ci/)
        - Regular deploys with a long-term goal of continous deployment.
        - working toward a culture of devsecops
        
        so that our products will be more maintainable and easier to
        evolve. While we do a lot of custom software development, we stand on the shoulders of giants, and build on best of breed open source tools such as: 
        - The [US Web Design System](https://designsystem.digital.gov/) 
        - [D3.js](https://d3js.org/) for visualizations and charting
        - [Leaflet](https://leafletjs.com/) and [GeoServer](http://geoserver.org/) for web mapping
        - The [Flask](https://flask.palletsprojects.com/en/1.1.x/) web server microframework
        - The [Spring](https://spring.io/) Framework for Java based APIs
        - The [Serverless Framework](https://www.serverless.com/) for cloud-native, serverless deployment
        
        when available.

    -   Agile methodology and its cadences and ceremonies bring together
        product, design, and engineering activities to delivery value to
        users frequently. Our current flavor of agile uses a scrum team,
        daily standups, and biweekly technical deep-dives, demos, and
        planning ceremonies. Learn more about where we came from
        [here](https://waterdata.usgs.gov/blog/beingvsdoingagile/).
        We're currently transitioning from a single scrum to a
        large-scale scrum model as part of an emphasis on continuous
        process improvement. We'll will report back later how it's
        working.

To learn more about our products, tech, and design, check out these
resources:

[Doing user research to design the next-gen
WDFN.](https://18f.gsa.gov/2020/08/06/doing-user-research-to-design-the-next-gen-wdfn/)

[Modern groundwater dataflow delivered through mobile-first
next-generation monitoring location
pages](https://waterdata.usgs.gov/blog/groundwater-field-visits-monitoring-location-pages/).

[A recent set of release notes, demonstrating delivery of valuable
features to
users.](https://waterdata.usgs.gov/blog/improvingmonitoringpages/)

Our legacy data access application: <https://waterdata.usgs.gov/nwis>.

Our legacy data access services: <https://waterservices.usgs.gov>

Modern monitoring location pages:
<https://waterdata.usgs.gov/monitoring-location/05428500/#parameterCode=00065>