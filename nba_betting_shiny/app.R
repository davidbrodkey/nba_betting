library(shiny)
library(readr)
library(ggplot2)
library(shinyWidgets)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("NBA Betting / Probability"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        pickerInput(inputId="selected_season"
                    ,label="Season Filter"
                    ,choices=2009:2020
                    ,multiple=TRUE
                    ,selected=2009:2020)
        
      ),

      mainPanel(
         plotOutput("scatter_plot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  raw_df<-data.frame(read_csv("~/Desktop/nba_betting/nba_betting_shiny/preped_nba_betting_odds.csv"))
  
  
  filt_df<-reactive({
    df<-raw_df
    
    df<-df[df$season %in% input$selected_season,]
    
    df
  })
  
   output$scatter_plot <- renderPlot({
     ggplot(data=filt_df(),aes(x=self_elo_prob,y=bet_decimal))+
       geom_point()
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

