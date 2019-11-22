---
author: 
date: 2019-11-22
slug: pivot
draft: True
title: Using R to prepare your Excel file
type: post
categories: Data Science
 
author_twitter: DeCiccoDonk
author_github: ldecicco-usgs
author_gs: jXd0feEAAAAJ
 
author_staff: laura-decicco
author_email: <a href="mailto:ldecicco@usgs.gov" class="email">ldecicco@usgs.gov</a>

tags: 
  - R
 
 
description: Convert wide water quality data wide to long.
keywords:
  - R
 
 
  - tidyr
 
---
This article will walk through prepping your data and exporting it to a
Microsoft™ Excel file using R. This article will focus on using
functions and techniques from the “tidyverse” collection of R packages
(`dplyr` + `tidyr` + many others…).

Pivot from wide to long
-----------------------

It is very common for environmental chemistry data to come back from the
laboratory in a “wide” format. A wide format typically has a few
“header” columns such as site and date with additional columns
representing a sigle chemical per column and possibly a remark code for
each chemical as a separate column. The remark column could indicate
censored data (ie “below detection limit”) or some information about the
sampling conditions. We can use the `tidyr` package to “pivot” this data
to the required long format used in `toxEval`.

Let’s start with the most simple case, a wide data frame with no remark
codes. In this simple example, column “a” represents the measured value
of “a” and column “b” represents the measured value of “b”:

``` r
df_simple <- data.frame(
  site = c("A","A","B","B"),
  date = as.Date(Sys.Date():(Sys.Date()-3), 
                 origin = "1970-01-01"),
  a = c(1:4),
  b = c(4:1),
  stringsAsFactors = FALSE
)
df_simple
```

    ##   site       date a b
    ## 1    A 2019-11-22 1 4
    ## 2    A 2019-11-21 2 3
    ## 3    B 2019-11-20 3 2
    ## 4    B 2019-11-19 4 1

The “long” version of this data frame will still have the “site” and
“date” columns, but instead of “a”, “b” (and potentially many many
more…), it will now have “Chemical” and “Value”. To do this
programatically, we can use the `pivot_longer` function in `tidyr`:

``` r
library(tidyr)
library(dplyr)

df_simple_long <- df_simple %>% 
  pivot_longer(cols = c(-site, -date),
               names_to = "Chemical",
               values_to = "Value")
head(df_simple_long)
```

    ## # A tibble: 6 x 4
    ##   site  date       Chemical Value
    ##   <chr> <date>     <chr>    <int>
    ## 1 A     2019-11-22 a            1
    ## 2 A     2019-11-22 b            4
    ## 3 A     2019-11-21 a            2
    ## 4 A     2019-11-21 b            3
    ## 5 B     2019-11-20 a            3
    ## 6 B     2019-11-20 b            2

The “names\_to” argument is the name given to the column that is
populated from the wide column names (so, the chemical names). The
“values\_to” is the column name for the values populated from the
chemical columns.

Let’s make a more complicated wide data that now has the “a” and “b”
measured values, but also has “a” and “b” remark codes:

``` r
df_with_rmks <- data.frame(
  site = c("A","A","B","B"),
  date = as.Date(Sys.Date():(Sys.Date()-3), 
                 origin = "1970-01-01"),
  a_value = c(1:4),
  a_rmk = c("<","","",""),
  b_value = c(4:1),
  b_rmk = c("","","","<"),
  stringsAsFactors = FALSE
)
df_with_rmks
```

    ##   site       date a_value a_rmk b_value b_rmk
    ## 1    A 2019-11-22       1     <       4      
    ## 2    A 2019-11-21       2             3      
    ## 3    B 2019-11-20       3             2      
    ## 4    B 2019-11-19       4             1     <

We can use the “pivot\_longer” function again to make this into a long
data frame with the columns: site, date, Chemical, value, remark:

``` r
library(tidyr)
df_long_with_rmks <- df_with_rmks %>% 
  pivot_longer(cols = c(-site, -date), 
               names_to = c("Chemical", ".value"),
               names_pattern = "(.+)_(.+)")

head(df_long_with_rmks)
```

    ## # A tibble: 6 x 5
    ##   site  date       Chemical value rmk  
    ##   <chr> <date>     <chr>    <int> <chr>
    ## 1 A     2019-11-22 a            1 <    
    ## 2 A     2019-11-22 b            4 ""   
    ## 3 A     2019-11-21 a            2 ""   
    ## 4 A     2019-11-21 b            3 ""   
    ## 5 B     2019-11-20 a            3 ""   
    ## 6 B     2019-11-20 b            2 ""

This time, the “names\_to” argument is a vector. Since it’s going to
produce more than a simple name/value combination, we need to tell it
how to make the name/value/remark combinations. We do that using the
“names\_pattern” argument. In this case, `tidyr` is going to look at the
column names (excluding site and date…since we negate those in the
“cols” argument), and try to split the names by the “\_” separator. This
is a very powerful tool…in this case we are saying anything in the first
group (on the left of the “\_”) is the “Chemical” and every matching
group on the right of the “\_” creates new value columns. So with the
columns are: a\_value, a\_rmk, b\_value, b\_rmk - we get a column of
chemicals (a & b), a column of “rmk” values, and a column of “value”
values.

What if the column names didn’t have the "\_value" prepended? This is
more common in our raw data:

``` r
data_example2 <- data.frame(
  site = c("A","A","B","B"),
  date = as.Date(Sys.Date():(Sys.Date()-3), 
                 origin = "1970-01-01"),
  a = c(1:4),
  a_rmk = c("<","","",""),
  b = c(4:1),
  b_rmk = c("","","","<"),
  c = c(3:6),
  c_rmk = rep("",4),
  stringsAsFactors = FALSE
)
data_example2
```

    ##   site       date a a_rmk b b_rmk c c_rmk
    ## 1    A 2019-11-22 1     < 4       3      
    ## 2    A 2019-11-21 2       3       4      
    ## 3    B 2019-11-20 3       2       5      
    ## 4    B 2019-11-19 4       1     < 6

