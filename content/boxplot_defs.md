---
author: Laura DeCicco
date: 2018-08-02
slug: boxplots
draft: True
title: Describing ggplot2 boxplots
type: post
categories: Data Science
image: static/boxplots/visualizeBox-1.png
author_twitter: DeCiccoDonk
author_github: ldecicco-usgs
author_gs: jXd0feEAAAAJ
 
author_staff: laura-decicco
author_email: <ldecicco@usgs.gov>

tags: 
  - R
 
 
description: Identifying boxplot limits in ggplot2.
keywords:
  - R
 
 
  - boxplot
  - ggplot2
---
Box plots are often used to show data distributions, and `ggplot2` is often used to visualize data. A question that comes up is what exactly do the box plots represent? The `ggplot2` box plots follow standard Tukey representations, and there are many references of this online and in standard statistical text books. The base R function to calculate the box plot limits is `boxplot.stats`. The help file for this function is very informative, but it's often non-R users asking what exactly the plot means. Therefore, this blog post breaks down the calculations into (hopefully!) easy-to-follow chunks of code for you to make your own box plot legend if necessary.

We'll set up random data using the R function `sample` and then create a plot to visualize what the lines and dots represent.

Data Setup
----------

``` r
set.seed(100)

sample_df <- data.frame(parameter = "test",
                        values = sample(500))

# Make sure there's only 1 lower outlier:
sample_df$values[1] <- -300

# Extend the top whisker a bit:
sample_df$values[2:50] <- 752:800
```

Boxplot Calculations
--------------------

``` r
ggplot2_boxplot <- function(x){
  
  quartiles <- as.numeric(quantile(x, 
                                   probs = c(0.25, 0.5, 0.75)))
  
  names(quartiles) <- c("25th percentile", 
                        "50th percentile\n(median)",
                        "75th percentile")
  
  IQR <- diff(quartiles[c(1,3)])

  upper_whisker <- max(x[x < (quartiles[3] + 1.5 * IQR)])
  lower_whisker <- min(x[x > (quartiles[1] - 1.5 * IQR)])
    
  upper_dots <- x[x > (quartiles[3] + 1.5*IQR)]
  lower_dots <- x[x < (quartiles[1] - 1.5*IQR)]

  return(list("quartiles" = quartiles,
              "IQR" = IQR,
              "upper_whisker" = upper_whisker,
              "lower_whisker" = lower_whisker,
              "upper_dots" = upper_dots,
              "lower_dots" = lower_dots))
}

ggplot_output <- ggplot2_boxplot(sample_df$values)
ggplot_output
```

    ## $quartiles
    ##           25th percentile 50th percentile\n(median) 
    ##                    132.75                    274.50 
    ##           75th percentile 
    ##                    416.25 
    ## 
    ## $IQR
    ## 75th percentile 
    ##           283.5 
    ## 
    ## $upper_whisker
    ## [1] 800
    ## 
    ## $lower_whisker
    ## [1] 1
    ## 
    ## $upper_dots
    ## numeric(0)
    ## 
    ## $lower_dots
    ## [1] -300

Let's check that the output matches `boxplot.stats`:

``` r
# Using base R:
base_R_output <- boxplot.stats(sample_df$values)

# Some checks:

# Outliers:
all(c(ggplot_output[["upper_dots"]], 
      ggplot_output[["lowerdots"]]) %in%
    c(base_R_output[["out"]]))
```

    ## [1] TRUE

``` r
# whiskers:
ggplot_output[["upper_whisker"]] == base_R_output[["stats"]][5]
```

    ## [1] TRUE

``` r
ggplot_output[["lower_whisker"]] == base_R_output[["stats"]][1]
```

    ## [1] TRUE

Boxplot Visualization
---------------------

Let's plot that information. There is a lot of `ggplot2` code to digest here. Most of it is style adjustments to approximate USGS style guidelines.

