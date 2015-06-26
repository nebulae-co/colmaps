## Map data

## Alternative data at: http://sites.google.com/site/seriescol/shapes

geoserver <- paste0("http://geoportal.dane.gov.co:8084/geoserver/divipola/ows?",
                    "service=WFS&version=1.0.0&request=GetFeature&typeName=",
                    "divipola%3A")

format <- "&outputformat=SHAPE-ZIP"

map_levels <- c(municipios = "DIVIPOLA_MUNICIPIOS",
                departamentos = "DIVIPOLA_DEPARTAMENTOS")

for (level in names(map_levels)){

  path <- paste0("data-raw/shapefiles/", level)

  if (!dir.exists(path)){
    url  <- paste0(geoserver, map_levels[level], format)
    tmp <- tempfile(fileext = ".zip")
    method <- if(capabilities("libcurl")) "libcurl" else "auto"
    download.file(url, tmp, method, quiet = TRUE)
    unzip(tmp, exdir = path)
    unlink(tmp)
  }

  # Rename files from *.ext to level.ext

  files <- dir(path)
  new_files <- paste0(path, "/", gsub(".+\\.", paste0(level, "."), files))
  files <- paste0(path, "/", files)
  file.rename(files, new_files)
}
