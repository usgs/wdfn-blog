---
author: David Blodgett
date: 2020-12-28
slug: nldi-geoconnex
draft: True
type: post
image: /static/nldi-geoconnex/geoconnex.png
title: "The Network Linked Data Index and geoconnex.us"
author_twitter: D_Blodgett
author_github: dblodgett-usgs
author_staff: david-l-blodgett
author_email: dblodgett@usgs.gov
categories:
  - Applications
description: Update on the Network Linked Data Index and how it relates to geoconnex.us
keywords:
  - NHDPlus
  - nldi
tags:
  - Water Data for the Nation

---

The NLDI is a search engine that uses the river network as it's index. Like a search engine, it can cache and index new data. Beyond indexing and data discovery, it also offers some convenient data services like basin boundaries and accumulated catchment characteristics.

Previous waterdata blog posts ([here](https://waterdata.usgs.gov/blog/nldi-intro/) and [here](https://waterdata.usgs.gov/blog/nldi_update/)) describe what the Network Linked Data Index (NLDI) is and what it can do in detail.

This post announces new USGS gage locations available from the NLDI and describes how it fits between data systems like https://waterdata.usgs.gov and environmental data registries like https://geoxonnex.us.

The post closes with information about an in-development project to establish a community sourced set of reference stream gage locations. This project aims to establish reference gage locations for many organizations to reference their own monitoring locations to.

New NWIS Network Locations
--------------------------

The NLDI (currently) has two methods of indexing data:

1) it can use NHDPlus catchment polygons to determine a catchment index for a point and
2) it can take pre-determined network locations in the form of a "reachcode" and "measure" hydrographic address.

*Reachcode* and *measure* are attributes used by the National Hydrography Dataset in a way that is analogous to a street name and house number. These are commonly referred to as "hydrographic addresses".

A new USGS project, the National Hydrologic Geospatial Fabric, recently updated the addresses for all NWIS sites in the NLDI to include reachcode and measure locations. Before this update, only active USGS sites were included and they were indexed with the comparatively inaccurate catchment indexing method.

The new network locations, while not perfect, are derived through a multi-step process that improves an important deficiency with the old method. The NLDI and geoconnex.us system is also designed to allow continuous improvement as new information and methods become available (more about this below).

A major difficulty with addressing point locations to river lines is where the point should be on a large mainstem river but happens to be very close to a line that represents a small tributary river. Spatial proximity methods can fail to capture the relationship between the point and the large river.

For this new NLDI release, newly developed capabilities in the [nhdplusTools R package](https://code.usgs.gov/water/nhdplusTools) were used to find multiple nearby rivers for each site and avoid those with major differences in drainage area estimated at the gage and by the source hydrography dataset.

It should be noted that the methods applied here were automated and issues should still be expected to exist. The these network locations are for data discovery and visualization. Any analytical or decision making use should be reviewed before assuming accuracy.

geoconnex.us
----------------------------

https://geoconnex.us is a public domain registry system supported by the [Internet of Water](https://internetofwater.org/) team to facilitate use of linked open data about water on the Internet. A geoconnex.us identifier can be thought of like a [Digital Object Identifier (DOI)](https://www.doi.org/) in that it forwards (redirects) a web request to a different (less persistent) URL. For example,

https://geoconnex.us/usgs/monitoring-location/08279500

redirects to:

https://waterdata.usgs.gov/monitoring-location/08279500/

This provides a stable identifier that can be used in places where persistence is important, such as structured metadata and knowledge management. Because the redirect can change, it allows people implementing web services and systems to change domain and/or URL path structure while allowing persistent and robust indexing of the information in question. For more on the design of this arrangement, see the [first](https://docs.opengeospatial.org/per/18-097.html) and [second](https://docs.ogc.org/per/20-067.html) Environmental Linked Features Interoperability Experiment outcomes.

Q: How does the NLDI and hydrographic addressing relate to geoconnes.ux?

A: On the internet, a hydrographic address can be expressed as a link between a hydrographic feature and a located feature (such as a stream gage). Identifiers for both hydrographic and located features can be registered with geoconnex.us and indexed and discovered with the NLDI.

Scope note
-------------------------------

**geoconnex.us is only a registry for identifiers.** It does not attempt to catalog or publish geospatial features or other data.  

**The NLDI is only an index and set of data services.** It does not persist data other than the hydrographic network that makes up its index and allows it to provide data services.  

These scope limitations are important to understand for two reasons:

1) persistent and authoritative data systems such as waterdata.usgs.gov are required for the web architecture of geoconnex.us and the NLDI and
2) the limited scope of the two systems means they can be used as building blocks that provide flexibility for systems that integrate with them.

Reference gages
---------------------------------

A river can only be monitored in so many places. This is true at a basic level because a river is finite. From a practical perspective, there are a limited number of accessible locations along a river. As a result, different organizations collect monitoring data at the same location for their own purposes.

However, each organization may have different identifiers and different spatial information about what is actually the same real-world location. Given that identifiers and spatial descriptions are different, it can be surprisingly difficult to determine if two monitoring locations are the same. The community reference gage locations discussed here are intended to provide a common identifier and reference location to fill this gap.

The project is just getting started so only includes USGS gages so far, but expect the dataset to grow and mature going forward. Code to create the dataset is hosted at [this preliminary repository](https://github.com/dblodgett-usgs/ref_gages). An index of reference gages by state [can be seen here.](https://dblodgett-usgs.github.io/ref_gages/) The reference gages can also be found through the https://info.geoconnex.us service [here](https://info.geoconnex.us/collections/gages).

For example, say we wanted to find reference gages in a particular place. We could use the https://info.geoconnex.us service with a bbox query like:

https://info.geoconnex.us/collections/gages/items?bbox=-86.2,39.7,-86.1,39.8

There, we might find that there is a reference gage to link to with the URI:

https://geoconnex.us/ref/gages/1055733

Going to that URL, we can find that the *provider* of the reference gage is USGS and the provider's ID for the gage is "03353000". There is also a "subjectOf" link (saying that one of the "subjects of" the reference gage is the USGS gage) available to the USGS monitoring location page.

https://waterdata.usgs.gov/monitoring-location/03353000

In turn, the USGS monitoring location page could have an "about" link back to the reference gage. So we would have:

https://geoconnex.us/ref/gages/1055733  
  subjectOf  
  https://waterdata.usgs.gov/monitoring-location/03353000  

and:  

https://waterdata.usgs.gov/monitoring-location/03353000  
  about  
  https://geoconnex.us/ref/gages/1055733  

In the future, other organizations could then establish relationships between their monitoring locations and existing reference locations or, if the reference locations haven't been created, register new reference locations for their own and others' use.
