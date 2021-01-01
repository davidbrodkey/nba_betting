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
                    ,selected=2009:2020
                    ,pickerOptions(actionsBox=TRUE))
        ,
        helpText("Carm.Elo only available 2016-2019 \n Raptor only available 2019-2020")
        ,
        pickerInput(inputId="x_axis"
                    ,label="X Axis Variable"
                    ,choices=c("self_elo_prob","self_carm.elo_prob","self_raptor_prob","bet_decimal","winnings","random")
                    ,selected="self_elo_prob")
        ,
        pickerInput(inputId="y_axis"
                    ,label="Y Axis Variable"
                    ,choices=c("self_elo_prob","self_carm.elo_prob","self_raptor_prob","bet_decimal","winnings","random")
                    ,selected="bet_decimal")
        ,
        hr()
        ,
        h3("Method Tester")
        
        
      ),

      mainPanel(
         plotOutput("scatter_plot")
      )
   )
)

server <- function(input, output) {
   
  raw_df<-data.frame(read_csv("~/Desktop/nba_betting/nba_betting_shiny/preped_nba_betting_odds.csv",
                              col_types=cols(self_carm.elo_prob="n"
                                             ,self_raptor_prob="n")))
  
  
  filt_df<-reactive({
    df<-raw_df
    df<-df[df$season %in% input$selected_season,]
    
    df$bet_result<-ifelse(df$winnings>0,"Good Bet","Bad Bet")
    df$random<-runif(nrow(df))
    #browser()
    df
  })
  
   output$scatter_plot <- renderPlot({
     df<-filt_df()
     
     
     ggplot(data=df,aes_string(x=input$x_axis,y=input$y_axis,col="bet_result"))+
       geom_point()
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

