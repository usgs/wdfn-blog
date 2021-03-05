---
author: Jordan S Read (he/him)
date: 2021-03-05
slug: water-data-science-2021
draft: True
type: post
image: /static/FY21DataSci/pgdl_flubber_small.gif
title: "Water Data Science in 2021"
author_staff: Jordan-S-Read
author_email: <jread@usgs.gov>
author_twitter: jordansread
author_github: jread-usgs
author_gs: geFLqWAAAAAJ
categories:
  - data-science
description: Where data science in USGS is headed in 2021
keywords:
  - data science
  - machine learning
  - deep learning
  - knowledge-guided machine learning
  - data assimilation
  - data visualization
  - reproducibility
tags:
  - data-science 

---

Where the USGS water data science branch is headed in 2021 
--------------------
It is an exciting time to be a data science practitioner in environmental science. In the last five years, we’ve seen massive data growth, modeling improvements, new more inclusive definitions of "impact" in science, and new jobs and duties. The title of "data scientist" has even been formally added as a [job role](https://www.chcoc.gov/content/data-scientist-titling-guidance) by the federal government. USGS SCIENCE PLAN!!! https://pubs.er.usgs.gov/publication/cir1476 

As 2021 progresses, I felt compelled to write up a few of the activities we are focusing on right now, as well as share some ideas we are exploring for the future. If you want to jump ahead, I’ve included links below to four areas of emphasis our Data Science Branch has this year. 

[A renewed focus on water data visualizations](#vizlab)

[Advancing machine learning architectures for water prediction](#pgdl)

[Forecasting changes to water resources](#data-assimilation)

[Collaborative, reproducible, and efficient data workflows](#reproducibility)


First, some background
--------------------
We formally started a data science team in 2014, and this team was converted into the organizational unit of “Data Science Branch” in the USGS Water Resources Mission Area in late 2017. The scope of this team/branch has evolved over the years but has always included elements of data analysis and prediction, data visualization, reproducibility, and data science training. We’ve also continued to be motivated by solving problems related to data complexity and data volume, and how we can integrate new data science concepts into more traditional fields like hydrology, ecology, and limnology. 

We work for the US Federal Government where change is often slow, but we were able to establish the first formal data science group in the U.S. Geological Survey and continue to benefit from leadership support of this capability. At the same time, what we do and how we do it is pretty different from the way the USGS has operated in the past. Having entire jobs devoted to data visualization or having staff spend the necessary time to make complex data workflows fully reproducible are two examples that have required years of demonstrated usefulness to gain general acceptance. And although machine learning is the main toolset for prediction in many sectors, environmental science has continued to make primary modeling investments in process-based approaches that build on existing knowledge. We’ve been making progress bridging these modeling approaches by simply combining them, generating deep learning predictions that are guided by existing theory and are more accurate than either approach alone. 

Ok...enough of my rambling and onto the fun stuff.

A renewed focus on water data visualizations {#vizlab}
--------------------

![USGS VIZLAB BANNER](/static/FY21DataSci/vizlab_banner.png)

In 2021 we are stepping up our data visualization game. Step one was hiring Colleen and Ellen to join the team as full-time visualization specialists, as well as Hayley, who does viz, modeling, and workflows. Next, we're holding ourselves to the goal of greater output of high-quality data visualizations. We first started experimenting with data visualization in 2014, visualizing the drought conditions in California with a mix of tech that included parallax and D3 and started using the banner of USGS "Vizlab" (visualization laboratory), going on to release a number of data visualizations on water topics including [microplastics in our waterways](https://labs.waterdata.usgs.gov/visualizations/microplastics/), [climate change and freshwater fish](https://labs.waterdata.usgs.gov/visualizations/climate-change-walleye-bass/index.html), and [U.S. water use](https://labs.waterdata.usgs.gov/visualizations/water-use-15). We also have tested different ways to communicate the complexity of flood timing during hurricane events, using both [interactive](https://labs.waterdata.usgs.gov/visualizations/hurricane-maria/) and [GIFs/videos](https://prd-wret.s3.us-west-2.amazonaws.com/assets/palladium/production/s3fs-public/thumbnails/image/Sally_2020_24fps.gif) that were rendered shortly after landfall. But we’re making a major leap this year with the way we produce visualizations and we’ve upped our standards for design. Check out [water sci and mgmt in the Delware](https://labs.waterdata.usgs.gov/visualizations/delaware-basin-story/index.html#/), [gages through the ages](https://labs.waterdata.usgs.gov/visualizations/gages-through-the-ages/index.html#/), and [fire hydro](https://labs.waterdata.usgs.gov/visualizations/fire-hydro/index.html#/) for a view into early progress. We’re even working on a dataviz that explains how process-guided deep learning models make more accurate predictions. I’m excited to see what’s next. 


Advancing machine learning architectures for water prediction {#pgdl}
--------------------

<div class="grid-row">
{{< figure src="/static/FY21DataSci/pgdl_flubber_small.gif" alt="Process-guided deep learning predictions of stream temperature" class="side-by-side" >}}

<p class="side-by-side" >
There is swirling mix of excitement, fear, misunderstanding, and raw wonder concerning the role of machine learning in water prediction. In the Data Science branch, we’re excited about the potential use of ML in all kinds of USGS projects. But being part of the USGS, we also understand the positive modeling legacy our agency has, which could be tarnished by misuse or blind adoption of ML. A lot of the fear surrounding ML in environmental sciences comes from a combination of how well it seems to perform in prediction and how effortless applying it to the problem de jour seems to be. There is a lot of nuance to each of these assumptions, as we rarely have enough data to build a truly generalizable environmental ML model, and while these models may be faster to spin up, major challenges exist for dealing with data sparsity, estimating uncertainty, and applying knowledge-based constraints that require custom architectures and cutting-edge research. We have partnerships with the Kumar lab at U-MN, the Jia lab at Pitt, and the Shen lab at Penn State to collaborate on the exciting field of "<a href="https://sites.google.com/umn.edu/kgml/home">Knowledge Guided Machine Learning</a>". 
</p>
</div>
We’re focusing heavily in 2021 on a subset of KGML - which we’re calling Process-Guided Deep Learning - to make improved predictions of water quality or quantity that are guided by physical models and laws (such as conservation of energy, see <a href="https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2019WR024922">here</a>). These are advanced hybrid models that take the best of what our field has to offer for physics-based models and the best machine learning frameworks for spatiotemporally-aware models. The results of these collaborations have been exciting, with large improvements in our predictive accuracy and ability to transfer these models into unseen conditions and still make good predictions. We are currently working on the prediction of water temperature in lakes and streams with these methods, and also working on similar concepts for predicting stream discharge. The place for machine learning in USGS will continue to grow in the next several years and KGML and PGDL will generate some very interesting conversations regarding environmental modeling architectures. 


Forecasting changes to water resources {#data-assimilation}
--------------------

<div class="grid-row">
{{< figure src="/static/FY21DataSci/sequential_DA.png" alt="Sequential data assimilation forecasting" class="side-by-side" >}}

<p class="side-by-side" >
Continuing on with the theme of building better predictions with data, we are leading a new project to forecast stream and reservoir temperatures in the Delaware River Basin using data assimilation and machine learning. Data assimilation (DA) is a technique that makes iterative improvements to forecasts by weighting the confidence in new observations (e.g. streamflow and water temperature) with the confidence in model predictions. These improvements or adjustments can include changes to parameters and/or state variables that are internal to the model. DA is an especially powerful tool for environmental forecasts because it can take advantage of the continued accumulation of data to improve predictions and leverage real-time observations for updates, such as those from the thousands of USGS gages that pepper the landscape. 
</p>
This technique is clearly data-intensive and requires thoughtful automation to perform in a forecast setting. We are able to leverage several of the other Data Science capabilities to strengthen his effort, such as reproducible workflows and data visualization. Forecasting is relatively new but important territory for USGS, and we’re very pleased to be part of leading the simultaneous growth in forecasting and DA in the Water Resources Mission Area. 
</div>

Capturing reproducible and efficient data workflows {#reproducibility}
--------------------
![USGS data science reproducibility](/static/FY21DataSci/reproducibility.png)

Reproducibility is a crisis in some research fields and is only getting harder as science becomes larger, more collaborative, more data-intensive, and more integrated across a greater number of disciplines. We’re repro-nerds and think it is a tough ask to trust results or findings that aren’t backed by a transparent and repeatable workflow, so we emphasize doing so in all aspects of our work. A lot of researchers can get by without investing too much in reproducibility, but it seems inevitable that this strategy will either result in embarrassment or be a blocker to implementing the next logical approach. Worse, an entire research community that undervalues reproducibility may stunt the growth of the field – for example – accepting the status quo of single numeric predictions instead of expecting more useful results that explicitly quantify uncertainty (but which require workflows due to numerous iterations). Each of our data visualizations includes a GitHub repository that exposes all of the code used to build it, including how we fetched, transformed, and visualized the data. We have large-scale data pipelines for building model-ready data that can be updated quickly, and similar workflows for analyzing traffic to USGS Water websites (new hire Rasha is working on both). We’ve built some of our own tools to do this that use a make-like tracking of data and code dependencies, so that running the whole processing/modeling workflow only runs steps that have upstream data/code that are out of date, while still ensuring that the entire workflow could be run from scratch if needed. 


It’s an exciting time and we like what we’re doing! Contact us to discuss, collaborate, or even join our team. You can follow [@USGS_WaterSci](https://twitter.com/USGS_Datasci) on twitter to stay up to date. We’ll be hiring ~4 people this year alone and are on the lookout for people who would be energized to be part of this team.

