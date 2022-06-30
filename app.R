library(shiny)

library(leaflet) # fior base map functions
library(maps) # for mapping state shape files
library(dplyr)

rsconnect::setAccountInfo(name='0makvj-andrew-purgiel',
                          token='9FAA56758E89706F2709D8102830B9A6',
                          secret='AieaxdKqMh6ROuXjuRlzHm7iHjTTBn5u9RnZZS01')



# build example song data matched with state ------
row1 <- list('maine',
             
             'https://musicalmunchies.com/happy-songs-maine/',
             
             'https://www.google.com/search?q=maine+cry&rlz=1C1VDKB_enUS988US988&sxsrf=ALiCzsaU9lm6hy1uKgI0_CAuHHajUh8sBA%3A1653882961667&ei=UUCUYs-aKIa90PEP0ryo2Ao&ved=0ahUKEwiPh7iTqob4AhWGHjQIHVIeCqsQ4dUDCA4&uact=5&oq=maine+cry&gs_lcp=Cgdnd3Mtd2l6EAMyBQgAEIAEMggIABCABBDJAzIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyCwguEIAEEMcBEK8BMgUIABCGAzIFCAAQhgM6BwgAEEcQsAM6BwguELEDEEM6CAgAELEDEJECOgUIABCRAjoFCAAQkgM6CAguEIAEELEDOgsILhDHARCvARCRAjoLCAAQsQMQgwEQkQI6FgguEIAEEIcCELEDEIMBEMcBEK8BEBRKBAhBGABKBAhGGABQyAVY3Qhg0QxoAnABeACAAXGIAcICkgEDMC4zmAEAoAEByAEEwAEB&sclient=gws-wiz'
             )


row2 <- list('new hampshire',
             
             'https://www.google.com/search?q=new+hampshire+happy&rlz=1C1VDKB_enUS988US988&sxsrf=ALiCzsZ6laoC35zNCNJtMQHxYOeRhXioZA%3A1653883067144&ei=u0CUYrSwCJ6Q0PEPsqyF4Ac&ved=0ahUKEwj0-d3Fqob4AhUeCDQIHTJWAXwQ4dUDCA4&uact=5&oq=new+hampshire+happy&gs_lcp=Cgdnd3Mtd2l6EAMyBQgAEIAEMgYIABAeEBYyCAgAEB4QDxAWMgYIABAeEBYyCAgAEB4QDxAWMgYIABAeEBYyBQgAEIYDMgUIABCGAzIFCAAQhgM6BwgAEEcQsAM6BQgAEJECOgsILhDHARDRAxCRAjoICAAQgAQQyQM6CwguEIAEEMcBEK8BOgUILhCABDoICAAQHhAWEApKBAhBGABKBAhGGABQ6AJY5AdgwgtoAnABeACAAYwBiAHQA5IBAzQuMZgBAKABAcgBCMABAQ&sclient=gws-wiz',
             
             'https://www.google.com/search?q=new+hampshire+cry&rlz=1C1VDKB_enUS988US988&sxsrf=ALiCzsbvLlG_ccmdbdDfEcz4vOyqfI0FzA%3A1653882998394&ei=dkCUYtvYF5-s0PEPupyF0As&ved=0ahUKEwjb6_mkqob4AhUfFjQIHTpOAboQ4dUDCA4&uact=5&oq=new+hampshire+cry&gs_lcp=Cgdnd3Mtd2l6EAMyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDILCC4QgAQQxwEQrwEyBQgAEIAEOggIABCABBCwAzoHCAAQHhCwAzoJCAAQHhCwAxAFOgYIABAeEAc6CAgAEIAEELEDOggIABAeEAgQBzoKCAAQHhAPEAcQCjoKCC4QsQMQgwEQDToECAAQDToHCC4QsQMQDToKCAAQsQMQgwEQDToKCC4QxwEQrwEQDToGCAAQHhANSgQIQRgBSgQIRhgAUMkDWNMVYNQbaAJwAHgAgAFmiAHfCJIBBDExLjKYAQCgAQHIAQrAAQE&sclient=gws-wiz'
             )


