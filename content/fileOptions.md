---
author: Laura DeCicco
date: 2019-02-20
slug: formats
draft: True
title: Working with pretty big data in R
type: post
categories: Data Science
image: static/comparison.jpg
author_twitter: DeCiccoDonk
author_github: ldecicco-usgs
author_gs: jXd0feEAAAAJ
 
author_staff: laura-decicco
author_email: <ldecicco@usgs.gov>

tags: 
  - R
 
 
description: Exploring file format options in R.
keywords:
  - R
 
 
  - files
  - io
---
TLDR!
=====

This blog post discusses our thought process for picking out file formats and when/if to use a database. It was interesting for me to write, I learned a lot, but if I'm honest...you are just here for the final table. I get it...your time is precious. So, here's the final results. If you want the longer explainations or the code examples that generated the table...continue reading.

Introduction
============

The vast majority of the projects that my data science team works on use flat files for data storage. Sometimes, the files get a bit large, so we create a set of files...but basically we've been fine without wading into the world of databases. Recently however, the data involved in our projects are creeping up to be bigger and bigger. We're still not anywhere in the "BIG DATA (TM)" realm, but big enough to warrant exploring options. This blog explores the options: csv (both from `readr` and `data.table`), RDS, fst, sqlite, feather, monetDB. One of the takeaways I've learned was that there is not a single right answer. This post will attempt to lay out the options and summarize the pros and cons.

