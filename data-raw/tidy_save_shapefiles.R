library("dplyr")
library("rgdal")
library("stringi")
library("rgeos")

map <- list(municipios = NULL, departamentos = NULL)

var_codigo <- c(municipios = "CODIGO_DPT", departamentos = "CODIGO_DEP")

for (level in names(map)){
  path <- list(input     = "data-raw/shapefiles/raw/",
               rawoutput = "data-raw/shapefiles/",
               binoutput = "data/")

  path <- sapply(path, paste0, level)

  encoding <- readLines(con = paste0(path["input"], "/", level, ".cst"),
                        warn = FALSE)

  map[[level]] <- readOGR(dsn = path["input"], layer = level, verbose = FALSE,
                          stringsAsFactors = FALSE, encoding = encoding)

  map[[level]] <- map[[level]] %>%
                  gSimplify(tol = .0001, topologyPreserve = TRUE) %>%
                  SpatialPolygonsDataFrame(data = map[[level]]@data,
                                           match.ID = FALSE)

  # Set polygons ids
  for (i in seq_len(nrow(map[[level]]))){
    current_id <- slot(slot(map[[level]], "polygons")[[i]], "ID")
    id_dane <- slot(map[[level]], "data")[current_id, var_codigo[level]]
    slot(slot(map[[level]], "polygons")[[i]], "ID") <- id_dane
  }

  # Check:
  identical(sapply(slot(map[[level]], "polygons"), slot, "ID"),
            slot(map[[level]], "data")[[var_codigo[level]]])

  # Format data
  dots <- list(id = var_codigo[[level]],
               id_depto = ~ CODIGO_DEP,
               municipio = ~ stri_trans_totitle(enc2utf8(NOMBRE_MUN)),
               depto = ~ stri_trans_totitle(enc2utf8(NOMBRE_DEP)))

  if (level == "departamentos") dots <- dots[-c(2, 3)]

  slot(map[[level]], "data") <- slot(map[[level]], "data") %>%
    transmute_(.dots = dots)

  if(dir.exists(path["rawoutput"])){
    file.remove(dir(path["rawoutput"], full.names = TRUE))
  } else {
    dir.create(path["rawoutput"])
  }

  writeOGR(obj = map[[level]], dsn = path["rawoutput"], layer = level,
           driver = "ESRI Shapefile", layer_options = 'ENCODING="ISO-8859-1"')

  save(list = level, file = paste0(path["binoutput"], ".rda"),
       compress = "xz", envir = as.environment(map))
}
