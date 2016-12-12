---
author: Brian Breaker and Laura DeCicco
date: 2016-10-28
slug: peak-flow-analysis
draft: True
title: Introduction to peak flow analysis
type: post
categories: Data Science
image: static/peak-flow-analysis/unnamed-chunk-7-1.png
tags: 
  - R
  - dataRetrieval
 
description: Using the R-packages dataRetrieval, dplyr, and ggplot2, a simple analysis on peak flow.
keywords:
  - R
  - dataRetrieval
 
 
 
---
Get data using dataRetrieval
----------------------------

Peak flow data is available through the `dataRetrieval` package.

``` r
library(dataRetrieval)
buffaloSites <- c("07055646", "07055660", "07055680", "07056000", "07056700")

#read the peak flow files
buffaloPks <- readNWISpeak(buffaloSites, asDateTime = FALSE)
```

Plot using ggplot2
------------------

``` r
library(ggplot2)

pBuffaloPks <- ggplot(data = buffaloPks, aes(x = peak_dt, y = peak_va)) +
  geom_line(aes(color = site_no)) +
  geom_point(aes(shape = site_no)) +
  scale_y_log10() +
  annotation_logticks(sides = "rl") +
  labs(x = "Date", y = expression(paste("Annual peak discharge", ", ", ft^{3}/s))) +
  theme_bw() +
  scale_x_date(limits = c(as.Date("1990-10-01"), as.Date("2014-09-30")))

pBuffaloPks
```

<img src='/static/peak-flow-analysis/unnamed-chunk-2-1.png'/ title='Annual peak discharge over time' alt='Annual peak discharge over time' class=''/>

The records for data from the 3 upstream sites for 2009-2013 looks like it could use a second look....

Amite River in Louisiana
------------------------

``` r
amiteSites <- c("07378500", "07380120")

#read the peak flow files
amitePks <- readNWISpeak(amiteSites, asDateTime = FALSE)

pAmitePks <- ggplot(data = amitePks, aes(x = peak_dt, y = peak_va, label = as.character(peak_dt))) +
  geom_line(aes(color = site_no)) +
  geom_point(aes(shape = site_no)) +
  scale_y_log10() +
  annotation_logticks(sides = "rl") +
  labs(x = "Date", y = expression(paste("Annual peak discharge", ", ", ft^{3}/s))) +
  theme_bw() +
  scale_x_date(limits = as.Date(c("1984-10-01", "2014-09-30")))

pAmitePks
```

<img src='/static/peak-flow-analysis/unnamed-chunk-3-1.png'/ title='Peak discharge over time, Amite River' alt='Peak discharge over time, Amite River' class=''/>

Buffalo River
-------------

``` r
buffaloMmts <- readNWISmeas(buffaloSites, expanded = TRUE)

#plot the measurements
pBuffaloMmts <- ggplot(data = buffaloMmts, aes(x = measurement_dateTime, y = discharge_va, label = measurement_nu)) +
  geom_point(aes(shape = site_no, color = site_no)) +
  scale_y_log10() +
  labs(x = "Date", y = expression(paste(Discharge, ", ", ft^{3}/s))) +
  theme_bw()

pBuffaloMmts
```

<img src='/static/peak-flow-analysis/unnamed-chunk-4-1.png'/ title='Discharge over time for Buffalo rivers.' alt='Discharge over time for Buffalo rivers.' class=''/>

Here we figure out what the "bankfull" discharge is for the sites based off of the peak flow files. We will use the 2-yr recurrence interval or probability of 0.5.

