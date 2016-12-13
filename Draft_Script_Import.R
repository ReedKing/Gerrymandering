## Packages ----
library(ggplot2)
library(dplyr)
library(tidyr)
library(broom)
library(magrittr)
library(rgdal)
library(redist)
library(rgeos)
library(maptools)

## Import Data ----

tract <- readOGR(dsn = ".", layer = "cb_2015_37_tract_500k")
tract@data$GEOID <- as.character(tract@data$GEOID)
tract_tidy <- tidy(tract, region = "GEOID")
tract_tidy$Id <- tract_tidy$id
tract_tidy$id <- NULL

NCData <- read.csv("ACS_15_5YR_S0601.csv", stringsAsFactors = FALSE)
colnames(NCData) <- as.character(unlist(NCData[1,]))
NCData <- NCData[-1,]
NCData$Id <- NCData$Id2
NCData$Id2 <- NULL

## GGPlot2 Map ----

maptract <- fortify(tract_tidy, region = "GEOID")
maptract <- left_join(maptract, NCData, by = c("Id"))

maptract <- maptract[grep("Alamance | Alexander | Alleghany | Anson | Ashe | Avery | Beaufort | Bertie | Blanden | Brunswick | Buncombe | Burke | Cabarrus | Caldwell | Camden
                         | Carteret | Caswell | Catawba | Chatham | Cherokee | Chowan | Clay | Cleveland | Columbus | Craven | Cumberland | Currituck | Dare | Davidson 
                         | Davie | Duplin | Durham | Edgecombe | Forsyth | Franklin | Gaston | Gates | Graham | Granville | Greene | Guilford | Halifax | Harnett | Haywood 
                         | Henderson | Hertford | Hoke | Hyde | Iredell | Jackson | Johnston | Jones | Lee | Lenoir | Linconl | McDowell | Macon | Madison | Martin | Mecklenburg
                         | Mithcell | Montgomery | Moore | Nash | New Hanover | Northampton | Onslow | Orange | Pamlico | Pasquotank | Pender | Perquimans | Person | Pitt | Polk
                         | Randolph | Richmond | Robeson | Rockingham | Rowan | Rutherford | Sampson | Scotland | Stanly | Stokes | Surry | Swain | Transylvania | Tyrrell | Union
                         | Vance | Wake | Warren | Washington | Watauga | Wayne | Wilkes | Wilson | Yadkin | Yancey", maptract$Geography),]

ggplot() + 
  geom_polygon(data = maptract, aes(x = long, y = lat, group = group), color = "grey50")
  

  