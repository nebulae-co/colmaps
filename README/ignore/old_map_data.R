## Map data

map_levels <- c(municipios = "mpio", departamentos = "depto",
                localidades = "localidades")

for (level in names(map_levels)){

  path <- paste0("data-raw/old-shapefiles/", level)

  if (!dir.exists(path)){
    url  <- paste0("http://sites.google.com/site/seriescol/shapes/",
                   map_levels[level], ".zip")
    tmp <- tempfile(fileext = ".zip")
    method <- if(capabilities("libcurl")) "libcurl" else "auto"
    download.file(url, tmp, method, quiet = TRUE)
    unzip(tmp, exdir = path)
    unlink(tmp)
  }

  # Rename files from *.ext to level.ext
  if (level != map_levels[level]){
    files <- dir(path)
    new_files <- paste0(path, "/", gsub(".+\\.", paste0(level, "."), files))
    files <- paste0(path, "/", files)

    file.rename(files, new_files)
  }
}