``` r
library(dplyr)
library(mgcv)
library(lmomco)

freqAnalysis <- function( series, distribution, nep = nonexceeds() ) {
  distribution <- tolower(distribution)
  transformed <- FALSE
  base.dist <- c('lp3', dist.list())
  if( any(distribution %in% base.dist) ) {
    if( distribution == 'lp3' ) {
      series <- log10(series)
      transformed <- TRUE
      distribution <- 'pe3'
    }
    samLmom <- lmom.ub(series)
    distPar <- lmom2par(samLmom, type = distribution)
    quant <- par2qua(f = nep, para = distPar)
    if( distribution == 'pe3' & transformed ) {
      distribution <- 'lp3'
      quant <- 10^quant
    }
    return(
      list(
        distribution = list(
          name = distribution,
          logTransformed = transformed,
          parameters = distPar),
        output = data.frame(nep = nep, rp = prob2T(nep), estimate = quant) 
      ) )
  } else {
    stop(
      sprintf('Distribution \'%s\' not recognized!', distribution))
  }
}

summary.Buffalo <- buffaloPks %>%
  group_by(site_no) %>%
  summarise(bankfullMaybe = freqAnalysis(na.omit(peak_va), dist = "lp3")$output[15,3])


bnkfllMmts <- left_join(buffaloMmts, summary.Buffalo, by="site_no") %>%
  filter(discharge_va >= bankfullMaybe)

pBuffaloMmtsBnkFll <- ggplot(data = bnkfllMmts, aes(x = measurement_dateTime, y = discharge_va, label = measurement_nu)) +
  geom_point(aes(shape = site_no, color = site_no), size = 3) +
  scale_y_log10() +
  annotation_logticks(sides = "rl") +
  labs(x = "Date", y = expression(paste(Discharge, ", ", ft^{3}/s))) +
  theme_bw()

pBuffaloMmtsBnkFll
```

<img src='/static/peak-flow-analysis/unnamed-chunk-5-1.png'/ title='Frequency analysis' alt='Frequency analysis' class=''/>

How many measurements per year?

``` r
buffaloMmts.tally <- buffaloMmts %>%
  mutate(Yr = format(measurement_dt, "%Y")) %>%
  group_by(site_no, Yr) %>%
  tally()

pbuffaloMmtsPerYear <- ggplot(data = buffaloMmts.tally, aes(x = as.numeric(Yr), y = n, color = site_no)) +
  geom_bar(position = "dodge", stat = "identity", aes(fill = site_no)) +
  scale_y_continuous(expand = c(0,0), breaks = seq(0,36,4)) +
  scale_fill_grey() +
  scale_color_grey() +
  labs(x = "Year", y = "Number of Measurements") +
  theme_bw()+
  scale_x_continuous(limits = c(1996, 2016)) +
  scale_y_continuous(expand = c(0,0), breaks = seq(0,10,1), limits = c(0,10))

pbuffaloMmtsPerYear
```

<img src='/static/peak-flow-analysis/unnamed-chunk-6-1.png'/ title='Number of measurements per year' alt='Number of measurements per year.' class=''/>

Create a base stage-discharge rating for one of the sites on the Buffalo River.
-------------------------------------------------------------------------------

``` r
mmts07055680 <- subset(buffaloMmts, site_no == "07055680")

#plot all of the measurements 
pMmts5680 <- ggplot(data = mmts07055680, aes(x = gage_height_va, y = discharge_va)) +
  geom_point() +
  stat_smooth(method = "gam", formula = y ~ s(x, bs = "cs")) +
  scale_x_log10(breaks = seq(2,24,2)) +
  scale_y_log10() +
  annotation_logticks(sides = "trbl") +
  labs(x = "Gage height, ft", y = expression(paste(Discharge, ", ", ft^{3}/s))) +
  theme_bw()

gam5680 <- gam(log10(discharge_va) ~ s(log10(gage_height_va), bs = "cs"), data = mmts07055680)
newRat5680 <- data.frame(gage_height_va = seq(3.14, 25, 0.01))
newRat5680$discharge <- signif(10^predict(gam5680, newRat5680), 3)


pMmts5680 <- pMmts5680 +
  geom_line(data = newRat5680, aes(x = gage_height_va, y = discharge), color = "red")

pMmts5680
```

<img src='/static/peak-flow-analysis/unnamed-chunk-7-1.png'/ title='Discharge vs gage height' alt='Discharge vs gage height' class=''/>

Compute annual means and yields for discharge from the DV data.
===============================================================

Retrieve some DV data for sites on and around the Buffalo River.

