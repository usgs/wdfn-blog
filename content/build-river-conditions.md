---
author: Lindsay RC Platt
date: 2021-03-19
slug: build-r-animations
draft: True
title: Recreating the U.S. River Conditions animations in R
type: post
categories: Data Science
image: /static/us-river-conditions/blog_thumbnail.gif
author_twitter: LindsayRCPlatt
author_github: lindsayplatt
author_staff: lindsay-rc-platt
author_email: <lplatt@usgs.gov>
description: Use R to generate a video and gif similar to the Vizlab animation series, U.S. River Conditions.
keywords:
  - NWIS
  - reproducibility
  - data visualization
tags: 
  - R
  - dataRetrieval
---
For the last few years, we have [released quarterly animations of
streamflow conditions at all active USGS streamflow sites](https://www.usgs.gov/media/videos/us-river-conditions-october-december-2020). These visualizations use daily streamflow measurements pulled from the [USGS National Water Information System (NWIS)](https://nwis.waterdata.usgs.gov/nwis) to show how streamflow changes throughout the year and highlight the reason behind some of the hydrologic patterns. Here, we walk through the steps to recreate a similar version in R.

{{< figure src="/static/us-river-conditions/blog_thumbnail.gif" alt="Map animating through time, starting October 1, 2020 and ending October 31, 2020. Points on the map show USGS stream gage locations and the points change color based on streamflow values. They are red for low flow (less than 25th percentile), white for normal, and blue for high flow (greater than or equal to 75th percentile).">}}

The workflow to recreate the U.S. River Conditions animations can be divided into these key sections:

* [Workflow setup](#setup)
* [Get data](#fetchdata)
* [Visual configurations](#viconfig)
* [Prep data for mapping](#mapreadydata)
* [Create animation frames](#makeframes)
* [Make a gif](#creategif)
* [Make a video](#createvideo)
* [Optimize your animations](#optimize)

Background on the animation series
----------------------------

The U.S. River Conditions animation series ([visit the full portfolio of USGS Vizlab
products to see examples)](https://www.usgs.gov/mission-areas/water-resources/science/water-data-visualizations) was inspired by the USGS streamflow conditions website,
[WaterWatch](https://waterwatch.usgs.gov/?id=ww_current). WaterWatch depicts national streamflow conditions by coloring each gage's dot by how it's daily streamflow value relates to _that day’s_ record of streamflow values. Hydrologists and other water data experts use this nuanced metric to inform daily decisions.

In contrast to WaterWatch, the U.S. River Conditions animation series was intended to target a new audience of users who may be unfamiliar with the USGS streamgaging network. To make the content more accessible to non-technical audiences, we deviated from WaterWatch by 1) adding context to the data by including callout text, 2)
building a file type that can be directly embedded on social media
platforms (e.g Twitter, Facebook, Instagram), and 3) using streamflow metrics that
were not as complex. To make the streamflow metrics less complex, the animation colors 
each gage's dot by how it's daily streamflow value relates to its _entire_
record of streamflow values (not the individual day's record as WaterWatch does). This change helps reinforce knowledge that lots of people already have about seasonal patterns (e.g. wet springs
and dry summers) and builds on that existing framework to introduce streamflow data. 

We rebuild the U.S. River Conditions animation every three months to summarize the last quarter's streamflow 
events to the public. To be able to do this efficiently and programmatically, the entire visualization is
coded in R. The only manual effort required is to update the timeframe of interest and
configure the text for hydrologic events. You can see the code for the visualization
[here on GitHub](https://github.com/USGS-VIZLAB/gage-conditions-gif). 
The visualization pipeline is completely reproducible, but does use a custom, internal
pipelining tool built off of the R package, `remake` (very powerful, but
almost like learning a new language). To make the processing more transparent and accessible,
I created this blog to demonstrate the main workflow for how we create the U.S. River Conditions 
animations in R (independent of the pipeline tool). The workflow below will 
not recreate them exactly, but it should give you the tools to make similar 
video and gif animations from R.

First, configs and packages. {#setup}
----------------------------

This code is set up to operate based on all CONUS states. You should be
able to change the state(s), projection, and date range to
quickly generate something relevant to your area!

``` r
library(dataRetrieval)
library(tidyverse) # includes dplyr, tidyr
library(maps)
library(sf)

# Viz dates
viz_date_start <- as.Date("2020-10-01")
viz_date_end <- as.Date("2020-10-31")

# Currently set to CONUS (to list just a few, do something like `c("MN", "WI", "IA", "IL")`)
viz_states <- c("AL", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", 
                "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", 
                "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", 
                "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", 
                "UT", "VT", "VA", "WA", "WV", "WI", "WY")

# Albers Equal Area, which is good for full CONUS
viz_proj <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"

# Configs that could be changed ...
param_cd <- "00060" # This is the streamflow parameter code. See `dataRetrieval::parameterCdFile` for more.
service_cd <- "dv" # This is the daily value service. See `https://waterservices.usgs.gov/rest/` for more info about services available.

```

Get data!  {#fetchdata}
---------

### Find the site numbers.

Find the gages that have data for your states and time period.

``` r
# Can only query one state at a time, so need to loop through. 
# For one month of CONUS data, this took ~ 1 minute.

sites_available <- data.frame() # This will be table of site numbers and their locations.
for(s in viz_states) {
  # Some states might not return anything, so use `tryCatch` to allow
  # the `for` loop to keep going.
  message(sprintf("Trying %s ...", s))
  sites_available <- tryCatch(
    whatNWISsites(
      stateCd = s, 
      startDate = viz_date_start,
      endDate = viz_date_end,
      parameterCd = param_cd, 
      service = service_cd) %>%
      select(site_no, station_nm, dec_lat_va, dec_long_va), 
    error = function(e) return()
  ) %>% bind_rows(sites_available)
}
```

### Next, get the statistics data.

The biggest processing hurdle for the U.S. River Conditions animation is
to fetch and process EVERY streamflow data point in the entire NWIS
database in order to calculate historic statistics. We have a separate
pipeline to pull the data (see
[`national-flow-observations`](https://github.com/USGS-R/national-flow-observations))
and steps in the U.S. River Conditions code to calculate the quantiles
(see [this
script](https://github.com/USGS-VIZLAB/gage-conditions-gif/blob/master/2_process/src/process_dv_historic_quantiles.R)).

For the purposes of this workflow, we will use [the `stat` service (beta)
from NWIS](https://waterservices.usgs.gov/rest/Statistics-Service.html)
so that we don’t need to pull down all of the historic data. This means
that the final viz will show the values relative to that day’s historic
values (as WaterWatch does). That is how the `stat` service works and
greatly simplifies the processing part of this example so we can get to the
animation!

For this map, we will create a scale of 3 values from low (less than
25th percentile), normal (between 25th and 75th percentile), and high
(greater than 75th percentile). So, let’s fetch those stats for the
sites we now have. You can visit [the stats service
documentation](https://waterservices.usgs.gov/rest/Statistics-Service.html#statType)
for more on what stats are available to download.

``` r
# For one month of CONUS, this took ~ 15 min

# Can only pull stats for 10 sites at a time, so loop through chunks of 10
#   sites at a time and combine into one big dataset!
sites <- unique(sites_available$site_no)

# Divide request into chunks of 10
req_bks <- seq(1, length(sites), by=10)

viz_stats <- data.frame()
for(chk_start in req_bks) {
  chk_end <- ifelse(chk_start + 9 < length(sites), chk_start + 9, length(sites))
  # Note that each call throws warning about BETA service :)
  message(sprintf("Pulling down stats for %s:%s", chk_start, chk_end))
  viz_stats <- tryCatch(readNWISstat(
    siteNumbers = sites[chk_start:chk_end],
    parameterCd = param_cd,
    statType = c("P25", "P75")
  ) %>% select(site_no, month_nu, day_nu, p25_va, p75_va), 
  error = function(e) return()
  ) %>% bind_rows(viz_stats)
}
```

### Now get the daily values

``` r
# For all of CONUS, there are 8500+ sites.
# Just in case there is an issue, use a loop to cycle through 100
# at a time and save the output temporarily, then combine after.
# For one month of CONUS data, this took ~ 10 minutes

max_n <- 100
sites <- unique(sites_available$site_no)
sites_chunk <- seq(1, length(sites), by=max_n)
site_data_fns <- c()
tmp <- tempdir()
  
for(chk_start in sites_chunk) {
  chk_end <- ifelse(chk_start + (max_n-1) < length(sites), 
                    chk_start + (max_n-1), length(sites))
  
  site_data_fn_i <- sprintf(
    "%s/site_data_%s_%s_chk_%s_%s.rds", tmp, 
    format(viz_date_start, "%Y_%m_%d"), format(viz_date_end, "%Y_%m_%d"),
    # Add leading zeroes in front of numbers so they remain alphanumerically ordered
    sprintf("%02d", chk_start), 
    sprintf("%02d", chk_end))
  site_data_fns <- c(site_data_fns, site_data_fn_i)
  
  if(file.exists(site_data_fn_i)) {
      message(sprintf("ALREADY fetched sites %s:%s, skipping ...", chk_start, chk_end))
    next
  } else {
    site_data_df_i <- readNWISdata(
      siteNumbers = sites_available$site_no[chk_start:chk_end],
      startDate = viz_date_start,
      endDate = viz_date_end,
      parameterCd = param_cd,
      service = service_cd
    ) %>% renameNWISColumns() %>% 
      select(site_no, dateTime, Flow) 
    saveRDS(site_data_df_i, site_data_fn_i)
    message(sprintf("Fetched sites %s:%s out of %s", chk_start, chk_end, length(sites)))
    }
  
}

# Read and combine all of them
viz_daily_values <-  lapply(site_data_fns, readRDS) %>% bind_rows()

nrow(viz_daily_values) # ~250,000 obs for one month of CONUS data
```

### Compare daily to stats to get viz categories

``` r
# To join with the stats data, we need to first break the dates into
# month day columns
viz_daily_stats <- viz_daily_values %>% 
  mutate(month_nu = as.numeric(format(dateTime, "%m")),
         day_nu = as.numeric(format(dateTime, "%d"))) %>% 
  left_join(viz_stats) %>% 
  mutate(viz_category = ifelse(
    Flow <= p25_va, "Low", 
    ifelse(Flow > p25_va & Flow <= p75_va, "Normal",
           ifelse(Flow > p75_va, "High",
                  NA))))
```

Build the animation frames.
---------------------------

Now onto visualizing the data!

### Setup visualization configs {#vizconfig}

I like to separate visual configurations, such as frame dimensions and symbol colors/shapes, so that it is easy to find them when I want to make adjustments or reuse the code for another project.

```r
# Viz frame height and width. These are double the size the end video & 
#   gifs will be. See why in the "Optimizing for various platforms" section
viz_width <- 2048 # in pixels 
viz_height <- 1024 # in pixels

# Style configs for plotting
viz_categories <- c("High", "Normal", "Low", "Missing")  
category_col <- c("#00126099", "#EAEDE9FF", "#601200FF", "#7f7f7fFF") # Colors in order of categories (hex color codes + alpha code)
category_pch <- c(16, 19, 1, 4) # Point types in order of categories
category_cex <- c(1.5, 1, 2, 0.75) # Point sizes in order of categories
category_lwd <- c(NA, NA, 1, NA) # Circle outline width in order of categories
```

### Get data ready for mapping  {#mapreadydata}

We are going to need to do two last things to our data to get it ready
to visualize. First, add a column that becomes the color used based on
the category. Second, join in the lat/long information and convert to a
spatial data frame.

``` r
# Created a function to use that picks out the correct config based on
# category name. Made it a fxn since I needed to do it for colors, 
# point types, and point sizes.
pick_config <- function(viz_category, config) {
  ifelse(
    viz_category == "Low", config[3], 
    ifelse(viz_category == "Normal", config[2],
           ifelse(viz_category == "High", config[1],
                  config[4]))) # NA color
}

# Add style information as 3 new columns
viz_data_ready <- viz_daily_stats %>% 
  mutate(viz_pt_color = pick_config(viz_category, category_col),
         viz_pt_type = pick_config(viz_category, category_pch),
         viz_pt_size = pick_config(viz_category, category_cex),
         viz_pt_outline = pick_config(viz_category, category_lwd)) %>% 
  # Simplify columns
  select(site_no, dateTime, viz_category, viz_pt_color, 
         viz_pt_type, viz_pt_size, viz_pt_outline) %>% 
  left_join(sites_available) %>% 
  # Arrange so that NAs are plot first, then normal values on top of those, then 
  # high values, and then low so that viewer can see the most points possible.
  arrange(dateTime, factor(viz_category, levels = c(NA, "Normal", "High", "Low")))

# Convert to `sf` object for mapping
viz_data_sf <- viz_data_ready %>% 
  st_as_sf(coords = c("dec_long_va", "dec_lat_va"), crs = "+proj=longlat +datum=WGS84") %>% 
  st_transform(viz_proj)
```

### Get background map data ready

Using the states the user picked, create an `sf` object to use as the
map background.

``` r
# Convert state codes into lowercase state names, which `maps` needs
viz_state_names <- tolower(stateCdLookup(viz_states, "fullName"))
state_sf <- st_as_sf(maps::map('state', viz_state_names, fill = TRUE, plot = FALSE)) %>%
  st_transform(viz_proj)
```

Make a single map frame!
========================

Use base plotting to make a map per day. Pick the first day in the date
sequence to test out your single frame.

``` r
png("test_single_day.png", width = viz_width, height = viz_height)

# Prep plotting area (no margins, small space at top/bottom for title, white background)
par(omi = c(0,0,0,0), mai = c(0.5,0,0.5,0.25), bg = "white")

# Add the background map
plot(st_geometry(state_sf), col = "#b7b7b7", border = "white") 

# Add gages for the first day in the data set
viz_data_sf_1 <- viz_data_sf %>% filter(dateTime == viz_date_start)
plot(st_geometry(viz_data_sf_1), add=TRUE, pch = viz_data_sf_1$viz_pt_type, 
     cex = viz_data_sf_1$viz_pt_size, col = viz_data_sf_1$viz_pt_color,
     lwd = viz_data_sf_1$viz_pt_outline)

# Now add on a title, the date, and a legend
text_color <- "#363636"
title("Daily streamflow relative to daily historic record", cex.main = 4.5, col.main = text_color)
mtext(format(viz_date_start, "%b %d, %Y"), side = 1, line = 0.5, cex = 3.5, font = 2, col = text_color)
legend("right", legend = viz_categories, col = category_col, pch = category_pch, 
       pt.cex = category_cex*3, pt.lwd = category_lwd*2, bty = "n", cex = 3, text.col = text_color)

dev.off()
```

{{< figure src="/static/us-river-conditions/test_single_day.png" alt="Map depicting October 1, 2020 streamflow data with points colored red for low flow (less than 25th percentile), white for normal, and blue for high flow (greater than or equal to 75th percentile).">}}

### Create animation frames {#makeframes}

Ok, we have created one frame and we like how it looks, so time to apply
this to every date.

``` r
frame_dir <- "frame_tmp" # Save frames to a folder
frame_configs <- data.frame(date = unique(viz_data_sf$dateTime)) %>% 
   # Each day gets it's own file
  mutate(name = sprintf("%s/frame_%s.png", frame_dir, date),
         frame_num = row_number())

if(!dir.exists(frame_dir)) dir.create(frame_dir)

# Loop through dates
for(i in frame_configs$frame_num) {
  this_date <- frame_configs$date[i]
  
  # Filter gage data to just this day:
  data_this_date <- viz_data_sf %>% filter(dateTime == this_date)
  
  png(frame_configs$name[i], width = viz_width, height = viz_height) # Open file
  
  # Copied plotting code from previous step
  # Prep plotting area (no margins, small space at top/bottom for title, white background)
  par(omi = c(0,0,0,0), mai = c(1,0,1,0.5), bg = "white")
  
  # Add the background map
  plot(st_geometry(state_sf), col = "#b7b7b7", border = "white") 
  
  # Add gages for this day
  plot(st_geometry(data_this_date), add=TRUE, pch = data_this_date$viz_pt_type, 
       cex = data_this_date$viz_pt_size, col = data_this_date$viz_pt_color, 
       lwd = data_this_date$viz_pt_outline)
  
  # Add the title, date, and legend
  text_color <- "#363636"
  title("Daily streamflow relative to daily historic record", 
        cex.main = 4.5, col.main = text_color)
  mtext(format(this_date, "%b %d, %Y"), side = 1, line = 0.5, 
        cex = 3.5, font = 2, col = text_color)
  legend("right", legend = viz_categories, col = category_col, 
         pch = category_pch, pt.cex = category_cex*3, 
         pt.lwd = category_lwd*2, bty = "n", cex = 3, 
         text.col = text_color)
  
  dev.off() # Close file
}

# You can check that all the files were created by running
all(file.exists(frame_configs$name))
```

Stitch together into an actual animation
----------------------------------------

Now that you have all of your frames for the animation ready, we can
stitch them together into a video or GIF! This will work for any set of
images you have. To use this code with other frames (if you didn’t
create the ones above), just change out the first line of the GIF or
video code chunks that define a vector of files as `frames`.

### GIF {#creategif}

To create GIFs, we use a software called `ImageMagick`. It is not an R
package, but we can run commands to use it through the `system` function
in R. For these commands to work, you will first need to install the
`ImageMagick` library. Go to
[imagemagick.org](https://imagemagick.org/script/download.php) to do so.
Once installed, make sure you restart R if you had it open before
installing.

``` r
# GIF configs that you set
frames <- frame_configs$name # Assumes all are in the same directory
gif_length <- 10 # Num seconds to make the gif
gif_file_out <- sprintf("animation_%s_%s.gif", 
                        format(viz_date_start, "%Y_%m_%d"),
                        format(viz_date_end, "%Y_%m_%d"))

# ImageMagick needs a temporary directory while it is creating the GIF to 
#   store things. Make sure it has one. I am making this one, inside of
#   the directory where our frames exist.
tmp_dir <- sprintf("%s/magick", dirname(frames[1]))
if(!dir.exists(tmp_dir)) dir.create(tmp_dir)

# Calculate GIF delay based on desired length & frames
# See https://legacy.imagemagick.org/discourse-server/viewtopic.php?t=14739
fps <- length(frames) / gif_length # Note that some platforms have specific fps requirements
gif_delay <- round(100 / fps) # 100 is an ImageMagick default (see that link above)

# Create a single string of all the frames going to be stitched together
#   to pass to ImageMagick commans.
frame_str <- paste(frames, collapse = " ")

# Create the ImageMagick command to convert the files into a GIF
magick_command <- sprintf('convert -define registry:temporary-path=%s -limit memory 24GiB -delay %s -loop 0 %s %s',
                          tmp_dir, gif_delay, frame_str, gif_file_out)

# If you are on a Windows machine, you will need to have `magick` added before the command
if(Sys.info()[['sysname']] == "Windows") {
  magick_command <- sprintf('magick %s', magick_command)
}

# Now actually run the command and create the GIF
system(magick_command)
```

An optional step is to use an additional non-R library called `gifsicle`
to simplify the GIF. It will lower the final size of your GIFs (which
can get quite large if you have a lot of frames). You will need to
[install `gifsicle`](https://www.lcdf.org/gifsicle/) before you can run
this code.

``` r
# Simplify the gif with gifsicle - cuts size by about 2/3
gifsicle_command <- sprintf('gifsicle -b -O3 -d %s --colors 256 %s', 
                            round(gif_delay), gif_file_out)
system(gifsicle_command)
```

{{< figure src="/static/us-river-conditions/animation_2020_10_01_2020_10_31.gif" alt="Map animating through time, starting October 1, 2020 and ending October 31, 2020. Points on the map show USGS stream gage locations and the points change color based on streamflow values. They are red for low flow (less than 25th percentile), white for normal, and blue for high flow (greater than or equal to 75th percentile).">}}

### Video {#createvideo}

Videos are created in a similar way to GIFs, but we use a tool called
`ffmpeg`. There are a lot of configuration options (we are still
learning about how to use these). What we have in the command here is
what we have found results in the best video. You can see all of the
options and download the tool from
[ffmpeg.org](https://www.ffmpeg.org/).

Note: This tool requires an extra step [if you are on a Windows machine
because it cannot use your filenames outright (unless numbered from
1:n)](https://stackoverflow.com/questions/31201164/ffmpeg-error-pattern-type-glob-was-selected-but-globbing-is-not-support-ed-by).
I have included the extra step to [add the filenames to a text file and
use that in the video creation
command](https://stackoverflow.com/questions/47935195/how-to-create-a-video-from-frames-named-using-timestamp-with-ffmpeg).

``` r
# Video configs that you set
frames <- frame_configs$name # Assumes all are in the same directory
video_length <- 30 # in seconds
video_file_out <- sprintf("animation_%s_%s.mp4", 
                          format(viz_date_start, "%Y_%m_%d"),
                          format(viz_date_end, "%Y_%m_%d"))

# Calculate frame rate based on desired length & num frames 
# If r < 1, duplicates some frames; if r > 1, drops some frames
# Round up to nearest 0.25 (don't need to be more specific than that)
r <- video_length/length(frames)
r <- ceiling(r / 0.25) * 0.25

# Put all frame filenames into a single text file & their
# durations in the line right below (use same duration for 
# each in this example).
files_to_cat_fn <- "frames_to_video.txt" # Will delete at end
writeLines(sprintf("file '%s'\nduration %s", frames, r), files_to_cat_fn)

# Construct command, see more options at https://www.ffmpeg.org/ffmpeg.html
#   `-y` allows you to overwrite the out file
#   `-f` concat is needed to tell ffmpeg we are using a text file of images to use
#   `-i %s` will list the text file for input files to stitch together
#   `-pix_fmt yuv420p` is the pixel format being used. This works well with libx264
#   `-vcodec libx264` choose the library that will be used to compress the video
#   `-crf 27`, option for controling quality. See https://slhck.info/video/2017/02/24/crf-guide.html
ffmpeg_command <- sprintf(
  "ffmpeg -y -f concat -i %s -pix_fmt yuv420p -vcodec libx264 -crf 27 %s", 
  files_to_cat_fn, video_file_out)
system(ffmpeg_command) # Run command
```

<video autosize=TRUE controls>
  <source src="static/us-river-conditions/animation_2020_10_01_2020_10_31.mp4" type="video/mp4">
</video>

Optimizing for various platforms  {#optimize}
--------------------------------

### Image quality

For Windows users, the quality of saved PNG images is pretty low and
results in pixelated videos. We were able to overcome this by setting
the width and height to double the desired size and later downscaling
the video. It will require you to adjust your point and text sizes on
frames themselves. When creating the PNG files, I use a width and height
double the size of what I wanted in the end, so now all I have to do is
downscale! If you follow this approach, you can downscale your video to
half the size by running the following:

``` r
# For GIFs
original_gif_file <- gif_file_out # The file with the dimensions double what you need
out_gif_file <- gsub(".gif", "_downscaled.gif", gif_file_out) # The final file that has been downscale
system(sprintf("gifsicle --scale 0.5 -i %s > %s", original_gif_file, out_gif_file))

# For videos
original_video_file <- video_file_out # The file with the dimensions double what you need
out_video_file <- gsub(".mp4", "_downscaled.mp4", video_file_out) # The final file that has been downscale
system(sprintf("ffmpeg -i %s -vf scale=iw/2:-1 %s", original_video_file, out_video_file))
```

### Platform specs

Different social media platforms have different requirements for your
content. The biggest thing to check before planning your animation are
the dimensions and aspect ratio you will need. Those can change the way
that you need to layout your animation (for example, Instagram videos
are often square or portrait but rarely landscape). If I want to put
this on multiple platforms, you will likely need to generate multiple
animations. I always have three different versions, where each is
optimized for the platform on which it will be released. When I do this,
I make sure to write functions to share as much of the code as possible
but deviate as necessary.

As you plan your animation, consider the following list of technical
specs that platforms may require. To find technical specs by platform,
you can use your favorite web search! Try to look at the most recent
list available because the specs can change. So far, I have had great
success with [this updating article from Sprout
Social](https://sproutsocial.com/insights/social-media-image-sizes-guide/).

-   maximum file size
-   maximum video length
-   maximum/minimum height/width
-   specific aspect ratio
-   framerate

Other animation options
-----------------------

In the world of R, there are tons of other animation options. If you are
a `ggplot2` user, there is a package called `gganimate` that will create
animations without the need for any of the additional tools I listed
here. I have struggled with using that package in the past (though to be
fair since I had been using this method, I didn’t try very hard to
learn) and found it to be very slow compared to the multiframe plus ImageMagick
or FFMPEG method.

Go forth and animate!
