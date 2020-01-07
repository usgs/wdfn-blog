---
author: 
date: 2020-01-07
slug: pivot
draft: True
title: Using R to pivot wide water-quality data
type: post
categories: Data Science
author_twitter: DeCiccoDonk
author_github: ldecicco-usgs
author_gs: jXd0feEAAAAJ
author_staff: laura-decicco
author_email: <ldecicco@usgs.gov>

tags: 
  - R
 
description: Convert wide water quality data wide to long with new tidyverse convention.
keywords:
  - R
  - tidyverse
  - pivot
 
---
This article will walk through prepping water-quality chemistry data formatted in a “wide” configuration and exporting it to a Microsoft™ Excel “long” file using R. This article will focus on using functions and techniques from the “tidyverse” collection of R packages (`dplyr` + `tidyr` + others…).

Pivot from wide to long
-----------------------

It is very common for environmental chemistry data to come back from the laboratory in a “wide” format. A wide format typically has a few “header” columns such as site and date with additional columns representing a single chemical per column and possibly a remark code for each chemical as a separate column. The remark column could indicate censored data (ie “below detection limit”) or some information about the sampling conditions. We can use the `tidyr` package to “pivot” this data to the required long format used in `toxEval`.

Let’s start with the most simple case, a wide data frame with no remark codes. In this simple example, column “Phosphorus” represents measured phosphorus values, and column “Nitrate” represents measured nitrate values:

``` r
df_simple <- data.frame(
  site = c("A","A","B","B"),
  date = as.Date(Sys.Date():(Sys.Date()-3), 
                 origin = "1970-01-01"),
  Phosphorus = c(1:4),
  Nitrate = c(4:1),
  stringsAsFactors = FALSE
)
```

| site | date       |  Phosphorus|  Nitrate|
|:-----|:-----------|-----------:|--------:|
| A    | 2020-01-07 |           1|        4|
| A    | 2020-01-06 |           2|        3|
| B    | 2020-01-05 |           3|        2|
| B    | 2020-01-04 |           4|        1|

The “long” version of this data frame will still have the “site” and “date” columns, but instead of “Phosphorus”, “Nitrate” (and potentially many many more…), it will now have “Chemical” and “Value”. To do this programatically, we can use the `pivot_longer` function in `tidyr`:

``` r
library(tidyr)
library(dplyr)

df_simple_long <- df_simple %>% 
  pivot_longer(cols = c(-site, -date),
               names_to = "Chemical",
               values_to = "Value")
```

| site | date       | Chemical   |  Value|
|:-----|:-----------|:-----------|------:|
| A    | 2020-01-07 | Phosphorus |      1|
| A    | 2020-01-07 | Nitrate    |      4|
| A    | 2020-01-06 | Phosphorus |      2|
| A    | 2020-01-06 | Nitrate    |      3|
| B    | 2020-01-05 | Phosphorus |      3|
| B    | 2020-01-05 | Nitrate    |      2|
| B    | 2020-01-04 | Phosphorus |      4|
| B    | 2020-01-04 | Nitrate    |      1|

The “names\_to” argument is the name given to the column that is populated from the wide column names (so, the chemical names). The “values\_to” is the column name for the values populated from the chemical columns.

Let’s make a more complicated wide data that now has the “Phosphorus” and “Nitrate” measured values, but also has “Phosphorus” and “Nitrate” remark codes:

``` r
df_with_rmks <- data.frame(
  site = c("A","A","B","B"),
  date = as.Date(Sys.Date():(Sys.Date()-3), 
                 origin = "1970-01-01"),
  Phosphorus_value = c(1:4),
  Phosphorus_rmk = c("<","","",""),
  Nitrate_value = c(4:1),
  Nitrate_rmk = c("","","","<"),
  stringsAsFactors = FALSE
)
```

| site | date       |  Phosphorus\_value| Phosphorus\_rmk |  Nitrate\_value| Nitrate\_rmk |
|:-----|:-----------|------------------:|:----------------|---------------:|:-------------|
| A    | 2020-01-07 |                  1| \<              |               4|              |
| A    | 2020-01-06 |                  2|                 |               3|              |
| B    | 2020-01-05 |                  3|                 |               2|              |
| B    | 2020-01-04 |                  4|                 |               1| \<           |

We can use the “pivot\_longer” function again to make this into a long data frame with the columns: site, date, Chemical, value, remark:

``` r
library(tidyr)
df_long_with_rmks <- df_with_rmks %>% 
  pivot_longer(cols = c(-site, -date), 
               names_to = c("Chemical", ".value"),
               names_pattern = "(.+)_(.+)")
```

| site | date       | Chemical   |  value| rmk |
|:-----|:-----------|:-----------|------:|:----|
| A    | 2020-01-07 | Phosphorus |      1| \<  |
| A    | 2020-01-07 | Nitrate    |      4|     |
| A    | 2020-01-06 | Phosphorus |      2|     |
| A    | 2020-01-06 | Nitrate    |      3|     |
| B    | 2020-01-05 | Phosphorus |      3|     |
| B    | 2020-01-05 | Nitrate    |      2|     |
| B    | 2020-01-04 | Phosphorus |      4|     |
| B    | 2020-01-04 | Nitrate    |      1| \<  |

