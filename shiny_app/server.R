library(shiny)
library(DT)
source("global.R")

shinyServer(function(input, output) {
        
        # make dataset a reactive object
        dataInput <- reactive(proj_sf)
        
        # make new_sf a reactive object
        second_sf <- reactive({
                adjust_geometry(dataInput(), input$representation, input$variable)
        })
        
        # make args reactive
        args <- reactive({
                get_args(second_sf(), input$variable)
        })
        
        # make a choropleth
        output$mymap <- renderggiraph({
                make_choropleth(second_sf(), args(), input$color_scheme,
                                input$graticules, input$representation, input$abbs)
        })
        
        # make a dotplot
        output$dotplot <- renderggiraph({
                make_dotplot(second_sf(), args())
        })
        
        # make a table
        output$table <- DT::renderDataTable({
                DT::datatable(
                        second_sf() %>% 
                                st_set_geometry(NULL) %>% 
                                select(-c(1,3,5,6,7,8,9)),
                        caption = 'La data se obtuve la pagina del IPE. Ver Documentacion para obtener informacion adicional',
                        options = list(lengthMenu = c(10, 20, 36), pageLength = 10) 
                ) %>% 
                        formatRound(c('esperanza', 'secundaria', 'years_educ', 'idh'), digits = 1) %>%
                        formatCurrency('ingreso', 0) 
        })
        
})
