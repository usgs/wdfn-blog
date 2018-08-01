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
Box plots are often used to show data distributions, and `ggplot2` is often used to visualize data. A question that often comes up is what exactly do the box plots represent? The `ggplot2` box plots follow standard Tukey representations, and there are many references of this online and in standard statistical text books.

This blog post simply creates some random data using the R function `rnorm`, and demonstrates what the lines and dots represent. First, let's set up a simple data frame:

``` r
sample_df <- data.frame(parameter = "test",
                        values = rnorm(510, mean = 500, sd = 300))

#Make sure there are some outliers:
sample_df$values[1] <- 1000
sample_df$values[2] <- 900
sample_df$values[3] <- -200
sample_df$values[4] <- -600
```

Next, we calculate the important limits, and put those values into another data frame (lablel\_df):

``` r
quartiles <- as.numeric(quantile(sample_df$values))
IQR <- diff(quartiles[c(2,4)])

upper_whisker <- max(sample_df$values[sample_df$values <
                           (quartiles[4] + 1.5 * IQR)])
lower_whisker <- min(sample_df$values[sample_df$values >
                           (quartiles[2] - 1.5 * IQR)])
  
upper_dots <- sample_df$values[sample_df$values > 
                            quartiles[4] + 1.5*IQR]
lower_dots <- sample_df$values[sample_df$values < 
                            quartiles[2] - 1.5*IQR]

label_df <- data.frame(parameter = "explaination",
                       values = c(quartiles,
                                  upper_whisker,
                                  lower_whisker),
                       names = c("Minimum", 
                                 "Q1 = 25th percentile", "Median",
                                 "Q3 = 75th percentile", "Maximum","",""))
```

Finally, let's plot that information:

``` r
library(ggplot2)

ggplot() +
  geom_hline(yintercept = label_df$values,linetype="dashed", color = "lightgrey") +
  geom_boxplot(data = sample_df, aes(x = parameter, y=values), width = 0.2) +  theme_bw() +
  geom_text(data = label_df, aes(x = 0.75, y = values, label = names), vjust = 0.4) +
  geom_segment(aes(x = 1.15, xend = 1.15, 
                   y = label_df$values[2], yend = label_df$values[4]),
               arrow = arrow(length = unit(0.2, "cm"), ends = "both")) +
  geom_text(aes(x = 1.25, y = label_df$values[3]), 
            label = "IQR = Q3-Q1", hjust = 0.2, vjust = 0.4) +
  geom_text(aes(x = c(1.1,1.1), y = label_df$values[6:7]), 
            label = c(bquote(italic(max)*"(y[y < (Q3 + 1.5*IQR)])"),
                      bquote(italic(min)*"(y[y > (Q1 - 1.5*IQR)])")), 
            hjust = 0, vjust = 0.4, parse = TRUE) +
  geom_text(aes(x = c(1.1), y = mean(upper_dots)), 
            label = "upper dots > Q3 + 1.5*IQR", hjust = 0, vjust = 0.4) +
  geom_text(aes(x = c(1.1), y = mean(lower_dots)), 
            label = "lower dots < Q1 - 1.5*IQR", hjust = 0, vjust = 0.4) +
  ylab("") + xlab("") + 
  labs(title = "ggplot2 boxplot explanation", 
       caption = bquote(italic("Q = quartiles, IQR = Interquartile range, y = data"))) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())
```

<img src='/static/boxplots/visualizeBox-1.png'/ title='ggplot2 box plot with explanation.' alt='ggplot2 box plot with explanation.' />