The easiest way to do that would be to add that “\_value”. Keeping in
the “tidyverse” (acknowledging there are other base-R ways that work
well too for the column renames):

``` r
library(dplyr)

data_wide2 <- data_example2 %>% 
  rename_if(!grepl("_rmk", names(.)) &
              names(.) != c("site","date"), 
            list(~ sprintf('%s_value', .))) %>% 
  pivot_longer(cols = c(-site, -date), 
               names_to = c("Chemical", ".value"),
               names_pattern = "(.+)_(.+)")

head(data_wide2)
```

    ## # A tibble: 6 x 5
    ##   site  date       Chemical value rmk  
    ##   <chr> <date>     <chr>    <int> <chr>
    ## 1 A     2019-11-22 a            1 <    
    ## 2 A     2019-11-22 b            4 ""   
    ## 3 A     2019-11-22 c            3 ""   
    ## 4 A     2019-11-21 a            2 ""   
    ## 5 A     2019-11-21 b            3 ""   
    ## 6 A     2019-11-21 c            4 ""

Opening the file
----------------

To open an Excel file in R, use the `readxl` package. There are many
different configurations of Excel files possible.

As one example, let’s say the lab returned the data looking like this:

<img src='/static/pivot/tabIMAGE-1.png'/ title='Wide data that needs to be converted to a long format.' alt='Screen shot of Excel spreadsheet.' />

Let’s break down the issues:

-   Top row contains the CAS
-   2nd row basically contains the useful column headers
-   Need to skip a random 3rd row
-   4th row has 2 column headers for the first 2 columns
-   The data starts in row 5, in a “wide” format
-   The date format is unusual

In this example, we’ll work through these spacing and header issues to
get us to a wide data frame that we can then pivot to a long data frame
as described in the next section.

First, let’s just get the data with no column names:

``` r
library(readxl)
data_no_header <- read_xlsx("static/pivot/Wide data example.xlsx",
                            sheet = "data_from_lab", 
                            skip = 4, col_names = FALSE)
```

`data_no_header` is now a data frame with accurate types (except for
dates…we’ll get that later!), but no column names. We know the first 2
columns are site and date, so we can name those easily:

``` r
names(data_no_header)[1:2] <- c("SiteID", "Sample Date")
```

Now we need to get the CAS values for the column names:

``` r
headers <- read_xlsx("static/pivot/Wide data example.xlsx",
                     sheet = "data_from_lab", 
                     n_max = 1)
# Get rid or first 2 columns:
headers <- headers[,-1:-2]
```

It would be nice to use the first row as the column names in
“data\_no\_header”, but then it would be very confusing what “Code”
means (since it’s repeated). So, let’s remove the “Code”, and just
repeat the chemical names:

``` r
headers <- headers[,which(as.character(headers[1,]) != "Code")]

chem_names <- as.character(headers[1,])

column_names <- rep(chem_names, each = 2)
column_names <- paste0(column_names, c("_code","_Value"))
head(column_names)
```

    ## [1] "Atrazine_code"              "Atrazine_Value"            
    ## [3] "Thiabendazole_code"         "Thiabendazole_Value"       
    ## [5] "1,7-Dimethylxanthine_code"  "1,7-Dimethylxanthine_Value"

Now, we can assign the “column\_names” to the “data\_no\_header”:

``` r
names(data_no_header)[-1:-2] <- column_names
```

Before we pivot this data to the long format (as described above), let’s
transform the “Sample Date” column to an R date time format:

``` r
data_no_header$`Sample Date` <- as.POSIXct(data_no_header$`Sample Date`, 
                                format = "%Y%m%d%H%M")
```

Now let’s pivot this to the long format:

``` r
cleaned_long <- data_no_header %>% 
  pivot_longer(cols = c(-SiteID, -`Sample Date`), 
               names_to = c("Chemical", ".value"),
               names_pattern = "(.+)_(.+)") 
head(cleaned_long)
```

    ## # A tibble: 6 x 5
    ##   SiteID   `Sample Date`       Chemical                 code    Value
    ##   <chr>    <dttm>              <chr>                    <chr>   <dbl>
    ## 1 Upstream 2016-08-01 10:00:00 Atrazine                 <NA>  0.0183 
    ## 2 Upstream 2016-08-01 10:00:00 Thiabendazole            <     0.00410
    ## 3 Upstream 2016-08-01 10:00:00 1,7-Dimethylxanthine     <     0.0877 
    ## 4 Upstream 2016-08-01 10:00:00 10-Hydroxy-amitriptyline <     0.0083 
    ## 5 Upstream 2017-09-07 10:00:00 Atrazine                 <NA>  0.0666 
    ## 6 Upstream 2017-09-07 10:00:00 Thiabendazole            <     0.011

Save to Excel
-------------

The package `openxlsx` can be used to export Excel files. Create a named
list in R, and each of those parts of the list become a Worksheet in
Excel:

``` r
to_Excel <- list(Data = cleaned_long)

library(openxlsx)
write.xlsx(to_Excel,
           file = "cleanedData.xlsx")
```

Disclaimer
==========

This information is preliminary or provisional and is subject to
revision. It is being provided to meet the need for timely best science.
The information has not received final approval by the U.S. Geological
Survey (USGS) and is provided on the condition that neither the USGS nor
the U.S. Government shall be held liable for any damages resulting from
the authorized or unauthorized use of the information.

Any use of trade, firm, or product names is for descriptive purposes
only and does not imply endorsement by the U.S. Government.
