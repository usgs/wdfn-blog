
---
author: Jeff Sadler
date: 2022-01-19
slug: snakemake-for-ml-experiments
draft: True
image: static/25_years_waterdata_web/nwisweb_beginnings.png
type: post
title: Big, parallel deep learning experiments using the workflow management tool, Snakemake
author_email: <jsadler@usgs.gov>
author_github: jsadler2
description: How we used Snakemake to automate and parallelize big deep learning experiments.
categories:
  - data-science
tags:
  - data-science
---

A paper we wrote was recently published [Link](link_to_paper)! 
In the paper we had to run and evaluate many DL model runs.
These experiments required many model runs.
We wanted to show how we used Snakemake to do our experiment.
To automate these model runs and execute them in parallel, we used the worflow management software, [Snakemake](https://snakemake.github.io).

# To multi-task or not to multi-task? 
In the paper we asked a somewhat basic question: is it helpful to multi-task?
More specifically, we wondered if a deep learning model would be more accurate when trained to predict just one variable, streamflow, or when trained to predict two related variables (streamflow and water temperature)?
To answer this question, we designed a few experiments.
Here we'll focus on just one of four experiments - the one that required the most model runs.
We used Snakemake for the other three and found some interesting things from those too.
If you are interested check out the full manuscript.

# 27,270 model runs
Our first experiment, and the one with the most model runs required 27,270 model runs. 
Let's break that down.
- In the experiment we trained a separate DL model (LSTM) for each of 101 [NWIS](https://waterdata.usgs.gov/nwis) stations.
- For each station we needed to test the effect of a multi-task scaling factor to see how much multi-tasking was beneficial; the larger the value of the multi-task scaling factor, the more the model focused on the secondary task (predicting water temperature) - the smaller the value, the more the model focused on just getting the primary task right (predicting streamflow)
For the experiment we tried out 9 different values of the multi-task scaling factor (ranging from 0 to 320).
- Some of the differences between model runs is from differences in random starting model weights and not from differences in the multi-task scaling factor.
To account for this, 30 models with different random starting weights were trained for each station and multi-task scaling factor.
So all tolled - that's 101 sites x 9 multi-task scaling factors x 30 random starting weights = 27,270.

# Snakemake to the rescue
Now most of these can be totally done in parallel.
Each model is independent of the others. 
For example, the model for site A and multi-task scaling factor of 1 can be trained and evaluated at the exact same time the model for site B and multi-task scaling factor of 10 is trained and evaluated.
Snakemake is awesome! 
It allowed us not only to automate these large experiments but parallelize them.
Further, Snakemake took care of all of the job submission on the SLURM system.
