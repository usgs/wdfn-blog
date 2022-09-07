---
author: Jordan S Read (he/him)
date: 2022-09-03
slug: water-data-science-2022
draft: True
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

Within the data science branch, we are advocates for open science and build data science solutions that aim to increase scientific integrity, cost less over the long-run, and are accessible for others to build upon or reuse. We're also working to expand access, representation, and participation in federal science with [innovative hiring initiatives](../hiring-spring-2021#DIT) (including for [data visualization specialists](../viz-hires-2021/)). 

Our data science branch has grown and our capabilities have matured over the years. Now it is time for new changes that will contribute to more effective and sustainable work practices by: 1) launching new positions that will create more pathways for leadership and promotion, 2) adding new team structures that will be aligned with our data science sub-disciplines (visualizations, ML, web analytics, and reproducible data assembly), and 3) distributing supervisory responsibilities and vision to team leads.  

Below is my current description of what each sub-team does, the current status, and a couple of thoughts (likely to be proven wrong!) on where I think there might be some new opportunities for growth. 

What are these capabilities/teams?
--------------------

### Visualizations

Our data visualization sub-team ("Vizlab") has been around since 2014, but is constantly evolving and [added staff this year](../viz-hires-2021/). Described by [Cee recently](../what-is-vizlab/) as "_**a collaborative team that uses data visualization to communicate water science and data to non-technical audiences. Our mission is to create timely visualizations that distill complex scientific concepts and datasets into compelling charts, maps, and graphics. We operate at the intersection of data science and science communication.**_" See also <a href="https://labs.waterdata.usgs.gov/visualizations/vizlab-home/index.html#/?utm_source=blog&utm_medium=wdfn&utm_campaign=what_is_vizlab#/" target="_blank" >Vizlab's portfolio site</a>.

<div class="grid-row">
{{< figure src="/static/water-data-science-2022/vizlab_function.png" alt="A cartogram map of the US with proportional area charts for each state showing the proportion of streamgages by flow levels in August 2022, categorized using percentile bins." class="side-by-side" caption="A cartogram map of the US with proportional area charts for each state showing the proportion of streamgages by flow levels for August 2022, categorized using percentile bins. (credit USGS Vizlab)">}}

