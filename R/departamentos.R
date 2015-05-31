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
