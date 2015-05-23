#' Colombian municipality boundaries.
#'
#' A dataset containing the polygons that define boundaries of the 1122
#' colombian municipalities (cities, towns and smaller populated administrative
#' areas).
#'
#' @format A \code{"\linkS4class{SpatialPolygonsDataFrame}"}. The data slot is a
#' data frame with:
#' \describe{
#'   \item{id}{oficial municipality id as defined by the
#'      \href{http://dane.gov.co}{National Department of Statistics (DANE)},
#'      character}
#'   \item{id_depto}{oficial department id to which the municipality is
#'      circumbscribed, character}
#'   \item{municipio}{name of the municipality}
#'      \item{depto}{department name}
#' }
#'
#' @source \url{http://geoportal.dane.gov.co:8084/Divipola}
#'
#' @seealso \code{\link{departamentos}} for department level data.
"municipios"
