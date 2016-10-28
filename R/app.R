if(!require(tidyverse)) install.packages("tidyverse")
if(!require(leaflet)) install.packages("leaflet")

library(tidyverse)
library(leaflet)
library(shiny)

listings <- read_csv("../data/listings.csv")

server <- function(input, output) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = listings)
  })
}
  
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      leafletOutput("map")
    )
  )
)
 
shinyApp(server = server, ui = ui) 

