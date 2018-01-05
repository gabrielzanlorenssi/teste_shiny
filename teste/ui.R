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
      checkboxInput(inputId = "show",
                    label = "Show statistics", 
                    value = T)
    ),
    mainPanel(
       plotOutput("plot"),
       DT::dataTableOutput("output_table")
    )
  )
))
