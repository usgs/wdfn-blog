---
date: 2016-09-01
slug: introduction
draft: True
type: post
title: Introducing OWI Blogs!
categories: 
  - Data Science
  - Software Development
  - OWI Applications
 
 
---
Welcome
=======

Welcome to the U.S. Geological Survey's Office of Water Information's new blog. We are committed to advancing USGS science by integrating data across scales and domains, improving access to data and research, and developing tools for analysis and visualization, and fostering collaboration with the international community.

The blog posts here represent "non-interpretive" or "interpretive, but not new" information. This is fancy lingo to indicate that nothing that is posted here will be interpreting data or findings in new ways. That sort of information needs to be published in a more rigorous outlet (for example, a peer-reviewed scientific journal article).

The Office of Water Information has a wide variety of services available to improve the access and understanding of US water information. Blog posts will highlight data, developments, and applications of these services. 

So why do we blog?

-   Show the public where their tax dollars go
-   Raise awareness of the cool software development & analytics at the USGS
-   Engage with public and other agencies
-   Share ideas and get feedback
-   Get more in-depth than Twitter, but share faster than apps & websites

Categories
==========

There are currently 3 categories: Data Science, OWI Applications, and Software Development.

OWI Applications
----------------

OWI runs about 40 different applications, from the enterprise scale data accession, management, and distribution applications that comprise the National Water Information System that are used by millions of people across the country to boutique data analysis tools that serve a few scientists.

Blogs in this category will provide updates, interesting applications, user-stories, or any number of information on the various applications produced and maintained by the Office of Water Information in the USGS.

Software Development
--------------------

There are many talented software developers working at the USGS. Blogs within the "Software Development" category will showcase innovative work being done on a wide variety of software engineering topics and platforms.

Data Science
------------

Data science is an emerging field both within and outside the USGS. Posts in this category will tend to show workflows for cleaning and analyzing data. 

Data scientists build tools and software that enable reproducible data & modeling pipelines. The development of these tools is aligned with the architectural recommendations of the software development lifecycle best practices. OWI data scientists collaborate with other scientists to design, implement, and communicate reproducible workflows for earth science (primarily water science).

Communication
==========

There are several ways to keep abreast of the work that is done at OWI, and to provide feedback.

|Twitter|Github|
|-----------|------------|
|<a href="https://twitter.com/USGS_WaterData" class="twitter-follow-button" data-show-count="false">Follow @USGS_WaterData</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>|[https://github.com/USGS-OWI](https://github.com/USGS-OWI)|
|<a href="https://twitter.com/USGS_R" class="twitter-follow-button" data-show-count="false">Follow @USGS_R</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>|[https://github.com/USGS-R](https://github.com/USGS-R)|
|<a href="https://twitter.com/USGS_GDP" class="twitter-follow-button" data-show-count="false">Follow @USGS_GDP</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>|[https://github.com/USGS](https://github.com/USGS)|
|<a href="https://twitter.com/USGS_Pubs" class="twitter-follow-button" data-show-count="false">Follow @USGS_Pubs</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>||

Links
-------
|Description|Link|
|-----------|------------|
|Main USGS page|[https://www.usgs.gov/](https://www.usgs.gov/)|
|Office of Water Information|[https://owi.usgs.gov/](https://owi.usgs.gov/)|
|USGS Water Services|[http://waterservices.usgs.gov/](http://waterservices.usgs.gov/)|
|USGS Water Data for the Nation|[http://nwis.waterdata.usgs.gov/](http://nwis.waterdata.usgs.gov/)|
|Water Quality Portal|[http://www.waterqualitydata.us/](http://www.waterqualitydata.us/)|
|USGS Publications Warehouse|[https://pubs.er.usgs.gov/](https://pubs.er.usgs.gov/)|
|National Water Census - Data Portal|[http://cida.usgs.gov/nwc/](http://cida.usgs.gov/nwc/)|
|USGS Geo Data Portal|[http://cida.usgs.gov/gdp/](http://cida.usgs.gov/gdp/)|
|National Ground-Water Monitoring Network|[http://cida.usgs.gov/ngwmn/](http://cida.usgs.gov/ngwmn/)|
|USGS Coastal Change Hazards Portal|[http://marine.usgs.gov/coastalchangehazardsportal/](http://marine.usgs.gov/coastalchangehazardsportal/)|
|Environmental Data Discovery and Transformation|[http://cida.usgs.gov/enddat/](http://cida.usgs.gov/enddat/)|
|Pilot National Soil Moisture Network|[http://cida.usgs.gov/nsmn_pilot/](http://cida.usgs.gov/nsmn_pilot/)|

Technical Details
=================

A few details concerning the blog itself. It is produced using [Hugo](https://gohugo.io/). The basic "robust" theme was used as a base, but fairly straightforward modifications were done to comply with OWI website styles. The development and collaboration on blog posts is done via Github at <https://github.com/USGS-OWI/owi-blog>.

Each blog post is created in a simple markdown format. Posts are deployed to a development Amazon S3 bucket using the continuous integration tool Jenkins. When a pull request is merged on github, a Jenkin's job pulls the github repository, builds the Hugo site, and pushes the generated static files from the "public" folder to the development S3 bucket. Once the post has been reviewed for style and content, the status `draft: true` is removed. A production deployment is also done via Jenkins.

Questions
==========
Please direct any questions or comments about the blog to:
[https://github.com/USGS-OWI/owi-blog/issues](https://github.com/USGS-OWI/owi-blog/issues)

Disclaimer
==========
"Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government."

