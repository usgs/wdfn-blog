---
author: Marcus Beck and Laura DeCicco
date: 2016-07-13
slug: plotFlowConc
title: EGRET plotFlowConc using ggplot2
categories: Data Science
tags: 
  - R
  - EGRET
image: static/plotFlowConc/unnamed-chunk-4-1.png
---
Introduction
============

[`EGRET`](https://cran.r-project.org/package=EGRET) is an R-package for the analysis of long-term changes in water quality and streamflow, and includes the water-quality method Weighted Regressions on Time, Discharge, and Season (WRTDS). It is available on CRAN.

More information can be found at <https://github.com/USGS-R/EGRET>.

ggplot2
=======

`ggplot2` is a powerful and popular graphing package. Although all `EGRET` functions return with a specialized list, it is quite easy to extract the relavent data frames `Daily`, `Sample`, and `INFO`. Here are a few examples of using `ggplot2` to make plots that are also available in `EGRET`.

Please note there are a lot of nuances that are captured in the `EGRET` plotting functions that are not captured in these `ggplot2` examples.

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

<img class="sideBySide" src='/static/plotFlowConc/unnamed-chunk-1-1.png'/>
<img class="sideBySide" src='/static/plotFlowConc/unnamed-chunk-1-2.png'/>

boxConcMonth
------------

``` r
Sample$monthAbb <- as.factor(Sample$Month)
levels(Sample$monthAbb) <- month.abb

boxConcMonth_gg <- ggplot(data=Sample) +
  geom_boxplot(aes(monthAbb, ConcAve)) +
  scale_y_log10() +
  ggtitle(INFO$station.nm)

boxConcMonth_gg
boxConcMonth(eList)
```

<img class="sideBySide" src='/static/plotFlowConc/unnamed-chunk-2-1.png'/>
<img class="sideBySide" src='/static/plotFlowConc/unnamed-chunk-2-2.png'/>

plotFlowConc
============

Here is an example of using `ggplot2` with `EGRET` objects. It also takes advantage of the `dplyr` and `tidyr` packages. A function `plotFlowConc` was created:

``` r
library(tidyr)
library(dplyr)
library(fields)


plotFlowConc <- function(eList, month = c(1:12), years = NULL, col_vec = c('red', 'green', 'blue'), ylabel = NULL, xlabel = NULL, alpha = 1, size = 1,  allflo = FALSE, ncol = NULL, grids = TRUE, scales = NULL, interp = 4, pretty = TRUE, use_bw = TRUE, fac_nms = NULL){
  
  localDaily <- getDaily(eList)
  localINFO <- getInfo(eList)
  localsurfaces <- getSurfaces(eList)
  
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
  
  # subset years to plot
  if(!is.null(years)){
    
    to_plo <- to_plo[to_plo$year %in% years, ]
    to_plo <- to_plo[to_plo$month %in% month, ]
        
    if(nrow(to_plo) == 0) stop('No data to plot for the date range')
  
  }

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
  
  # make plot
  p <- ggplot(to_plo, aes(x = flo, y = res, group = year)) + 
    facet_wrap(~month, ncol = ncol, scales = scales)
  
  # return bare bones if FALSE
  if(!pretty) return(p + geom_line())
  
  # get colors
  cols <- col_vec
  
  # use bw theme
  if(use_bw) p <- p + theme_bw()
  
  p <- p + 
    geom_line(size = size, aes(colour = year), alpha = alpha) +
    scale_y_continuous(ylabel, expand = c(0, 0)) +
    scale_x_continuous(xlabel, expand = c(0, 0)) +
    theme(
      legend.position = 'top'
    ) +
    scale_colour_gradientn('Year', colours = cols) +
    guides(colour = guide_colourbar(barwidth = 10)) 
  
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

Next, the function can be called with any `EGRET` object:

``` r
eList <-  Choptank_eList
plotFlowConc(eList)
```

<img src='/static/plotFlowConc/unnamed-chunk-4-1.png'/>

Questions
=========

Please direct any questions or comments on `EGRET` to: <https://github.com/USGS-R/EGRET/issues>