``` r
#read in the DV data for the Buffalo Sites
datAllDVs <- renameNWISColumns(readNWISdv(buffaloSites, "00060", startDate = "", endDate = Sys.Date()))

#plot all of the data
pAllDVs <- ggplot(data = datAllDVs, aes(x = Date, y = Flow)) +
  geom_line(aes(color = site_no)) +
  scale_y_log10() +
  annotation_logticks(sides = "rl") +
  labs(x = "Date", y = expression(paste(Discharge, ", ", ft^{3}/s))) +
  theme_bw()

pAllDVs
```

<img src='/static/peak-flow-analysis/unnamed-chunk-8-1.png'/ title='Daily discharge over time.' alt='Daily discharge over time.' class=''/>

Compute annual means:
=====================

``` r
annMean <- datAllDVs %>%
  mutate(Yr = as.numeric(format(Date, "%Y"))) %>%
  group_by(site_no, Yr) %>%
  summarize(annMean = mean(Flow, na.rm = TRUE))

pAnnMean <- ggplot(data = annMean, aes(x = Yr, y = annMean)) +
  geom_bar(position = "dodge", stat = "identity", aes(fill = site_no)) +
  scale_y_log10(expand = c(0,0)) +
  annotation_logticks(sides = "rl") +
  scale_fill_grey() +
  scale_color_grey() +
  labs(x = "Year", y = expression(paste("Annual mean discharge", ", ", ft^{3}/s))) +
  theme_bw() +
  scale_x_continuous(limits = c(2008,2016))

pAnnMean
```

<img src='/static/peak-flow-analysis/unnamed-chunk-9-1.png'/ title='Annual mean' alt='Annual mean' class=''/>

Get drainage area and calculate yield

``` r
infoAll <- readNWISsite(buffaloSites)

annMean <- left_join(annMean, 
                     select(infoAll, site_no, drain_area_va), by = "site_no")

#add a column to the annMean data frame that contains the annual yield
annMean$Yield <- annMean$annMean/annMean$drain_area_va

#plot the annual means
pAnnYield <- ggplot(data = annMean, aes(x = Yr, y = Yield)) +
  geom_bar(position = "dodge", stat = "identity", aes(fill = site_no)) +
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_grey() +
  scale_color_grey() +
  labs(x = "Year", y = expression(paste("Annual yield", ", ", ft^{3}/s/mi^2))) +
  theme_bw() +
  scale_x_continuous(limits = c(2008,2016))

pAnnYield
```

<img src='/static/peak-flow-analysis/unnamed-chunk-10-1.png'/ title='Annual Yield' alt='Annual yield' class=''/>

Estimate missing data
---------------------

Remove a chunk from site 07055680, find the best sites for comparison, and estimate the missing data.

``` r
library(tidyr)
datAllDVs <- filter( datAllDVs, Date >= as.Date("2008-06-14")) 

dataAllDVwide <- datAllDVs %>%
  select(-Flow_cd) %>%
   gather(variable, value, Flow) %>% 
   unite(VarG, variable, site_no) %>% 
   spread(VarG, value) 

# Adding in some NA's for demonstration only

dataAllDVwide$Flow_07055680[dataAllDVwide$Date %in% seq(as.Date("2015-07-01"),as.Date("2015-07-31"), by="1 day")] <- NA

#create a vector of the Dates from the wide data frame
DatesVec <- dataAllDVwide$Date

library(smwrStats)
candidateVars <- as.matrix(select(dataAllDVwide, -agency_cd, -Date, -Flow_07055680))
Flow_07055680 <- dataAllDVwide$Flow_07055680
bestEstLM <- allReg(x = candidateVars, 
                    y = Flow_07055680, 
                    nmax = 2, nbst = 3, na.rm.x = TRUE)
```

| model.formula                                    |  stderr|    R2|       Cp|      press|
|:-------------------------------------------------|-------:|-----:|--------:|----------:|
| Flow\_07055680 ~ Flow\_07055660                  |   239.8|  89.9|   5877.6|  182925698|
| Flow\_07055680 ~ Flow\_07055646                  |   307.5|  83.4|  11618.7|  300913171|
| Flow\_07055680 ~ Flow\_07056000                  |   319.9|  82.1|  12820.9|  351836293|
| Flow\_07055680 ~ Flow\_07055660 + Flow\_07056000 |   147.4|  96.2|    338.2|   76013602|
| Flow\_07055680 ~ Flow\_07055660 + Flow\_07056700 |   162.8|  95.4|   1081.0|   87505474|
| Flow\_07055680 ~ Flow\_07055646 + Flow\_07056000 |   203.8|  92.7|   3405.8|  148914484|

