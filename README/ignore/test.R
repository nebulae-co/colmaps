library("colmaps")
library("ggplot2")
library("dplyr")

# dane <- function(x){if (nchar(x) != 5) paste0(0, x) else as.character(x)}
# Saber11 <- Saber11 %>%
#   mutate(id_dane = sapply(id_dane, dane), id_depto = substr(id_dane, 1, 2))
#
# saveRDS(Saber11, "data-raw/Saber11.rds")

Saber11 <- readRDS("data-raw/Saber11.rds")

deciles <- quantile(Saber11$total, probs = seq(0, 1, 0.1))

promedio <- Saber11 %>% group_by(id_depto) %>%
  summarise(promedio        = mean(total, na.rm = TRUE)) %>%
     mutate(promedio_int    = as.integer(promedio),
            promedio_factor = cut(promedio, breaks = deciles,
                                  labels = names(deciles)[-1],
                                  include.lowest = TRUE),
            promedio_ord    = ordered(promedio_factor))

colmap()
# colmap(map = fortify(departamentos))
colmap(map = municipios)

p_numeric <- colmap(map = departamentos, data = promedio, data_id = "id_depto")
print(p_numeric)

p_int <- colmap(departamentos, promedio, "promedio_int", data_id = "id_depto")
print(p_int)

p_factor <- colmap(departamentos, promedio, "promedio_factor", data_id = "id_depto")
print(p_factor)

p_ord <- colmap(departamentos, promedio, "promedio_ord", "id_depto")
print(p_ord)

p + scale_fill_brewer()
# p + scale_fill_distiller(type = "div")
p + scale_fill_gradient(name = "Promedio", low = "red", high = "green",
                        space = "Lab", guide = "colourbar")
