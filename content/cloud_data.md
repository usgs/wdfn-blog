---
author: Jeff Sadler
date: 2019-12-10
slug: cloud_data
draft: True
type: post
title: Cloud-optimized USGS Time Series Data
categories: Data Science
tags:
  - time series data
  - data retrieval
  - discharge data
  - Delaware River Basin
  - cloud-computing
  - data formats
description: Compressed formats, Zarr and Parquet scale much better for retrieving, reading, and writing USGS discharge time series data.
keywords:
  - time series data
  - data retrieval
  - discharge data
  - Delaware River Basin
  - cloud-computing
  - data formats
author_github: jsadler2
author_gs:user: hGlW7UUAAAAJ
author_email: <jsadler@usgs.gov>
---
## Intro
The scalability, flexibility, and configurabilty of the commercial cloud provide new and exciting possibilities for many applications including earth science research. As with many organizations, the US Geological Survey (USGS) is exploring the use and advantages of the cloud for performing their science. The full benefit of the cloud, however, can only be realized if the data that will be used is in a cloud-friendly format.

In this blog post I'll compare three formats for storing time series data: Zarr, Parquet, and CSV. Zarr ([zarr.readthedocs.io](https://zarr.readthedocs.io/en/stable/)) and Parquet ([parquet.apache.org](https://parquet.apache.org)) are compressed, binary data formats that can also be chunked or partitioned. This makes them a good choice for use on cloud-based environments where the number of computational cores can be scaled quickly and without limits common to more traditional HPC/HTC platforms. CSV will serve as a baseline comparison as a long-time standard format for time series data storage.

I am doing this comparision using time series data that are stored in and served from the USGS National Water Information System (NWIS). NWIS serves time series recorded at thousands observation locations throughout the US. These observations are of dozens of water science variables. My comparison will use discharge (or streamflow) data that were, for the most part, recorded 15 minute intervals.

