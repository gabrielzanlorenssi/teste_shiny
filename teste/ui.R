library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Distribuição do PIB dos municípios - 2015"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "x",
                  label = "Setor",
                  choices = c("Administração Pública" = "s_adm",
                              "Serviços" = "s_servicos",
                              "Indústria" = "s_industria",
                              "Agropecuária" = "s_agropecuaria"),
                  selected = "Agropecuária"),
      selectInput(inputId = "filter",
                  label = "Selecionar UFs",
                  choices = tabela2$uf,
                  selected = "SP",
                  multiple = T),
      sliderInput(inputId = "alpha",
                   label = "Transparência",
                   min = 0, max = 1,
                   value = 0.7, step = 0.1),
      checkboxInput(inputId = "show_stats",
                    label = "Mostrar estatísticas", 
                    value = T),
      checkboxInput(inputId = "show_values",
                    label = "Mostrar municípios", 
                    value = T)
    ),
    mainPanel(
       plotOutput("plot"),
       plotOutput("plot2"),
       DT::dataTableOutput("output_table1"),
       DT::dataTableOutput("output_table2")
    )
  )
))
