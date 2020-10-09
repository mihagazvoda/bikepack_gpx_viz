source("R/packages.R")
source("R/functions.R")

df <- list.files(path = "activities", pattern = "*.gpx", full.names = TRUE) %>%
  purrr::map_dfr(get_gpx_df) %>% 
  arrange(time) %>% 
  mutate(dist_cum = cumsum(dist_to_prev))

# slovenia <- ggmap::get_googlemap(center = c(mean(df$lon), mean(df$lat)), style = ggmapstyles::map_style(ID = "84"), zoom = 9)

p_map <- slovenia %>%
  ggmap() +
  geom_point(data = df, aes(lon, lat), size = 0.1) +
  theme_void()

p_ele <- ggplot(df) +
  geom_line(aes(x = dist_cum, y = ele)) + 
  theme_void()

cowplot::plot_grid(p_map, p_ele, ncol = 1)

# -----
leaflet() %>% 
  # Jawk.Terrain
  addProviderTiles(providers$Stamen.Terrain) %>% 
  leaflet::addPolylines(lng = df$lon, lat = df$lat, color = "black", opacity = 0.8)

