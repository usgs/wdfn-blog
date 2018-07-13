---
author: David Watkins
date: 2018-07-11
slug: mapping-in-r
draft: True
title: Basic mapping in R
type: post
categories: Data Science
image: static/mapping-in-r/poly-map-state-1.png
 
 
 
 
 
 

tags: 
  - R
  - maps
 
description: Basic mapping in R with the maps and ggmap package
keywords:
  - R
  - maps
 
 
  - maps
---
Introduction
------------

There are many different R packages for dealing with spatial data. The main distinctions between them involve the types of data they work with --- raster or polygonal --- and the sophistication of the analyses they can do. Raster data can be thought of as pixels, similar to an image, while polygonal data consists of lines or polygons. Spatial data manipulation can be quite complex, but creating some basic plots can be done with just a few commands. In this post, we will show simple examples of each for plotting gage locations, and link to some other more complex examples.

Setting up
==========

We'll start with a polygon example. First, let's download an example shapefile (a polygon) of a HUC8 from western Pennsylania, using the `sbtools` package to access Sciencebase. Then we'll retrieve gages with discharge from this watershed using the `dataRetrieval` package. The `readOGR` function from `rgdal` reads shapefiles into R. `rgdal` accesses the [Geospatial Data Abstraction Library](http://www.gdal.org/) (GDAL) system library.

``` r
library(sbtools)
library(dataRetrieval)
library(rgdal)

item_file_download(sb_id = "5a83025ce4b00f54eb32956b", 
                   names = "huc8_05010007_example.zip", 
                   destinations = "huc8_05010007_example.zip", 
                   overwrite_file = TRUE)
```

    ## [1] "huc8_05010007_example.zip"

