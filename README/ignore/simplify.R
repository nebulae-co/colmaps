library("magrittr")
library("colmaps")
library("sp")
library("rgeos")

getPolygonPoints <- function(Polygons){
  sum(
    sapply(slot(Polygons, "Polygons"),
           function(Polygon) nrow(slot(Polygon, "coords"))
    )
  )
}

sum(sapply(departamentos@polygons, getPolygonPoints))
sum(sapply(hist_us_states@polygons, getPolygonPoints))

sum(sapply(municipios@polygons, getPolygonPoints))
sum(sapply(hist_us_counties@polygons, getPolygonPoints))


test <- departamentos %>%
  gSimplify(tol = .0001, topologyPreserve = TRUE) %>%
  SpatialPolygonsDataFrame(data = departamentos@data, match.ID = "id")

all(gIsValid(test, TRUE)) & gIsValid(test)
format(object.size(test), units = "Mb")
format(object.size(departamentos), units = "Mb")
1 - as.numeric(object.size(test)/object.size(departamentos))
sum(sapply(test@polygons, getPolygonPoints))
sum(sapply(departamentos@polygons, getPolygonPoints))
1 - sum(sapply(test@polygons, getPolygonPoints)) /
  sum(sapply(departamentos@polygons, getPolygonPoints))

colmap(map = test)
save(test, file = "data/test.rda", compress = "xz")

test <- municipios %>%
  gSimplify(tol = .0001, topologyPreserve = TRUE) %>%
  SpatialPolygonsDataFrame(data = municipios@data, match.ID = "id")

all(gIsValid(test, TRUE)) & gIsValid(test) &
  length(test@polygons) == length(municipios@polygons)

format(object.size(test), units = "Mb")
format(object.size(municipios), units = "Mb")
1 - as.numeric(object.size(test)/object.size(municipios))
sum(sapply(test@polygons, getPolygonPoints))
sum(sapply(municipios@polygons, getPolygonPoints))
1 - sum(sapply(test@polygons, getPolygonPoints)) /
  sum(sapply(municipios@polygons, getPolygonPoints))

colmap(map = test)
save(test, file = "data/test2.rda", compress = "xz")

