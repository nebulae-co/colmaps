library("dplyr")
library("rgdal")

# help("tolower")
capwords <- function(s, strict = TRUE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
                           {s <- substring(s, 2); if(strict) tolower(s) else s},
                           sep = "", collapse = " " )
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

map <- list(municipios = NULL, departamentos = NULL)

var_codigo <- c(municipios = "CODIGO_DPT", departamentos = "CODIGO_DEP")

for (level in names(map)){
  path <- list(input     = "inst/extdata/",
               rawoutput = "inst/extdata/",
               binoutput = "data/")

  path <- sapply(path, paste0, level)

  encoding <- readLines(con = paste0(path["input"], "/", level, ".cpg"),
                        warn = FALSE)

  map[[level]] <- readOGR(dsn = path["input"], layer = level, verbose = FALSE,
                          stringsAsFactors = FALSE, encoding = encoding)

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
               municipio = ~ capwords(NOMBRE_MUN),
               depto = ~ capwords(NOMBRE_DEP))

  if (level == "departamentos") dots <- dots[-c(2, 3)]

  slot(map[[level]], "data") <- slot(map[[level]], "data") %>%
    transmute_(.dots = dots)

  if(dir.exists(path["rawoutput"]))
    file.remove(dir(path["rawoutput"], full.names = TRUE))

  writeOGR(obj = map[[level]], dsn = path["rawoutput"], layer = level,
           driver = "ESRI Shapefile", layer_options = 'ENCODING="ISO-8859-1"')

  save(list = level, file = paste0(path["binoutput"], ".rda"),
       compress = "bzip2", envir = as.environment(map))
}
