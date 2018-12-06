---
date: 2018-10-25
slug: introduction
type: post
title: Water Data Blog Introduction
categories:
  - Data Science
  - Software Development
  - Applications
description: About the USGS Water Data for the Nation blog.
keywords:
  - water information
---
Welcome
=======

Welcome to the U.S. Geological Survey Water Mission Area’s Water Data Blog. Water information is fundamental to national and local economic well-being, protection of life and property, and effective management of the Nation’s water resources. The USGS works with partners to monitor, assess, conduct targeted research, and deliver information on a wide range of water resources and conditions including streamflow, groundwater, water quality, and water use and availability. The the USGS Water Mission Area has a wide variety of services available to improve the access and understanding of U.S. water information. Water Data for the Nation blog posts highlight developments, data, and applications of these services. The posts made to the blog represent _non-interpretive_ or _interpretative_, _but_ _not_ _new_ information. In other words, nothing posted here will be interpreting data or findings in new ways. Interpretive information from USGS is published in a more rigorous outlet, for example, a peer-reviewed scientific journal article or a USGS report. Where appropriate, primary data and scientific sources will be cited.


So why was this part of waterdata.usgs.gov created?
-   Communicate to users about new data access and analytical features as they come out
-   Raise awareness of new software development and  data science at USGS
-   Engage with the public and other agencies in water resources science
-   Share ideas and get feedback
-   Get more in-depth than Twitter, but share faster than apps & websites

Prior to 2018, a similar project from the former USGS Office of Water Information existed at [owi.usgs.gov/blog](https://owi.usgs.gov/blog). Today, the Water Data for the Nation blog is curated by the USGS Water Mission Area Integrated Information Dissemination Division. Feedback on the blog can be directed [here](https://water.usgs.gov/contact/gsanswers?pemail=gs-w_water_data_for_the_nation&subject=Water%20Data%20for%20the%20Nation%20Updates%20Feedback&viewnote=%3CH1%3EUSGS+WDFN+TNG+Feedback%3C/H1%3E).

What we post about
==========

This page will have posts in 3 broad categories of posts: Applications, Data Science, and Software Development.

Applications
----------------

The USGS Water Mission Area runs around 30 different public-facing applications, from enterprise scale data assimilation, management, and dissemination systems including the [National Water Information System](http://waterdata.usgs.gov/) to project-scale data analysis tools that serve more specialized needs. Many of these systems have public data services that can be used by developers to get more direct access to data and information.

Posts in this category will provide updates, interesting applications, user-stories, or other information on the various applications produced and maintained by the USGS Water Mission Area.


Software Development
--------------------

Software development is integral to USGS information delivery on the Web. Posts within the “Software Development” category will showcase innovative work being done on a wide variety of software engineering topics and platforms.

Data Science
------------

Data science is an emerging field both inside and outside the USGS. Data scientists wade through vast stores of environmental and operational data to generate actionable information or predict future outcomes. These individuals have interdisciplinary backgrounds that include data analysis, statistics, data visualization, computer science, and mathematics. Posts in this category will show how these skills can be used to analyze, predict, and visualize data using reproducible data and modeling pipelines.

Other ways to hear from The USGS Water Mission Area
==========

There are several ways to keep up to date on the work that is done at at the Water Mission Area, and to provide feedback.

For news, updates, and resources for the Water Mission Area, please visit the [Water Mission Area homepage](https://www.usgs.gov/science/mission-areas/water-resources). Twitter feeds on [USGS Water Data](https://twitter.com/USGS_WaterData), packages and workflows in the [R programming language](https://twitter.com/USGS_R), and [general USGS news](https://twitter.com/USGS) are can be found below. Software repositories for [Water Data for the Nation](https://github.com/usgs/waterdataui), [USGS-R tools](https://github.com/USGS-R), and the [USGS organization](https://github.com/USGS) are also publicly available.


How blogs get published
=================

The blogs page itself is produced using [Hugo](https://gohugo.io/). The basic “robust” theme was used as a base, but then we layered on the [U.S. Federal Design System](https://designsystem.digital.gov), with modifications to meet USGS visual ID requirements. The development and collaboration on blog posts is done via Github at <https://github.com/USGS/wdfn-updates>.

Each post is created in a simple markdown format. Posts are deployed to a development Amazon S3 bucket using the continuous integration tool Jenkins. When a pull request is merged on Github, a Jenkins job pulls the github repository, builds the Hugo site, and pushes the generated static files from the “public” folder to the development S3 bucket. Once the post has been reviewed for style and content, the status draft: true is removed. A production deployment is also done via Jenkins.


Questions
==========
Please direct any questions or comments about the blogs [here.](https://water.usgs.gov/contact/gsanswers?pemail=gs-w_water_data_for_the_nation&subject=Water%20Data%20for%20the%20Nation%20Updates%20Feedback&viewnote=%3CH1%3EUSGS+WDFN+TNG+Feedback%3C/H1%3E) or open an issue on Github at [wdfn-updates](https://github.com/usgs/wdfn-updates)

Disclaimer
==========
Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
