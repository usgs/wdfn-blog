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
Boxplots are often used to show data distributions, and `ggplot2` is often used to visualize data. A question that comes up is what exactly do the box plots represent? The `ggplot2` box plots follow standard Tukey representations, and there are many references of this online and in standard statistical text books. The base R function to calculate the box plot limits is `boxplot.stats`. The help file for this function is very informative, but it's often non-R users asking what exactly the plot means. Therefore, this blog post breaks down the calculations into (hopefully!) easy-to-follow chunks of code for you to make your own box plot legend if necessary. Some additional goals here are to create the boxplots *close* to USGS style.

I'm going to start this post backwards and show the results first. Let's get some chloride data (parameter code "00940") from a USGS station in Green Bay, WI (station ID "04085139"). We'll use the package `dataRetrieval` to get the data (see [this tutorial](https://owi.usgs.gov/R/dataRetrieval.html) for more information on `dataRetrieval`), and plot a simple boxplot by month using `ggplot2`:

``` r
library(dataRetrieval)
library(ggplot2)

chloride <- readNWISqw("04085139", "00940")
chloride$month <- month.abb[as.numeric(format(chloride$sample_dt, "%m"))]
chloride$month <- factor(chloride$month, labels = month.abb)

ggplot() +
  geom_boxplot(data = chloride, aes(x = month, y = result_va))
```

<img src='/static/boxplots/getChoride-1.png'/ title='TODO' alt='TODO' />

Now I'll use some code that will be described below to create the same plot, but getting closer to USGS style guidelines including a boxplot legend:

``` r
library(cowplot)
library(dplyr)

counts <- chloride %>%
  group_by(month) %>%
  summarize(counts = n())

legend_plot <- ggplot_box_legend()

chloride_plot <- ggplot(data = chloride, aes(x = month, y = result_va)) +
  stat_boxplot(geom ='errorbar', width = 0.6) +
  geom_boxplot(width = 0.6, fill = "lightgrey") +
  geom_text(data = counts, aes(x = month, y = 65, label = counts),
            size = 3, family = "sans") +
  expand_limits(y = 0) +
  theme_bw() + 
  xlab("Month") +
  ylab(attr(chloride, "variableInfo")[["parameter_nm"]]) +
  labs(title = attr(chloride, "siteInfo")[["station_nm"]]) +
  scale_y_continuous(sec.axis = dup_axis(label = NULL, 
                                         name = NULL),
                     expand = expand_scale(mult = c(0, 0)),
                     breaks = pretty(c(0,chloride$result_va, 70), n = 5), 
                     limits = c(0,70)) +
  theme(panel.grid = element_blank(),
        text = element_text(family = "sans", size = 9),
        axis.ticks.length = unit(-0.05, "in"),
        axis.text.y = element_text(margin=unit(c(0.3,0.3,0.3,0.3), "cm")), 
        axis.text.x = element_text(margin=unit(c(0.3,0.3,0.3,0.3), "cm")),
        axis.ticks.x = element_blank()) 

plot_grid(chloride_plot, 
          legend_plot,
          nrow = 1, rel_widths = c(.6,.4))
```

<img src='/static/boxplots/chlorideWithLegend-1.png'/ title='Chloride by month styled.' alt='TODO' />

What are some of the notable style additions to this graph?

-   Ticks on the inside of the graph, and on both left and right side (see `?dup_axis`).
-   No ticks for discrete scales.
-   y-limit start at zero, and zero is labeled.
-   Whiskers have horizontal line (see `?stat_boxplot`)
-   Detailed legend

So how do we create the function `ggplot_box_legend`? First, let's create a function to calculate the important features of a boxplot.

Boxplots values
===============

We'll set up random data using the R function `sample` and then create a function to calculate the values for the lines and dots.

Data Setup
----------

``` r
set.seed(100)

sample_df <- data.frame(parameter = "test",
                        values = sample(500))

# Extend the top whisker a bit:
sample_df$values[1:100] <- 701:800
# Make sure there's only 1 lower outlier:
sample_df$values[1] <- -350
```

Boxplot Calculations
--------------------

