library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)
library(RColorBrewer)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$plot <- renderPlot({
  req(input$filter)
  tabela2a <- filter(tabela2, uf %in% input$filter)
  ggplot(data = tabela2a, aes_string(x=input$x, fill="uf")) + 
      geom_density(alpha=input$alpha) +
      scale_x_continuous(lim=c(0,1)) +
      scale_y_continuous(lim=c(0,20)) +
    scale_fill_manual(values = alpha(brewer.pal(n=length(input$x), name="Dark2"),
                                      alpha=input$alpha)) 
  })
  
  output$plot2 <- renderPlot({
    req(input$filter)
    tabela2b <- tabela2 %>%
      filter(uf %in% input$filter) %>% 
      select(mun, uf, s_agropecuaria,
             s_adm, s_servicos, s_industria) %>%
      gather(var, val, s_agropecuaria:s_industria) %>% 
      mutate(val = abs(val),
             y = case_when(var == "s_agropecuaria" ~ 0,
                           var == "s_adm" ~ val,
                           var == "s_industria" ~ 0,
                           var == "s_servicos" ~ - val),
             x = case_when(var == "s_agropecuaria" ~ val,
                           var == "s_adm" ~ 0,
                           var == "s_industria" ~ -val,
                           var == "s_servicos" ~ 0),
             group = case_when(var == "s_agropecuaria" ~ 1,
                               var == "s_adm" ~ 4,
                               var == "s_industria" ~ 3,
                               var == "s_servicos" ~ 2)) %>% 
      arrange(mun, group)
    
    ggplot(data = tabela2b, aes(x, y, group=mun, col=uf)) + 
      geom_polygon(fill=NA) +
      scale_color_manual(values = alpha(brewer.pal(n=length(input$x), name="Dark2"),
                                        alpha=input$alpha)) +
      facet_wrap(~uf)
  
    })
  
  output$output_table1 <- DT::renderDataTable({
    if(input$show_stats) {
      tabela3  <- tabela2 %>%
        filter(uf %in% input$filter) %>% 
        select(s_adm, s_agropecuaria, s_servicos, s_industria) %>% 
        summarise_all(funs(min = min, 
                           q25 = quantile(., 0.25), 
                           median = median, 
                           q75 = quantile(., 0.75), 
                           max = max,
                           mean = mean, 
                           sd = sd)) %>% 
        gather(stat, val) %>%
        separate(stat, into = c("s", "var", "stat"), sep = "_") %>%
        spread(stat, val) %>%
        select(var, min, q25, median, q75, max, mean, sd) %>% 
        mutate(mean = round(mean, digits= 2), sd = round(sd, digits=2))
      DT::datatable(tabela3, rownames =  F)
    }
  })
  
  
  output$output_table2 <- DT::renderDataTable({
    if(input$show_values) {
      tabela2b <- filter(tabela2, uf %in% input$filter) 
      DT::datatable(tabela2b, rownames =  F)
    }
  })
  
})