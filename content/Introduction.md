---
author: Laura DeCicco
date: 2016-09-01
slug: introduction
draft: True
title: Introducing OWI Blogs!
categories: 
  - Data Science
  - OWI Applications
  - Software Development
 
 
---
Welcome to the U.S. Geological Survey's Office of Water Information's new blog. We are committed to advancing USGS science by integrating data across scales and domains, improving access to data and research, and developing tools for analysis and visualization, fostering collaboration with the international community.

The blog posts here represent "non-interpretive" or "interpretive, but not new" information. This is fancy lingo to indicate that nothing that is posted here will be interpreting data or findings in new ways. That sort of information needs to be published in a more rigorous outlet (for example, a peer-reviewed scientific journal article).

Why do we blog? \* Show the public where their tax dollars go \* Raise awareness of the cool software development & analytics at the USGS \* Engage with public and other agencies \* Share ideas and get feedback \* More in-depth than Twitter, faster than apps & websites

A few details concerning the blog itself. It is produced using [Hugo](https://gohugo.io/). The basic "robust" theme was used as a base, but fairly straightforward modifications were done to comply with OWI website styles.

The development and collaboration on blog posts is done via Github at <https://github.com/USGS-OWI/owi-blog>.

Posts are deployed to a development Amazon S3 bucket using the continuous integration tool Jenkins. When a pull request is merged on github, a Jenkin's job pulls the github repository, build the Hugo site, and pushes the generated "public" folder to the development S3 bucket. Once the post has been reviewed for style and content, the status `draft: true` is removed. A production deployment is also done via Jenkins.

There are currently 3 categories: Data Science, OWI Applications, and Software Development.
