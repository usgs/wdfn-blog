---
author: USGS Vizlab
date: 2021-11-10
slug: what-is-vizlab
draft: False
type: post
image: /static/what-is-vizlab/what-is-vizlab-thumb.png
title: "What is the USGS Vizlab?"
author_email: <cnell@usgs.gov>
author_twitter: USGS_DataSci
author_github: usgs-vizlab
categories:
  - data-science
description: Water data visualizations at USGS in 2021
keywords:
  - data science
  - data visualization
  - reproducibility
tags:
  - data-science 

---
{{< figure src="/static/what-is-vizlab/viz-logo.png" alt="A banner for the USGS Vizlab water data visualization team featuring an abstract streamgraph that mimics flowing water.">}}

The USGS Vizlab is a collaborative team that uses data visualization to communicate water science and data to non-technical audiences. Our mission is to create timely visualizations that distill complex scientific concepts and datasets into compelling charts, maps, and graphics. We operate at the intersection of data science and science communication. To get a sense of our work you can check out <a href="https://labs.waterdata.usgs.gov/visualizations/vizlab-home/index.html#/?utm_source=blog&utm_medium=wdfn&utm_campaign=what_is_vizlab#/" target="_blank" >our new portfolio site</a>. 

<div class="grid-row">
{{< figure src="/static/what-is-vizlab/forecast_gradient.png" alt="A chart showing 7-day-ahead forecasts of maximum stream temperature at 5 sites. For each site, the mean and 90% CI of daily temperature predictions are shown in comparison to the observed maximum temperature. Most observations fall within the 90% CI of the forecasts, but accuracy is variable among sites. Predictions and observations above a max temperature threshold of 75F are emphasized to indicate negative implications with exceedance." caption="Predicting temperature exceedances with 7-day-ahead forecasts of maximum stream temperature at 5 sites." class="side-by-side" >}}
<p class="side-by-side" >
The origin of the Vizlab goes back to 2014, rising from collaboration among data scientists and researchers with an interest in science communication. Our early work leveraged open data sources to depict drought conditions in <a href="https://www.doi.gov/water/owdi.cr.drought/en/?utm_source=blog&utm_medium=wdfn&utm_campaign=what_is_vizlab#/" target="_blank" >Colorado</a> and <a href="https://labs.waterdata.usgs.gov/visualizations/ca_drought/index.html?utm_source=blog&utm_medium=wdfn&utm_campaign=what_is_vizlab#/" target="_blank" >California</a>, explored the <a href="https://labs.waterdata.usgs.gov/visualizations/climate-change-walleye-bass/index.html?utm_source=blog&utm_medium=wdfn&utm_campaign=what_is_vizlab#/" target="_blank" >impacts of climate change on freshwater fish</a>, and <a href="https://labs.waterdata.usgs.gov/visualizations/water-use-15/index.html#=undefined&utm_medium=wdfn&utm_campaign=what_is_vizlab#/&view=USA&category=total" target="_blank" >visualized 2015 water use across the U.S</a>. This work has been featured by the <a href="https://www.washingtonpost.com/news/wonk/wp/2018/06/25/americans-are-conserving-water-like-never-before-according-to-the-latest-federal-data/?noredirect=on" target="_blank" >Washington Post</a>, <a href="https://www.nationalgeographic.com/environment/article/climate-change-comes-for-favorite-summer-pastime-fishing" target="_blank" >linked by National Geographic</a>, and received several awards. This success motivated further investment and laid the groundwork for where we are today. <br/><br/>As part of the <a href="https://waterdata.usgs.gov/blog/water-data-science-2021/" target="_blank" >Data Science Branch in the USGS Water Mission Area</a>, the Vizlab is embedded in a vibrant community of researchers, data scientists, modelers, and technical experts. We function as a creative extension of these research efforts - developing visualizations and graphics that help communicate and disseminate key findings. In the coming year, we’re excited to support their innovative work in the areas of knowledge guided machine learning and ecological forecasting. We also plan to continue to work on the critical topics of climate change, drought, water use, and water availability in the coming year. 
</p>
</div>

