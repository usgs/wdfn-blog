---
author: David Blodgett
date: 2022-04-12
slug: nldi-processes
draft: True
type: post
image: /static/nldi-processes/TODO.png
title: "The Network Linked Data Index Geoprocessing with OGC API Processes"
author_twitter: D_Blodgett
author_github: dblodgett-usgs
author_staff: david-l-blodgett
author_email: dblodgett@usgs.gov
categories:
  - Applications
description: Update on the Network Linked Data Index processing capabilities using OGC API Process
keywords:
  - Geoprocessing
  - nldi
tags:
  - Water Data for the Nation

---

The [Network Linked Data Index](https://labs.waterdata.usgs.gov/about-nldi/index.html) (NLDI) is a search engine that uses the river network as it's index. Like a search engine, it can cache and index new data. Beyond indexing and data discovery, it also offers some convenient data services like basin boundaries and accumulated catchment characteristics.

Previous waterdata blog post ([intro](https://waterdata.usgs.gov/blog/nldi-intro/), [new functionality](https://waterdata.usgs.gov/blog/nldi_update/) and [linked-data](https://waterdata.usgs.gov/blog/nldi-geoconnex/)) describe what the Network Linked Data Index (NLDI) is and what it can do in detail.

This post announces new capabilities that extend the base NLDI API with processing capabilities implemented as open-source python-based geoprocessing services that are exposed using the new OGC-API Processes specification. 

# NLDI API Background:

For those not familiar, a quick overview follows. The NLDI API [swagger docs](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui/index.html) offers a intuitive set of web resources via a `linked-data` endpoint.

A set of `featureSource`s can be discovered at the `linked-data` root.  
`.../api/nldi/linked-data/`

Each `featureSource` has a set of `featureID`s.  
`.../api/nldi/linked-data/{featureSource}/{featureID}`

Each `featureID` is indexed to a network of catchment polygons and some are also indexed to the flowpaths that connect the catchments.

Using these indexes, the NLDI offers a `navigation` api based on each `featureID` providing upstream/downstream search and access to network-data.  
`.../api/linked-data/{featureSource}/{featureID}/navigation`

Two other capabilities stem from each `featureID` -- one to retrieve a `basin` upstream of the feature and one to retrieve local, total accumulated, or divergence-routed accumulated landscape characteristics.  
`.../api/linked-data/{featureSource}/{featureID}/basin`  
`.../api/linked-data/{featureSource}/{featureID}/{local|tot|div}`

There is one "special" `featureSource`, `comid` which corresponds to identifiers for the catchment polygons and flowpath lines of the base index.  
`.../api/linked-data/comid/`

The `comid` `feautureSource` offers a `position` endpoint allowing discovery of network identifiers for a given lon/lat location.  
`.../api/linked-data/comid/position?coords=POINT({lon},{lat})`

# NLDI Processing Updates:
