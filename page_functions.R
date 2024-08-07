# Thanks to Cait Harrigan: https://github.com/teaswamp-creations/bee-book/blob/master/page_functions.R

library(plotly)
suppressPackageStartupMessages(library(tidyverse))


# make species map
gbif <- read_delim("../../files/0037810-231120084113126.csv", delim='\t') %>%
  mutate(date = ymd(date(eventDate)), Year = year(date),
         Month = lubridate::month(date, label=T),
         lat=decimalLatitude, lon=decimalLongitude) %>%
  drop_na(date, lat, lon, genus, occurrenceID) %>%
  separate_wider_delim(species, ' ', names=c('Genus', 'Species'), too_many = 'merge') %>%
  mutate(Species=ifelse(Species=='nr', NA, Species))


make_species_map <- function(species){
  if (!(species %in% gbif$Species)){
    return("no GBIF data to display")
  }
  
  gbif %>% 
    filter(Species == species) %>%
    plot_ly() %>%
    add_trace(
      lat = ~lat, lon =~lon,
      mode = 'markers', type = 'scattermapbox',
      color = ~Year,
      text = ~paste(
        basisOfRecord,
        '\nSpecies:', Genus, Species, 
        '\nObserved:', stamp("March 1, 1999")(date)
        ),
      size=10,
      name= ~Year,
      marker= list(opacity=0.6),
      showlegend=F
    ) %>%
    colorbar(tick0=0,
             dtick=max(3, ceiling(length(unique((filter(gbif, Species %in% species)$Year)))/3))) %>%
    layout(mapbox = list(
      style = 'carto-positron', show_legend = T,
      #zoom=7, center = list(lon = -123, lat = 49)),
      zoom=3.8, center = list(lon = -127, lat = 50)),
      title = 'GBIF observations in the Pacific Maritime region') %>%
    return()
}

