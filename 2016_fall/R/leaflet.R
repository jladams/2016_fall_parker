# Load in libraries
library(tidyverse)
library(leaflet)
library(shiny)

# Take a look at Leaflet
leaflet()

# Boring without tiles, so let's add a base layer
leaflet() %>%
  addTiles()

# We could try provider tiles, using list from: http://leaflet-extras.github.io/leaflet-providers/preview/index.html
leaflet() %>%
  addProviderTiles(providers$Stamen.Toner)

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron)

# Try stacking them up:
leaflet() %>%
  addProviderTiles(providers$Esri.WorldShadedRelief) %>%
  addProviderTiles(providers$Stamen.TonerLabels)

# Let's try adding markers
# Get data from Airbnb
listings <- read_csv("./data/listings.csv")

# Get rid of commas and dollar signs, make price numeric
listings$price <- as.numeric(gsub("[$,]", "", listings$price))


# Add markers to map as regular markers (this is a nightmare)
leaflet() %>%
  addTiles() %>%
  addMarkers(data = listings)

# Let's try using circle markers instead
leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = listings)

# Better, but we can customize those markers to do all kinds of stuff!
leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = listings,
                   stroke = FALSE
                   )

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = listings,
                   weight = 1,
                   color = "black",
                   fillColor = "steelblue"
  )

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = listings,
                   weight = 1,
                   color = "black",
                   fillColor = "steelblue",
                   fillOpacity = 1,
                   radius = 5
  )

# Now that we've customized markers a little, let's try adding a popup!
leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = listings,
                   weight = 1,
                   color = "black",
                   fillColor = "steelblue",
                   fillOpacity = 1,
                   radius = 5,
                   popup = "Hello!"
  )

# Better to use actual data for popup content
leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = listings,
                   weight = 1,
                   color = "black",
                   fillColor = "steelblue",
                   fillOpacity = 1,
                   radius = 5,
                   popup = ~host_name
  )

# We can use data to color the dots, as well - first things first, let's get a color palette
pal <- colorFactor(topo.colors(3), listings$room_type)

# We'll use data to color the dots and populate the popup (using html), and we'll also add a legend
leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = listings,
                   weight = 1,
                   color = "black",
                   fillColor = ~pal(room_type),
                   fillOpacity = 1,
                   radius = 5,
                   popup = ~paste0("<img src='",thumbnail_url,"'</img></br>",
                                   "<b><a href='",listing_url,"' target='_blank'>",name,"</a></b></br>",
                                   "Host: ",host_name,"</br>",
                                   "Bedrooms: ", bedrooms,"</br>",
                                   "Beds: ", beds,"</br>",
                                   "Bathrooms: ",bathrooms,"</br>",
                                   "Price: ",price, "</br>",
                                   "Rating: ", review_scores_rating
                                   )
                   ) %>%
  addLegend("bottomleft", pal = pal, values = listings$room_type, opacity = 1)




