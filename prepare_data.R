#https://shiny.atlan.com/indiastates/
#https://github.com/seanangio/viz_india

#Loading libraries
library(tidyverse)
library(tmap)
library(sf)

#Set working directory
setwd("F:/RESEARCH/OPPORTUNITIES/RA for Econ Phds/Indicadores-de-desarrollo-regional-provincial-y-distrital")

###########################################
##################  MAPS  ##################
###########################################


#Load in data of distrito shapefiles
distritos_1 <- sf::st_read(dsn="./shapefiles/DISTRITOS.shp", quiet=TRUE)
str(distritos_1)
names(distritos_1)[5] <- "ubigeo" 

depart_1 <- sf::st_read(dsn="./shapefiles/DEPARTAMENTOS.shp", quiet=TRUE)
depart_1$ABREV <- abbreviate(depart_1$DEPARTAMEN, 4)
table(depart_1$ABREV)
str(depart_1)

###########################################
##################  IDH  ##################
###########################################

#Load in data of IDH 2003
idh03 <- readxl::read_xlsx("./IDH-y-Componentes-2003-2019.xlsx", sheet="Variables del IDH 2003-2017", col_names = FALSE, skip=10) 
idh03 <- idh03[1:2292, c(1,2,3,6,14, 22, 30, 38, 46)]
names(idh03) <- c("ubigeo", "departamento", "distrito", "poblacion","idh", "esperanza", "secundaria", "years_educ", "ingreso")
idh03 <- idh03[complete.cases(idh03$departamento, idh03$distrito), -2]
#idh0319 [,c(3:9)] = sapply(idh0319[,3:9], function(x) round(as.numeric(as.character(x)),0))
idh03$year <- "2003"
str(idh03)

#Load in data of IDH 2007
idh07 <- readxl::read_xlsx("./IDH-y-Componentes-2003-2019.xlsx", sheet="Variables del IDH 2003-2017", col_names = FALSE, skip=10) 
idh07 <- idh07[1:2292, c(1,2,3,7, 15, 23, 31, 39, 47)]
names(idh07) <- c("ubigeo", "departamento", "distrito", "poblacion", "idh", "esperanza", "secundaria", "years_educ", "ingreso")
idh07 <- idh07[complete.cases(idh07$departamento, idh07$distrito), -2]
#idh0319 [,c(3:9)] = sapply(idh0319[,3:9], function(x) round(as.numeric(as.character(x)),0))
idh07$year <- "2007"
str(idh07)

#Load in data of IDH 2010
idh10 <- readxl::read_xlsx("./IDH-y-Componentes-2003-2019.xlsx", sheet="Variables del IDH 2003-2017", col_names = FALSE, skip=10) 
idh10 <- idh10[1:2292, c(1,2,3,8, 16, 24, 32, 40, 48)]
names(idh10) <- c("ubigeo", "departamento", "distrito", "poblacion", "idh", "esperanza", "secundaria", "years_educ", "ingreso")
idh10 <- idh10[complete.cases(idh10$departamento, idh10$distrito), -2]
#idh0319 [,c(3:9)] = sapply(idh0319[,3:9], function(x) round(as.numeric(as.character(x)),0))
idh10$year <- "2010"
str(idh10)

#Load in data of IDH 2011
idh11 <- readxl::read_xlsx("./IDH-y-Componentes-2003-2019.xlsx", sheet="Variables del IDH 2003-2017", col_names = FALSE, skip=10) 
idh11 <- idh11[1:2292, c(1,2,3,9, 17, 25, 33, 41, 49)]
names(idh11) <- c("ubigeo", "departamento", "distrito", "poblacion", "idh", "esperanza", "secundaria", "years_educ", "ingreso")
idh11 <- idh11[complete.cases(idh11$departamento, idh11$distrito), -2]
#idh0319 [,c(3:9)] = sapply(idh0319[,3:9], function(x) round(as.numeric(as.character(x)),0))
idh11$year <- "2011"
str(idh11)

