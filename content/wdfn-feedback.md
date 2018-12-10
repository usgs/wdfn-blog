---
author: Jim Kreft and Bradley Garner
date: 2018-12-03
slug: wdfn-feedback
type: post
title: Approach to Feedback
author_github: jkreft-usgs
author_staff: james-m-kreft
author_email: <jkreft@usgs.gov>
categories:
  - Applications
description: How user feedback is incorporated into development priorities for USGS Water Data for the Nation. 
keywords:
  - water information
tags:
  - Water Data for the Nation
  
---
Approach to Feedback for Water Data for the Nation
=======

Next-generation Water Data for the Nation is characterized by always being production-ready—new software is ready to be released at any time. When issues with the system are identified, there is a process for evaluating and prioritizing changes.

Next-generation development priorities of Water Data for the Nation are designed to support goals of the [USGS Water Science Strategy](https://pubs.usgs.gov/circ/1383g/). Specific projects to improve data delivery, such as for the development of new real-time water data pages, are proposed, planned, and approved by USGS Water Mission Area governance. In addition, user feedback informs development priorities, and is built into the software development process. 

Feedback on new real-time water data pages is being consolidated on this publicly viewable GitHub project board. Feedback is evaluated and triaged using these categories:

1. **Bugs.**  Bugs are defects in existing functionality. Ideally, bugs would never be introduced to public facing systems, but practically speaking, this is a national data system with heterogeneous, multi-domain data that crosses many scales and therefore will have defects. Bugs are subdivided into high and lower priority:

	* *High priority bug.*  Requires immediate attention by software developed, disrupting planned work. A bug like this (a) directly affects how data or science is presented to the public that could lead to incorrect interpretations, or (b) makes it impossible for many users to access important functionality, with no workaround.

	* *Lower priority bug.*  Does not require immediate attention and is prioritized with other planned work. Examples: Data edge case; only affects certain sites or certain users/browsers; browser element resizing unexpectedly when the page is interacted with.

2. **User-Interface Suggestions.**  Arising mostly from user testing and analytics, the USGS weighs these suggestions against the unifying vision for Water Data for the Nation. Not all suggestions may be taken, especially if user testing and analytics suggest the feature works as expected and is understood by most users.

3. **New Feature Requests.**  All-new functionality.  USGS is always listening for great new ideas that may not be in the Water Data for the Nation roadmap. Requests are evaluated and triaged along these lines of thought (not an exclusive list):

	* What is the audience broadness and long-term applicability?
	* Can another venue such as a visualization, report product, blog post, R package, etc, suffice?
	* Where does it fit in long-term strategic USGS objectives?


Disclaimer
==========
Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
