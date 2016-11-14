---
author: Marcus Beck and Laura DeCicco
date: 2016-07-13
slug: plotFlowConc
type: post
title: EGRET plotFlowConc using ggplot2
categories: Data Science
image: static/plotFlowConc/plotFlowConc-1.png
tags: 
  - R
  - EGRET
description: Using the R packages, ggplot and EGRET, a new function plotFlowConc shows a new way to visualize the changes between flow and concentration.
keywords:
  - EGRET
  - ggplot2
  - data visualization
---

* Marcus Beck (USEPA)
<a href="mailto:beck.marcus@epa.gov"><i class="fa fa-envelope-square fa-2x"></i></a>
<a href="https://twitter.com/fawda123"><i class="fa fa-twitter-square fa-2x"></i></a>
<a href="https://github.com/fawda123"><i class="fa fa-github-square fa-2x"></i></a>
<a href="https://scholar.google.com/citations?user=9ZDDQ_8AAAAJ"><i class="ai ai-google-scholar-square ai-2x"></i></a>
<a href="https://www.researchgate.net/profile/Marcus_Beck"><i class="ai ai-researchgate-square ai-2x"></i></a>

* Laura DeCicco (USGS-OWI)
<a href="mailto:ldecicco@usgs.gov"><i class="fa fa-envelope-square fa-2x"></i></a>
<a href="https://twitter.com/DeCiccoDonk"><i class="fa fa-twitter-square fa-2x"></i></a>
<a href="https://github.com/ldecicco-usgs"><i class="fa fa-github-square fa-2x"></i></a>
<a href="https://scholar.google.com/citations?hl=en&user=jXd0feEAAAAJ"><i class="ai ai-google-scholar-square ai-2x"></i></a>
<a href="https://www.researchgate.net/profile/Laura_De_Cicco"><i class="ai ai-researchgate-square ai-2x"></i></a>
<a href="https://profile.usgs.gov/ldecicco"><i class="fa fa-user fa-2x"></i></a>

Introduction
============