This time, the “names\_to” argument is a vector. Since it’s going to produce more than a simple name/value combination, we need to tell it how to make the name/value/remark combinations. We do that using the “names\_pattern” argument. In this case, `tidyr` is going to look at the column names (excluding site and date…since we negate those in the “cols” argument), and try to split the names by the “\_” separator. This is a very powerful tool…in this case we are saying anything in the first group (on the left of the “\_”) is the “Chemical” and every matching group on the right of the “\_” creates new value columns. So with the columns are: Phosphorus\_value, Phosphorus\_rmk, Nitrate\_value, Nitrate\_rmk - we get a column of chemicals (Phosphorus & Nitrate), a column of “rmk” values, and a column of “value” values.

What if the column names didn’t have the "\_value" prepended? This is more common in our raw data:

``` r
data_example2 <- data.frame(
  site = c("A","A","B","B"),
  date = as.Date(Sys.Date():(Sys.Date()-3), 
                 origin = "1970-01-01"),
  Phos = c(1:4),
  Phos_rmk = c("<","","",""),
  Nitrate = c(4:1),
  Nitrate_rmk = c("","","","<"),
  Chloride = c(3:6),
  Chloride_rmk = rep("",4),
  stringsAsFactors = FALSE
)
```

| site | date       |  Phos| Phos\_rmk |  Nitrate| Nitrate\_rmk |  Chloride| Chloride\_rmk |
|:-----|:-----------|-----:|:----------|--------:|:-------------|---------:|:--------------|
| A    | 2020-01-07 |     1| \<        |        4|              |         3|               |
| A    | 2020-01-06 |     2|           |        3|              |         4|               |
| B    | 2020-01-05 |     3|           |        2|              |         5|               |
| B    | 2020-01-04 |     4|           |        1| \<           |         6|               |

The easiest way to do that would be to add that “\_value”. Keeping in the “tidyverse” (acknowledging there are other base-R ways that work well too for the column renames):

``` r
library(dplyr)

data_renamed <- data_example2 %>% 
  rename_if(!grepl("_rmk", names(.)) &
              names(.) != c("site","date"), 
            list(~ sprintf('%s_value', .))) 
```

| site | date       |  Phos\_value| Phos\_rmk |  Nitrate\_value| Nitrate\_rmk |  Chloride\_value| Chloride\_rmk |
|:-----|:-----------|------------:|:----------|---------------:|:-------------|----------------:|:--------------|
| A    | 2020-01-07 |            1| \<        |               4|              |                3|               |
| A    | 2020-01-06 |            2|           |               3|              |                4|               |
| B    | 2020-01-05 |            3|           |               2|              |                5|               |
| B    | 2020-01-04 |            4|           |               1| \<           |                6|               |

``` r
data_long_2 <- data_renamed %>% 
  pivot_longer(cols = c(-site, -date), 
               names_to = c("Chemical", ".value"),
               names_pattern = "(.+)_(.+)")
```

The top 6 rows are now:

| site | date       | Chemical |  value| rmk |
|:-----|:-----------|:---------|------:|:----|
| A    | 2020-01-07 | Phos     |      1| \<  |
| A    | 2020-01-07 | Nitrate  |      4|     |
| A    | 2020-01-07 | Chloride |      3|     |
| A    | 2020-01-06 | Phos     |      2|     |
| A    | 2020-01-06 | Nitrate  |      3|     |
| A    | 2020-01-06 | Chloride |      4|     |

Real-world example
------------------

To open an Excel file in R, use the `readxl` package. There are many different configurations of Excel files possible. As one example, let’s say the lab returned the data looking like this:

{{\< figure src="/static/pivot/messyData.png" title="Wide data that needs to be converted to a long format." alt="Screen shot of Excel spreadsheet." \>}}

Let’s break down the issues:

-   Top row contains the CAS
-   2nd row basically contains the useful column headers
-   Need to skip a random 3rd row
-   4th row has 2 column headers for the first 2 columns
-   The data starts in row 5, in a “wide” format
-   The date format is unusual

In this example, we’ll work through these spacing and header issues to get us to a wide data frame that we can then pivot to a long data frame as described in the next section.

First, let’s just get the data with no column names:

``` r
library(readxl)
data_no_header <- read_xlsx("static/pivot/Wide data example.xlsx",
                            sheet = "data_from_lab", 
                            skip = 4, col_names = FALSE)
```

`data_no_header` is now a data frame with accurate types (except for dates…we’ll get that later!), but no column names. We know the first 2 columns are site and date, so we can name those easily:

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
“data\_no\_header”, but then it would be very confusing what “Code” means (since it’s repeated). So, let’s remove the “Code”, and just repeat the chemical names:

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

Before we pivot this data to the long format (as described above), let’s transform the “Sample Date” column to an R date time format:

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
```

The top 6 rows are now:

| SiteID   | Sample Date         | Chemical                 | code |   Value|
|:---------|:--------------------|:-------------------------|:-----|-------:|
| Upstream | 2016-08-01 10:00:00 | Atrazine                 | NA   |  0.0183|
| Upstream | 2016-08-01 10:00:00 | Thiabendazole            | \<   |  0.0041|
| Upstream | 2016-08-01 10:00:00 | 1,7-Dimethylxanthine     | \<   |  0.0877|
| Upstream | 2016-08-01 10:00:00 | 10-Hydroxy-amitriptyline | \<   |  0.0083|
| Upstream | 2017-09-07 10:00:00 | Atrazine                 | NA   |  0.0666|
| Upstream | 2017-09-07 10:00:00 | Thiabendazole            | \<   |  0.0110|

Save to Excel
-------------

The package `openxlsx` can be used to export Excel files. Create a named list in R, and each of those parts of the list become a Worksheet in Excel:

``` r
to_Excel <- list(Data = cleaned_long)

library(openxlsx)
write.xlsx(to_Excel,
           file = "cleanedData.xlsx")
```

Disclaimer
==========

Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
