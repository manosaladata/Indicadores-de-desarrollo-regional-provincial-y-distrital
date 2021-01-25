rm(list=ls())

#Loading spatial libraries
library(maptools)
library(rgdal) # Installing rgdal for reading shapefiles
library(tidyverse)
library(dplyr)

#Set working directory
setwd("F:/RESEARCH/BEST/Project")

#Load in an example data of budget public
initial <- read.csv("./2019/2019.csv", nrows=50000)
str(initial)

#Load in data of budget policy
presupuesto <- data.table::fread("./2019/2019.csv", select=c("TIPO_GOBIERNO", "TIPO_GOBIERNO_NOMBRE", "SECTOR",
                                                             "SECTOR_NOMBRE", "PLIEGO", "PLIEGO_NOMBRE",
                                                             "EJECUTORA", "DEPARTAMENTO_EJECUTORA", "DEPARTAMENTO_EJECUTORA_NOMBRE",
                                                             "PROVINCIA_EJECUTORA", "PROVINCIA_EJECUTORA_NOMBRE", "DISTRITO_EJECUTORA", 
                                                             "DISTRITO_EJECUTORA_NOMBRE", "EJECUTORA_NOMBRE", "FUENTE_FINANC",
                                                             "FUENTE_FINANC_NOMBRE", "CATEG_GASTO", "CATEG_GASTO_NOMBRE", "GENERICA", "GENERICA_NOMBRE",
                                                             "MONTO_PIA", "MONTO_PIM", "MONTO_DEVENGADO"))
str(presupuesto)

#Collapse observations of the data at district level
agregado_2019 <- presupuesto %>% dplyr::group_by  (NIVEL_GOB=`TIPO_GOBIERNO_NOMBRE`, `DEPARTAMENTO_EJECUTORA`, DEPARTAMENTO = `DEPARTAMENTO_EJECUTORA_NOMBRE`, 
                                                   `PROVINCIA_EJECUTORA`, PROVINCIA = `PROVINCIA_EJECUTORA_NOMBRE`, `DISTRITO_EJECUTORA`, DISTRITO=`DISTRITO_EJECUTORA_NOMBRE`) %>% 
        dplyr::summarise (PIA = sum(MONTO_PIA, na.rm = T),
                          PIM = sum(MONTO_PIM, na.rm = T),
                          DEV_ANUAL = sum(MONTO_DEVENGADO, na.rm = T))
View(agregado_2019)
head(agregado_2019)



#Load in data of province shapefiles
getinfo.shape("PROVINCIAS.shp")
provincias <- rgdal::readOGR("./provicia_files", "PROVINCIAS")

#Plotting maps of province shapefiles
plot(provincias, border = 'grey')

