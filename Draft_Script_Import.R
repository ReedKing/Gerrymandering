## Packages ----
library(ggplot2)
library(ggthemes)
library(leaflet)
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
tract_spatial <- tract
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
Main_Data <- data.frame(Main_Data)


## Maps to Test ----


NCMap <- ggplot() +
  geom_polygon(data = Main_Data, aes(x = long, y = lat, group = group), color = "grey50") +
  labs(title = "Hey Look It's North Carolina", x = "Longitude", y = "Latitude") +
  theme_bw()
  
  
OldPeople <- data.frame(Id = Main_Data$Id,
                        Geography = Main_Data$Geography,
                        long = Main_Data$long,
                        lat = Main_Data$lat,
                        group = Main_Data$group,
                        Old = as.numeric(Main_Data$Total..Estimate..AGE...75.years.and.over)
                        )

OldPeopleMap <-ggplot(data = OldPeople, aes(x = long, y = lat)) +
  geom_polygon(aes(group = group, fill = Old), col = NA, lwd = 0) +
  scale_fill_gradient(low = "white", high = "grey10") +
  labs(title = "WHERE DEM OLD FOLKS AT", x = "Longitude", y = "Latitude") +
  theme_bw()

NCPolygons <- tract_spatial
NCPolygons@data$rec <- 1:nrow(NCPolygons@data)
tempdata <- left_join(NCPolygons@data, Main_Data, by = c("GEOID"="Id")) %>%
  arrange(rec)
NCPolygons@data <- tempdata
NCPolygons$Old <- as.numeric(NCPolygons$Total..Estimate..AGE...75.years.and.over)

Bubble <- paste0("GEOID: ", OldPeople$Id, "<br>", "Percent of Population over 75 Years Old:", NCPolygons$Old)
pallet <- colorNumeric(
  palette = "YlGnBu",
  domain = NCPolygons$Old
)

LeafletMap <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = NCPolygons,
              color = "#b2aeae",
              fillColor = ~pallet(Old),
              fillOpacity = .7,
              weight = 1,
              smoothFactor = .2,
              popup = Bubble)
LeafletMap
