library(sf)
library(dplyr)
library(ggplot2)
library(ggiraph)
library(geogrid)
library(cartogram)

#Set working directory
setwd("F:/RESEARCH/OPPORTUNITIES/RA for Econ Phds/Indicadores-de-desarrollo-regional-provincial-y-distrital/shiny_app")

# define css for tooltips
tooltip_css <- "background-color:gray;color:white;padding:5px;border-radius:5px;font-family:sans-serif;font-size:12px;"

proj_sf <- readRDS("distritos_idh.rds") 

str(proj_sf)

# function that receives an sf object and returns a modified sf object
# according to user selections of region and uts
choose_area <- function(regions) {
        
        data <- proj_sf %>% 
                filter(DEPARTAMEN %in% regions)
        
        data
}

# function that receives a (possibly filtered) sf object and
# outputs the same sf object with geometry modified depending on 
# user-selected representation and variable

adjust_geometry <- function(data, representation, variable) {
        
        var <- switch(variable,
                      "Poblacion" = "poblacion",
                      "Indice de Desarrollo Humano" = "idh", 
                      "Esperanza de vida al nacer" = "esperanza", 
                      "Poblacion con secundaria completa" = "secundaria",
                      "Anos de educacion" = "years_educ",
                      "Ingreso familiar percapita" = "ingreso"
        )

        if (representation == "Geografico") {
                new_sf <- data
        } else if (representation == "Cartograma de puntos") {
                new_sf <- cartogram_dorling(data, var)
        } else {
                print("Representacion no encontrada")
        }
         
        
        
        # calculate x, y coordinates for geom_text labels
        if (representation == "Geografico") {
                new_sf <- new_sf %>% 
                        mutate(
                                CENTROID = purrr::map(geometry, st_centroid),
                                COORDS = purrr::map(CENTROID, st_coordinates),
                                COORDS_X = purrr::map_dbl(COORDS, 1),
                                COORDS_Y = purrr::map_dbl(COORDS, 2)
                        )
                
        } else {
                new_sf <- new_sf %>% 
                        mutate(
                                CENTROID = purrr::map(geometry, st_centroid),
                                COORDS = purrr::map(CENTROID, st_coordinates),
                                COORDS_X = purrr::map_dbl(COORDS, 1),
                                COORDS_Y = purrr::map_dbl(COORDS, 2)
                        )
        }
        
        new_sf
        
}

# function that receives the existing sf object and user-selected variable
# and outputs a list of matching arguments to be used in plots

        get_args <- function(new_sf, variable) {
        
        args <- switch(variable, 
                       "Poblacion" = list(
                               plot_var = new_sf$poblacion, 
                               legend_title = "Cantidad de habitantes",
                               legend_labels = scales::comma
                       ),
                       "Indice de Desarrollo Humano" = list(
                               plot_var = new_sf$idh, 
                               legend_title = "Indice de Desarrollo Humano (IDH)",
                               legend_labels = scales::comma
                       ),
                       "Esperanza de vida al nacer" = list(
                               plot_var = new_sf$esperanza, 
                               legend_title = "Esperanza de vida al nacer",
                               legend_labels = scales::comma
                       ),
                       
                       "Poblacion con secundaria completa" = list(
                               plot_var = new_sf$secundaria,
                               legend_title = "Poblacion con secundaria completa",
                               legend_labels = scales::comma
                       ),
                       "Anos de educacion" = list(
                               plot_var = new_sf$years_educ, 
                               legend_title = "Anos de educacion de la poblacion",
                               legend_labels = scales::comma
                       ),
                       "Ingreso familiar percapita" = list(
                               plot_var = new_sf$ingreso, 
                               legend_title = "Ingreso familiar percapita",
                               legend_labels = scales::comma
                       )
        )
       args 
}

# function that receives previous sf object, list of args, and
# user-defined plot settings and returns the appropriate choropleth
make_choropleth <- function(new_sf, args, color_scheme, 
                            graticules, representation, abbs) {
                
                new_sf <- new_sf %>% 
                        mutate(
                                tip = paste0(
                                        "<b>", DISTRITO, " : ", args$plot_var, "</b>",
                                        "</span></div>")
                        )        
        p <- ggplot(
                data = new_sf
        ) +
                geom_sf_interactive(
                        aes(fill = args$plot_var,
                            tooltip = tip,
                            data_id = DISTRITO), 
                        lwd = 0
                ) +
                geom_sf(
                        fill = NA, color = "lightgrey", lwd = 0.5
                ) +    
                scale_fill_viridis_c(
                        args$legend_title, 
                        option = color_scheme,
                        labels = args$legend_labels
                )
        
        if (!graticules) {
                p <- p +
                        coord_sf(datum = NA) +
                        theme_void()
        }
        
        if (abbs) {
                p <- p +
                        geom_text(
                                mapping = aes(x = COORDS_X, y = COORDS_Y, label = distrito),
                                color = "white", size = 2
                        ) +
                        scale_y_continuous(NULL) +
                        scale_x_continuous(NULL)
        }
        
        p <- ggiraph(
                ggobj = p, 
                hover_css = "cursor:pointer;stroke-width:5px;fill-opacity:0.8;",
                tooltip_extra_css = tooltip_css, tooltip_opacity = 0.75,
                zoom_max = 5
        )    
        
        p
        
}

# function that receives sf object and list of args for plotting
# returns appropriate dotplot
make_dotplot <- function(new_sf, args) {
        
        p <- ggplot(
                data = new_sf,
                mapping = aes(
                        x = reorder(DISTRITO, args$plot_var), 
                        y = args$plot_var,
                        color = DEPARTAMEN)
        ) +
                geom_point_interactive(
                        aes(tooltip = paste0(DISTRITO, ": ", args$plot_var), 
                            data_id = DISTRITO)
                ) +
                coord_flip() +
                scale_y_continuous(
                        args$legend_title, 
                ) +
                scale_x_discrete("") +
                scale_color_discrete("DEPARTAMEN") +
                theme(legend.position = "bottom")
        
        ggiraph(
                code = print(p), 
                hover_css = "cursor:pointer;stroke-width:5px;fill-opacity:0.8;"
        )
        
}
