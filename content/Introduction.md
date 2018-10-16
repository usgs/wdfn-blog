---
date: 2018-10-25
slug: introduction
type: post
title: Introducing Water Data for the Nation Updates!
categories:
  - Data Science
  - Software Development
  - Applications
description: An introduction to the new USGS Water Data for the Nation updates site.
keywords:
  - water information
---
Welcome
=======

Welcome to the U.S. Geological Survey's Water Mission Area's new updates page. We are committed to advancing USGS science by integrating data across scales and domains, improving access to data and research, developing tools for analysis and visualization, and fostering collaboration with the international water informatics community. There are also big changes afoot, as we work to reimagine and reengineer the USGS water data web presence.  This space will serve to both update the community about new things that we are releasing (and the possiblities of older things going away)

The updates here represent "non-interpretive" or "interpretive, but not new" information. This is fancy lingo to indicate that nothing posted here will be interpreting data or findings in new ways. That sort of information needs to be published in a more rigorous outlet (for example, a peer-reviewed scientific journal article).

The the USGS Water Mission Area has a wide variety of services available to improve the access and understanding of US water information. Update posts will highlight developments, data and applications of these services.

So why did we create this part of waterdata.usgs.gov?

-   Communicate to users about new features as they come out
-   Raise awareness of new software development & analytics at USGS
-   Engage with the public and other agencies
-   Share ideas and get feedback
-   Get more in-depth than Twitter, but share faster than apps & websites

Just to get it out of the way, yes, the "pre-populated" nature of this site belies its origins in a previous, similar project that came out of the now defunct USGS Office of Water Information at owi.usgs.gov.  We kept the relevent posts, and updated others.

Categories
==========

There are currently 3 categories: Data Science, Applications, and Software Development.

Applications
----------------

The USGS Water Mission Area runs around 40 different public-facing applications, from enterprise scale data assimilation, management, and dissemination systems including the [National Water Information System](http://waterdata.usgs.gov/) to project-scale data analysis tools that serve more specialized needs.

Posts in this category will provide updates, interesting applications, user-stories, or other information on the various applications produced and maintained by the USGS Water Mission Area.

Software Development
--------------------

Posts within the "Software Development" category will showcase innovative work being done on a wide variety of software engineering topics and platforms.

Data Science
------------

Data science is an emerging field both inside and outside the USGS. Data scientists build tools and software that enable reproducible data & modeling pipelines.  WMA data scientists collaborate with other scientists to design, implement, and communicate reproducible workflows for earth science (primarily water science). Posts in this category will show workflows for processing and analyzing data.

The development of these tools is closely coordinated with USGS enterprise information systems providing convenient access to USGS monitoring data within various data analysis environments.

Communication
==========

There are several ways to keep up to date on the work that is done at OWI, and to provide feedback.

|Twitter|Github|
|-----------|------------|
|<a href="https://twitter.com/USGS_WaterData" class="twitter-follow-button" data-show-count="false">Follow @USGS_WaterData</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>|[https://github.com/USGS](https://github.com/USGS)|
|<a href="https://twitter.com/USGS_R" class="twitter-follow-button" data-show-count="false">Follow @USGS_R</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>|[https://github.com/USGS-R](https://github.com/USGS-R)|
|<a href="https://twitter.com/USGS_GDP" class="twitter-follow-button" data-show-count="false">Follow @USGS_GDP</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>|[https://github.com/USGS](https://github.com/USGS)|

Links
-------
|Description|Link|
|-----------|------------|
|Main USGS page|[https://www.usgs.gov/](https://www.usgs.gov/)|
|USGS Wter Resources Mission Area|[https://www.usgs.gov/science/water-resources](https://www.usgs.gov/science/water-resources)|
|USGS Water Services|[https://waterservices.usgs.gov/](https://waterservices.usgs.gov/)|
|USGS Water Data for the Nation|[https://waterdata.usgs.gov/](https://waterdata.usgs.gov/)|
|USGS Water Watch|[https://waterwatch.usgs.gov](https://waterwatch.usgs.gov)
|Water Quality Portal|[https://www.waterqualitydata.us/](https://www.waterqualitydata.us/)|
|USGS Publications Warehouse|[https://pubs.er.usgs.gov/](https://pubs.er.usgs.gov/)|
|National Water Census - Data Portal|[https://cida.usgs.gov/nwc/](https://cida.usgs.gov/nwc/)|
|USGS Geo Data Portal|[https://cida.usgs.gov/gdp/](https://cida.usgs.gov/gdp/)|
|National Ground-Water Monitoring Network Portal|[https://cida.usgs.gov/ngwmn/](https://cida.usgs.gov/ngwmn/)|
|USGS Coastal Change Hazards Portal|[https://marine.usgs.gov/coastalchangehazardsportal/](https://marine.usgs.gov/coastalchangehazardsportal/)|
|Environmental Data Discovery and Transformation|[https://cida.usgs.gov/enddat/](https://cida.usgs.gov/enddat/)|

Technical Details
=================

A few details concerning the updates page itself. It is produced using [Hugo](https://gohugo.io/). The basic "robust" theme was used as a base, but then we layered on the [U.S. Federal Design System](https://designsystem.digital.gov), with modifications to meet USGS visual ID requirements. The development and collaboration on blog posts is done via Github at <https://github.com/USGS/wdfn-updates>.

Each post is created in a simple markdown format. Posts are deployed to a development Amazon S3 bucket using the continuous integration tool Jenkins. When a pull request is merged on github, a Jenkin's job pulls the github repository, builds the Hugo site, and pushes the generated static files from the "public" folder to the development S3 bucket. Once the post has been reviewed for style and content, the status `draft: true` is removed. A production deployment is also done via Jenkins.

Questions
==========
Please direct any questions or comments about the updates [here.](https://water.usgs.gov/contact/gsanswers?pemail=gs-w_water_data_for_the_nation&subject=Water%20Data%20for%20the%20Nation%20Updates%20Feedback&viewnote=%3CH1%3EUSGS+WDFN+TNG+Feedback%3C/H1%3E) or open an issue on Github at [wdfn-updates](https://github.com/usgs/wdfn-updates)

Disclaimer
==========
"Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government."
