library(shiny)

library(leaflet) # fior base map functions
library(maps) # for mapping state shape files
library(dplyr)

rsconnect::setAccountInfo(name='0makvj-andrew-purgiel',
                          token='9FAA56758E89706F2709D8102830B9A6',
                          secret='AieaxdKqMh6ROuXjuRlzHm7iHjTTBn5u9RnZZS01')



# build example song data matched with state ------
row1 <- list('maine',
             'https://musicalmunchies.com/home/playlists-by-location/'
                          )


row2 <- list('michigan', 
             'https://musicalmunchies.com/michigan/'
             )


row3 <- list('colorado',
            'https://musicalmunchies.com/colorado/'
             )

row4 <- list('alabama',
             'https://musicalmunchies.com/home/playlists-by-location/#al'
)

song_data <- data.frame(region = character(),    # Create empty data frame
                        link = character())

song_data[1,] <- row1
song_data[2,] <- row2
song_data[3,] <- row3
song_data[4,] <- row4

# ----




# make matched df of state and abbreviation ----
states <- bind_cols(region = state.name, abb = state.abb) %>%
  mutate(region = tolower(region), abb = tolower(abb))
# ----




# define shapefile of states containing state names ---------
mapStates = map("state", fill = TRUE, plot = FALSE)

# some states in the dataset have several regions (identified after a colon)
# remove these special region names and just make them a duplicate of the state name
mapStates[['names']] <- mapStates[['names']] %>%
  lapply(function(x) sub(':.*', '', x)) %>%
  unlist()

# add an empty element to mapStates list
mapStates[['link']]<- rep(NA, length(mapStates[['names']]))


# fill in element with songs matched to the state from which they're from
for (  i in 1:nrow(song_data)  ){

  mapStates[['link']][which(mapStates[['names']] == song_data[["region"]][i])] <- song_data[["link"]][i]
 
}

# -----



# create interactive map -----


  map_data <- mapStates
  


# map states with popups that include song data
song_map <- 
  leaflet(data = map_data) %>%
  addTiles() %>% # add basemap
  addPolygons(
    fillColor = topo.colors(10, alpha = NULL), # add colored state polygons
    stroke = F,
    # add the name of the state in a popup (name in mapState data)
    # may need to use htmltools::htmlEscape()
    # use htmlEscapse to avoid issues with text that could be interpreted
    # as HTML text
    popup = ~paste0(
      'State: ', stringr::str_to_title(names), '<br>',# State Name, uppercased
      '<a href = ', link, '> Playlist </a>'
      
      )
    
  )


# ----




# make user interface ----

ui <- fluidPage(

  # App title
  # titlePanel("Stately Songs"),
    
    
    # Main panel for displaying outputs
    mainPanel(
      
      #allow link to open outside of iframe
      tags$head(tags$base(target="_top")),
      
      # Hide errors
      tags$style(type = "text/css",
                 ".shiny-output-error { visibility: hidden; }",
                 ".shiny-output-error:before { visibility: hidden; }"),
      
      # Output: interactive world map
      leafletOutput("map_output")
      
    )
     
)

# -----



# make server ------
server <- function(input, output) {

# Create the interactive world map 
output$map_output <- renderLeaflet({
  print(  song_map)
  
})


}

# ------



# run UI and server ----

shinyApp(ui = ui, server = server)
