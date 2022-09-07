---
author: Jordan S Read (he/him)
date: 2022-09-03
slug: water-data-science-2022
draft: False
type: post
image: /static/water-data-science-2022/DaSB_thumbnail.png
title: "USGS water data science in 2022"
author_staff: Jordan-S-Read
author_email: <jread@usgs.gov>
author_twitter: jordansread
author_github: jordansread
author_gs: geFLqWAAAAAJ
categories:
  - data-science
description: USGS water data science in 2022
keywords:
  - data science
  - machine learning
  - deep learning
  - knowledge-guided machine learning
  - data assimilation
  - data visualization
  - reproducibility
  - web analytics
tags:
  - data-science 

---

The USGS water data science branch in 2022
{{< figure src="/static/water-data-science-2022/ds-subteams-2022.png" alt="update this ***** A banner for the USGS Vizlab water data visualization team featuring an abstract streamgraph that mimics flowing water.">}}
--------------------
The USGS data science branch advances environmental sciences and water information delivery with data-intensive modeling, data workflows, visualizations, and analytics. A short summary of our history can be found in a [prior blog post](../water-data-science-2021#data-sci-background). Sometimes I refer to data scientists as _**experts in wrangling complex data and making it more valuable or usable**_.

Within the data science branch, we are advocates for open science and we build useful data science solutions that often increase scientific integrity, cost less over the long-run, and are accessible for others to build upon or reuse. We're also working to expand access, representation, and participation in federal science with [innovative hiring initiatives](../hiring-spring-2021#DIT) (including for [data visualization specialists](../viz-hires-2021/)). 

Our data science branch has grown and our capabilities have matured over the years. Now it is time for new changes that will contribute to more effective and sustainable work practices by: 1) launching new positions that will create more pathways for leadership and promotion, 2) adding new team structures that will be aligned with our data science sub-disciplines (visualizations, ML, web analytics, and reproducible data assembly), and 3) distributing supervisory responsibilities and vision to team leads.  

Below is my current description of what each sub-team does, the current status, and a couple of thoughts (likely to be proven wrong!) on where I think there might be some new opportunities for growth. 

What are these capabilities/teams?
--------------------

### Visualizations
{{< figure src="/static/what-is-vizlab/viz-logo.png" alt="A banner for the USGS Vizlab water data visualization team featuring an abstract streamgraph that mimics flowing water.">}}

Our data visualization sub-team ("Vizlab") has been around since 2014, but is constantly evolving and [added staff this year](../viz-hires-2021/). Described by [Cee recently](../what-is-vizlab/) as "_**a collaborative team that uses data visualization to communicate water science and data to non-technical audiences. Our mission is to create timely visualizations that distill complex scientific concepts and datasets into compelling charts, maps, and graphics. We operate at the intersection of data science and science communication.**_" See also <a href="https://labs.waterdata.usgs.gov/visualizations/vizlab-home/index.html#/?utm_source=blog&utm_medium=wdfn&utm_campaign=what_is_vizlab#/" target="_blank" >Vizlab's portfolio site</a>.

Vizlab **right now** includes three full time federal employees and a mix of part time contributors. The group excels at producing new visualization content that ranges from social media (e.g., [#30DayChartChallenge](../chart-challenge-2022/)), complex interactives (e.g.,  [stream temperature in the Delaware River Basin](https://labs.waterdata.usgs.gov/visualizations/temperature-prediction/index.html#)), and storytelling like in [“From Snow to Flow”](https://labs.waterdata.usgs.gov/visualizations/snow-to-flow/index.html#). In addition to being excellent data communicators, Vizlab builds data workflows that make it faster to template or reuse content in the future, such as for recurring event types or seasonal syntheses of water patterns. 


Vizlab **in the future _may_** provide new leadership in the publication of data visualization code and underlying data. The team already has a strong emphasis on data visualization accessibility and codes in the open (see [Vizlab GitHub](https://github.com/USGS-VIZLAB)) but I wouldn't be suprised to see more Vizlab authored blog posts that show "how we did it" that help others with a bit of a tutorial on how some of the thorny data, graphics, interactions, or hosting challenges were solved. We'll have some challenges ahead with code publication as new policies in motion will encourage more open source releases of code while also creating some new processes that we'll need to navigate through. I'm confident the group will continue to innovate with all kinds of approaches to generate interesting products while pushing to make the work more "open" (e.g., [stream forecast example on observable](https://observablehq.com/@ceenell/forecasting-stream-temperature)). Additionally, as water research in USGS expands in scale and complexity, I'd bet we'll see Vizlab author some very compelling new visuals for explaining and exploring patterns in large environmental datasets and I think we'll see a clear impact of the group on traditional USGS science products including raising the bar on publication figures, visuals, and supplements. 

### Machine learning

Machine learning (ML) is a rapidly growing capability in the U.S. Geological Survey, and the Water Mission Area is no exception. ML offers a ton of promise for a range of important applications, including improving our ability to predict changes in water quality/quantity as well as more business-oriented decisions, such as improving user experience through our large portfolio of water information web applications and providing early warnings of sensor failures in the field. 

<div class="grid-row">
{{< figure src="/static/water-data-science-2022/ML-2022.png" alt="*********." caption="********* (credit A P Appling)." class="side-by-side" >}}

<p class="side-by-side" >
Our ML capability <strong>right now</strong> includes three machine learning specialist full time federal employees and an ML postdoc in the data science branch, with three more in our partner "analysis and prediction" branch coming out of our <a href="../hiring-spring-2021">joint hiring effort</a> from last year. The group's current strengths are in temporally and spatially aware deep learning approaches for predict water quality changes in streams and rivers, most of which involve adding forms of "process-guidance" to an otherwise purely data-driven model. Alison is providing leadership for the growth of this capability in USGS water, including leading an effort tasked with "building capacity in AI/ML" and authoring a recent comprehensive book chapter on ML for inland waters (see <a href="https://www.sciencedirect.com/science/article/pii/B9780128191668001213">journal link</a> or <a href="https://doi.org/10.1016/B978-0-12-819166-8.00121-3">non-paywalled preprint</a>). Jake and Sam led new water temperature forecasts for the Delaware River Basin that provide a quasi-operational delivery of ... 
</p>


forecasting, KGML, TERM hiring, capacity building, ML strategy, some XAI,

We've provided leadership in the new field of knowledge-guided machine learning (KGML) 

Our data science branch ML sub-team **in the future _may_** inference, operational data, KGML, integration with enterprise modeling, decision-focused model streams, PERM hiring and leadership, MLOps, mature XAI.
</div>


### Web analytics

[Details here about analytics]

Our web analytics sub-team **right now** includes 

Our web analytics sub-team **in the future _may_** 

### Reproducible data assembly
<div class="grid-row">
{{< figure src="/static/water-data-science-2022/repro-data-assembly-2022.png" alt="*********." class="side-by-side" caption="*********. (credit L Platt)">}}
</div>

Our reproducible data assembly capability **right now** includes TERM hiring, targets/snakemake, collab code

Our reproducible data assembly sub-team **in the future _may_** 


## Other focal areas in 2022:

### knowledge management
DSP and DS manual, training, onboarding, mentoring, blogging

### How we're going to hire in the near-term
step one: supervisors
step two: cluster hire for individual contributors
step three: group hire for technical/process lead positions


_Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government._