Next, we'll create a function that calculates the necessary values for the boxplots:

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
```

What are those calculations?

-   Quartiles (25, 50, 75 percentiles), 50% is the median
-   Interquartile range is the difference between the 75th and 25th percentiles
-   The upper whisker is the maximum value of the data that is within 1.5 times the interquartile range over the 75th percentile.
-   The lower whisker is the minimum value of the data that is within 1.5 times the interquartile range under the 25th percentile.
-   Outlier values are considered any values over 1.5 times the interquartile range over the 75th percentile or any values under 1.5 times the interquartile range under the 25th percentile.

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

Let's plot that information, and while we're at it, we can make the function used in the first plot. There is a *lot* of `ggplot2` code to digest here. Most of it is style adjustments to approximate USGS style guidelines and requirements for legends. The `cowplot` package makes it easy to bind two or more `ggplot2` objects. We can make a

``` r
ggplot_box_legend <- function(){
  set.seed(100)

  sample_df <- data.frame(parameter = "test",
                        values = sample(500))

  # Extend the top whisker a bit:
  sample_df$values[1:100] <- 701:800
  # Make sure there's only 1 lower outlier:
  sample_df$values[1] <- -350
  
  ggplot_output <- ggplot2_boxplot(sample_df$values)
  
  explain_plot <- ggplot() +
    stat_boxplot(data = sample_df,
                 aes(x = parameter, y=values),
                 geom ='errorbar', width = 0.3) +
    geom_boxplot(data = sample_df,
                 aes(x = parameter, y=values), 
                 width = 0.3, fill = "lightgrey") +
    geom_text(aes(x = 1, y = 950, label = "500"), size = 3) +
    geom_text(aes(x = 1.17, y = 950,
                  label = "Number of values"),
              fontface = "bold", hjust = 0, vjust = 0.4, size = 3) +
    theme_minimal(base_size = 5) +
    geom_segment(aes(x = 2.3, xend = 2.3, 
                     y = ggplot_output[["quartiles"]][1], 
                     yend = ggplot_output[["quartiles"]][3])) +
    geom_segment(aes(x = 1.2, xend = 2.3, 
                     y = ggplot_output[["quartiles"]][1], 
                     yend = ggplot_output[["quartiles"]][1])) +
    geom_segment(aes(x = 1.2, xend = 2.3, 
                     y = ggplot_output[["quartiles"]][3], 
                     yend = ggplot_output[["quartiles"]][3])) +
    geom_text(aes(x = 2.4, y = ggplot_output[["quartiles"]][2]), 
              label = "Interquartile\nrange", fontface = "bold",
              hjust = 0, vjust = 0.4, size = 3) +
    geom_text(aes(x = c(1.17,1.17), 
                  y = c(ggplot_output[["upper_whisker"]],
                        ggplot_output[["lower_whisker"]]), 
                  label = c("Largest value within 1.5 times\ninterquartile range above\n75th percentile",
                            "Smallest value within 1.5 times\ninterquartile range below\n25th percentile")),
                  fontface = "bold", hjust = 0, vjust = 0.9, size = 3) +
    geom_text(aes(x = c(1.17), 
                  y =  ggplot_output[["lower_dots"]], 
                  label = "Outside value"), 
              hjust = 0, vjust = 0.5, fontface = "bold", size = 3) +
    geom_text(aes(x = c(2.1), 
                  y =  ggplot_output[["lower_dots"]], 
                  label = "-Value is >1.5 times and"), 
              hjust = 0, vjust = 0.5, size = 3) +
    geom_text(aes(x = 1.17, 
                  y = ggplot_output[["lower_dots"]], 
                  label = "<3 times the interquartile range\nbeyond either end of the box"), 
              hjust = 0, vjust = 1.5, size = 3) +
    geom_label(aes(x = 1.17, y = ggplot_output[["quartiles"]], 
                  label = names(ggplot_output[["quartiles"]])),
              vjust = c(0.4,0.85,0.4), hjust = 0, 
              fill = "white", label.size = 0, size = 3) +
    ylab("") + xlab("") +
    theme(axis.text = element_blank(),
          axis.ticks = element_blank(),
          panel.grid = element_blank(),
          text = element_text(family = "sans"),
          plot.title = element_text(hjust = 0.5, size = 10),
          plot.margin = unit(c(1,0,1,0), "cm")) +
    coord_cartesian(xlim = c(1.4,3.1), ylim = c(-600, 1000)) +
    labs(title = "EXPLANATION")

  return(explain_plot) 
  
}

ggplot_box_legend()
```

<img src='/static/boxplots/visualizeBox-1.png'/ title='ggplot2 box plot with explanation.' alt='ggplot2 box plot with explanation.' />

For another example, let's take a quick look at some data included in the `dplyr` package:

``` r
explain_plot <- ggplot_box_legend()

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
          explain_plot,
          nrow = 1, rel_widths = c(.6,.4))
```

<img src='/static/boxplots/starWars-1.png'/ title='Star wars character's mass distribution by planet.' alt='TODO' />
