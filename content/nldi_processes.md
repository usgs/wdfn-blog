---
author: David Blodgett
date: 2022-04-12
slug: nldi-processes
draft: True
type: post
image: /static/nldi_processes/basin_zoom.png
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

For those not familiar, a quick overview follows. The NLDI API offers an intuitive set of web resources via a `linked-data` endpoint. It is hosted on `https://labs.waterdata.usgs.gov`. `...` below is used as shorthand for this base URL. For full API details, see the [Swagger API documentation here.](https://labs.waterdata.usgs.gov/api/nldi/swagger-ui/index.html)

A set of `featureSource`s can be discovered at the `linked-data` root.  
`.../api/nldi/linked-data/`

Each `featureSource` has a set of `featureID`s.  
`.../api/nldi/linked-data/{featureSource}/{featureID}`

Each `featureID` is indexed to a network of catchment polygons and some are also indexed to the flowpaths that connect the catchments.

Using these indexes, the NLDI offers a `navigation` api based on each `featureID` providing upstream/downstream search and access to network-data.  
`.../api/nldi/linked-data/{featureSource}/{featureID}/navigation`  
`.../api/nldi/linked-data/{featureSource}/{featureID}/navigation/{mode}/{dataSource}`

Two other capabilities stem from each `featureID` -- one to retrieve a `basin` upstream of the feature and one to retrieve local, total accumulated, or divergence-routed accumulated landscape characteristics.  
`.../api/nldi/linked-data/{featureSource}/{featureID}/basin`  
`.../api/nldi/linked-data/{featureSource}/{featureID}/{local|tot|div}`

`comid` is a "special" `featureSource` which corresponds to identifiers for the catchment polygons and flowpath lines of the base index.  
`.../api/nldi/linked-data/comid/`

The `comid` `feautureSource` offers a `position` endpoint allowing discovery of network identifiers for a given lon/lat location. This is a simple "point in polygon" query that returns the flowline for the catchment area the provided coordinates are in.  
`.../api/nldi/linked-data/comid/position?coords=POINT({lon} {lat})`

There is also a `hydrolocation` endpoint that returns a linear reference to a flowline. If the provided point is within 200 meters, it is "snapped" to the flowline, otherwise the linear reference is derived using a "raindrop trace" that follows an elevation surface downstream to the nearest flowline.  
`.../api/nldi/linked-data/hydrolocation?coords=POINT({lon lat})`

<figure>
<img src='/static/nldi_processes/nldi-api.png' title='Network Linked Data Index API Diagram' alt='Diagram showing the overall Network Linked Data Index API' >
<figcaption>NLDI API Summary Diagram</figcaption>
</figure>

# NLDI Processing Updates:

<figure>
<img src='/static/nldi_processes/map_base.png' title='Drainage basin upstream of a streamgage' alt='Simple map depicting a drainage basin upstream of a streamgage.' >
<figcaption>This figure shows a stream gage (black dot) at the outlet of a drainage basin. In this case, the streamgage is at a naturally occurring basin outlet in the hydrographic data used by the NLDI. But this is not always the case. Sometimes, as shown below, we need to derive a drainage basin for a point midway up a flowline river segment.</figcaption>
</figure>

The NLDI `hydrolocation` and `basin` endpoints both rely on some custom elevation-based processing. The two processes are referred to as "raindrop trace" and "split catchment" algorithms. Two other algorithms, both to retrieve cross sections are included in the current (Spring 2022) NLDI processes services. These algorithms retrieve cross sections either at a point along a flowline from the NLDI or between two provided points (presumable spanning a river to form a cross section). 

These processes are available as stand alone python packages: [nldi-xstool](https://code.usgs.gov/wma/nhgf/toolsteam/nldi-xstool) and [nldi-flowtools](https://code.usgs.gov/wma/nhgf/toolsteam/nldi-flowtools) as well as hosted processing services via the [NLDI "pygeoapi" server.](https://labs.waterdata.usgs.gov/api/nldi/pygeoapi) [pygeoapi](https://pygeoapi.io/) is a python [OGC API](https://ogcapi.ogc.org/) server that the USGS waterdata teams use for a number of applications.

The two processes that are tightly integrated into the NLDI are called in the code behind the `hydrolocation` and `basin` endpoints. In both of these endpoints, the raindrop trace algorithm is used to ensure that a flowline within the local watershed of a selected point is found and the point used for basin retrieval is along a flowline.

<figure>
<img src='/static/nldi_processes/basin_zoom.png' title='Raindrop trace and split catchment.' alt='Simple map depicting a raindrop trace intersection with a flowline and the resulting split catchment and basin boundary.' >
<figcaption>This figure shows a raindrop trace (dark blue) that intersects an existing flowline (lighter blue), the local NHDPlusV2 catchment area (green), and a custom drainage basin for the intersection point (faint green with blue border).</figcaption>
</figure>

The second process called in the code behind the `basin` endpoint is the split catchment algorithm. This algorithm requires that a precise location along a flowline be provided (as can be derived from the raindrop trace algorithm). Given this point, the process retrieves needed data to delineate a "split catchment", returning one polygon upstream of the provided point and one downstream. These two polygons "split" the catchment polygon that defines the area that drains to the flowline in question. This split catchment can be used in conjunction with an upstream basin to provide a "precise" basin that is delineated to any provided location.

<figure>
<img src='/static/nldi_processes/basin.png' title='Precise basin to a specific point.' alt='Simple map depicting a custom delineated drainage basin.' >
<figcaption>This figure is a zoomed out version of the one just above. It shows how we now have a custom delineated basin to this specific location.</figcaption>
</figure>