row3 <- list('colorado',
             
             'https://www.google.com/search?q=colorado+happy&rlz=1C1VDKB_enUS988US988&sxsrf=ALiCzsaIUJIpJMwiuvqy-vEdESopDltt-w%3A1653883108979&ei=5ECUYvCvO5yw0PEPuLyigAw&ved=0ahUKEwjwsdfZqob4AhUcGDQIHTieCMAQ4dUDCA4&uact=5&oq=colorado+happy&gs_lcp=Cgdnd3Mtd2l6EAMyBggAEB4QBzIGCAAQHhAHMgYIABAeEAcyBggAEB4QBzIGCAAQHhAHMgUIABCABDIGCAAQHhAHMgYIABAeEAcyBggAEB4QBzIFCAAQgAQ6CAguEIAEENQCOgQIABANSgQIQRgASgQIRhgAUABYkwhgtgxoAHABeACAAbYBiAG_BpIBAzYuMpgBAKABAcABAQ&sclient=gws-wiz',
             
             'https://www.google.com/search?q=colorado+cry&rlz=1C1VDKB_enUS988US988&sxsrf=ALiCzsY6NL3iIyEq4Xbh-9kSfKLpyvz_qw%3A1653883145549&ei=CUGUYquEIaT59APYnIXgDA&ved=0ahUKEwjrrI_rqob4AhWkPH0KHVhOAcwQ4dUDCA4&uact=5&oq=colorado+cry&gs_lcp=Cgdnd3Mtd2l6EAMyCwguEIAEEMcBEK8BMgUIABCABDIFCAAQgAQyBQgAEIAEMggIABCABBDJAzIFCAAQgAQyBQgAEIAEMgsILhCABBDHARCvATILCC4QgAQQxwEQrwEyBQgAEIAEOgcIABBHELADOggILhCABBCxAzoFCC4QgAQ6CAgAEIAEELEDOg4ILhCABBDHARCvARDUAjoLCC4QgAQQsQMQgwE6CggAEIAEEIcCEBQ6CwgAEIAEELEDEIMBSgQIQRgASgQIRhgAUPkCWMYGYMcJaAJwAXgAgAF1iAHBApIBAzEuMpgBAKABAcgBCMABAQ&sclient=gws-wiz'
             )


song_data <- data.frame(region = character(),    # Create empty data frame
                        happy_link = character(),
                        cry_link = character())
song_data[1,] <- row1
song_data[2,] <- row2
song_data[3,] <- row3
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
mapStates[['happy_link']]<- rep(NA, length(mapStates[['names']]))

mapStates[['cry_link']]<- rep(NA, length(mapStates[['names']]))


# fill in element with songs matched to the state from which they're from
for (  i in 1:nrow(song_data)  ){

  mapStates[['happy_link']][which(mapStates[['names']] == song_data[["region"]][i])] <- song_data[["happy_link"]][i]
 
  mapStates[['cry_link']][which(mapStates[['names']] == song_data[["region"]][i])] <- song_data[["cry_link"]][i]
  
}

# -----



# mapping function -----



# define function
state.map <- function(
  song_type # happy, cry, nost, or fave
  )   {
  map_data <- mapStates
  
# only display results for song type chosen by user
if( song_type == 'happy') {
          map_data[['link']] <-  map_data[['happy_link']] 
} else if(song_type == 'cry') {
  map_data[['link']] <-  map_data[['cry_link']] 
  
}
#remove list element to avoid coding mistakes
map_data[["happy_link"]] <- NULL
map_data[["cry_link"]] <- NULL


# map states with popups that include song data
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
}

# ----




# make user interface ----

ui <- fluidPage(

  # App title
  # titlePanel("Stately Songs"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    
    # Sidebar panel for inputs 
    sidebarPanel(
      
      # First input: Type of data
      selectInput(inputId = "song_type",
                  label = "Choose the type of song you want to see:",
                  choices = list("Puts You in a Good Mood" = "happy", "Likely to Make You Cry" = "cry")
      )
      
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      
      # Hide errors
      tags$style(type = "text/css",
                 ".shiny-output-error { visibility: hidden; }",
                 ".shiny-output-error:before { visibility: hidden; }"),
      
      # Output: interactive world map
      leafletOutput("map_output")
      
    )
  )
     
)

# -----



# make server ------
server <- function(input, output) {

# Create the interactive world map 
output$map_output <- renderLeaflet({
  print(  state.map(input$song_type))
  
})


}

# ------



# run UI and server ----

shinyApp(ui = ui, server = server)
