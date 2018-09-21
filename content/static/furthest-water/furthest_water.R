library(sf)
library(nhdplusTools)
library(dplyr)

furthest_water <- function(scenario) {
  # First we will use a nhdplusTools to load up the national seamless geodatabase.
  nhdplusTools::nhdplus_path("nhdplus_data/NHDPlusV21_National_Seamless.gdb")
  staged_data <- nhdplusTools::stage_national_data(include = "flowline", 
                                                   output_path = "nhdplus_data")
  flowlines <- readRDS(staged_data$flowline)
  
  # Now lets read in the waterbodies directly from the national seamless database.
  if("waterbodies" %in% scenario) {
    water_bodies <- read_sf(nhdplus_path(), "NHDWaterbody")
  }
  
  if("filter_monthly_flow" %in% scenario) {
    monthlies <- which(grepl("QA_[0-1][0-9]", names(flowlines)))
    min_monthlies <- apply(st_set_geometry(flowlines, NULL)[monthlies], 1, min)
  }
  
  if("remove_intermittent" %in% scenario) {
    fcodes <- sf::read_sf(nhdplus_path(), "NHDFCode")
    remove_fcodes <- fcodes[which(fcodes$Hydrograph == "Intermittent"), ]
  }
  
  # For this analysis, the albers equal area projection will work.
  # http://spatialreference.org/ref/sr-org/epsg-5070/
  crs <- st_crs(5070)
  
  # See: https://www.arcgis.com/home/item.html?id=b07a9393ecbd430795a6f6218443dccc for this file
  states <- read_sf("states_21basic/states.shp")
  
  # http://bboxfinder.com/#25.284438,-127.265625,43.707594,-94.438477
  bbox <- c(-127.265625,25.284438,-94.438477,43.7075949)
  names(bbox) <- c("xmin", "ymin", "xmax", "ymax")
  class(bbox) <- "bbox"
  bbox <- st_as_sfc(bbox)
  st_crs(bbox) <- 4326
  
  # Now filter, transform and simplify the geometry getting ready for processing.
  bbox <- st_transform(bbox, crs)
  
  states <- states %>%
    st_transform(crs) %>%
    st_cast("POLYGON") %>%
    mutate(AREA = st_area(.)) %>%
    filter(AREA > units::set_units(2500000000, "m^2")) %>%
    select(-AREA)
  
  if("filter_monthly_flow" %in% scenario) {
    flowlines <- flowlines[which(min_monthlies !=0 ), ]
  }
  
  if("remove_intermittent" %in% scenario) {
    flowlines <- flowlines[which(!flowlines$FCODE %in% remove_fcodes$FCode), ] 
    if("waterbodies" %in% scenario) {
      water_bodies <- water_bodies[which(!water_bodies$FCODE %in% remove_fcodes$FCode), ]
    }
  }
  
  flowlines <- flowlines %>%
    st_transform(crs) %>%
    st_simplify(1000) %>%
    st_intersection(bbox)
  
  if("waterbodies" %in% scenario) {
    water_bodies <-
      st_transform(water_bodies, crs) %>%
      st_buffer(0) %>%
      st_simplify(500) %>%
      st_intersection(bbox)
  }
  
  # Save some intermediate artifacts that we'll read back in later.
  saveRDS(flowlines, "temp_flowlines.rds")
  if("waterbodies" %in% scenario) saveRDS(water_bodies, "temp_water_bodies.rds")
  
  # Convert data to raw coordinates and set up search points.
  #####
  if("waterbodies" %in% scenario) wb_COMID <- water_bodies$COMID
  fl_COMID <- flowlines$COMID
  
  # Now turn both flowlines and water_bodies into coordinate pairs only
  flowlines <-
    st_cast(flowlines, "MULTILINESTRING") %>%
    st_coordinates()
  if("waterbodies" %in% scenario) {
    water_bodies <-
      st_cast(water_bodies, "MULTIPOLYGON") %>%
      st_coordinates()
  }
  
  # Extract the identifier of features from the coordinates
  if("waterbodies" %in% scenario) {
    water_bodies <- water_bodies[,c(1,2,5)] %>%
      data.frame() %>%
      rename(ID = L3)
  }
  flowlines <- flowlines[,c(1,2,4)] %>%
    data.frame() %>%
    rename(ID = L2)
  
  # Switch the new ID column to the "COMID" values from the source data.
  if("waterbodies" %in% scenario) {
    water_bodies[["COMID"]] <- wb_COMID[water_bodies[["ID"]]]
  }
  flowlines[["COMID"]] <- fl_COMID[flowlines[["ID"]]]
  
  # Bind together into one huge set of coordinates.
  if("waterbodies" %in% scenario) {
    coords <- rbind(water_bodies, flowlines) %>%
      dplyr::select(-ID)
    rm(flowlines, water_bodies)
  } else {
    coords <- flowlines %>%
      dplyr::select(-ID)
    rm(flowlines)
  }
  
  # Create a set of search locations
  search_bbox <- st_bbox(bbox)
  x <- seq(search_bbox$xmin, search_bbox$xmax, 5000)
  y <- seq(search_bbox$ymin, search_bbox$ymax, 5000)
  search <- expand.grid(x,y)
  
  # Convert to sf and intersect with the state boundaries.
  search <- st_as_sf(data.frame(search), coords = c("Var1", "Var2"), crs = crs) %>%
    st_intersection(states) %>%
    st_intersection(bbox) %>%
    st_coordinates() %>%
    data.frame()
  
  # Function to plot results in a .png
  plot_result <- function(search, radius, crs, bbox, states) {
    fname <- stringr::str_pad(paste0(as.character(radius), ".png"), 10, "left", "0")
    png(fname,
        width = 1000, height = 800)
    result <- st_as_sf(search, coords = c("X", "Y"), crs = crs)
    
    plot(bbox, main = paste("Distance to nearest water:", radius, "meters"))
    plot(states$geometry, add = TRUE)
    plot(result$geometry, pch = 19, add = TRUE)
    dev.off()
  }
  
  # Set up values for while loop
  radius <- 0
  num_left <- nrow(search)
  
  while(num_left > 1) {
    num_left <- nrow(search)
    
    # This is where the magic happens.
    matched <- RANN::nn2(coords[,1:2],
                         search,
                         k = 1,
                         searchtype = "radius",
                         radius = radius) %>%
      data.frame()
    
    # This while loop is destructive. Only keep unmatched.
    search <- filter(search, matched$nn.idx == 0)
    
    plot_result(search, radius, crs, bbox, states)
    
    if(radius < 2000) {
      radius <- radius + 200
    } else  if(num_left > 50) {
      radius <- radius + 1000
    } else if (num_left > 3) {
      radius <- radius + 500
    } else {
      radius <- radius + 100
    }
  }
  
  rm(coords)
  
  gifski::gifski(list.files(pattern = "*0.png"))
  
  # Where in the world is the result?
  result <- st_as_sf(search, coords = c("X", "Y"), crs = crs)
  print(sf::st_transform(result$geometry, 4326))
  
  # Load geospatial data again.
  flowlines <- readRDS("temp_flowlines.rds")
  if("waterbodies" %in% scenario) water_bodies <- readRDS("temp_water_bodies.rds")
  
  # Set up a plot area around our result.
  plot_area <- st_buffer(result$geometry, 150000) %>%
    st_bbox() %>%
    st_as_sfc()
  st_crs(plot_area) <- crs
  
  # Use 3857 (web mercator) for visualization.
  plot_proj <- 3857
  plot_area <- st_transform(plot_area, plot_proj)
  
  # Subset data to an area that satisfies plot_area.
  data_area <- st_bbox(plot_area) %>%
    st_as_sfc()
  st_crs(data_area) <- st_crs(data_area)
  data_area <- st_transform(data_area, crs)
  
  if("waterbodies" %in% scenario) {
    local_water <- st_intersection(water_bodies,
                                   data_area) %>%
      st_simplify(1000) %>%
      st_transform(plot_proj)
  }
  
  local_flowlines <- st_intersection(flowlines,
                                  data_area) %>%
    st_simplify(5000) %>%
    st_transform(plot_proj)
  
  bgmap <- plot_area %>%
    st_transform(4326) %>%
    st_bbox() %>%
    setNames(c("left", "bottom", "right", "top")) %>%
    ggmap::get_map(zoom = 7)
  
  # write out a png of the local area.
  png("furthest_water.png", width = 1024, height = 1024)
  par(omi = c(0,0,0,0), mai = c(0,0,0,0))
  plot(plot_area, col = NA, border = NA, xaxs = 'i', yaxs = 'i', bgMap = bgmap)
  plot(st_transform(states$geometry, plot_proj), add = TRUE)
  plot(st_transform(result$geometry, plot_proj), col = "red", cex = 3, lwd = 4, add = TRUE)
  plot(local_flowlines$Shape, add = TRUE, col = "blue")
  if("waterbodies" %in% scenario) plot(local_water$Shape, add = TRUE, col = "azure2")
  dev.off()
  
  unlink("temp_water_bodies.rds", force = TRUE)
  unlink("temp_flowlines.rds", force = TRUE)
  unlink(list.files(pattern = "*0.png"), force = TRUE)
}