[`EGRET`](https://cran.r-project.org/package=EGRET) is an R-package for the analysis of long-term changes in water quality and streamflow, and includes the water-quality method Weighted Regressions on Time, Discharge, and Season (WRTDS). It is available on CRAN.

More information can be found at <https://github.com/USGS-R/EGRET>.

ggplot2
-------

`ggplot2` is a powerful and popular graphing package. All`EGRET` functions return, or take as an input, a specialized list (referred as the "eList" in `EGRET` documentation). It is quite easy to extract the simple-to-use, relavent data frames: `Daily`, `Sample`, and `INFO`. Here is a simple example of using `ggplot2` to make a plot that is also available in `EGRET`.

Please note there are a lot of nuances that are captured in the `EGRET` plotting functions that are not automatically captured by using `ggplot2`. However, this simple example can give you the minimal workflow you might need to create your own more specialized `ggplot2` `EGRET` plots.

plotConcQ
---------

``` r
library(EGRET)
library(ggplot2)

eList <-  Choptank_eList
Sample <- eList$Sample
INFO <- eList$INFO

Sample$cen <- factor(Sample$Uncen)
levels(Sample$cen) <- c("Censored","Uncensored") 

plotConcQ_gg <- ggplot(data=Sample) +
  geom_point(aes(x=Q, y=ConcAve, color = cen)) +
  scale_x_log10() +
  ggtitle(INFO$station.nm)

plotConcQ_gg
plotConcQ(eList)
```

<img src='/static/plotFlowConc/plotConcQ-1.png'/ title='ggplot2 Concentration Flow plot' alt='ggplot vs EGRET' class='sideBySide'/><img src='/static/plotFlowConc/plotConcQ-2.png'/ title='EGRET Concentration Flow plot' alt='ggplot vs EGRET' class='sideBySide'/>

plotFlowConc
============

One of the things the WRTDS statistical model provides is a characterization of the gradually changing relationship between concentration and discharge as it evolves over a period of many years, and also a characterization of how that pattern is different for different times of the year.

The `plotContours`, `plotDiffContours`, `plotConcQSmooth`, and `plotConcTimeSmooth` functions in `EGRET` are all designed to help the user explore various aspects of the model. Because of the multivariate character of the model it is helpful to have a variety of ways to view it to aid in making interpretations about the nature of the changes that have taken place. Another approach is one developed by Marcus Beck of US EPA that makes very effective use of color and multiple panel graphs to help visualize these evolving conditions. This new function `plotFlowConc` which uses the packages `ggplot2`, `dplyr`, and `tidyr` is a wonderful new way to visualize these changes.

<p class="ToggleButton" onclick="toggle_visibility('hideMe')">
Show/Hide Code
</p>
<div id="hideMe">

``` r
library(tidyr)
library(dplyr)
library(ggplot2)
library(fields)

plotFlowConc <- function(eList, month = c(1:12), years = NULL, col_vec = c('red', 'green', 'blue'), ylabel = NULL, xlabel = NULL, alpha = 1, size = 1,  allflo = FALSE, ncol = NULL, grids = TRUE, scales = NULL, interp = 4, pretty = TRUE, use_bw = TRUE, fac_nms = NULL, ymin = 0){
  
  localDaily <- getDaily(eList)
  localINFO <- getInfo(eList)
  localsurfaces <- getSurfaces(eList)
  
  # plot title
  toplab <- with(eList$INFO, paste(shortName, paramShortName, sep = ', '))

  # flow, date info for interpolation surface
  LogQ <- seq(localINFO$bottomLogQ, by=localINFO$stepLogQ, length.out=localINFO$nVectorLogQ)
  year <- seq(localINFO$bottomYear, by=localINFO$stepYear, length.out=localINFO$nVectorYear)
  jday <- 1 + round(365 * (year - floor(year)))
  surfyear <- floor(year)
  surfdts <- as.Date(paste(surfyear, jday, sep = '-'), format = '%Y-%j')
  surfmos <- as.numeric(format(surfdts, '%m'))
  surfday <- as.numeric(format(surfdts, '%d'))
   
  # interpolation surface
  ConcDay <- localsurfaces[,,3]

  # convert month vector to those present in data
  month <- month[month %in% surfmos]
  if(length(month) == 0) stop('No observable data for the chosen month')
  
  # salinity/flow grid values
  flo_grd <- LogQ

  # get the grid
  to_plo <- data.frame(date = surfdts, year = surfyear, month = surfmos, day = surfday, t(ConcDay))
  
  # reshape data frame, average by year, month for symmetry
  to_plo <- to_plo[to_plo$month %in% month, , drop = FALSE]
  names(to_plo)[grep('^X', names(to_plo))] <- paste('flo', flo_grd)
  to_plo <- tidyr::gather(to_plo, 'flo', 'res', 5:ncol(to_plo)) %>% 
    mutate(flo = as.numeric(gsub('^flo ', '', flo))) %>% 
    select(-day)

  # smooth the grid
  if(!is.null(interp)){
    
    to_interp <- to_plo
    to_interp <- ungroup(to_interp) %>% 
      select(date, flo, res) %>% 
      tidyr::spread(flo, res)
    
    # values to pass to interp
    dts <- to_interp$date
    fit_grd <- select(to_interp, -date)
    flo_fac <- length(flo_grd) * interp
    flo_fac <- seq(min(flo_grd), max(flo_grd), length.out = flo_fac)
    yr_fac <- seq(min(dts), max(dts), length.out = length(dts) *  interp)
    to_interp <- expand.grid(yr_fac, flo_fac)
          
    # bilinear interpolation of fit grid
    interps <- interp.surface(
      obj = list(
        y = flo_grd,
        x = dts,
        z = data.frame(fit_grd)
      ), 
      loc = to_interp
    )

    # format interped output
    to_plo <- data.frame(to_interp, interps) %>% 
      rename(date = Var1, 
        flo = Var2, 
        res = interps
      ) %>% 
      mutate(
        month = as.numeric(format(date, '%m')), 
        year = as.numeric(format(date, '%Y'))
      )

  }

  # subset years to plot
  if(!is.null(years)){
 
    to_plo <- to_plo[to_plo$year %in% years, ]
    to_plo <- to_plo[to_plo$month %in% month, ]
        
    if(nrow(to_plo) == 0) stop('No data to plot for the date range')
  
  }
  
  # summarize so no duplicate flos for month/yr combos
  to_plo <- group_by(to_plo, year, month, flo) %>% 
      summarize(res = mean(res, na.rm = TRUE)) %>% 
      ungroup
  
  # axis labels
  if(is.null(ylabel))
    ylabel <- localINFO$paramShortName
  if(is.null(xlabel))
    xlabel <- expression(paste('Discharge in ', m^3, '/s'))

  # constrain plots to salinity/flow limits for the selected month
  if(!allflo){
    
    #min, max flow values to plot
    lim_vals<- group_by(data.frame(localDaily), Month) %>% 
      summarize(
        Low = quantile(LogQ, 0.05, na.rm = TRUE),
        High = quantile(LogQ, 0.95, na.rm = TRUE)
      )
  
    # month flo ranges for plot
    lim_vals <- lim_vals[lim_vals$Month %in% month, ]
    lim_vals <- rename(lim_vals, month = Month)
    
    # merge limits with months
    to_plo <- left_join(to_plo, lim_vals, by = 'month')
    to_plo <- to_plo[to_plo$month %in% month, ]
        
    # reduce data
    sel_vec <- with(to_plo, 
      flo >= Low &
      flo <= High
      )
    to_plo <- to_plo[sel_vec, !names(to_plo) %in% c('Low', 'High')]
    to_plo <- arrange(to_plo, year, month)
    
  }
  
  # months labels as text
  mo_lab <- data.frame(
    num = seq(1:12), 
    txt = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')
  )
  mo_lab <- mo_lab[mo_lab$num %in% month, ]
  to_plo$month <- factor(to_plo$month, levels =  mo_lab$num, labels = mo_lab$txt)
  
  # reassign facet names if fac_nms is provided
  if(!is.null(fac_nms)){
    
    if(length(fac_nms) != length(unique(to_plo$month))) 
      stop('fac_nms must have same lengths as months')
  
    to_plo$month <- factor(to_plo$month, labels = fac_nms)
    
  }
  
  # convert discharge to arithmetic scale
  to_plo$flo <- exp(to_plo$flo)
  
  # make plot
  p <- ggplot(to_plo, aes(x = flo, y = res, group = year)) + 
    facet_wrap(~month, ncol = ncol, scales = scales)
  
  # set lower limit for y-axis if applicable
  lims <- coord_cartesian(ylim = c(ymin, max(to_plo$res, na.rm = TRUE)))
  if(!is.null(scales)){
    if(scales == 'free_x') p <- p + lims
  } else {
    p <- p + lims
  }

  
  # return bare bones if FALSE
  if(!pretty) return(p + geom_line())
  
  # get colors
  cols <- col_vec
  
  # use bw theme
  if(use_bw) p <- p + theme_bw()

  # log scale breaks
  brks <- c(0, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000)

  p <- p + 
    geom_line(size = size, aes(colour = year), alpha = alpha) +
    scale_y_continuous(ylabel, expand = c(0, 0)) +
    scale_x_log10(xlabel, expand = c(0, 0), breaks = brks) +
    theme(
      legend.position = 'top', 
      axis.text.x = element_text(size = 8), 
      axis.text.y = element_text(size = 8)
    ) +
    scale_colour_gradientn('Year', colours = cols) +
    guides(colour = guide_colourbar(barwidth = 10)) + 
    ggtitle(toplab)
  
  # remove grid lines
  if(!grids) 
    p <- p + 
      theme(      
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()
      )
  
  return(p)
    
}
```
</div>

The function can also be imported in the workspace from GitHub:

``` r
library(devtools)
source_gist("00003218e6a913f681fa16e587c7fbbb", filename = "plotFlowConc.R")
```

Next, the function can be called with any `EGRET` object:

``` r
eList <-  Choptank_eList
plotFlowConc(eList, years=seq(1980, 2014, by = 4))
```

<img src='/static/plotFlowConc/plotFlowConc-1.png'/ title='Custom plotFlowConc' alt='Custom ggplot2 plotFlowConc image' class=''/>

This graphic allows the user to see a variety of types of changes. For example, if the curves substantially change their shape over time it may suggest shifts among various pollutant sources (e.g. shallow groundwater, deeper groundwater, point sources, and surface runoff). It may also show changes that are strong in some seasons and weak in others because of factors like shifts in the time when nutrients are applied to the landscape or changes in cropping practices (e.g. no-till farming or cover crops). It can also show seasons when change may be accelerating versus others where conditions may have become more stable over time. All of these kinds of patterns can be useful in developing interpretations of the kinds of changes taking place and can help the user to develop hypotheses that they can test out in a formal manner with the existing data or by adding new data over time.

The `plotFlowConc` function has several arguments that control the plot aesthetics. The only argument that is required is the first one (`eList`), all the others have defaults that result in a highly presentable graphic, but there are options that the user can chose if they wish to vary the look of their output.

-   `eList` input `EGRET` object
-   `month` numeric input from 1 to 12 indicating the monthly predictions to plot
-   `years` numeric vector of years to plot. For example, `seq(1980, 2014, by = 4)` will plot nine years of data from 1980 to 2014 at four year intervals. Set as `NULL` to plot all years
-   `col_vec` chr string of plot colors to use, passed to `ggplot2::scale_colour_gradient` for line shading
-   `ylabel` chr string for y-axis label
-   `xlabel` chr string for x-axis label
-   `alpha` numeric value from zero to one for line transparency
-   `size` numeric value for line size
-   `allflo` logical indicating if the flow values are limited to the fifth and ninety-fifth percentile of observed values for each month
-   `ncol` numeric argument passed to `ggplot2::facet_wrap` indicating number of facet columns
-   `grids` logical indicating if grid lines are present
-   `scales` chr string passed to `ggplot2::facet_wrap` to change x/y axis scaling on facets, acceptable values are 'free', 'free\_x', or 'free\_y'
-   `interp` numeric input as a scalar for smoothing the plot lines. The default is 4 indicating that four times as many values are interpolated and plotted compared to the original results matrix from WRTDS. The interpolation does not create novel data outside the range of the predictions but instead creates observations in the time, flow domain that are between values that were used explicitly to create the model. The effect is a smoother plot that reduces the jaggedness of the lines. A value of 1 or `NULL` can be used to suppress this behavior if the WRTDS results matrix is sufficiently large, i.e., minimal jaggedness in the plot lines. Values larger than 4 typically do not improve the visual appearance of trends.
-   `pretty` logical indicating if preset plot aesthetics are applied, otherwise the ggplot2 default themes are used
-   `use_bw` logical indicating if `ggplot2::theme_bw` is used
-   `fac_nms` optional chr string for facet labels, which must be equal in length to `month`
-   `ymin` numeric input for lower limit of y-axis, applies only if `scales = NULL` or `scales = free_x`

Questions
=========

Please direct any questions or comments on `EGRET` to: <https://github.com/USGS-R/EGRET/issues>

Questions about `plotFlowConc` can be directed to Marcus Beck at <beck.marcus@epa.gov>
