library(shiny)
library(readr)
library(ggplot2)
library(shinyWidgets)

ui <- fluidPage(
   
   # Application title
   titlePanel("NBA Betting / Probability"),
   
   sidebarLayout(
      sidebarPanel(
        pickerInput(inputId="selected_season"
                    ,label="Season Filter"
                    ,choices=2009:2020
                    ,multiple=TRUE
                    ,selected=2009:2020)
        ,
        pickerInput(inputId="x_axis"
                    ,label="X Axis Variable"
                    ,choices=c("self_elo_prob","self_carm.elo_prob","self_raptor_prob","bet_decimal","winnings")
                    ,selected="self_elo_prob")
        ,
        pickerInput(inputId="y_axis"
                    ,label="Y Axis Variable"
                    ,choices=c("self_elo_prob","self_carm.elo_prob","self_raptor_prob","bet_decimal","winnings")
                    ,selected="bet_decimal")
        
        
      ),

      mainPanel(
         plotOutput("scatter_plot")
      )
   )
)

server <- function(input, output) {
   
  raw_df<-data.frame(read_csv("~/Desktop/nba_betting/nba_betting_shiny/preped_nba_betting_odds.csv"))
  
  
  filt_df<-reactive({
    df<-raw_df
    
    df<-df[df$season %in% input$selected_season,]
    
    df
  })
  
   output$scatter_plot <- renderPlot({
     
     ggplot(data=filt_df(),aes_string(x=input$x_axis,y=input$y_axis))+
       geom_point()
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