## Comparison set up
There were two major comparisons. First I compared NWIS to Zarr for retrieval and formatting of time series for a subset of stations. Second I compared the write/read speeds and storage requirements between Zarr, Parquet, and CSV for the same subset of stations. I did these comparisons using a stock AWS EC2 t3a.large machine (8GB memory). The code I used to do these comparisons is [here](https://github.com/jsadler2/usgs_zarr_blog/blob/master/comparison.py). Both comparisons were done for 1) a 10-day period and 2) a 40-year period.  

### Initial data gathering
For the first comparison, I first needed to gather the discharge data from all stations and write them to Zarr in an S3 bucket. Altogether I gathered data from more than 12,000 stations across the continental US for a period of record of 1970-2019 using the NWIS web services ([waterservices.usgs.gov/rest/IV-Service.html](https://waterservices.usgs.gov/rest/IV-Service.html)).

### Subset of basins
To do the comparison between the file formats I selected the Schuylkill River Basin, a sub-basin of the Delaware River Basin. Recently, the USGS initiated a program for the Next Generation Water Observation System ([NGWOS](https://www.usgs.gov/mission-areas/water-resources/science/usgs-next-generation-water-observing-system-ngwos?qt-science_center_objects=0#qt-science_center_objects)) in the Delaware River Basin. NGWOS will provide denser, less expensive, and more rapid water quality and quantity data than what is currently being offered by the USGS and the DRB is the first basin to pilot the new systems. 

![Delaware and Schuylkill River Basins](fig/drb_gauges1.png)

### Comparison 1: Data retrieval and formatting (Zarr vs. NWIS web services)
I recorded the time it took to retrieve and format data using the NWIS web services and then from Zarr.  I did the retrieval and formatting for one station (the overall outlet) and for all 23 stations in the sub-basin. I intended this comparison to answer the question: "If I have a bunch of sites in a data base (NWIS) or if I have a bunch of sites in a Zarr store, which one performs better at retrieving a relevant subset?"

For the formatting of the data, I converted the NWIS data into a Pandas DataFrame with a DateTime index. The formatting was necessary because NWIS webservices currently returns a plain text response which then has to be parsed and read into memory before analysis. When the Zarr data is retrieved, it is already in an analysis ready format as an Xarray dataset which can efficiently be operated on or converted to other formats such as a Pandas dataframe.

### Comparison 2: Data write, read, and storage (Zarr vs. Parquet vs CSV)
Once I retrieved the data subset, I wrote this subset to a new Zarr store, a Parquet file, and a CSV file. All of these files were written on the S3 bucket. I recorded the time it took to write to each of these formats, to read from each, and the storage sizes of each. 

## Results

### Comparison 1: Data retrieval and formatting

#### Table 1. Time in seconds to retrieve and format 10 days of data
| | Zarr | NWIS|
|---|---|---|
|Schuylkill outlet (sec)| 5.9 | 1.04| 
|all stations in Schuylkill basin (sec)| 6.1 | 19.7|  

#### Table 2. Time in seconds to retrieve and format 40 years of data 
| | Zarr | NWIS|
|---|---|---|
|Schuylkill outlet (sec)| 5.8 | 29.8 | 
|all stations in Schuylkill basin (sec)| 6.3 | 830 |  
|all stations in Schuylkill basin retrieve (sec)| | 401 |  

Overall Zarr was much faster at retrieving data from a subset of observations compared to the NWIS web services and scaled very well. In fact, there was hardly any difference in retrieval time when increasing the volume of data requested. Consequently, the performance difference between Zarr and NWIS increased as the volume of data requested increased. NWIS was actually faster for a single station for the 10-day request. When we increased the 10-day request to all 23 stations or the single station to a 40-year request, Zarr was 3x and 4x faster, respectively. The largest difference, though, occurred when pulling the 40 years of data for all 23 stations: retrieving and formatting the data from Zarr was more than 127x faster compared to NWIS web services! And this difference was only for 23 stations! Imagine the difference if we wanted only 123 stations (only about 1% of the total stations available).

<!-- The 830 seconds it took to retrieve from NWIS and format the 40 years of data from the 23 stations in the Schuylkill basin was split nearly evenly between retrieval and formatting. -->

### Comparison 2: Data write, read, and storage

#### Table 3. Read, write, and storage for 10 days of data
| | Zarr | Parquet| CSV|
|---|---|---| ---|
|read (sec)| 0.3 | 0.02 | 0.02 | 
|write (sec)| 2.4 | 0.2 | 0.26 | 
|storage (kB)| 51.3 | 40.8 | 124.1 | 

#### Table 4. Read, write, and storage for 40 years of data 
| | Zarr | Parquet| CSV|
|---|---|---| ---|
|read (sec)| 1.1 | 0.6 | 3.7 | 
|write (sec)| 6.1 | 1.6 | 31.1 | 
|storage (MB)| 33.5 | 15.4 | 110 | 

Except for reading the 10-day data, Parquet was the best performing for read and write times and storage size for both the 10-day and 40-year datasets. Zarr was the slowest format for read/write for the 10-day dataset with write speeds an order of magnitude slower than Parquet and CSV, though still under a second and a half. The performance of the CSV format was comparable to Parquet with the 10-day dataset and even faster reading. However, CSV scaled very poorly with the 40-year dataset. This was especially true of the the read and write times which increased over 170x for CSV. In contrast, the maximum increase for either Zarr or Parquet between the 10-day and 40-year dataset was an 11x increase in the Parquet write time. CSV also required a considerably larger storage size (3x compared to Zarr for the 40-year dataset).

## Discussion 
Since Parquet performed the best in nearly all of the categories of Comparison 2, you may be wondering, "why didn't you use Parquet to store all of the discharge data instead of Zarr?" The answer to that is flexibility. Zarr is a more flexible format than Parquet. Zarr allows for chunking along any dimension. Parquet is a columnar data format and allows for chunking only along one dimension. Additionally, Xarray's interface to Zarr makes it very easy to append to a Zarr store. This was very handy when I was making all of the NWIS web service calls. Even though the connection was very reliable because it was on a cloud machine, there times where the connection was dropped whether it was on EC2 side or the NWIS side. Because I could append to Zarr, when the connection dropped I could just pick up from the last chunk of data I had written and keep going.

The results of Comparison 1 show great promise in making large-scale USGS data more readily accessible through cloud-friendly formats on cloud storage. My speculation is that cloud-accessible data one day may serve as a complement to or a complete replacement of traditional web services. Because the S3 bucket is in the CHS cloud, any USGS researcher that has CHS access will have access to the same dataset that I did the tests on. Although I did the analysis on stations in the Schuylkill River Basin, similar results should be able to be produced with any arbitrary subset of NWIS stations. This retrieval is possible without any type of web-service for subsetting the data. Since Zarr is chunked, object storage it is easily and efficiently subsettable with functionality built into the interfacing software package (i.e., Xarray in Python). Additionally, the data is read directly into a computation friendly in-memory format (i.e., an Xarray dataset) instead of plain text in an HTML response as is delivered by a web service.

Beside efficient access, a major benefit of storing the data in the CHS S3 bucket in Zarr is the proximity to and propensity for scalable computing. Through the cloud, a computational cluster could be quickly scaled up to efficiently operate on the chunks of Zarr data. As USGS scientists become more accustomed to using cloud resources on CHS, having USGS data accessible in cloud-friendly formats will be a great benefit for large-scale research. The [Pangeo software stack](https://www.pangeo.io), which should be available through CHS soon, provides intuitive and approachable tools to help scientists perform cloud-based, scalable analyses on large cloud-friendly datasets.  

## Conclusion
The two big takeaways for me from this exercise were 1) time series data retrieval scales much much better with Zarr compared to using NWIS and 2) Parquet and Zarr scale much better in the reading, writing, and storage of time series compared CSV. These takeaways highlight the benefits of cloud-friendly storage formats when storing data on the cloud.
