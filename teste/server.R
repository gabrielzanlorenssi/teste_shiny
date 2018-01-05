library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$plot <- renderPlot({

  ggplot(data = tabela2, aes_string(x=input$x)) + 
      geom_density() +
      scale_x_continuous(lim=c(0,1)) +
      scale_y_continuous(lim=c(0,12))
    
  })
  
  output$output_table <- DT::renderDataTable({
    if(input$show) {
      DT::datatable(tabela3, rownames =  F)
    }
  })
  
})