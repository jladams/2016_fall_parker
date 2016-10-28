if(!require(tidyverse)) install.packages("tidyverse")
if(!require(leaflet)) install.packages("leaflet")

library(tidyverse)
library(leaflet)
library(shiny)

listings <- read_csv("../data/listings.csv")
listings$price <- as.numeric(gsub("[$,]", "", listings$price))
# listings$weekly_price <- as.numeric(gsub("[$,]", "", listings$weekly_price))


server <- function(input, output) {
  
  df <- reactive({
    df <- listings %>%
      filter((price >= input$minPrice & price <= input$maxPrice) & 
               (review_scores_rating >= input$ratingFilter[1] & review_scores_rating <= input$ratingFilter[2]) &
               (bedrooms %in% input$bedroomFilter)
             )
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df(),
                       weight = 1,
                       color = "black",
                       fillColor = "blue",
                       popup = ~paste0("<img src=\"",thumbnail_url,"\"</img></br>",
                                       "<b><a href=\"",listing_url,"\" target=\"_blank\">",name,"</a></b></br>",
                                       "Host: ",host_name,"</br>",
                                       "Bedrooms: ", bedrooms,"</br>",
                                       "Beds: ", beds,"</br>",
                                       "Bathrooms: ",bathrooms,"</br>",
                                       "Price: ",price, "</br>",
                                       "Rating: ", review_scores_rating
                                       )
                       )
  })
  
  output$table <- renderDataTable({df()})
  
}
  
ui <- fluidPage(
  title = "Airbnb Boston",
  titlePanel("Airbnb Boston"),
  tabsetPanel(
    tabPanel("Map", leafletOutput("map")),
    tabPanel("Data", dataTableOutput("table"))
    ),
  hr(),
  fluidRow(
    column(4,
           h3("Filter by Price"),
           column(6,
                  numericInput("minPrice", "Minimum Price:", value = 1)
                  ),
           column(6,
                  numericInput("maxPrice", "Maximum Price:", value = 4000)
                  )
           ),
    column(4,
           h3("Filter by Rating"),
           sliderInput('ratingFilter', "Rating:",
                       min = 1, max = 100, value = c(1, 100)
                       )
           ),
    column(4,
           h3("Filter by Bedrooms"),
           checkboxGroupInput('bedroomFilter', "Bedrooms:",
                              choices = c("5" = 5, "4" = 4, "3" = 3, "2" = 2, "1" = 1, "0" = 0, "NA" = NA),
                              selected = c("5" = 5, "4" = 4, "3" = 3, "2" = 2, "1" = 1, "0" = 0, "NA" = NA)
                              )
           )
  )
  
  
)

 
shinyApp(server = server, ui = ui) 

