#' Colombian department boundaries.
#'
#' A dataset containing the polygons that define boundaries of the 33 colombian
#' departments, including its capital, Bogotá.
#'
#' @format A \code{\linkS4class{SpatialPolygonsDataFrame}}. The data slot is a
#' data frame with:
#' \describe{
#'   \item{id}{official department id as defined by the National Department of
#'   Statistics (DANE), character}
#'   \item{depto}{the department name}
#'}
#'
#' @source \url{http://geoportal.dane.gov.co:8084/Divipola}
#'
#' @seealso \code{\link{municipios}} for data at the municipality level.
#'
"departamentos"

# So that check finds municipios in map_municipios
globalVariables("municipios")

#' Colombian department map.
#'
#'A function to create the map of a departament with it's municipalities. Each
#'departament is conformed by a set of municipalities.
#'
#' @param deptos a name (char) of the departament which will be created.
#'
#' @return a map, a \code{\link{fortify}}able object sucha as a
#' \code{\linkS4class{SpatialPolygonsDataFrame}} resulting in a
#' data.frame with columns \code{x} or \code{long}, \code{y} or \code{lat} and
#' \code{region} or \code{id}.
#'
#' @export
#'
#' @examples
#'
#' Antioquia <- map_departamentos("Antioquia")
#' colmap(Antioquia) # Generating the color map
#'
map_departamentos <- function(deptos){
  if(any(!deptos %in% unique(municipios@data$depto)))
    stop(deptos, " no esta en la lista de los departamentos.")

  municipios[municipios@data$depto %in% deptos, ]
}
