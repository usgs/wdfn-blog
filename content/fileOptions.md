---
author: Laura DeCicco
date: 2018-08-30
slug: formats
draft: True
title: Pretty big data... now what?
type: post
categories: Data Science
image: static/formats/visualizeBox-1.png
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
In the group that I work with <https://owi.usgs.gov/datascience/>, the vast majority of the projects use flat files for data storage. Sometimes, the files get a bit large, so we create a set of files...but basically we've been fine without wading into the world of databases. Recently however, the data involved in our projects are creeping up to be bigger and bigger. We're still not anywhere in the "BIG DATA (TM)" realm, but big enough to warrant exploring options. This blog explores the options: csv (both from `readr` and `data.table`), RDS, fst, sqlite, feather, monetDB. One of the takeaways I've learned was that there is not a single right answer. This post will attempt to lay out the options and summarize the pros and cons.

In a blog post that laid out similar work: [sqlite-feather-and-fst](https://kbroman.org/blog/2017/04/30/sqlite-feather-and-fst/) and continued [here](https://kbroman.org/blog/2017/05/11/reading/writing-biggish-data-revisited/), Karl Broman discusses his journey from flat files to "big-ish data". I've taken some of his workflow, added more robust for `fst` and `monetDB`, and used my own data.

First question: should we set up a shared database?

Shared Database
===============

A database is probably many data scientist's go-to tool for data storage and access. There are many database options, and discussing the pros and cons of each could (and does!) fill a semester-long college course. This post will not cover those topics.

Our initial question was: when should we even *consider* going through the process of setting up a shared database? There's overhead involved, and our group would either need a spend a fair amount of time getting over the initial learning-curve or spend a fair amount of our limited resources on access to skilled data base administrators. None of these hurdles are insurmountable, but we want to make sure our project and data needs are worth those investments.

If a single file can be easily passed around to coworkers, and loaded entirely in memory directly in R, there doesn't seem to be any reason to consider a shared database. Maybe the data can be logically chunked into several files (or 100's....or 1,000's) that make collaborating on the same data easier. What conditions warrant our "R-flat-file-happy" group to consider a database?

Not being an expert, I asked and got great advice from members of the [rOpenSci](https://ropensci.org/) community. This is what I learned:

-   "Identify how much CRUD (create, read, uprequested\_date, delete) you need to do over time and how complicated your conceptual model is. If you need people to be interacting and changing data a shared database can help add change tracking and important constraints to data inputs. If you have multiple things that interact like sites, species, field people, measurement classes, complicated requested\_date concepts etc then the db can help." (Steph Locke)

-   "One thing to consider is whether the data are uprequested\_dated and how and by single or multiple processes." (Elin Waring)

-   "I encourage people towards databases when/if they need to make use of all the validation logic you can put into databases. If they just need to query, a pattern I like is to keep the data in a text-based format like CSV/TSV and load the data into sqlite for querying." (Bryce Mecum)

-   "I suppose another criterion is whether multiple people need to access the same data or just a solo user. Concurrency afforded by DBs is nice in that regard." (James Balamuta)

All great points! In the majority of our data science projects, the focus is not on creating and maintaining complex data systems...it's using large amounts of data. Most if not all of that data already come from other databases (usually through web services). So...the big benefits for setting up a shared database for our projects at the moment seems unnecessary.

Now what?
=========

OK, so we don't need to buy an Oracle license. We still want to make a smart choice in the way we save and access the data. We usually have 1-to-many file(s) that we share between a few people. So, we'll want to minimize the file size to reduce that transfer time (we have used Google drive and S3 buckets to store files to share historically). We'd also like to minimize the time to read and write the files. Maintaining attributes (like column types) is also ideal.

I will be using a large data frame to test `data.table`,`readr`, `fst`, `feather`, `sqlite`, `MonetDBLite`.

What is in the data frame is not important to this analysis. Keep in mind your own personal "biggish" data frame and your hardware might have different results.

Let's start by loading the whole file into memory. The columns are a mix of factors, characters, numerics, requested\_dates, and logicals.

``` r
biggish <- readRDS("test.rds")

nrow(biggish)
```

    ## [1] 3731514

``` r
ncol(biggish)
```

    ## [1] 38

Read and Write
--------------

Using the "biggish" data frame, I'm going to write and read the files completely in memory to start. Because we are often shuffling files around (one person pushes up to an S3 bucket and another pulls them down for example), I also want to compare compressed files vs not compressed when possible.

``` r
library(microbenchmark)
library(data.table)
library(readr)
library(feather)
library(fst)
library(RSQLite)
library(MonetDBLite)
library(dplyr)
library(dbplyr)

tested <- c("rds","rds_compressed","readr","readr_compressed",
            "fread","feather","fst","fst_compressed",
            "sqlite","monetDB","monetDB_csv")
file_name <- setNames(c("test.rds","test_compressed.rds",
                        "test_readr.csv","test_readr.csv.gz",
                        "test.csv","test.feather",
                        "test.fst", "test_compressed.fst","test.sqlite",
                        "test.montdb","test.csv"),tested)

write_times <- microbenchmark(
  rds = saveRDS(biggish, file_name[["rds"]],compress = FALSE),
  rds_compressed = saveRDS(biggish, file_name[["rds_compressed"]]),
  readr = write_csv(biggish, file_name[["readr"]]),
  readr_compressed = write_csv(biggish, file_name[["readr_compressed"]]),
  fread = fwrite(biggish, file_name[["fread"]]),
  feather = write_feather(biggish, file_name[["feather"]]),
  fst = write_fst(biggish, file_name[["fst"]], compress = 0),
  fst_compressed = write_fst(biggish, file_name[["fst_compressed"]], compress = 100),
  sqlite = {sqldb <- dbConnect(SQLite(), dbname = file_name[["sqlite"]])
  dbWriteTable(sqldb,name =  "test", biggish, 
             row.names=FALSE, overwrite=TRUE,
             append=FALSE, field.types=NULL)
  dbDisconnect(sqldb)
  },
  monetDB_write = { 
    con <- dbConnect(MonetDBLite(), dbname = file_name[["monetDB"]])
    dbWriteTable(con, name = "test", biggish,
                 row.names=FALSE, overwrite=TRUE,
                 append=FALSE, field.types=NULL)
    dbDisconnect(con, shutdown=TRUE)},
  times = 1
)

monet.read.csv <- function(file) {
  monet.con <- DBI::dbConnect(MonetDBLite(), ":memory:")
  suppressMessages(MonetDBLite::monetdb.read.csv(monet.con, file, "file", sep = ",",best.effort = TRUE))
  result <- DBI::dbReadTable(monet.con, "file")
  DBI::dbDisconnect(monet.con, shutdown = T)
  return(result)  
}

read_times <- microbenchmark(
  rds_df <- readRDS(file_name[["rds"]]),
  rds_compressed_df <- readRDS(file_name[["rds_compressed"]]),
  readr_df <- read_csv(file_name[["readr"]]),
  readr_compressed_df = read_csv(file_name[["readr_compressed"]]),
  fread_df <- fread(file_name[["fread"]]),
  feather_df <- read_feather(file_name[["feather"]]),
  fst_df <- read.fst(file_name[["fst"]]),
  fst_compressed_df <- read.fst(file_name[["fst_compressed"]]),
  sql_df = {
    sqldb <- dbConnect(SQLite(), dbname = file_name[["sqlite"]])
    sql_df <- tbl(sqldb,"test") %>% collect()
    dbDisconnect(sqldb)},
  monetDB_df = {
    con <- dbConnect(MonetDBLite(), dbname = file_name[["monetDB"]])
    monetDB_df <- tbl(con,"test") %>% collect()
    dbDisconnect(con, shutdown=TRUE)},
  monetDB_csv <- monet.read.csv(file_name[["monetDB_csv"]]),
  times = 1
)

file_size <- c()

for(file_to_measure in names(file_name)){
  file_size[[file_to_measure]] <- file.info(file_name[[file_to_measure]])[["size"]]
}

# MonetDB isn't really 0...it's a folder:
file_size[file_size == 0] <- NA

knitr::kable(data.frame(file_size/10^6,
                        c(summary(write_times)$median,NA),
                        summary(read_times)$median), 
             digits = c(1,1,1),col.names = c("File Size (MB)","Write Time(seconds)", "Read Time(seconds)"))
```

|                   |  File Size (MB)|  Write Time(seconds)|  Read Time(seconds)|
|-------------------|---------------:|--------------------:|-------------------:|
| rds               |          1280.6|                 42.8|                43.6|
| rds\_compressed   |            55.4|                 81.4|                54.5|
| readr             |           703.9|                 66.3|                44.6|
| readr\_compressed |            65.7|                 77.4|                49.1|
| fread             |           503.7|                  3.2|                12.4|
| feather           |           818.4|                  4.9|                12.0|
| fst               |           988.6|                 10.9|                11.0|
| fst\_compressed   |           121.8|                 13.0|                 8.5|
| sqlite            |           464.2|                 58.3|                44.4|
| monetDB           |              NA|                 42.3|                19.6|
| monetDB\_csv      |           503.7|                   NA|                45.8|

MonetDBLite was tacked on at the last minute to this blog. I'm not 100% sure I'm doing things the most efficient way. It can read a csv file, which is tested in the read. I don't think it writes a single file, it seems to write a folder. I tried to follow some examples from [here](https://statcompute.wordpress.com/2018/05/09/mimicking-sqldf-with-monetdblite/).

Note! I didn't explore adjusting the `nThread` argument in `fread`/`fwrite`. I also didn't include a compressed version of `fread`/`fwrite`. Our crew is a hog-pog of Windows, Mac, and Linux, and we try to make our code work on any OS. Many of the solutions for combining compression with `data.table` functions looked fragile on the different OS. For the same reason, I didn't try compressing the `feather` format. Both `data.table` and `feather` have open GitHub issues to support compression in the future. It may be worth updating this script once those features are added.

One side consideration, who are your collaborators? If everyone's using R exclusively, this table on it's own is a fine way to judge what format to pick. If your collaborators are half R, half Python...you might favor `feather` since that format works well in both systems (and eliminate RDS). Likewise, if your collaborators "need" a csv....you can eliminate those other formats.

If you can read in all your data at once, that's all the analysis you need (assuming you are happy with those read times). From the table, you can choose the criteria that are important to you (going to write the file once and read it a bunch? weigh the read time highest. going to write over the file a lot? consider both read/write). If that's not true, read on!

Read partial files
------------------

All that's well and good, but there are many instances in our "biggish" data projects that we don't always need nor want ALL the data. The following tests how these packages compare to eachother grabbing a subset of the data. I'm going to pull out a requested\_date column, numeric, and string, and only rows that have specific strings and greater than a threshold.

Here's what we're trying to get:

``` r
smallish <- readRDS("test.rds") %>%
  filter(bytes > 100000,
         grepl("00060",parametercds)) %>%
  select(bytes, requested_date, parametercds) 
```

Here's how I figured out how to load that data in other ways. I would be happy to hear if there are other methods I've missed!

### feather

``` r
db_feather <- feather(file_name[["feather"]])

smallish_feather <- db_feather[,c("bytes","requested_date","parametercds")] %>%
  filter(bytes > 100000,
         grepl("00060",parametercds))
```

### fst

``` r
db_fst <- fst(file_name[["fst"]])

smallish_fst <- db_fst[,c("bytes","requested_date","parametercds")] %>%
  filter(bytes > 100000,
         grepl("00060",parametercds))

db_fst <- fst(file_name[["fst_compressed"]])

smallish_fst_compressed <- db_fst[,c("bytes","requested_date","parametercds")] %>%
  filter(bytes > 100000,
         grepl("00060",parametercds))
```

### fread

``` r
smallish_fread <- fread(file_name[["fread"]], 
                      select = c("bytes","requested_date","parametercds")) %>%
  filter(bytes > 100000,
         grepl("00060",parametercds))
```

### SQLite

``` r
sqldb <- dbConnect(SQLite(), dbname=file_name[["sqlite"]])

smallish_sqlite <- tbl(sqldb,"test") %>%
  select(bytes, requested_date, parametercds) %>%
  filter(bytes > 100000,
         parametercds %like% '%00060%') %>%
  collect()

dbDisconnect(sqldb)
```

### MonetDBLite

``` r
con <- dbConnect(MonetDBLite(), dbname=file_name[["monetDB"]])

smallish_monet <- tbl(con,"test") %>%
  select(bytes, requested_date, parametercds) %>%
  filter(bytes > 100000,
         parametercds %like% '%00060%') %>%
  collect()

dbDisconnect(con, shutdown=TRUE)
```

### Comparisons

``` r
sqldb <- dbConnect(SQLite(), dbname = file_name[["sqlite"]])
con <- dbConnect(MonetDBLite(), dbname = file_name[["monetDB"]])

partial_read <- microbenchmark(
  rds = {smallish <- readRDS(file_name[["rds"]]) %>%
              filter(bytes > 100000,
                     grepl("00060",parametercds)) %>%
              select(bytes, requested_date, parametercds) },
  fread = {smallish_fread <- fread(file_name[["fread"]], 
              select = c("bytes","requested_date","parametercds")) %>%
              filter(bytes > 100000,
                     grepl("00060",parametercds)) },
  feather = {db_feather <- feather(file_name[["feather"]])
              smallish_feather <- db_feather[,c("bytes","requested_date","parametercds")] %>%
                filter(bytes > 100000,
                       grepl("00060",parametercds))},
  fst = {db_fst <- fst(file_name[["fst"]])
          smallish_fst <- db_fst[,c("bytes","requested_date","parametercds")] %>%
                filter(bytes > 100000,
                       grepl("00060",parametercds))},
  fst_compressed = {db_fst <- fst(file_name[["fst_compressed"]])
          smallish_fst <- db_fst[,c("bytes","requested_date","parametercds")] %>%
                filter(bytes > 100000,
                       grepl("00060",parametercds))},
  sqlite = {smallish_sqlite <- tbl(sqldb,"test") %>%
            select(bytes, requested_date, parametercds) %>%
            filter(bytes > 100000,
                   parametercds %like% '%00060%') %>%
            collect()},
  monetDB = {smallish_monet <- tbl(con,"test") %>%
      select(bytes, requested_date, parametercds) %>%
      filter(bytes > 100000,
             parametercds %like% '%00060%') %>%
      collect()},
  times = 1
)

dbDisconnect(sqldb)
dbDisconnect(con, shutdown=TRUE)

knitr::kable(data.frame(names(summary(partial_read$expr)),
                        summary(partial_read)$median),digits = c(1,1),
             col.names = c("","Read Time (seconds)"))
```

|                 |  Read Time (seconds)|
|-----------------|--------------------:|
| rds             |                 40.2|
| fread           |                  4.1|
| feather         |                  2.5|
| fst             |                  2.5|
| fst\_compressed |                  2.2|
| sqlite          |                 13.5|
| monetDB         |                  1.8|

Note that only sqlite and monetDB actually filtered out rows before collecting the data. The other options in this table only filtered out columns on the collection. If the data is even bigger than this "biggish" dataframe, that will be important.

So...what have I learned now? There are a bunch of good options. Depending on how we're creating, sharing, and opening the files, I think there are best choices.

One question I still have is how much should I care about file size? Especially if we choose some of the fast read/write options with bigger file sizes. In our case, we have several remote collaborators, along with sketchy internet connections at times.

So, last-but-not-least, here's a simple test on how long it takes us to download and upload and download the different files:

``` r
library(aws.s3)
library(aws.signature)
use_credentials()
bucket_name <- "ds-nwis-logs"

upload_times <- microbenchmark(
  rds = put_object(file_name[["rds"]], bucket = bucket_name),
  rds_compressed <- put_object(file_name[["rds_compressed"]], bucket = bucket_name),
  readr <- put_object(file_name[["readr"]], bucket = bucket_name),
  readr_compressed = put_object(file_name[["readr_compressed"]], bucket = bucket_name),
  fread <- put_object(file_name[["fread"]], bucket = bucket_name),
  feather <- put_object(file_name[["feather"]], bucket = bucket_name),
  fst <- put_object(file_name[["fst"]], bucket = bucket_name),
  fst_compressed <- put_object(file_name[["fst_compressed"]], bucket = bucket_name),
  sql <- put_object(file_name[["sqlite"]], bucket = bucket_name),
  times = 1
)

download_times <- microbenchmark(
  rds = save_object(file_name[["rds"]], bucket = bucket_name, overwrite = TRUE),
  rds_compressed <- save_object(file_name[["rds_compressed"]], bucket = bucket_name, overwrite = TRUE),
  readr = save_object(file_name[["readr"]], bucket = bucket_name, overwrite = TRUE),
  readr_compressed = save_object(file_name[["readr_compressed"]], bucket = bucket_name, overwrite = TRUE),
  fread = save_object(file_name[["fread"]], bucket = bucket_name),
  feather = save_object(file_name[["feather"]], bucket = bucket_name, overwrite = TRUE),
  fst = save_object(file_name[["fst"]], bucket = bucket_name, overwrite = TRUE),
  fst_compressed = save_object(file_name[["fst_compressed"]], bucket = bucket_name, overwrite = TRUE),
  sql = save_object(file_name[["sqlite"]], bucket = bucket_name, overwrite = TRUE),
  times = 1
)

knitr::kable(data.frame(summary(upload_times)$median,
                        summary(download_times)$median), 
             digits = c(1,1,1),col.names = c("Upload Time", "Download Time"))
```

Disclaimer
==========

Any use of trade, firm, or product names is for descriptive purposes only and does not imply endorsement by the U.S. Government.