How we work  
--------------------
We work using an iterative design process. At each stage of project planning and development, we think critically about how best to communicate the data (from a scicomm and scientific perspective), carefully consider the visual design (from an information design and usability standpoint), and strategize on how to best engage target audiences. This process embraces diversity in design, and we often exploring multiple ways to look at the same data. We encourage creativity through regular “idea blitzes” aimed at providing a low stakes environment to explore new ideas, and support one another with critical feedback at all stages of develoment. We commonly collaborate with domain-specific experts, integrating their expertise and feedback into our final products, and ensuring a high standard of scientific integrity.   

{{< figure src="/static/what-is-vizlab/snow-diagrams.png" alt="A mountain scene depicted in the Spring months during a high snow year and a low snow year. When snow-water equivalent (SWE) is higher, the timing of snowmelt occurs later in the year. When SWE in low, timing may be earlier." caption="Changes in the magnitude and timing of snow">}}

As data scientists, our workflows are rooted in the use of programming languages like R, python, and javascript to gather, process, and visualize data (<a href="https://github.com/usgs-vizlab" target="_blank">find us on github</a>). In addition to these programming languages, our workflows often incorporate graphic design tools such as Adobe Illustrator in order to elevate the visuals of our final products. Our approach to implementation and our incorporation of both code and graphic design is always evolving, and is informed by the goal of the visualization, design best practices, advances in visualization techniques and, of course, the data itself. An example of a purely code-based workflow can be seen in <a href="https://waterdata.usgs.gov/blog/build-r-animations/" target="_blank"> this recreation of our U.S. River Conditions animation in R</a>. An example of a design-based workflow is in our ongoing project to redesign the classic USGS water cycle diagram to include human impacts. <a href="https://twitter.com/USGS_DataSci/status/1417530514815266823" target="_blank">Check out this timelapse of the redesign process</a>. We’re always exploring new ways to visualize data and new ways for doing so in an effective, transparent, and accessible manner. 

In the last year, we’ve tried new narrative styles aimed at communicating data in context, developed fully reproducible data visualization pipelines, and worked to engage new audiences through social media and outreach efforts. 

#### Communicating data in context 

In our development process we value our ability to experiment with new tools and approaches to communication in order to reach our target audience. One major focus has been to develop interactive “explainers”. These are visualizations that dig deep on an interesting dataset or concept in water science. For example, in <a href="https://labs.waterdata.usgs.gov/visualizations/snow-to-flow/index.html#/?utm_source=blog&utm_medium=wdfn&utm_campaign=what_is_vizlab#/" target="_blank">“From Snow to Flow”</a> we worked with a USGS snow-hydrology team to look at what changing snowmelt means for water in the Western U.S. Before that, we published a visualization on <a href="https://labs.waterdata.usgs.gov/visualizations/fire-hydro/index.html#/?utm_source=blog&utm_medium=wdfn&utm_campaign=what_is_vizlab#/" target="_blank">how wildfires change watersheds and impacts to water availability</a>, motivated by the devastating wildfire season in 2020. These projects aimed to capture the timeliness of major annual events in an effort to engage new users with water science.  

{{< figure src="https://labs.waterdata.usgs.gov/visualizations/gifs/temp-variation.gif" alt="A line chart showing stream temperatures throughout the year at river reaches in the Delaware River Basin. In the DRB temperatures follow a consistent pattern within the year but each stream behaves a little differently. Urban streams get consistently warmer in the summer and streams above reservoirs stay cool. Why? During a given year most streams warm up as air temperature increases. But streams below reservoirs are kept cool by releases of cold water. In the fall, air temperatures drop and stream temperatures do too." caption="Stream temperature variability at stream reaches in the Delaware River Basin." style="maxWidth=400px">}}

