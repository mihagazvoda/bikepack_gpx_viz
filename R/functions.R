get_gpx_df <- function(path) {
  plotKML::readGPX(path)$tracks[[1]][[1]] %>% 
    tibble::tibble() %>% 
    select(-extensions) %>%
    mutate(
      id = path,
      ele = as.numeric(ele),
      time = lubridate::as_datetime(time)
    ) %>% 
    dplyr::mutate(
      dist_to_prev = c(0, sp::spDists(x = as.matrix(.[, c("lon", "lat")]), longlat = TRUE, segments = TRUE))
    )
}