<p class="side-by-side" >
Vizlab **right now** includes three full time federal employees and a mix of part time contributors. The group excels at producing new visualization content that ranges from social media (e.g., [#30DayChartChallenge](../chart-challenge-2022/)), complex interactives (e.g.,  [stream temperature in the Delaware River Basin](https://labs.waterdata.usgs.gov/visualizations/temperature-prediction/index.html#)), and storytelling like in [“From Snow to Flow”](https://labs.waterdata.usgs.gov/visualizations/snow-to-flow/index.html#). In addition to being excellent data communicators, Vizlab builds data workflows that make it faster to template or reuse content in the future, such as for recurring event types or seasonal syntheses of water patterns. 
</p>
</div>

Vizlab **in the future _may_** provide new leadership in the publication of data visualization code and underlying data. The team already has a strong emphasis on data visualization accessibility and codes in the open (see [Vizlab GitHub](https://github.com/USGS-VIZLAB)) but I wouldn't be suprised to see more Vizlab authored blog posts that show "how we did it" that help others with a bit of a tutorial on how some of the thorny data, graphics, interactions, or hosting challenges were solved. We'll have some challenges ahead with code publication as new policies in motion will encourage more open source releases of code while also creating some new processes that we'll need to navigate through. I'm confident the group will continue to innovate with all kinds of approaches to generate interesting products while pushing to make the work more "open" (e.g., [stream forecast example on observable](https://observablehq.com/@ceenell/forecasting-stream-temperature)). Additionally, as water research in USGS expands in scale and complexity, I'd bet we'll see Vizlab author some very compelling new visuals for explaining and exploring patterns in large environmental datasets and I think we'll see a clear impact of the group on traditional USGS science products including raising the bar on publication figures, visuals, and supplements. 

### Machine learning

Machine learning (ML) is a rapidly growing capability in the U.S. Geological Survey, and the Water Mission Area is no exception. ML offers a ton of promise for a range of important applications, including improving our ability to predict changes in water quality/quantity as well as more business-oriented decisions, such as improving user experience through our large portfolio of water information web applications and providing early warnings of sensor failures in the field. 

<div class="grid-row">
{{< figure src="/static/water-data-science-2022/ML_function.png" alt="Model types positioned by their use of design and discovery, with models such as deep neural networks and process-guided deep learning scoring higher on discovery and process-based models scoring higher on design." caption="Model types positioned by their use of design and discovery. (credit AP Appling)." class="side-by-side" >}}

<p class="side-by-side" >
Our ML capability <strong>right now</strong> includes three machine learning specialist full time federal employees and an ML postdoc in the data science branch, with three more in our partner "analysis and prediction" branch coming out of our <a href="../hiring-spring-2021">joint hiring effort</a> from last year. The group's current strengths are in temporally and spatially aware deep learning approaches for predict water quality changes in streams and rivers, most of which involve adding forms of "process-guidance" to an otherwise purely data-driven model. Alison is providing leadership for the growth of this capability in USGS water, including leading an effort tasked with "building capacity in AI/ML" (AI = artificial intelligence) and authoring a recent comprehensive book chapter on ML for inland waters (see <a href="https://www.sciencedirect.com/science/article/pii/B9780128191668001213">journal link</a> or <a href="https://doi.org/10.1016/B978-0-12-819166-8.00121-3">non-paywalled preprint</a>, as well as the adjacent figure). Jake and Sam led forecasts for the Delaware River Basin that provide quasi-operational delivery of <a href="https://labs.waterdata.usgs.gov/water-temperature-forecasts/DRB/2022/index.html">zero to seven-day-ahead summer water temperatures</a> with innovative ML and data assimilation methods that are described in a <a href="https://doi.org/10.31223/X55K7G">companion paper</a> led by Jake
This crew is also working actively on a strategy document for ML opportunities in USGS water and also exploring methods in explainable AI (XAI), as well as continuing to provide leadership and development in the new field of knowledge-guided machine learning (KGML). 
</p>
</div>

Our data science branch ML sub-team **in the future _may_** strive to mature our methods for inference in ML applications and advancing XAI. Given our position in a science agency that places great value on understanding processes at play alongside more accurate prediction goals, it is unlikely to see closed-box (i.e., not inrepretable) approaches gain traction in critical applications. I'd also expect a continued effort to build data and operations (operations = robust and dependable, less nimble and exploratory) capabilities that complement ML development efforts. David moved into a role in ML operations (MLOps) this year and the needs for these skills will grow as projects mature and codes migrate into more operational use-cases. Similarly, efforts in USGS water to build enterprise models will create opportunities to strategically fuse ML and process-based codes in formal model/software development efforts that will require thoughtful architectures and robust implementations. Lastly, as our ML capability spreads to touch on more diverse applications, I wouldn't be surprised to see more situations of "decision-tuned" predictions where a similar underlying model is subtly re-purposed to deliver parallel data streams for distinct use-cases. For example, training two variants of a model to predict maximum temperature alongside temperature exposure duration may inform two different decisions with a single model development investment; using a variant of an environmental forecasting model to also provide real-time warning of faulty automated field measurements may result in field visit efficiencies. Ok, one more... I think the challenges related to model sharing, model/environment capture, model reuse, and general open science needs for ML models and their associated data prep and computing needs are going to lean on leadership from this sub-team in collaboration with the data assembly sub-team mentioned below. 


### Web analytics

Our data science branch is situated within the "Integrated Information Dissemination Division" along with the web communications branch and the decision support branch. Our colleagues build lots of [web applications](../tags/water-data-for-the-nation/) that deliver tons of water data to the public and decision makers. Our web analytics capability is responsible for capturing data on user or machine interactions with these data/information delivery systems and turning it into useful insights that can be used to make decisions that improve these systems or help them reach new audiences. The data we have available include user interface details (mostly captured via Google Analytics presently) and server logs. The web portfolio within the scope of the analytics capability has tens of millions of unique users each year. 
<div class="grid-row">
{{< figure src="/static/water-data-science-2022/analytics_function.png" alt="Graphics showing active users for September 7, 2022 by time of day, geographical location, and by date." class="side-by-side" caption="Graphics that represent active users for USGS Water Mission Area web products. (credit Google Analytics)">}}

<p class="side-by-side" >
Our web analytics sub-team <strong>right now</strong> includes a few data scientist contributors that primarily work on other projects. We're currently light on staffing but heavy in opportunities for growth in this area. The primary efforts of web analytics right now include development and maintenance of a real-time analytics dashboard that provides access and summarization of patterns and trends in application usage across over four dozen unique web applications. We deliver quarterly reports as part of Congressional communication that provide a view into how much water data is being served (e.g., last quarter there were 1.1 billion requests to <a href = "../user_operational_pull/">USGS water services</a> and 104 billion rows of discrete water quality data served from 2.3 million unique data requests to the multi-agency <a href="https://www.waterqualitydata.us/">Water Quality Portal</a>). David led prior work to build data flows that make feed these summaries as well as the analytics dashboard and much of the current work is automated. 
</p>
</div>

Our web analytics sub-team **in the future _may_** work more closely with web application development teams in order to build better content for analytics and deliver more value to software development decisions. Analytics has opportunities to work with our information delivery crew and create iterative experiments that can inform agile development (i.e., things that are working for users get promoted, new features that create confusion get reevaluated). This closer partnership would also likely result in better-formed server logs and user interface event tracking that would both support richer analyses. I'd also love to see this capability aligned with measuring targets of new web content we create, and have that feed back into earlier project designs that are more realistic about audience goals and encouraging earlier discussions about end users. Lastly, we've long envisioned that this capability could help us recommend water information products to users to improve the value we provide generally. This kind of thing could be as simple as inferring interest in a state-specific flooding visualization based on a user's region and visit to similar USGS web content, or could involve real-time modeling of user flows to recommend content in our web footers. Either way, there are some neat collaborative concepts to explore in future analytics efforts. 

### Reproducible data assembly
<div class="grid-row">
Reproducible data assembly captures the connections between data, code, and results to improve confidence and potential for efficient reuse of data workflows. These data workflows are used to build datasets for models, used to orchestrate the running and summarization of models, and/or to create results or visualizations. 

{{< figure src="/static/water-data-science-2022/assembly_function.png" alt="*********." class="side-by-side" caption="*********. (credit L Platt)">}}
<p class="side-by-side" >
Our reproducible data assembly capability <strong>right now</strong> includes four full time federal employees in the data science branch, with three more in our partner branches (analysis and prediction; geointelligence) coming out of our <a href="../hiring-spring-2021">joint hiring effort</a> from last year. We build dependency tracking workflows with <a href="https://snakemake.readthedocs.io/en/stable/">snakemake</a> in python and <a href="https://books.ropensci.org/targets/">targets</a> in R. What "dependency" tracking means in this context is that these tools track whether code or data have changed and rebuild products or outputs that are impacted by those changes while skipping the rebuild of outputs that aren't impacted. In the past, we've used <a href="https://www.gnu.org/software/make/">make</a> and <a href="https://github.com/richfitz/remake">remake</a>, and created our own extension to remake with <a href="https://github.com/USGS-R/scipiper">scipiper</a but now primarily use other tools. We have onboarding materials for new staff that include three training modules in targets and one for snakemake. This group currently works a lot on capturing computing environments, refining collaborative coding practices, and building efficient published data releases. 
</p>
</div>

Our reproducible data assembly sub-team **in the future _may_** move into design and usability issues for data publications and code publications. Right now it is a major win to be releasing code and data alongside models, papers. In the future, there will likely be a greater emphasis on making these artifacts more useful as building blocks for future science instead of captures for reproducibility. Similar to how we use [user-centered design](../user-centered-design/) to build information delivery systems that meet real needs, we could employ similar practices to build better outputs from our models/analyses that are more accessible and usable by others. I also see opportunities to build more efficient project workflows that meet a wider number of collaborators where they are with their own coding practices. We've used "tiers of reproducibility" in the past to communicate different levels of code/data capture, but a similar spectrum could apply to the selection of technical solutions we bring or recommend to projects to meet needs (such as scripting for groups that are just starting to hop into coding and containerization for others who are ready to make a jump into portability and environment capture). The needs for this type of capability are so ubiquitous and diverse; we'll need to find ways to elevate lots of different kinds of data work by operating at different technical levels, with different languages, and with varied data scales and complexities. 



### How we're going to hire in the near-term
step one: We're going to hire supervisors very soon ([positions open on September 12th](https://www.usajobs.gov/job/675611500)) that will provide new supervision and vision to these capabilities. 
step two: cluster hire for individual contributors to meet needs with permanent federal hires (early 2023).
step three: group hire for technical/process lead positions that will provide leadership of core concepts or capabilities (early to late 2023). 


_Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government._
