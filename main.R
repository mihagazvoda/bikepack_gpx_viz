library(ggmap)
library(dplyr)

gpx_file <- plotKML::readGPX("activities/Bled_Predel_Bovec.gpx")

df <- tibble::tibble(gpx_file$tracks[[1]][[1]])

df %>%
  select(-extensions) %>% 
  mutate(
    ele = as.numeric(ele),
    time = lubridate::as_datetime(time)
    ) %>% View()

ggplot(df, aes(lon, lat)) + 
  coord_quickmap() + 
  geom_point()

western_slovenia <- get_googlemap(center = c(mean(df$lon), mean(df$lat)), language = "en-EN")

western_slovenia %>% 
  ggmap() + 
  geom_point(data = df, aes(lon, lat), size = 0.1) + 
  theme_void() 