``` r
unzip('huc8_05010007_example.zip', overwrite = TRUE)
huc_poly <- readOGR('huc8_05010007_example')
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/Users/wwatkins/Documents/R/owi-blog/content/huc8_05010007_example", layer: "wbdhu8_alb_simp"
    ## with 1 features
    ## It has 9 fields

``` r
class(huc_poly)
```

    ## [1] "SpatialPolygonsDataFrame"
    ## attr(,"package")
    ## [1] "sp"

``` r
huc_gages <- whatNWISdata(huc = "05010007", parameterCd = "00060", service="uv")
print(huc_gages)
```

    ##      agency_cd  site_no                                        station_nm
    ## 197       USGS 03039925 North Fork Bens Creek at North Fork Reservoir, PA
    ## 591       USGS 03040000                  Stonycreek River at Ferndale, PA
    ## 621       USGS 03041029                Conemaugh River at Minersville, PA
    ## 731       USGS 03041500                     Conemaugh River at Seward, PA
    ## 824       USGS 03042000                  Blacklick Creek at Josephine, PA
    ## 964       USGS 03042280                  Yellow Creek near Homer City, PA
    ## 1058      USGS 03042500                    Two Lick Creek at Graceton, PA
    ## 1245      USGS 03044000                  Conemaugh River at Tunnelton, PA
    ##      site_tp_cd dec_lat_va dec_long_va coord_acy_cd dec_coord_datum_cd
    ## 197          ST   40.26619   -79.01669            S              NAD83
    ## 591          ST   40.28563   -78.92058            S              NAD83
    ## 621          ST   40.34139   -78.92611            S              NAD83
    ## 731          ST   40.41924   -79.02614            S              NAD83
    ## 824          ST   40.47701   -79.18670            S              NAD83
    ## 964          ST   40.57257   -79.10337            S              NAD83
    ## 1058         ST   40.51729   -79.17170            S              NAD83
    ## 1245         ST   40.45451   -79.39087            S              NAD83
    ##        alt_va alt_acy_va alt_datum_cd   huc_cd data_type_cd parm_cd
    ## 197      <NA>       <NA>         <NA> 05010007           uv   00060
    ## 591   1184.06        .01       NGVD29 05010007           uv   00060
    ## 621      1140        .01       NGVD29 05010007           uv   00060
    ## 731   1076.01        .01       NGVD29 05010007           uv   00060
    ## 824    954.46        .01       NAVD88 05010007           uv   00060
    ## 964      1140        .01       NGVD29 05010007           uv   00060
    ## 1058   981.63        .01       NGVD29 05010007           uv   00060
    ## 1245   844.64        .01       NGVD29 05010007           uv   00060
    ##      stat_cd  ts_id loc_web_ds medium_grp_cd parm_grp_cd  srs_id access_cd
    ## 197     <NA> 221326       <NA>           wat        <NA> 1645423         0
    ## 591     <NA> 122456       <NA>           wat        <NA> 1645423         0
    ## 621     <NA> 122464       <NA>           wat        <NA> 1645423         0
    ## 731     <NA> 122468       <NA>           wat        <NA> 1645423         0
    ## 824     <NA> 122471       <NA>           wat        <NA> 1645423         0
    ## 964     <NA> 122477       <NA>           wat        <NA> 1645423         0
    ## 1058    <NA> 122479       <NA>           wat        <NA> 1645423         0
    ## 1245    <NA> 122490       <NA>           wat        <NA> 1645423         0
    ##      begin_date   end_date count_nu
    ## 197  1987-10-03 1998-09-26     4011
    ## 591  1991-10-01 2018-07-13     9782
    ## 621  2001-12-13 2018-07-13     6056
    ## 731  1991-10-01 2018-07-13     9782
    ## 824  1991-10-15 2018-07-13     9768
    ## 964  1991-10-01 2018-07-13     9782
    ## 1058 1986-10-01 2018-07-13    11608
    ## 1245 2010-10-01 2018-07-13     2842

The `huc_poly` object is a new type of object that we haven't seen --- a `SpatialPolygonsDataFrame`. It has several different parts, or "slots". You can click on the object in your Rstudio environment window to see what is inside, or run `slotNames(t)`. Slots can be referenced directly using `@`, e.g. `huc_poly@data`. The `data` slot is like a regular R data frame, and contains information about the polygon. You can look at its contents in the nice Rstudio data frame format using `View(huc_poly@data)`. Since this shapefile only contains a single polygon, it only has one row . The `polygons` slot contains the actual vertices of the polygon. If there were multiple polygons in this object, the `plotOrder` field would determine the order in which they are drawn. The `bbox` field gives the bounding box of all polygons in the object, and `proj4.string` gives the projection. These fields can be used and modified to change or reference specific things about the object. In this examples, we will use the `bbox` slot in order to request a map zoomed to this HUC.

Now that we understand this new object, let's make some maps.

Raster map example
------------------

For the raster map, we will use the `ggmap` package to create a political map and a satellite basemap for the HUC. Since the basemaps that `ggmap` uses are quite detailed, they are too large to include with the package and must be retrieved from the web with the `get_map` function. For the `location` argument, we are taking the bounding box slot from the `huc_poly` object (originally a 2D vector) and converting it to a vector with `c()`. The `ggmap` function is analogous to the `ggplot` function in the `ggplot2` that you have likely already used. It creates the base map, which we can then add things to. Many of the commands used here are the same as in the `ggplot2` package.

``` r
library(ggmap)

#setting zoom to 9 gives us a bit of padding around the bounding box
basemap_streets <- get_map(maptype = "roadmap", location = c(huc_poly@bbox), zoom = 9)
basemap_satellite <- get_map(maptype = "satellite", location = c(huc_poly@bbox), zoom = 9)
street_map <- ggmap(basemap_streets) 
satellite_map <- ggmap(basemap_satellite)
print(street_map)
```

<img src='/static/mapping-in-r/raster_map_base-1.png'/ title='street base map' alt='plain base maps' class=''/>

``` r
print(satellite_map)
```

<img src='/static/mapping-in-r/raster_map_base-2.png'/ title='satellite base map' alt='plain base maps' class=''/>

Now we can start adding to our maps. To use a spatial polygon with `ggmap`, we first need to convert it to a standard data frame. Fortunately, the `tidy` function in the `broom` package does this for us. Also similar to `ggplot`, functions like `geom_polygon` and `geom_point` add to your base map.

``` r
tidy_huc_poly <- broom::tidy(huc_poly)
satellite_map + geom_polygon(data = tidy_huc_poly, aes(long, lat, group = group),
                             color = "white", fill = NA) + 
  geom_point(data = huc_gages, aes(x = dec_long_va, y = dec_lat_va, color = "Gage")) + 
  labs(color = NULL, x = "Longitude", y = "Latitude") + 
  geom_text(data = huc_gages, aes(label=site_no, x = dec_long_va, y = dec_lat_va), 
                                 hjust = 0, size=2.5, nudge_x = 0.02, col = "yellow")
