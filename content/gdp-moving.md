---
author: David Blodgett
date: 2022-06-06
slug: gdp-moving
draft: False
type: post
image: /static/gdp-moving/usgs-geo-data-portal.png
title: "USGS Geo Data Portal migration to labs.waterdata.usgs.gov"
author_twitter: D_Blodgett
author_github: dblodgett-usgs
author_staff: david-l-blodgett
author_email: dblodgett@usgs.gov
categories:
  - News
description: The GDP web interface, utility service, and processing service are migrating to labs.waterdata.usgs.gov as part of a broader modernization effort.
keywords:
  - Geoprocessing
  - Geo Data Portal
tags:
  - cloud-transition

---

The USGS Geo Data Portal (GDP) provides access to numerous datasets, including gridded data for climate and land use. Datasets can be subsetted or summarized before download using several algorithms, and these algorithms can also be applied to other datasets hosted elsewhere. 

The system has been hosted via `cida.usgs.gov` since its original release in 2011. See this report for more: Blodgett, David L., Nathaniel L. Booth, Thomas C. Kunicki, Jordan I. Walker, and Roland J. Viger. Description and testing of the Geo Data Portal: Data integration framework and Web processing services for environmental science collaboration. [No. 2011-1157. US Geological Survey, 2011.](https://pubs.usgs.gov/of/2011/1157/)

As part of a broader modernization of the system, all components of the GDP are migrating to a new hosting environment and new URLs. 

On or about July 1st, 2022:

`https://cida.usgs.gov/gdp/` will move to `https://labs.waterdata.usgs.gov/gdp_web`

`https://cida.usgs.gov/gdp/process/` will move to `https://labs.waterdata.usgs.gov/gdp-process-wps/`

`https://cida.usgs.gov/gdp/utility/` will move to `https://labs.waterdata.usgs.gov/gdp-utility-wps/`

No redirects will be put in place. By July 10th 2022, the three `cida.usgs.gov` end points will return a document pointing to this blog post.

We apologize for any inconvenience that this migration may cause. However, it will expand the potential for modernization of the GDP system and, long run, lead to much better data access.

In the coming months, new APIs and processing capabilities will become available via labs.waterdata.usgs.gov and possibly other URLs to replace the Geo Data Portal. The exact plans for this modernization are not established, but stay tuned for more user friendly APIs, more cloud-ready data access options, and a generally refined ecosystem of data, services and tools. 

# THREDDS Data Server

The GDP THREDDS Data Server (https://cida.usgs.gov/thredds/) will continue operating in its current state until further notice. However, a new instance of THREDDS containing all of the same data sets will be coming online as part of the GDP migration. The URL for the new server will be: https://labs.waterdata.usgs.gov/thredds The legacy (cida.usgs.gov) THREDDS should be considered deprecated and all future applications should use https://labs.waterdata.usgs.gov and be ready for a further transition as the waterdata.usgs.gov transition to cloud infrastructure continues. 
