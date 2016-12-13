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
tract <- tidy(tract, region = "GEOID")


NCData <- read.csv("ACS_15_5YR_S0601.csv", stringsAsFactors = FALSE)
colnames(NCData) <- as.character(unlist(NCData[1,]))
NCData <- NCData[-1,]
NCData$Id <- NCData$Id2
NCData$Id2 <- NULL

Main_Data <- fortify(tract, region = "GEOID")
Main_Data$Id <- Main_Data$id
Main_Data$id <- NULL
Main_Data <- left_join(Main_Data, NCData, by = c("Id"))

Main_Data[,9:432] <- lapply(Main_Data[,9:432], function(x){
  as.numeric(levels(x))[x]
  })

## Map to Test ----


ggplot() + 
  geom_polygon(data = Main_Data, aes(x = long, y = lat, group = group), color = "grey50")
  

  