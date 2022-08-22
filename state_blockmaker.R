library(dplyr)



    
# match embed links of playlists to their state's abbreviation




    # make matched df of state  abbreviation ----
  states <- bind_cols(state = state.name, abb = tolower(state.abb))
  
 
  
  
  

  
  
  state.header <- function(st_abb){
    
    st_name <-   states[['state']][which(states[['abb']] == st_abb)]
    cat( # use cat to avoid r putting in backslashes prior to double quotes
    paste0('<!-- wp:heading {"textAlign":"center","level":4} -->',
    '<h4 class="has-text-align-center" id="',
           st_abb,
           '">',
           st_name,
           '</h4>   <!-- /wp:heading --> ')
    )
  }
  
  state.header('me')

  
  
  