#Load in data of IDH 2012
idh12 <- readxl::read_xlsx("./IDH-y-Componentes-2003-2019.xlsx", sheet="Variables del IDH 2003-2017", col_names = FALSE, skip=10) 
idh12 <- idh12[1:2292, c(1,2,3,10, 18, 26, 34, 42, 50)]
names(idh12) <- c("ubigeo", "departamento", "distrito", "poblacion", "idh", "esperanza", "secundaria", "years_educ", "ingreso")
idh12 <- idh12[complete.cases(idh12$departamento, idh12$distrito), -2]
#idh0319 [,c(3:9)] = sapply(idh0319[,3:9], function(x) round(as.numeric(as.character(x)),0))
idh12$year <- "2012"
str(idh12)

#Load in data of IDH 2015
idh15 <- readxl::read_xlsx("./IDH-y-Componentes-2003-2019.xlsx", sheet="Variables del IDH 2003-2017", col_names = FALSE, skip=10) 
idh15 <- idh15[1:2292, c(1,2,3,11, 19, 27, 35, 43, 51)]
names(idh15) <- c("ubigeo", "departamento", "distrito", "poblacion", "idh", "esperanza", "secundaria", "years_educ", "ingreso")
idh15 <- idh15[complete.cases(idh15$departamento, idh15$distrito), -2]
#idh0319 [,c(3:9)] = sapply(idh0319[,3:9], function(x) round(as.numeric(as.character(x)),0))
idh15$year <- "2015"
str(idh15)

#Load in data of IDH 2017
idh17 <- readxl::read_xlsx("./IDH-y-Componentes-2003-2019.xlsx", sheet="Variables del IDH 2003-2017", col_names = FALSE, skip=10) 
idh17 <- idh17[1:2292, c(1,2,3,12, 20, 28, 36, 44, 52)]
names(idh17) <- c("ubigeo", "departamento", "distrito", "poblacion", "idh", "esperanza", "secundaria", "years_educ", "ingreso")
idh17 <- idh17[complete.cases(idh17$departamento, idh17$distrito), -2]
#idh0319 [,c(3:9)] = sapply(idh0319[,3:9], function(x) round(as.numeric(as.character(x)),0))
idh17$year <- "2017"
str(idh17)

#Load in data of IDH 2018
idh18 <- readxl::read_xlsx("./IDH-y-Componentes-2003-2019.xlsx", sheet="IDH 2018", col_names = FALSE, skip=9) 
idh18 <- idh18[1:2292, c(1,2,3,6, 7, 8, 9, 10, 11)]
names(idh18) <- c("ubigeo", "departamento", "distrito", "poblacion", "idh", "esperanza", "secundaria", "years_educ", "ingreso")
idh18 <- idh18[complete.cases(idh18$departamento, idh18$distrito), -2]
#idh0319 [,c(3:9)] = sapply(idh0319[,3:9], function(x) round(as.numeric(as.character(x)),0))
idhyear <- "2018"
str(idh18)

#Load in data of IDH 2019
idh19 <- readxl::read_xlsx("./IDH-y-Componentes-2003-2019.xlsx", sheet="IDH 2019", col_names = FALSE, skip=10) 
idh19 <- idh19[1:2292, c(1,2,3,6, 7, 8, 9, 10, 17)]
names(idh19) <- c("ubigeo", "departamento", "distrito", "poblacion", "esperanza", "secundaria", "years_educ", "ingreso", "idh")
idh19 <- idh19[complete.cases(idh19$departamento, idh19$distrito), -2]
#idh0319 [,c(3:9)] = sapply(idh0319[,3:9], function(x) round(as.numeric(as.character(x)),0))
idh19$year <- "2019"
str(idh19)

#Binding datasets
bd <- rbind(idh03,idh07)
bd <- rbind(bd,idh10)
bd <- rbind(bd,idh11)
bd <- rbind(bd,idh12)
bd <- rbind(bd,idh15)
bd <- rbind(bd,idh17)
#bd <- rbind(bd,idh18)
#bd <- rbind(bd,idh19)
str(bd)
View(bd)

##################################
######### JOINING DATA ###########
##################################

distritos_idh <- distritos_1 %>%
        left_join(bd, by="ubigeo")
str(distritos_idh)
View(distritos_idh)

distritos_idh <- distritos_idh %>%
        filter(year=="2011")

saveRDS(distritos_idh, "distritos_idh.rds")













































































































































































































