A project we're particularly proud of is the two-part series on USGS efforts to <a href="https://labs.waterdata.usgs.gov/visualizations/temperature-prediction/index.html#/monitoring?utm_source=blog&utm_medium=wdfn&utm_campaign=what_is_vizlab#/" target="_blank">monitor and model stream temperature in the Delaware River Basin</a> (DRB). In the first part in the series, “Monitoring”, we looked at the availability and variability of stream temperature data in one of the most well-observed water systems in the US. It features maps and charts with paired interactions that allow users to explore the data in both time and space. In the second part of this project, “Modeling”, we used a scrollytelling (scrolling + storytelling) approach to layer in complex information and build a narrative. This allowed us to describe how knowledge-guided deep learning can be used to make accurate environmental predictions when data are limited.  

Projects like this are an exciting opportunity to communicate cutting-edge USGS research. From scrollytelling to D3-force transitions to animations made with <a href="https://github.com/veltman/flubber" target="_blank">flubber</a>, the development of the DRB temperature explainer page stretched the bounds of our javascript skills.

#### Reproducible data visualizations 

Another area of focus is the development of reproducible data processing and visualization pipelines. Reproducible visualizations are efficient and allow us to respond quickly to current events, like storms during the Atlantic hurricane season, since they can be easily generated with only minor modifications and rapid execution of the code. For example, changing to the date, bounding box, and storm code in our hurricane pipeline will automatically trigger a download of precipitation data from NOAA, storm event data from the National Hurricane Center, and water levels from USGS streamgages. This same pipeline will also create the final output video file visualizing the water footprint of the storm. Similarly, our reoccurring U.S. River Conditions animations that depict current streamflow conditions across the country are generated entirely in R. This allows us to efficiently regenerate the visualization for any time period of interest. By capturing all the steps needed to get data from its source into its final, beautifully visualized form, we save development time and produce a stream of reliable, consistent visual products. We are excited by these capabilities and are looking to expand them to new events and data sources in the coming year. 

{{< figure src="https://labs.waterdata.usgs.gov/visualizations/gifs/water-footprint-ida-2021.gif" alt="An animation of the water footprint of Hurricane Ida in 2021. As the hurricane approaches Louisiana, precipitation accumulates over the Gulf of Mexico and generate flooding conditions. Storm conditions persist after the hurricane status has dropped, eventually moving up the east coast of the U.S. and contributing to flooding in NJ, DE, PA, and MA." caption="The water footprint of Hurricane Ida, 2021">}}

#### Engaging new audiences  

Our overarching goal is to bring water science and data to new audiences, and in support of that effort we've invested in our social media presence through the <a href="https://twitter.com/USGS_DataSci" target="_blank">USGS Data Science twitter account</a>. We are also frequent contributors to USGS Water social media (<a href="" target="_blank">twitter</a> and <a href="https://www.instagram.com/usgs_streamgages/" target="_blank">instagram</a>). We use these accounts to share our processes, get feedback on our latest work, and connect with the larger water science and data viz community. We have found social media to be a great way to find inspiration. One major highlight of last year was participating in the #30DayChartChallenge on twitter during the month of April. It was really fun to think creatively about how to fit the daily chart themes and explore new datasets to visualize. <a href="https://waterdata.usgs.gov/blog/30daychartchallenge-2021//" target="_blank">See our contributions on the Water Data for the Nation Blog</a>. 

{{< figure src="https://labs.waterdata.usgs.gov/visualizations/charts/flow-cartogram-202108.jpeg" alt="A cartogram map with proportional area charts for each state. The area charts depict the relative number of USGS streamgages across 6 percentile bins, calculated relative to the historic daily record for each gage. The month of august is shown, with apparent drought conditions in the west and high water in the northeast due to the Atlantic hurricane season." caption="Cartogram of streamflow conditions for the month of August.">}}

We are hiring! 
--------------------
We’re looking for Data Visualization Specialists to join our team at multiple levels of experience (GS-09 and GS-12 general schedule grades). These positions will be open to applications on USAjobs.gov November 17th to November 23rd. <a href="https://waterdata.usgs.gov/blog/viz-hires-2021/" target="_blank">Read more about these openings in our hiring blog post</a>. 

We’re always happy to connect to discuss ideas or collaborate. Reach out to team lead Cee Nell (they/them) at cnell@usgs.gov  

Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
