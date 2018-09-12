---
author: Jason C Fisher
date: 2018-09-12
slug: tolcolors
title: Tol Color Schemes
type: post
categories: Data Science
image: static/tolcolors/tolcolors.png
author_github: jfisher-usgs
author_staff: jason-c-fisher
author_email: <jfisher@usgs.gov>
tags:
  - R
  - inlmisc
keywords:
  - R
  - inlmisc
description: Qualitative, diverging, and sequential color schemes by Paul Tol.
draft: True
---



## Introduction

Choosing colors for a graphic is a bit like taking a trip down the rabbit hole,
that is, it can take much longer than expected and be both fun and frustrating at the same time.
Striking a balance between colors that look good to you and your audience is important.
Keep in mind that [color blindness](https://en.wikipedia.org/wiki/Color_blindness)
affects many individuals throughout the world and it is incumbent on you
to choose a color scheme that works in color-blind vision.
Luckily there are a number of excellent R packages
that address this very issue, such as the
[colorspace](https://CRAN.R-project.org/package=colorspace),
[RColorBrewer](https://CRAN.R-project.org/package=RColorBrewer), and
[viridis](https://CRAN.R-project.org/package=viridis) packages.
And because this is R, where diversity is king,
why not offer one more function for creating color blind friendly palettes.

Let me introduce the `GetTolColors` function in the R-package
[inlmisc](https://CRAN.R-project.org/package=inlmisc).
This function generates a vector of colors from qualitative, diverging,
and sequential color schemes by [Paul Tol (2018)](https://personal.sron.nl/~pault/data/colourschemes.pdf).
The original inspiration for developing this function came from
[Peter Carl's blog post](https://tradeblotter.wordpress.com/2013/02/28/the-paul-tol-21-color-salute/)
describing color schemes from an older issue of Paul Tol's Technical Note (issue 2.2, released Dec. 2012).
And the qualitative color schemes described in his blog post found their way into the
`ptol_pal` function in the R-package [ggthemes](https://CRAN.R-project.org/package=ggthemes).
My intent with this document is to exhibit the latest Tol color schemes (issue 3.0, released May 2018) and show
that they are not only visually pleasing but also well thought out.

To get started, install the **inlmisc** package from [CRAN](https://cran.r-project.org/) using the command:


```r
if (system.file(package = "inlmisc", lib.loc = .libPaths()) == "")
  utils::install.packages("inlmisc", dependencies = TRUE)
```

And if you're so inclined, read through the function documentation.


```r
utils::help("GetTolColors", package = "inlmisc")
```

Like almost every other R function used to create a color palette,
`GetTolColors` takes as its first argument the number of colors to be in the returned palette (`n`).
For example, the following command generates a palette of 10 colors using default values for function arguments.


```r
cols <- inlmisc::GetTolColors(n = 10)
print(cols)
```

```
##  [1] "#E8ECFB" "#B997C7" "#824D99" "#4E78C4" "#57A2AC" "#7EB875" "#D0B541"
##  [8] "#E67F33" "#CE2220" "#521A13"
## attr(,"bad")
## [1] "#666666"
## attr(,"call")
## GetTolColors(n = 10, scheme = "smooth rainbow", alpha = NULL, 
##     start = 0, end = 1, bias = 1, reverse = FALSE, blind = NULL, 
##     gray = FALSE)
## attr(,"class")
## [1] "Tol"       "character"
```

Returned from the function is an object of class `"Tol"` that inherits behavior from the `"character"` class.
A Tol-class object is comprised of a character vector of `n` colors and the following attributes:
`"names"`, the informal names assigned to colors in the palette,
where a value of `NULL` indicates that no color names were specified for the scheme;
`"bad"`, the color meant for bad data or data gaps, where a value of `NA` indicates
that no bad color was specified for the scheme; and
`"call"`, the unevaluated function call that can be used to reproduce the palette.

A `plot` method is provided for the Tol class that displays the palette of colors.


```r
plot(cols)
```

<img src='/static/tolcolors/plot-1.png'/ title='Display colors in palette.' alt='Display colors in palette.' class=''/>

The main title for the plot will always indicate the `n` and `scheme` argument values used to create the palette.
Where `scheme` is the name of the color scheme, its default value is `"smooth rainbow"`.
All other arguments are only included in the title if their specified value differs from their default value.
The label positioned below each shaded rectangle gives the informal color name.

## Color Schemes

Tal (2018) defines 13 color schemes:
7 for qualitative data, 3 for diverging data, and 3 for sequential data (table 1).
The maximum number of colors in a generated palette is dependent on the user selected scheme.
For example, the `"discrete rainbow"` scheme can have at most 23 colors in its palette (`n` &le; 23).
Whereas a continuous (or interpolated) version of the `"smooth rainbow"` scheme is available that has
no upper limit on values of `n`.
About half of the schemes include a color meant for bad data.

<table style='width: 90%;'>
<caption><b>Table 1.</b> Suggested data type for color schemes and the characteristics of generated palettes.  <p style='margin: 5px;'></p> <span style='font-size: smaller !important;'> [<b>Data type</b>: is the type of data being represented, either qualitative, diverging, or sequential.  <b>Maximum n</b>: is the maximum number of colors in a generated palette.  And the maximum n value when palette colors are designed for gray-scale conversion is enclosed in parentheses.  <b>Bad data</b>: whether a color has been provided for bad data.  <b>Abbreviations</b>: ---, no limit placed on the number of colors in the palette] </span></caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Data type </th>
   <th style="text-align:left;"> Color scheme </th>
   <th style="text-align:right;"> Maximum n </th>
   <th style="text-align:center;"> Bad data </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Qualitative </td>
   <td style="text-align:left;"> bright </td>
   <td style="text-align:right;"> 7 (3) </td>
   <td style="text-align:center;"> no </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> vibrant </td>
   <td style="text-align:right;"> 7 (4) </td>
   <td style="text-align:center;"> no </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> muted </td>
   <td style="text-align:right;"> 9 (5) </td>
   <td style="text-align:center;"> yes </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> pale </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:center;"> no </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> dark </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:center;"> no </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> light </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:center;"> no </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> ground cover </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:center;"> no </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Diverging </td>
   <td style="text-align:left;"> sunset </td>
   <td style="text-align:right;"> --- </td>
   <td style="text-align:center;"> yes </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> BuRd </td>
   <td style="text-align:right;"> --- </td>
   <td style="text-align:center;"> yes </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> PRGn </td>
   <td style="text-align:right;"> --- </td>
   <td style="text-align:center;"> yes </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sequential </td>
   <td style="text-align:left;"> YlOrBr </td>
   <td style="text-align:right;"> --- </td>
   <td style="text-align:center;"> yes </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> discrete rainbow </td>
   <td style="text-align:right;"> 23 </td>
   <td style="text-align:center;"> yes </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> smooth rainbow </td>
   <td style="text-align:right;"> --- </td>
   <td style="text-align:center;"> yes </td>
  </tr>
</tbody>
</table>

### Qualitative

Qualitative color schemes `"bright"`, `"vibrant"`, `"muted"`, `"pale"`, `"dark"`, and `"light"`
are appropriate for representing nominal or categorical data.


```r
op <- graphics::par(mfrow = c(6, 1), oma = c(0, 0, 0, 0))
plot(inlmisc::GetTolColors(7, scheme = "bright"))
plot(inlmisc::GetTolColors(7, scheme = "vibrant"))
plot(inlmisc::GetTolColors(9, scheme = "muted"))
plot(inlmisc::GetTolColors(6, scheme = "pale"))
plot(inlmisc::GetTolColors(6, scheme = "dark"))
plot(inlmisc::GetTolColors(9, scheme = "light"))
graphics::par(op)
```

<img src='/static/tolcolors/qualitative-1.png'/ title='Qualitative color schemes' alt='Qualitative color schemes' class=''/>

And the `"ground cover"` scheme is a color-blind safe version of the
[AVHRR](http://glcf.umd.edu/data/landcover/data.shtml)
global land cover classification color scheme (Hansen and others, 1998).


```r
op <- graphics::par(oma = c(1, 0, 0, 0), cex = 0.7)
plot(inlmisc::GetTolColors(14, scheme = "ground cover"))
graphics::par(op)
```

<img src='/static/tolcolors/cover-1.png'/ title='Land cover color scheme' alt='Land cover color scheme' class=''/>

Note that schemes `"pale"`, `"dark"`, and `"ground cover"` are intended to be accessed
in their entirety and subset using vector element names.

### Diverging

Diverging color schemes `"sunset"`, `"BuRd"`, and `"PRGn"` are appropriate for representing
quantitative data with progressions outward from a critical midpoint of the data range.


```r
op <- graphics::par(mfrow = c(6, 1), oma = c(0, 0, 0, 0))
plot(inlmisc::GetTolColors( 11, scheme = "sunset"))
plot(inlmisc::GetTolColors(256, scheme = "sunset"))
plot(inlmisc::GetTolColors(  9, scheme = "BuRd"))
plot(inlmisc::GetTolColors(256, scheme = "BuRd"))
plot(inlmisc::GetTolColors(  9, scheme = "PRGn"))
plot(inlmisc::GetTolColors(256, scheme = "PRGn"))
graphics::par(op)
```

<img src='/static/tolcolors/diverging-1.png'/ title='Diverging color schemes' alt='Diverging color schemes' class=''/>

### Sequential

Sequential schemes `"YlOrBr"`, `"discrete rainbow"`, and `"smooth rainbow"` are appropriate for representing
quantitative data that progress from small to large values.


```r
op <- graphics::par(mfrow = c(5, 1), oma = c(0, 0, 0, 0))
plot(inlmisc::GetTolColors(  9, scheme = "YlOrBr"))
plot(inlmisc::GetTolColors(256, scheme = "YlOrBr"))
plot(inlmisc::GetTolColors( 23, scheme = "discrete rainbow"))
plot(inlmisc::GetTolColors( 34, scheme = "smooth rainbow"))
plot(inlmisc::GetTolColors(256, scheme = "smooth rainbow"))
graphics::par(op)
```

<img src='/static/tolcolors/sequential-1.png'/ title='Sequential color schemes' alt='Sequential color schemes' class=''/>


## Alpha Transparency

The transparency (or opacity) of palette colors is specified using the `alpha` argument.
Values range from 0 (fully transparent) to 1 (fully opaque).


```r
op <- graphics::par(mfrow = c(5, 1), oma = c(0, 0, 0, 0))
plot(inlmisc::GetTolColors(34, alpha = 1.0))
plot(inlmisc::GetTolColors(34, alpha = 0.8))
plot(inlmisc::GetTolColors(34, alpha = 0.6))
plot(inlmisc::GetTolColors(34, alpha = 0.4))
plot(inlmisc::GetTolColors(34, alpha = 0.2))
graphics::par(op)
```

<img src='/static/tolcolors/alpha-1.png'/ title='Adjust alpha transparency of colors.' alt='Adjust alpha transparency of colors.' class=''/>

## Color Levels

Color levels are used to limit the range of colors in a scheme---applies only to schemes that can be interpolated,
which includes the `"sunset"`, `"BuRd"`, `"PRGn"`, `"YlOrBr"`, and `"smooth rainbow"` schemes.
Starting and ending color levels are specified using the `start` and `end` arguments, respectively.
Values range from 0 to 1 and represent a fraction of the scheme's color domain.


```r
op <- graphics::par(mfrow = c(4, 1), oma = c(0, 0, 0, 0))
plot(inlmisc::GetTolColors(256, start = 0.0, end = 1.0))
plot(inlmisc::GetTolColors(256, start = 0.0, end = 0.5))
plot(inlmisc::GetTolColors(256, start = 0.5, end = 1.0))
plot(inlmisc::GetTolColors(256, start = 0.3, end = 0.9))
graphics::par(op)
```

<img src='/static/tolcolors/levels-1.png'/ title='Adjust starting and ending color levels.' alt='Adjust starting and ending color levels.' class=''/>

## Interpolation Bias

Interpolation bias is specified using the `bias` argument, where a value of 1 indicates no bias.
Smaller values result in more widely spaced colors at the low end,
and larger values result in more widely spaced colors at the high end.


```r
op <- graphics::par(mfrow = c(7, 1), oma = c(0, 0, 0, 0))
plot(inlmisc::GetTolColors(256, bias = 0.4))
plot(inlmisc::GetTolColors(256, bias = 0.6))
plot(inlmisc::GetTolColors(256, bias = 0.8))
plot(inlmisc::GetTolColors(256, bias = 1.0))
plot(inlmisc::GetTolColors(256, bias = 1.2))
plot(inlmisc::GetTolColors(256, bias = 1.4))
plot(inlmisc::GetTolColors(256, bias = 1.6))
graphics::par(op)
```

<img src='/static/tolcolors/bias-1.png'/ title='Adjust interpolation bias.' alt='Adjust interpolation bias.' class=''/>

## Reverse Colors

Reverse the order of colors in a palette by specifying the `reverse` argument as `TRUE` .


```r
op <- graphics::par(mfrow = c(2, 1), oma = c(0, 0, 0, 0), cex = 0.7)
plot(inlmisc::GetTolColors(10, reverse = FALSE))
plot(inlmisc::GetTolColors(10, reverse = TRUE))
graphics::par(op)
```

<img src='/static/tolcolors/reverse-1.png'/ title='Reverse colors in palette.' alt='Reverse colors in palette.' class=''/>

## Color Blindness

Different types of color blindness can be simulated using the `blind` argument:
specify `"deutan"` for green-blind vision, `"protan"` for red-blind vision,
`"tritan"` for green-blue-blind vision, and `"monochromacy"` for total-color blindness.


```r
op <- graphics::par(mfrow = c(5, 1), oma = c(0, 0, 0, 0))
plot(inlmisc::GetTolColors(34, blind = NULL))
plot(inlmisc::GetTolColors(34, blind = "deutan"))
plot(inlmisc::GetTolColors(34, blind = "protan"))
plot(inlmisc::GetTolColors(34, blind = "tritan"))
plot(inlmisc::GetTolColors(34, blind = "monochromacy"))
graphics::par(op)
```

<img src='/static/tolcolors/blind-1.png'/ title='Adjust for color blindness.' alt='Adjust for color blindness.' class=''/>

With the exception of total-color blindness,
the `"smooth rainbow"` scheme is well suited for the variants of color-vision deficiency.

## Gray-Scale Preparation

Subset the qualitative schemes `"bright"`, `"vibrant"`, and `"muted"`
to work after conversion to gray scale by specifying the `gray` argument as `TRUE`.


```r
op <- graphics::par(mfrow = c(6, 1), oma = c(0, 0, 0, 0))
plot(inlmisc::GetTolColors(3, "bright",  gray = TRUE))
plot(inlmisc::GetTolColors(3, "bright",  gray = TRUE, blind = "m"))
plot(inlmisc::GetTolColors(4, "vibrant", gray = TRUE))
plot(inlmisc::GetTolColors(4, "vibrant", gray = TRUE, blind = "m"))
plot(inlmisc::GetTolColors(5, "muted",   gray = TRUE))
plot(inlmisc::GetTolColors(5, "muted",   gray = TRUE, blind = "m"))
graphics::par(op)
```

<img src='/static/tolcolors/gray-1.png'/ title='Prepare qualitative schemes for gray-scale conversion.' alt='Prepare qualitative schemes for gray-scale conversion.' class=''/>

Note that the sequential scheme `"YlOrBr"` works well for conversion to gray scale.


```r
op <- graphics::par(mfrow = c(2, 1), oma = c(0, 0, 0, 0), cex = 0.7)
plot(inlmisc::GetTolColors(256, "YlOrBr"))
plot(inlmisc::GetTolColors(256, "YlOrBr", blind = "monochromacy"))
graphics::par(op)
```

<img src='/static/tolcolors/ylorbr-1.png'/ title='Prepare YlOrBr scheme for gray-scale conversion.' alt='Prepare YlOrBr scheme for gray-scale conversion.' class=''/>

## References Cited

Hansen, M., DeFries, R., Townshend, J.R.G., and Sohlberg, R., 1998,
UMD Global Land Cover Classification, 1 Kilometer, 1.0:
Department of Geography, University of Maryland, College Park, Maryland, 1981-1994.

Tol, Paul, 2018, Colour Schemes: SRON Technical Note,
doc. no. SRON/EPS/TN/09-002, issue 3.0, 17 p.,
accessed August 29, 2018 at <https://personal.sron.nl/~pault/data/colourschemes.pdf>.

## Reproducibility

R-session information for content in this document is as follows:


```
##  setting  value                       
##  version  R version 3.5.1 (2018-07-02)
##  system   x86_64, mingw32             
##  ui       Rgui                        
##  language (EN)                        
##  collate  English_United States.1252  
##  tz       America/Los_Angeles         
##  date     2018-09-12                  
## 
##  package    * version date       source        
##  backports    1.1.2   2017-12-13 CRAN (R 3.5.0)
##  base       * 3.5.1   2018-07-02 local         
##  checkmate    1.8.5   2017-10-24 CRAN (R 3.5.1)
##  compiler     3.5.1   2018-07-02 local         
##  datasets   * 3.5.1   2018-07-02 local         
##  devtools     1.13.6  2018-06-27 CRAN (R 3.5.1)
##  dichromat    2.0-0   2013-01-24 CRAN (R 3.5.0)
##  digest       0.6.16  2018-08-22 CRAN (R 3.5.1)
##  evaluate     0.11    2018-07-17 CRAN (R 3.5.1)
##  graphics   * 3.5.1   2018-07-02 local         
##  grDevices  * 3.5.1   2018-07-02 local         
##  grid         3.5.1   2018-07-02 local         
##  highr        0.7     2018-06-09 CRAN (R 3.5.1)
##  igraph       1.2.2   2018-07-27 CRAN (R 3.5.1)
##  inlmisc      0.4.3   2018-09-10 CRAN (R 3.5.1)
##  knitr        1.20    2018-02-20 CRAN (R 3.5.1)
##  lattice      0.20-35 2017-03-25 CRAN (R 3.5.1)
##  magrittr     1.5     2014-11-22 CRAN (R 3.5.1)
##  memoise      1.1.0   2017-04-21 CRAN (R 3.5.1)
##  methods    * 3.5.1   2018-07-02 local         
##  pkgconfig    2.0.2   2018-08-16 CRAN (R 3.5.1)
##  rgdal        1.3-4   2018-08-03 CRAN (R 3.5.1)
##  rstudioapi   0.7     2017-09-07 CRAN (R 3.5.1)
##  sp           1.3-1   2018-06-05 CRAN (R 3.5.1)
##  stats      * 3.5.1   2018-07-02 local         
##  stringi      1.2.4   2018-07-20 CRAN (R 3.5.1)
##  stringr      1.3.1   2018-05-10 CRAN (R 3.5.1)
##  tools        3.5.1   2018-07-02 local         
##  utils      * 3.5.1   2018-07-02 local         
##  withr        2.1.2   2018-03-15 CRAN (R 3.5.1)
```