``` r
#how does that compare to log10 transforms, but first deal with 0's
#which sites have 0's
#site 07055660 has 0's, set those to NA
dataAllDVwide$Flow_07055660[dataAllDVwide$Flow_07055660 == 0] <- NA
candidateVars <- as.matrix(select(dataAllDVwide, -agency_cd, -Date, -Flow_07055680))
bestEstLMl10 <- allReg(x = log10(candidateVars), 
                       y = log10(Flow_07055680), 
                       nmax = 2, nbst = 3, na.rm.x = TRUE)
```

| model.formula                                           |  stderr|    R2|      Cp|  press|
|:--------------------------------------------------------|-------:|-----:|-------:|------:|
| log10(Flow\_07055680) ~ Flow\_07055660                  |     0.2|  93.4|  2366.0|  118.3|
| log10(Flow\_07055680) ~ Flow\_07056000                  |     0.2|  90.7|  4585.0|  166.8|
| log10(Flow\_07055680) ~ Flow\_07056700                  |     0.3|  88.8|  6146.5|  201.1|
| log10(Flow\_07055680) ~ Flow\_07055660 + Flow\_07056000 |     0.2|  96.1|   190.8|   70.6|
| log10(Flow\_07055680) ~ Flow\_07055660 + Flow\_07056700 |     0.2|  96.0|   223.2|   71.3|
| log10(Flow\_07055680) ~ Flow\_07055646 + Flow\_07055660 |     0.2|  94.4|  1574.7|  101.2|

``` r
#adj R-squared doesn't change much, Cp is reduced with the log transforms, so stick with that and create the regression
lm5680 <- lm(log10(Flow_07055680) ~ log10(Flow_07055660) + log10(Flow_07056000), 
             data = dataAllDVwide)
summary(lm5680)
```

    ## 
    ## Call:
    ## lm(formula = log10(Flow_07055680) ~ log10(Flow_07055660) + log10(Flow_07056000), 
    ##     data = dataAllDVwide)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.71684 -0.06800  0.00101  0.07017  0.86477 
    ## 
    ## Coefficients:
    ##                       Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)          -0.236822   0.017400  -13.61   <2e-16 ***
    ## log10(Flow_07055660)  0.506145   0.007868   64.33   <2e-16 ***
    ## log10(Flow_07056000)  0.488242   0.010784   45.27   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.1526 on 3018 degrees of freedom
    ##   (41 observations deleted due to missingness)
    ## Multiple R-squared:  0.9607, Adjusted R-squared:  0.9607 
    ## F-statistic: 3.687e+04 on 2 and 3018 DF,  p-value: < 2.2e-16

``` r
#use the regression to predict some new DVs for site 07055680
pred5680 <- 10^predict(lm5680, dataAllDVwide)

#create a new data frame of the observed and estimated data
comp5680 <- data.frame(Date = DatesVec, 
                       Observed = Flow_07055680, 
                       Estimated.lm = pred5680)

#look at the data
pLmEst <- ggplot(data = comp5680, aes(x = Date)) +
  geom_line(aes(y = Observed, color = "Observed"),size=1.25) +
  geom_line(aes(y = Estimated.lm, color = "Estimated.lm"),size=1.25) +
  scale_y_log10() +
  annotation_logticks(sides = "rl") +
  labs(x = "Date", y = expression(paste(Discharge, ", ", ft^{3}/s))) +
  theme_bw() + 
  scale_x_date(limits = c(as.Date("2015-06-01"), as.Date("2015-08-31"))) +
  theme(legend.title = element_blank())


pLmEst
```

<img src='/static/peak-flow-analysis/unnamed-chunk-16-1.png'/ title='TODO' alt='TODO' class=''/>

