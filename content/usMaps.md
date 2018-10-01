---
author: Jordan Read and Laura DeCicco
date: 2017-03-02
slug: usMap
draft: True
title: Map Stuff
type: post
categories: Data Science
image: static/usMap/map-1.png







tags:
  - R
  - dataRetrieval

description: Using the R packages dataRetrieval to discover how water-quailty has changed over time.
keywords:
  - R
  - dataRetrieval

  - dataRetrieval
  - Water-Quality
---
-   Jordan Read <a href="mailto:jread@usgs.gov" target="blank"><i class="fas fa-envelope-square fa-2x"></i></a> <a href="https://twitter.com/jordansread" target="blank"><i class="fab fa-twitter-square fa-2x"></i></a> <a href="https://github.com/jread-USGS" target="blank"><i class="fab fa-github-square fa-2x"></i></a> <a href="https://scholar.google.com/citations?hl=en&user=geFLqWAAAAAJ"><i class="ai ai-google-scholar-square ai-2x" target="blank"></i></a> <a href="https://cida.usgs.gov/people/jread.html" target="blank"><i class="fas fa-user fa-2x"></i></a>

-   Laura DeCicco <a href="mailto:ldecicco@usgs.gov" target="blank"><i class="fas fa-envelope-square fa-2x"></i></a> <a href="https://twitter.com/DeCiccoDonk" target="blank"><i class="fab fa-twitter-square fa-2x"></i></a> <a href="https://github.com/ldecicco-usgs" target="blank"><i class="fab fa-github-square fa-2x"></i></a> <a href="https://scholar.google.com/citations?hl=en&user=jXd0feEAAAAJ"><i class="ai ai-google-scholar-square ai-2x" target="blank"></i></a> <a href="https://www.usgs.gov/staff-profiles/laura-decicco" target="blank"><i class="fas fa-user fa-2x"></i></a>

``` r
library(dataRetrieval)
library(dplyr)

all_sites <- data.frame()
failed_sites <- c()

#Running this full code takes about 15 minutes:

for(i in stateCd$STUSAB[c(1:51,55)]){

  cat("Getting:",i,"\n")

  all_sites <- tryCatch({

    sites <- readNWISdata(service = "site",
                            seriesCatalogOutput=TRUE,
                            siteType="ST",hasDataTypeCd="qw",
                            stateCd = i)

    sites_filtered <- sites %>%
      filter(data_type_cd == "qw") %>%
      filter(count_nu >= 40) %>%
      select(site_no, station_nm, dec_lat_va, dec_long_va,
             begin_date, end_date) %>%
      distinct() %>%
      mutate(begin_date = as.Date(begin_date),
             end_date = as.Date(end_date),
             years = (end_date - begin_date)/365.25) %>%
      filter(years > 10) %>%
      mutate(state = i)

    bind_rows(all_sites, sites_filtered)
  },
  error=function(cond) {
    message("***************Errored on",i,"***********\n")
    return(all_sites)
  })
  saveRDS(all_sites, "static/usMap/allSites.rds")
}
```

``` r
unique_sites <- all_sites %>%
  group_by(site_no, station_nm, dec_lat_va, dec_long_va) %>%
  top_n(1, years) %>%
  data.frame() %>%
  distinct()
```

``` r
proj.string <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"

to_sp <- function(...){
  map <- maps::map(..., fill=TRUE, plot = FALSE)
  IDs <- sapply(strsplit(map$names, ":"), function(x) x[1])
  map.sp <- map2SpatialPolygons(map, IDs=IDs, proj4string=CRS("+proj=longlat +datum=WGS84"))
  map.sp.t <- spTransform(map.sp, CRS(proj.string))
  return(map.sp.t)
}

shift_sp <- function(sp, scale, shift, rotate = 0, ref=sp, proj.string=NULL, row.names=NULL){
  orig.cent <- rgeos::gCentroid(ref, byid=TRUE)@coords
  scale <- max(apply(bbox(ref), 1, diff)) * scale
  obj <- elide(sp, rotate=rotate, center=orig.cent, bb = bbox(ref))
  ref <- elide(ref, rotate=rotate, center=orig.cent, bb = bbox(ref))
  obj <- elide(obj, scale=scale, center=orig.cent, bb = bbox(ref))
  ref <- elide(ref, scale=scale, center=orig.cent, bb = bbox(ref))
  new.cent <- rgeos::gCentroid(ref, byid=TRUE)@coords
  obj <- elide(obj, shift=shift*10000+c(orig.cent-new.cent))
  if (is.null(proj.string)){
    proj4string(obj) <- proj4string(sp)
  } else {
    proj4string(obj) <- proj.string
  }

  if (!is.null(row.names)){
    row.names(obj) <- row.names
  }
  return(obj)
}

library(maptools)
library(maps)
library(sp)

conus <- to_sp('state')

# thanks to Bob Rudis (hrbrmstr):
# https://github.com/hrbrmstr/rd3albers

# -- if moving any more states, do it here: --
move_variables <- list(
  AK = list(scale=0.33, shift = c(80,-450), rotate=-50),
  HI = list(scale=1, shift=c(520, -110), rotate=-35),
  PR = list(scale=2.5, shift = c(-140, 90), rotate=20)
)

stuff_to_move <- list(
  AK = to_sp("world", "USA:alaska"),
  HI = to_sp("world", "USA:hawaii"),
  PR = to_sp("world", "Puerto Rico")
)

states.out <- conus

wgs84 <- "+init=epsg:4326"
coords = cbind(unique_sites$dec_long_va, unique_sites$dec_lat_va)
sites = SpatialPoints(coords, proj4string = CRS(wgs84)) %>%
  spTransform(CRS(proj4string(states.out)))

sites.df <- as.data.frame(sites)

for(i in names(move_variables)){
  shifted <- do.call(shift_sp, c(sp = stuff_to_move[[i]],
                                 move_variables[[i]],
                                 proj.string = proj4string(conus),
                                 row.names = i))
  states.out <- rbind(shifted, states.out, makeUniqueIDs = TRUE)

  shifted.sites <- do.call(shift_sp, c(sp = sites[unique_sites$state == i,],
                                       move_variables[[i]],
                                       proj.string = proj4string(conus),
                                       ref=stuff_to_move[[i]])) %>%
    as.data.frame %>%
    coordinates()

  sites.df[unique_sites$state == i, ] <- shifted.sites

}
```

``` r
library(ggplot2)
gsMap <- ggplot() +
  geom_polygon(aes(x = long, y = lat, group = group),
               data = states.out, fill = "grey90",
               alpha = 0.5, color = "white") +
  geom_point(data = sites.df,
             aes(x = coords.x1, y=coords.x2),
             colour = "red", size = 0.01) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank())

gsMap
```

<img src='/static/usMap/map-1.png'/ title='TODO' alt='TODO' class=''/>

Questions
---------

Information on USGS-R packages used in this post:

<table style="width:93%;">
<colgroup>
<col width="19%" />
<col width="73%" />
</colgroup>
<tbody>
<tr class="odd">
<td><a href="https://github.com/USGS-R/dataRetrieval" target="_blank"><img src="/images/USGS_R.png" alt="USGS-R image icon" style="width: 75px;" /></a></td>
<td><a href="https://github.com/USGS-R/dataRetrieval/issues" target="_blank">dataRetrieval</a>: This R package is designed to obtain USGS or EPA water quality sample data, streamflow data, and metadata directly from web services.</td>
</tr>
</tbody>
</table>