``` r
library(ggplot2)

explain_plot <- ggplot() +
  stat_boxplot(data = sample_df,
               aes(x = parameter, y=values),
               geom ='errorbar', width = 0.3) +
  geom_boxplot(data = sample_df, 
               aes(x = parameter, y=values), 
               width = 0.3, fill = "lightgrey") +
  theme_minimal() +
  geom_segment(aes(x = 2.6, xend = 2.6, 
                   y = ggplot_output[["quartiles"]][1], 
                   yend = ggplot_output[["quartiles"]][3])) +
  geom_segment(aes(x = 1.2, xend = 2.6, 
                   y = ggplot_output[["quartiles"]][1], 
                   yend = ggplot_output[["quartiles"]][1])) +
  geom_segment(aes(x = 1.2, xend = 2.6, 
                   y = ggplot_output[["quartiles"]][3], 
                   yend = ggplot_output[["quartiles"]][3])) +
  geom_text(aes(x = 2.65, y = ggplot_output[["quartiles"]][2]), 
            label = "Interquartile\nrange", fontface = "bold",
            hjust = 0, vjust = 0.4) +
  geom_text(aes(x = c(1.17,1.17), 
                y = c(ggplot_output[["upper_whisker"]],
                      ggplot_output[["lower_whisker"]]), 
                label = c("Largest value within 1.5 times\ninterquartile range above\n75th percentile",
                          "Smallest value within 1.5 times\ninterquartile range below\n25th percentile"),
                fontface = "bold"),
            hjust = 0, vjust = 0.9) +
  geom_text(aes(x = c(1.075), 
                y =  ggplot_output[["lower_dots"]], 
                label = "Outside value"), 
            hjust = 0, vjust = 0.5, fontface = "bold") +
  geom_text(aes(x = c(2.1), 
                y =  ggplot_output[["lower_dots"]], 
                label = "-Value is >1.5 times"), 
            hjust = 0, vjust = 0.5) +
  geom_text(aes(x = 1.075, 
                y = ggplot_output[["lower_dots"]], 
                label = "<3 times the interquartile range\nbeyond either end of the box"), 
            hjust = 0, vjust = 1.5) +
  geom_label(aes(x = 1.17, y = ggplot_output[["quartiles"]], 
                label = names(ggplot_output[["quartiles"]])),
            vjust = c(0.4,0.85,0.4), hjust = 0, 
            fill = "white", label.size = 0) +
  ylab("") + xlab("") +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        text = element_text(family = "Times", size = 9),
        plot.title = element_text(hjust = 0.5),
        plot.margin = unit(c(1,0,1,0), "cm")) +
  coord_cartesian(xlim = c(1.4,3), ylim = c(-600, 1000))


explain_plot +
  labs(title = "EXPLANATION")
```

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

<img src='/static/boxplots/visualizeBox-1.png'/ title='ggplot2 box plot with explanation.' alt='ggplot2 box plot with explanation.' />

Making a legend
---------------

Let's say you have a requirement to add a legend to your box plots. The easiest way using the code above would be to use the package `cowplot`:

``` r
library(dplyr)
library(cowplot)

starwars <- starwars

# Reduce data to homeworlds with several characters:
starwars <- starwars %>%
  group_by(homeworld) %>%
  filter(n() > 5)

size_dist <- ggplot(data = starwars, aes(x = homeworld, y = mass)) +
  stat_boxplot(geom ='errorbar', width = 0.3) +
  geom_boxplot(width = 0.3, fill = "lightgrey") +
  expand_limits(y = 0) +
  theme_bw() + 
  scale_y_continuous(sec.axis = dup_axis(label = NULL, 
                                         name = NULL),
                     expand = expand_scale(mult = c(0, 0.01)),
                     breaks = pretty(starwars$mass, n = 5)) +
  theme(panel.grid = element_blank(),
        plot.title = element_text(hjust = 0.5),
        text = element_text(family = "Times", size = 9),
        axis.ticks.length = unit(-0.25, "cm"),
        axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), 
        axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")),
        axis.ticks.x = element_blank()) 

plot_grid(size_dist, 
          explain_plot + labs(title = "EXPLANATION"),
          nrow = 1, rel_widths = c(.6,.4))
```

    ## Warning: Removed 14 rows containing non-finite values (stat_boxplot).

    ## Warning: Removed 14 rows containing non-finite values (stat_boxplot).

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call.graphics(C_text, as.graphicsAnnot(x$label), x$x, x
    ## $y, : font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

    ## Warning in grid.Call(C_textBounds, as.graphicsAnnot(x$label), x$x, x$y, :
    ## font family not found in Windows font database

<img src='/static/boxplots/withLegend-1.png'/ title='TODO' alt='TODO' />