``` r
#estimates for July look reasonable, look at another method, MOVE.2 with log10 distribution
#createa and print the model
m2lc5680 <- move.2(formula = Flow_07055680 ~ Flow_07055660, 
                   data = dataAllDVwide, 
                   distribution = "commonlog")

#estimate DVs using the move.2 model
comp5680$Estimated.m2lc <- predict(m2lc5680, dataAllDVwide)

#before comparing the OLS regression with MOVE.2 using common log distribution, now use MOVE.2 with the optimized Box-Cox transformations
#first, get the optimized Box-Cox tranformations
optBC5680 <- optimBoxCox(dataAllDVwide[c("Flow_07055680", "Flow_07055660")])
m2obc5680 <- move.2(formula = Flow_07055680 ~ Flow_07055660, 
                    data = dataAllDVwide, distribution = optBC5680)

#estimate DVs using the move.2 model with the Box-Cox distribution
comp5680$Estimated.m2obc <- predict(m2obc5680, dataAllDVwide)

#look at the data
pLmEst <- ggplot(data = comp5680, aes(x = Date)) +
  geom_line(aes(y = Observed, color = "Observed"),size=1.25) +
  geom_line(aes(y = Estimated.lm, color = "Estimated.lm"),size=1.25) +
  geom_line(aes(y = Estimated.m2lc, color = "Estimated.m2lc"),size=1.25) +
  geom_line(aes(y = Estimated.m2obc, color = "Estimated.m2obc"),size=1.25) +
  scale_y_log10() +
  annotation_logticks(sides = "rl") +
  labs(x = "Date", y = expression(paste(Discharge, ", ", ft^{3}/s))) +
  theme_bw() + 
  scale_x_date(limits = c(as.Date("2015-06-01"), as.Date("2015-08-31"))) +
  scale_y_log10(limits = c(10, 2000)) +
  theme(legend.title = element_blank())

pLmEst
```

<img src='/static/peak-flow-analysis/unnamed-chunk-17-1.png'/ title='TODO' alt='TODO' class=''/>

``` r
#create a function to "smooth" the estimated data for July, 2015 by the first and last residual
adjResid <- function(x, y, dates) {
  diffDates <- as.numeric(dates[length(dates)]) - as.numeric(dates[1])
  allResids <- y - x
  lftRsd <- allResids[1]
  rghtRsd <- allResids[(length(allResids))]
  slopeRsd <- (rghtRsd - lftRsd) / diffDates
  adjResid <- lftRsd + slopeRsd*(as.numeric(dates) - as.numeric(dates[1]))
  smoothed <- x + adjResid
  return(smoothed)
}

#get a subset of the data to "smooth" that starts one day before and ends one day after the missing period
forSmooth <- filter(comp5680, Date >= as.Date("2015-06-01") & Date <= as.Date("2015-08-31"))

#apply the function to the data
forSmooth$Smoothed.lm <- adjResid(x = forSmooth$Estimated.lm, 
                                  y = forSmooth$Observed, 
                                  dates = forSmooth$Date)

#now lets look at the data
pLmSmooth <- ggplot(data = forSmooth, aes(x = Date)) +
  geom_line(aes(y = Observed, color = "Observed"),size=1.25) +
  geom_line(aes(y = Estimated.lm, color = "Estimated.lm"),size=1.25) +
  geom_line(aes(y = Estimated.m2lc, color = "Estimated.m2lc"),size=1.25) +
  geom_line(aes(y = Estimated.m2obc, color = "Estimated.m2obc"),size=1.25) +
  geom_line(aes(y = Smoothed.lm, color = "Smoothed.lm"),size=1.5) +
  scale_y_log10() +
  annotation_logticks(sides = "rl") +
  labs(x = "Date", y = expression(paste(Discharge, ", ", ft^{3}/s))) +
  theme_bw() +
  theme(legend.title = element_blank())

pLmSmooth
```

<img src='/static/peak-flow-analysis/unnamed-chunk-18-1.png'/ title='TODO' alt='TODO' class=''/>

Questions
---------

Please direct any questions or comments on `dataRetrieval` to: <https://github.com/USGS-R/dataRetrieval/issues>
