leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = listings,
                   weight = 1,
                   color = "black",
                   fillColor = "blue",
                   popup = ~paste0("<img src='",thumbnail_url,"'</img></br>",
                                   "<b><a href='",listing_url,"' target='_blank'>",name,"</a></b></br>",
                                   "Host: ",host_name,"</br>",
                                   "Bedrooms: ", bedrooms,"</br>",
                                   "Beds: ", beds,"</br>",
                                   "Bathrooms: ",bathrooms,"</br>",
                                   "Price: ",price, "</br>",
                                   "Rating: ", review_scores_rating
                                   )
                   )