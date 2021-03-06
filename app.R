# Beginning of app
# Install and load required packagess
library(tidyverse)
library(leaflet)
library(shiny)

# Read in data, clean price field
# listings <- read_csv("./data/listings.csv")
listings <- read_csv("./data/listings.csv")
listings$price <- as.numeric(gsub("[$,]", "", listings$price))

pal <- colorFactor(topo.colors(3), listings$room_type, n = 3)

# Server
server <- function(input, output) {
  
  # Create reactive data frame from listings that match filter criteria
  df <- reactive({
    df <- listings %>%
      filter((price >= input$minPrice & price <= input$maxPrice) &
               (review_scores_rating >= input$ratingFilter[1] & review_scores_rating <= input$ratingFilter[2]) &
               (room_type %in% input$typeFilter)
             )
  })
  
  # Create Map output using same parameters from other Leaflet file, but with reactive data
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df(),
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
      addLegend("bottomleft", pal = pal, values = df()$room_type, opacity = 1)
  })
  
  # Create data table
  output$table <- renderDataTable({df()})
  
}

#========================================================

# UI
ui <- fluidPage(
  title = "Airbnb Boston",
  titlePanel("Airbnb Boston"),
  tabsetPanel(
    tabPanel("Map", leafletOutput("map")),
    tabPanel("Data", dataTableOutput("table"))
    ),
  hr(),
  fluidRow(
    # Price Filter
    column(4,
           h3("Filter by Price"),
           column(6,
                  numericInput("minPrice", "Minimum Price:", value = 1)
                  ),
           column(6,
                  numericInput("maxPrice", "Maximum Price:", value = 4000)
                  )
           ),
    # Rating Filter
    column(4,
           h3("Filter by Rating"),
           sliderInput('ratingFilter', "Rating:",
                       min = 1, max = 100, value = c(1, 100)
                       )
           ),
    # Listing Type Filter filter, leave out NA
    column(4,
           h3("Filter by Listing Type"),
           checkboxGroupInput('typeFilter', "Type:",
                              choices = c(unique(listings$room_type)),
                              selected = c(unique(listings$room_type))
                              )
           )
  ),
  hr(),
  fluidRow(p("Data from ", a("Inside Airbnb", href = "http://www.insideairbnb.com", target = "_blank")))
  
  
)

# Run app
shinyApp(server = server, ui = ui) 