```

<img src='/static/mapping-in-r/raster_map_add-1.png'/ title='satellite map with HUC and gages' alt='base maps with HUC and gages' class=''/>

``` r
street_map + geom_polygon(data = tidy_huc_poly, aes(long, lat, group = group),
                             color = "black", fill = NA) + 
  geom_point(data = huc_gages, aes(x = dec_long_va, y = dec_lat_va, color = "Gage")) + 
  labs(color = NULL, x = "Longitude", y ="Latitude") + 
  geom_text(data = huc_gages, aes(label=site_no, x = dec_long_va, y = dec_lat_va), 
                                 hjust = 0, size=2.5, nudge_x = 0.02)
```

<img src='/static/mapping-in-r/raster_map_add-2.png'/ title='street map with HUC and gages' alt='base maps with HUC and gages' class=''/>

Polygon map example
-------------------

If we don't want any raster background to our maps, we can use base plotting and the `maps` package. This style of map can be nicer for insets or large scale maps that would be cluttered with a raster background. The `maps` package provides easily accessible political boundary maps, that can be overlaid with other shapefiles. As with regular base plotting, you can think of creating maps like painting --- every layer has to go on in the right order. You can't remove things without starting over. Fortunately, you can start over with just a few keystrokes since you are scripting your plot! Run these commands one by one to see the map take shape --- first we create a blank state map, then add county lines in white, then the HUC boundary, then the gage points, and then the legend.

``` r
library(maps)
map(database = 'state', regions = 'Pennsylvania', col = "tan", fill = TRUE, border = NA)
#this draws all PA counties since the regions argument uses partial matching
map(database = 'county', regions = 'Pennsylvania', col = "white", fill = FALSE, add = TRUE)
plot(huc_poly, col = NA, add = TRUE)
points(x = huc_gages$dec_long_va, y = huc_gages$dec_lat_va, col = "red", pch = 19, cex = 0.7)
legend("bottomright", legend = c("Gage", "Subbasin boundary"), pch = c(19,NA), lty = c(NA, 1),
       col = c("red", "black"), title = "Legend")
title("Conemaugh Subbasin")
```

<img src='/static/mapping-in-r/poly-map-state-1.png'/ title='Polygon map of Pennsylvania' alt='Polygon map of Pennsylvania' class=''/>

Similarly, we could create a map zoomed in to the HUC polygon. We will start by plotting the HUC first, so that it sets the plot's boundaries, although if we wanted something else "on the bottom" we could specify a bounding box to the `map` function (you could access the coordinates from the shapefile with `huc_poly@bbox`.

``` r
  plot(huc_poly, col = "dodgerblue", border = NA)
  map(database = 'county', regions = 'Pennsylvania', add = TRUE, col = "lightgray")
  box()
  points(x = huc_gages$dec_long_va, y = huc_gages$dec_lat_va, col = "red", pch = 19, cex = 0.7)
  legend("bottomleft", legend = c("Gage", "Conemaugh subbasin"), pch = c(19,NA), lty = c(NA, 1),
       col = c("red", "dodgerblue"), title = "Legend", lwd = c(1,15), bg = "wheat")
  text(x = huc_gages$dec_long_va, y = huc_gages$dec_lat_va, labels = huc_gages$site_no,
       pos = 4, cex = 0.7)
```

<img src='/static/mapping-in-r/poly_map_zoomed_in-1.png'/ title='Polygon map zoomed to HUC' alt='Polygon map zoomed to HUC' class=''/>

Other packages and examples
---------------------------

Like plotting in R, there are endless intricacies to making maps, and we are only really scratching the surface here. Some other packages that you may find useful for certain applications include:

-   [sp](https://cran.r-project.org/web/packages/sp/index.html): The workhorse package for handling spatial data
-   [sf](https://cran.r-project.org/web/packages/sf/index.html): A newer package by many of the same authors as `sp` that simplifies spatial data manipulation
-   [raster](https://cran.r-project.org/web/packages/raster/index.html): For working with your own raster data

Also, check out our [additional topics in R](https://owi.usgs.gov/R/training-curriculum/intro-curriculum/Additional/) page for links to some other tutorials.
