# install.packages("shiny")
# install.packages("shinydashboard")
#install.packages("shinyWidgets")
#install.packages("shinythemes")
#install.packages("shinycssloaders")
#install.packages("markdown")

library(shiny)
library(shinyWidgets)
library(shinythemes)
library(shinycssloaders)
library(markdown)
source("global.R")

shinyUI(fluidPage(
  # line below to fix bug in ggiraph when deploying app
  tags$head( tags$style(type = "text/css", "text {font-family: sans-serif}")),
  theme = shinytheme("yeti"),
  titlePanel("Indice de Desarrollo Humano (IDH)"),
  
  sidebarLayout(
    sidebarPanel(
      pickerInput(
        inputId = "regions", 
        label = "Seleccionar departamentos para plotear", 
        choices = levels(proj_sf$DEPARTAMEN), 
        selected = levels(proj_sf$DEPARTAMEN),
        options = list(`actions-box` = TRUE),
        multiple = TRUE
        ),
      br(),
      pickerInput(
        inputId = "variable",
        label = "Elegir un indicador a plotear", 
        choices = c("Poblacion", 
                    "Indice de Desarrollo Humano",
                    "Esperanza de vida al nacer",
                    "Anos de educacion",
                    "Poblacion con secundaria completa",
                    "Ingreso familiar percapita"),
        selected = "Poblacion",
        width = '210px',
        ),
      pickerInput(
        inputId = "representation",
        label = "Elegir una representacion visual", 
        choices = c("Geografico", "Cartograma de puntos"),
        selected = "Geografico",
        multiple = FALSE,
        width = '210px'
      ),
      br(),
      h6(em("N.B.: Por favor, pedimos paciencia mientras carga el cartograma."))
      ),
    
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Choropleth", 
          withSpinner(ggiraphOutput("mymap", height = "600px")),
          h5("Mouse over map for hover and zoom effects.")
        ),
        tabPanel(
          "Dotplot", 
          ggiraphOutput("dotplot", height = "650px")
        ),
        tabPanel(
          "Table", 
          DT::dataTableOutput("table")
        ),
          tabPanel(
          "Documentation", 
          includeMarkdown("about.md"),
          br()
        )
      )
    )
  )
))

