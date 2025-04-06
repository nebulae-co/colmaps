library("dplyr")
# library("rgdal")
library("stringi")
# library("rgeos")
library("sf")
library("rmapshaper")


# Generate first maps -----------------------------------------------------

map <- list(municipios = NULL, departamentos = NULL)

for (level in names(map)){
  path <- c(input     = "data-raw/shapefiles-dane/",
               rawoutput = "data-raw/shapefiles-nebulae/")

  if(!dir.exists(path["rawoutput"])){
    dir.create(path["rawoutput"])
  }

  path <- sapply(path, paste0, level)

  map[[level]] <- st_read(path["input"], layer = level)

  map[[level]] <- ms_simplify(map[[level]], keep = 0.1, keep_shapes = TRUE)

  if(dir.exists(path["rawoutput"])){
    file.remove(dir(path["rawoutput"], full.names = TRUE))
  } else {
    dir.create(path["rawoutput"])
  }

  st_write(map[[level]], dsn = path["rawoutput"],  driver = "ESRI Shapefile",
           layer_options = "ENCODING=UTF-8", delete_dsn = TRUE)

}



# Compute the insets for traditional maps. --------------------------------


map[["municipios"]] %>%
  st_crs() -> current_crs

map[["municipios"]] %>%
  # filter(mpio_cdpmp == "88001") -> map_sanandres # Original
  filter(mpio_cdpmp == "88001") %>%
  mutate(
    geometry =
      ((geometry - c(-81.73562, 12.59481))*10 + c(-79.01018, 12.45944)) %>%
      st_set_crs(current_crs)
  ) -> map_sanandres # New
# Move to
#   xmin = 79.01018
#   ymax = 12.45944
# From
#   xmin = -81.73562
#   ymax = 12.59481


map[["municipios"]] %>%
  # filter(mpio_cdpmp == "88564") -> map_providencia # Original
  filter(mpio_cdpmp == "88564") %>%
  mutate(
    geometry =
      ((geometry - c(-81.39557, 13.32034))*10 + c(-78.52459, 11.31599)) %>%
      st_set_crs(current_crs)
  ) -> map_providencia # New
# Move to
#   xmin = -78.52459
#   ymin = 11.31599
# From
#   xmin = -81.39557
#   ymin = 13.32034


# Generate traditional maps.  ---------------------------------------------

bind_rows(map_sanandres, map_providencia) -> map_inset

map[["municipios"]] %>%
  # filter(!(mpio_cdpmp %in% c("88001", "88564"))) -> map_tmp
  filter(!(mpio_cdpmp %in% c("88001", "88564"))) %>%
  bind_rows(map_inset) -> map[["municipios_trad"]]

map_inset[["geometry"]] %>%
  st_combine() -> geometry_inset

map[["departamentos"]] %>%
  filter(dpto_ccdgo == 88) %>%
  st_set_geometry(geometry_inset) -> map_inset

map[["departamentos"]] %>%
  filter(!(dpto_ccdgo == 88)) %>%
  bind_rows(map_inset) -> map[["departamentos_trad"]]


# Guardar -----------------------------------------------------------------

for (level in names(map)){
  path <- c(binoutput = "data/")
  path <- sapply(path, paste0, level)
  save(list = level, file = paste0(path["binoutput"], ".rda"),
       compress = "xz", envir = as.environment(map))

}
