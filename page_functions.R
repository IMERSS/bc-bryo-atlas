# Thanks to Cait Harrigan: https://github.com/teaswamp-creations/bee-book/blob/master/page_functions.R

library(plotly)
suppressPackageStartupMessages(library(tidyverse))

# make species map
rawGbif <- read_delim("tabular_data/GBIF-0002297-240626123714530.csv", delim='\t')
gbif <- rawGbif %>%
  mutate(date = parse_date_time(eventDate, "Ymd HMS", truncated = 3), Year = year(date),
         Month = lubridate::month(date, label=T),
         lat=decimalLatitude, lon=decimalLongitude) %>%
  drop_na(date, lat, lon, genus, occurrenceID)

make_species_map <- function (thisSpecies) {
  if (!(thisSpecies %in% gbif$species)) {
    return("no GBIF data to display")
  }
  thisRecords <- gbif %>% filter(species == thisSpecies)
  
  lat_range <- range(thisRecords$lat)
  lon_range <- range(thisRecords$lon)
  
  # Center of the bounding box
  center <- list(lon = mean(lon_range), lat = mean(lat_range))
  
  # A rough estimate for zoom level based on bounds
  zoom <- min(20, max(1, 8 - log(diff(lat_range) + diff(lon_range)))) - 1
  
  thisRecords %>% plot_ly() %>%
    add_trace(
      lat = ~lat, lon =~lon,
      mode = 'markers', type = 'scattermapbox',
      color = ~Year,
      text = ~paste(
        basisOfRecord,
        '\nSpecies:', species, 
        '\nObserved:', stamp("March 1, 1999", quiet = TRUE)(date)
        ),
      size = 10,
      showlegend = FALSE, # doesn't work
      name = ~Year,
      marker = list(opacity=0.6)
    ) %>% colorbar(tick0=0,
       dtick=max(5, ceiling(length(unique((thisRecords$Year)))/3)),
       thickness=10) %>%
    layout(mapbox = list(
      style = 'carto-positron',
      zoom = zoom, center = center
    ),
    showlegend = FALSE, # These directives don't work, can't suppress legend
    legend = list(x = 0.9, y = 0.9),
    autosize = TRUE,
    margin = list(t = 0, r = 0, b = 0, l = 0)
    )
}

