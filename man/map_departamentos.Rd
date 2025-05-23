% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/departamentos.R
\name{map_departamentos}
\alias{map_departamentos}
\title{Colombian department map.}
\usage{
map_departamentos(deptos)
}
\arguments{
\item{deptos}{a name (char) of the departament which will be created.}
}
\value{
a map, a \code{\link{fortify}}able object sucha as a
\code{\linkS4class{SpatialPolygonsDataFrame}} resulting in a
data.frame with columns \code{x} or \code{long}, \code{y} or \code{lat} and
\code{region} or \code{id}.
}
\description{
A function to create the map of a departament with it's municipalities. Each
departament is conformed by a set of municipalities.
}
\examples{

Antioquia <- map_departamentos("Antioquia")
colmap(Antioquia) # Generating the color map

}