In a blog post that laid out similar work: [sqlite-feather-and-fst](https://kbroman.org/blog/2017/04/30/sqlite-feather-and-fst/) and continued [here](https://kbroman.org/blog/2017/05/11/reading/writing-biggish-data-revisited/), Karl Broman discusses his journey from flat files to "big-ish data". I've taken some of his workflow, added more robust analysis for `fst` and `monetDB`, and used my own data.

First question: should we set up a shared database?

Shared Database
===============

A database is probably many data scientist's go-to tool for data storage and access. There are many database options, and discussing the pros and cons of each can fill a semester-long college course. This post will not cover those topics.

Our initial question was: when should we even *consider* going through the process of setting up a shared database? There's overhead involved, and our group would either need a spend a fair amount of time getting over the initial learning-curve or spend a fair amount of our limited resources on access to skilled database administrators. None of these hurdles are insurmountable, but we want to make sure our project and data needs are worth those investments.

If a single file can be easily passed around to coworkers, and loaded entirely in memory directly in R, there doesn't seem to be any reason to consider a shared database. Maybe the data can be logically chunked into several files (or 100's....or 1,000's) that make collaborating on the same data easier. What conditions warrant our "R-flat-file-happy" group to consider a database? I asked and got great advice from members of the [rOpenSci](https://ropensci.org/) community. This is what I learned:

-   "Identify how much CRUD (create, read, update, delete) you need to do over time and how complicated your conceptual model is. If you need people to be interacting and changing data a shared database can help add change tracking and important constraints to data inputs. If you have multiple things that interact like sites, species, field people, measurement classes, complicated requested\_date concepts etc then the db can help." [Steph Locke](https://twitter.com/TheStephLocke)

-   "One thing to consider is whether the data are updated and how, and by single or multiple processes." [Elin Waring](https://twitter.com/ElinWaring)

-   "I encourage people towards databases when/if they need to make use of all the validation logic you can put into databases. If they just need to query, a pattern I like is to keep the data in a text-based format like CSV/TSV and load the data into sqlite for querying." [Bryce Mecum](https://twitter.com/brycem)

-   "I suppose another criterion is whether multiple people need to access the same data or just a solo user. Concurrency afforded by DBs is nice in that regard." [James Balamuta](https://twitter.com/axiomsofxyz)

All great points! In the majority of our data science projects, the focus is not on creating and maintaining complex data systems...it's using large amounts of data. Most if not all of that data already come from other databases (usually through web services). So...the big hurdles involved in setting up a shared database for our projects at the moment seems unnecessary.

OK, so we don't need to buy an Oracle license. We still want to make a smart choice in the way we save and access the data. We usually have one to many file(s) that we share between a few people. So, we'll want to minimize the file size to reduce that transfer time (we have used Google drive and S3 buckets to store files to share historically). We'd also like to minimize the time to read and write the files. Maintaining attributes such as column types is also ideal.

I will be using a large, wide, data frame to test `data.table`,`readr`, `fst`, `feather`, `sqlite`, and `MonetDBLite` data import functions. Late in the game, I tried to incorporate `sparklyr` into this analysis. `sparklyr` looks and sounds like an appealing option especially for "really big data". However, I was not able to get my standard examples presented here to work. The dependency on a specific version of Java made me nervous (at least, at the time of writing this blog post). So, while it might be an attractive solution, there was a bit too much of a learning curve for the needs of our group.

What is in the data frame is not important to this analysis. Keep in mind that your own personal "biggish" data frame and your hardware might have different results. Let's start by loading the whole file into memory. The columns are a mix of factors, characters, numerics, dates, and logicals.

``` r
biggish <- readRDS("test.rds")

nrow(biggish)
```

    ## [1] 3731514

``` r
ncol(biggish)
```

    ## [1] 38

Read, write, and files size
---------------------------

Using the "biggish" data frame, I'm going to write and read the files completely in memory to start. Because we are often shuffling files around (one person pushes up to an S3 bucket and another pulls them down for example), I also want to compare compressed files vs not compressed when possible.

If you can read in all your data at once, read/write time and file size should be enough to help you choose your file format. There are many instances in our "biggish" data projects that we don't always need nor want ALL the data ALL the time. I will also compare how long it takes to pull a subset of the data by pulling out a date, numeric, and string, and then do some filtering. Some of the functions to read in data (`fst`, `fread`, `feather`) can read in specific columns without loading the whole file initially. These functions will read and filter/summarize the data much quicker since less data is in memory from the start. The true database options (`sqlite`, `monetDB`) will rely on the databases to do the processing outside of R (so, they also will ultimately read in less data).

First, I'll show individually how to do each of these operations. The end of this post will include a table summarizing all the information. It is generated using the `microbenchmark` package.

RDS No Compression
------------------

We'll start with the basic R binary file, the "RDS" file. `saveRDS` has an argument "compress" that defaults to `TRUE`. Not compressing the files results in a bigger file size, but quicker read and write times.

``` r
library(dplyr)

file_name <- "test.rds"
# Write:
saveRDS(biggish, file = file_name, compress = FALSE)
# Read:
rds_df <- readRDS(file_name)
```

RDS files must be read entirely in memory so the "Read & Filter" and "Read & Group & Summarize" times will be driven by the "Read" timing. However, I will use 2 examples throughout to test the timings. The examples are deliberately set up to test some `dplyr` basic verbs and various data types, as well as tricky situations like timezones.

``` r
min_bytes <- 100000
param_cd <- "00060"
group_col <- "statecd"
service <- "dv"

# Read and Filter:
read_filter <- readRDS(file_name) %>%
  filter(bytes > !!min_bytes,
         grepl(!!param_cd, parametercds)) %>%
  select(bytes, requested_date, parametercds)

# Read and Group and Summarize:
read_group_summary <- readRDS(file_name) %>%
  filter(service == !!service, 
         !is.na(!!sym(group_col)),
         requested_date > as.POSIXct("2016-10-02 00:00:00", 
                                     tz = "America/New_York")) %>%
  mutate(requested_date = as.Date(requested_date)) %>%
  group_by(.dots = c(group_col, "requested_date")) %>%
  summarize(MB = sum(as.numeric(bytes), na.rm = TRUE)/10^6)
```

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
rds
</td>
<td style="text-align:right;">
35.1
</td>
<td style="text-align:right;">
38.5
</td>
<td style="text-align:right;">
32.8
</td>
<td style="text-align:right;">
34.5
</td>
</tr>
</tbody>
</table>
Timing in seconds.

RDS Compression
---------------

``` r
file_name <- "test_compressed.rds"
# Write:
saveRDS(biggish, file = file_name, compress = TRUE)
# Read:
rds_compressed_df <- readRDS(file_name)
```

The "Read and Filter" data files will be the same process as "RDS No Compression".

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
rds compression
</td>
<td style="text-align:right;">
27.9
</td>
<td style="text-align:right;">
44.8
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
26.5
</td>
</tr>
</tbody>
</table>
Timing in seconds.

readr No Compression
--------------------

``` r
library(readr)
file_name <- "test.csv"
# Write:
write_csv(biggish, path = file_name)
# Read:
readr_df <- read_csv(file_name)
attr(readr_df$requested_date, "tzone") <- "America/New_York"
```

`readr` also must be read entirely in memory so "Read and Filter" times are mostly driven by "Read". If there's a known, continuous set of rows, you can use the arguments "skip" and "n\_max" to pull just what you need. However, that is not flexible enough for most of our needs, so I am not including that in this evaluation.

``` r
min_bytes <- 100000
param_cd <- "00060"
group_col <- "statecd"
service <- "dv"

# Read and Filter:
read_filter_readr <- read_csv(file_name) %>%
  filter(bytes > !!min_bytes,
         grepl(!!param_cd, parametercds)) %>%
  select(bytes, requested_date, parametercds)

attr(read_filter_rdr$requested_date, "tzone") <- "America/New_York"

# Read and Group and Summarize:
read_group_summary_readr <- read_csv(file_name) %>%
  filter(service == !!service, 
         !is.na(!!sym(group_col)),
         requested_date > as.POSIXct("2016-10-02 00:00:00")) %>%
  mutate(requested_date = as.Date(requested_date)) %>%
  group_by(.dots = c(group_col, "requested_date")) %>%
  summarize(MB = sum(as.numeric(bytes), na.rm = TRUE)/10^6)
```

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
readr
</td>
<td style="text-align:right;">
15.3
</td>
<td style="text-align:right;">
52.1
</td>
<td style="text-align:right;">
14.6
</td>
<td style="text-align:right;">
16
</td>
</tr>
</tbody>
</table>
Timing in seconds.

readr Compression
-----------------

``` r
library(readr)
file_name <- "test_readr.csv.gz"
# Write:
write_csv(biggish,  path = file_name)
# Read:
readr_compressed_df <- read_csv(file_name)
```

The "Read and Filter" data files will be the same process as "readr No Compression".

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
readr compression
</td>
<td style="text-align:right;">
22.2
</td>
<td style="text-align:right;">
68
</td>
<td style="text-align:right;">
23.7
</td>
<td style="text-align:right;">
24
</td>
</tr>
</tbody>
</table>
Timing in seconds.

fread No Compression
--------------------

``` r
library(data.table)
library(fasttime)
file_name <- "test.csv"
# Write:
fwrite(biggish, file = file_name)
# Read:
fread_df <- fread(file_name, 
                  data.table = FALSE, 
                  na.strings = "",) %>%
  mutate(requested_date = fastPOSIXct(requested_date, tz = "America/New_York"))
```

`fread` includes arguments "select"/"drop" to only load specific columns into memory. This improves the load time if there are many columns that aren't needed. If there's a known, continuous set of rows, you can use the arguments "skip" and "nrows" to pull just what you need. However, that is not flexible enough for most of our needs, so I am not including that in this evaluation.

Also, I am keeping this analysis as a "data.frame" (rather than "data.table") because it is the system our group has decided to stick with.

``` r
min_bytes <- 100000
param_cd <- "00060"
group_col <- "statecd"
service <- "dv"

# Read and Filter:
read_filter_fread <- fread(file_name, na.strings = "",
                            data.table = FALSE,
                            select = c("bytes","requested_date","parametercds")) %>%
  filter(bytes > !!min_bytes,
         grepl(!!param_cd, parametercds)) %>%
  mutate(requested_date = fastPOSIXct(requested_date, tz = "America/New_York"))

# Read and Group and Summarize:
read_group_summary_fread <- fread(file_name,na.strings = "",
                             data.table = FALSE,
                             select = c("bytes","requested_date","service",group_col)) %>%
  mutate(requested_date = fastPOSIXct(requested_date, 
                                      tz = "America/New_York")) %>%
  filter(service == !!service, 
         !is.na(!!sym(group_col)),
         requested_date > as.POSIXct("2016-10-02 00:00:00")) %>%
  mutate(requested_date = as.Date(requested_date)) %>%
  group_by(.dots = c(group_col, "requested_date")) %>%
  summarize(MB = sum(as.numeric(bytes), na.rm = TRUE)/10^6)
```

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
fread
</td>
<td style="text-align:right;">
6.8
</td>
<td style="text-align:right;">
2.5
</td>
<td style="text-align:right;">
3.8
</td>
<td style="text-align:right;">
1.7
</td>
</tr>
</tbody>
</table>
Timing in seconds.

Note! I didn't explore adjusting the `nThread` argument in `fread`/`fwrite`. I also didn't include a compressed version of `fread`/`fwrite`. Our crew is a hodge-podge of Windows, Mac, and Linux, and we try to make our code work on any OS. Many of the solutions for combining compression with `data.table` functions looked fragile on the different OSes. The `data.table` package has an open GitHub issue to support compression in the future. It may be worth updating this script once that is added.

feather Compression
-------------------

``` r
library(feather)
file_name <- "test.feather"
# Write:
write_feather(biggish, path = file_name)
# Read:
feather_df <- read_feather(file_name)
```

`read_feather` includes an argument "columns" to only load specific columns into memory. This improves the load time if there are many columns that aren't needed.

``` r
min_bytes <- 100000
param_cd <- "00060"
group_col <- "statecd"
service <- "dv"

# Read and Filter:
read_filter_feather <- read_feather(file_name, 
        columns = c("bytes","requested_date","parametercds")) %>%
  filter(bytes > !!min_bytes,
         grepl(!!param_cd, parametercds))

# Read and Group and Summarize:
read_group_summarize_feather <- read_feather(file_name, 
                      columns = c("bytes","requested_date","service",group_col)) %>%
  filter(service == !!service, 
         !is.na(!!sym(group_col)),
         requested_date > as.POSIXct("2016-10-02 00:00:00", 
       tz = "America/New_York")) %>%
  mutate(requested_date = as.Date(requested_date)) %>%
  group_by(.dots = c(group_col, "requested_date")) %>%
  summarize(MB = sum(as.numeric(bytes), na.rm = TRUE)/10^6)
```

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
feather
</td>
<td style="text-align:right;">
9.1
</td>
<td style="text-align:right;">
3.4
</td>
<td style="text-align:right;">
1.4
</td>
<td style="text-align:right;">
0.3
</td>
</tr>
</tbody>
</table>
Timing in seconds.

For the same reason as `fread`, I didn't try compressing the `feather` format. Both `data.table` and `feather` have open GitHub issues to support compression in the future. It may be worth updating this script once those features are added.

fst No Compression
------------------

``` r
library(fst)
file_name <- "test.fst"

# Write:
write_fst(biggish, path = file_name, compress = 0)
# Read:
fst_df <- read_fst(file_name)
```

``` r
min_bytes <- 100000
param_cd <- "00060"
group_col <- "statecd"
service <- "dv"

# Read and Filter:
read_filter_fst <- read_fst(file_name, 
        columns = c("bytes","requested_date","parametercds")) %>%
  filter(bytes > !!min_bytes,
         grepl(!!param_cd, parametercds)) 

# Read and Group and Summarize:
read_group_summarize_fst <- read_fst(file_name, 
                      columns = c("bytes","requested_date","service",group_col)) %>%
  filter(service == !!service, 
         !is.na(!!sym(group_col)),
         requested_date > as.POSIXct("2016-10-02 00:00:00", 
       tz = "America/New_York")) %>%
  mutate(requested_date = as.Date(requested_date)) %>%
  group_by(.dots = c(group_col, "requested_date")) %>%
  summarize(MB = sum(as.numeric(bytes), na.rm = TRUE)/10^6)
```

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
fst
</td>
<td style="text-align:right;">
3.4
</td>
<td style="text-align:right;">
5.9
</td>
<td style="text-align:right;">
1.3
</td>
<td style="text-align:right;">
0.3
</td>
</tr>
</tbody>
</table>
Timing in seconds.

fst Compression
---------------

``` r
library(fst)
file_name <- "test_compressed.fst"

# Write:
write_fst(biggish, path = file_name, compress = 100)
# Read:
fst_df <- read_fst(file_name)
```

The "Read and Filter" and "Read and Group and Summarize" retrievals will be the same process as in "fst No Compression".

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
fst compression
</td>
<td style="text-align:right;">
6.4
</td>
<td style="text-align:right;">
11.9
</td>
<td style="text-align:right;">
1.7
</td>
<td style="text-align:right;">
0.4
</td>
</tr>
</tbody>
</table>
Timing in seconds.

SQLite
------

SQLite does not have a storage class set aside for storing dates and/or times.

``` r
library(RSQLite)

file_name <- "test.sqlite"

sqldb <- dbConnect(SQLite(), dbname=file_name)

# Write:
dbWriteTable(sqldb,name =  "test", biggish,
             row.names=FALSE, overwrite=TRUE,
             append=FALSE, field.types=NULL)
# Read:
sqlite_df <- tbl(sqldb,"test") %>% 
  collect() %>%
  mutate(requested_date = as.POSIXct(requested_date, 
                                     tz = "America/New_York",
                                     origin = "1970-01-01"))
```

Things to notice here, you can't just use `grep`.

``` r
min_bytes <- 100000
param_cd <- "00060"
group_col <- "statecd"
service <- "dv"

# Read and Filter:
read_filter_sqlite <- tbl(sqldb,"test") %>% 
  select(bytes, requested_date , parametercds) %>%
  filter(bytes > !!min_bytes,
         parametercds %like% '%00060%') %>%
  collect() %>%
  mutate(requested_date = as.POSIXct(requested_date, 
                                     tz = "America/New_York",
                                     origin = "1970-01-01"))

# Read and Group and Summarize:
filter_time <- as.numeric(as.POSIXct("2016-10-02 00:00:00", tz = "America/New_York"))

read_group_summarize_sqlite <- tbl(sqldb,"test") %>%
  select(bytes, requested_date, service, !!group_col) %>%
  filter(service == !!service, 
         !is.na(!!sym(group_col)),
         requested_date > !! filter_time) %>%
  mutate(requested_date = strftime('%Y-%m-%d', datetime(requested_date, 'unixepoch'))) %>%
  group_by(!!sym(group_col), requested_date) %>%
  summarize(MB = sum(bytes, na.rm = TRUE)/10^6) %>%
  collect()

dbDisconnect(sqldb)
```

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
sqlite
</td>
<td style="text-align:right;">
23.1
</td>
<td style="text-align:right;">
31.1
</td>
<td style="text-align:right;">
2.6
</td>
<td style="text-align:right;">
1.1
</td>
</tr>
</tbody>
</table>
Timing in seconds.

It is important to note that this is the first "Read and Filter" and "Read and Group and Summarize" solution that is completely done outside of R. So when you are getting data that pushes the limits (or passes the limits) of what you can load directly into R, this is the first basic solution.

MonetDB
-------

``` r
library(MonetDBLite)
library(DBI)

file_name <- "test.monet"

con <- dbConnect(MonetDBLite(), dbname = file_name)

# Write:
dbWriteTable(con, name =  "test", biggish,
             row.names=FALSE, overwrite=TRUE,
             append=FALSE, field.types=NULL)
# Read:
monet_df <- dbReadTable(con, "test")
attr(monet_df$requested_date, "tzone") <- "America/New_York"
```

``` r
min_bytes <- 100000
param_cd <- "00060"
group_col <- "statecd"
service <- "dv"

# Read and Filter:
read_filter_monet <- tbl(con,"test") %>% 
  select(bytes, requested_date , parametercds) %>%
  filter(bytes > !!min_bytes,
         parametercds %like% '%00060%') %>%
  collect() 

attr(read_filter_monet$requested_date, "tzone") <- "America/New_York"

# Read and Group and Summarize:
# MonetDB needs the time in UTC, formatted exactly as:
# 'YYYY-mm-dd HH:MM:SS', hence the last "format" commend:
filter_time <- as.POSIXct("2016-10-02 00:00:00", tz = "America/New_York")
attr(filter_time, "tzone") <- "UTC"
filter_time <- format(filter_time)

read_group_summarize_monet <- tbl(con,"test") %>%
  select(bytes, requested_date, service, !!group_col) %>%
  filter(service == !!service, 
         !is.na(!!sym(group_col)), 
         requested_date > !! filter_time) %>% 
  mutate(requested_date = str_to_date(timestamp_to_str(requested_date, '%Y-%m-%d'),'%Y-%m-%d')) %>%
  group_by(!!sym(group_col), requested_date) %>%
  summarize(MB = sum(bytes, na.rm = TRUE)/10^6) %>%
  collect()

dbDisconnect(con, shutdown=TRUE)
```

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Format
</th>
<th style="text-align:right;">
Read
</th>
<th style="text-align:right;">
Write
</th>
<th style="text-align:right;">
Read & Filter
</th>
<th style="text-align:right;">
Read & Group & Summarize
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
MonetDB
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
29.2
</td>
<td style="text-align:right;">
1.6
</td>
<td style="text-align:right;">
1.2
</td>
</tr>
</tbody>
</table>
Timing in seconds.

Again, it is important to note that the "Read and Filter" and "Read and Group and Summarize" solutions are completely done outside of R. So when you are getting data that pushes the limits (or passes the limits) of what you can load directly into R, this is another good solution. There also appears to be a lot more flexibility in using date/times directly in MonetDB compared to SQLite.

Comparison
==========

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="border-bottom:hidden" colspan="1">
</th>
<th style="border-bottom:hidden" colspan="1">
</th>
<th style="border-bottom:hidden" colspan="1">
</th>
<th style="border-bottom:hidden" colspan="1">
</th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="1">
Read &

</th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="1">
Read &

</th>
<th style="border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;text-align: center; " colspan="1">
File Size

</th>
</tr>
<tr>
<th style="text-align:center;">
File Format
</th>
<th style="text-align:center;">
Read Method
</th>
<th style="text-align:center;">
Read
</th>
<th style="text-align:center;">
Write
</th>
<th style="text-align:center;">
Filter
</th>
<th style="text-align:center;">
Group & Summarize
</th>
<th style="text-align:center;">
(MB)
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
rds
</td>
<td style="text-align:center;">
bulk
</td>
<td style="text-align:center;">
35.1
</td>
<td style="text-align:center;">
38.5
</td>
<td style="text-align:center;">
32.8
</td>
<td style="text-align:center;">
34.5
</td>
<td style="text-align:center;">
1280.6
</td>
</tr>
<tr>
<td style="text-align:center;">
rds compression
</td>
<td style="text-align:center;">
bulk
</td>
<td style="text-align:center;">
27.9
</td>
<td style="text-align:center;">
44.8
</td>
<td style="text-align:center;">
28.0
</td>
<td style="text-align:center;">
26.5
</td>
<td style="text-align:center;">
55.4
</td>
</tr>
<tr>
<td style="text-align:center;">
readr
</td>
<td style="text-align:center;">
bulk
</td>
<td style="text-align:center;">
15.3
</td>
<td style="text-align:center;">
52.1
</td>
<td style="text-align:center;">
14.6
</td>
<td style="text-align:center;">
16.0
</td>
<td style="text-align:center;">
703.9
</td>
</tr>
<tr>
<td style="text-align:center;">
readr compression
</td>
<td style="text-align:center;">
bulk
</td>
<td style="text-align:center;">
22.2
</td>
<td style="text-align:center;">
68.0
</td>
<td style="text-align:center;">
23.7
</td>
<td style="text-align:center;">
24.0
</td>
<td style="text-align:center;">
65.7
</td>
</tr>
<tr>
<td style="text-align:center;">
fread
</td>
<td style="text-align:center;">
limited partial
</td>
<td style="text-align:center;">
6.8
</td>
<td style="text-align:center;">
2.5
</td>
<td style="text-align:center;">
3.8
</td>
<td style="text-align:center;">
1.7
</td>
<td style="text-align:center;">
503.7
</td>
</tr>
<tr>
<td style="text-align:center;">
feather
</td>
<td style="text-align:center;">
limited partial
</td>
<td style="text-align:center;">
9.1
</td>
<td style="text-align:center;">
3.4
</td>
<td style="text-align:center;">
1.4
</td>
<td style="text-align:center;">
0.3
</td>
<td style="text-align:center;">
818.4
</td>
</tr>
<tr>
<td style="text-align:center;">
fst
</td>
<td style="text-align:center;">
limited partial
</td>
<td style="text-align:center;">
3.4
</td>
<td style="text-align:center;">
5.9
</td>
<td style="text-align:center;">
1.3
</td>
<td style="text-align:center;">
0.3
</td>
<td style="text-align:center;">
988.6
</td>
</tr>
<tr>
<td style="text-align:center;">
fst compression
</td>
<td style="text-align:center;">
limited partial
</td>
<td style="text-align:center;">
6.4
</td>
<td style="text-align:center;">
11.9
</td>
<td style="text-align:center;">
1.7
</td>
<td style="text-align:center;">
0.4
</td>
<td style="text-align:center;">
123.5
</td>
</tr>
<tr>
<td style="text-align:center;">
sqlite
</td>
<td style="text-align:center;">
partial
</td>
<td style="text-align:center;">
23.1
</td>
<td style="text-align:center;">
31.1
</td>
<td style="text-align:center;">
2.6
</td>
<td style="text-align:center;">
1.1
</td>
<td style="text-align:center;">
464.2
</td>
</tr>
<tr>
<td style="text-align:center;">
MonetDB
</td>
<td style="text-align:center;">
partial
</td>
<td style="text-align:center;">
4.0
</td>
<td style="text-align:center;">
29.2
</td>
<td style="text-align:center;">
1.6
</td>
<td style="text-align:center;">
1.2
</td>
<td style="text-align:center;">
359.9
</td>
</tr>
</tbody>
</table>
All timing in seconds.

Note that `sqlite` and `MonetDB` are the only formats here that allow careful filtering and calculate summaries without loading the whole data set. So if our "pretty big data" gets "really big", those will formats will rise to the top. If you can read in all the rows without crashing R, `fread`, `feather`, and `fst` are fast!

Another consideration, who are your collaborators? If everyone's using R exclusively, this table on its own is a fine way to judge what format to pick. If your collaborators are half R, half Python...you might favor `feather` since that format works well in both systems.

Collecting this information has been a very useful activity for helping me understand the various options for saving and reading data in R. I tried to pick somewhat complex queries to test out the capabilities, but I acknowledge I'm not an expert on databases and file formats. I would be very happy to hear more efficient ways to perform these analyses.

Disclaimer
==========

Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
