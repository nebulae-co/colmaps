library("grid")
library("ggplot2")
library("colmaps")
library("maps")
library("dplyr")

# Some map data with a random value
# map <- ggplot2::map_data(map = "worldHires") %>%
#   mutate(name_len = sample(nrow(.)))

map <- ggplot2::map_data(map = "worldHires")

# Just the data of interest
data <- map %>% count(region) %>% as.data.frame()

proj <- list(list("aitoff"),
             list(projection = "albers", 0, 0),
             list(projection = "azequalarea"),
             list(projection = "azequidist"),
             list(projection = "bicentric", 0),
             list(projection = "bonne", 0),
             list(projection = "conic", 0),
             list(projection = "cylequalarea", 0),
             list(projection = "cylindrical"),
             # list(projection = "eisenlohr"),
             list(projection = "elliptic", 0),
             list(projection = "fisheye", 0),
             list(projection = "gall", 0),
             list(projection = "gilbert"),
             list(projection = "guyou"),
             list(projection = "harrison", 0, 0),
             list(projection = "hex"),
             list(projection = "homing", 0),
             list(projection = "lagrange"),
             list(projection = "lambert", 0, 0),
             list(projection = "laue"),
             # list(projection = "lune", 0, 0),
             list(projection = "mercator"),
             list(projection = "mollweide"),
             # list(projection = "newyorker", 0),
             list(projection = "orthographic"),
             list(projection = "perspective", 0),
             list(projection = "polyconic"),
             list(projection = "rectangular", 0),
             list(projection = "simpleconic", 0, 0),
             list(projection = "sinusoidal"),
             list(projection = "tetra"),
             list(projection = "trapezoidal", 0, 0)
)

gg <- colmap(map, data, "n", "region", legend = FALSE)

# gg <- colmap()

dev.off()

png(filename = "coord_hi_res_projections.png", width = 49*1.5, height = 1.5*25,
    units = "cm", res = 72*2)

grid.newpage()

pushViewport(viewport(layout = grid.layout(5, 7)))

for (i in seq_along(proj)){
  print(proj[[i]][[1]])

  pushViewport(viewport(layout.pos.col = ((i - 1) %% 7) + 1,
                        layout.pos.row = ((i - 1) %/% 7) + 1))


  coords <- do.call(coord_map, proj[[i]])
  print(gg + coords + ggtitle(proj[[i]][[1]]), newpage = FALSE)
  gg + coord_equal()
  popViewport()
}

popViewport()
dev.off()
