## Packages ----
library(tidyr)
library(dplyr)
library(magrittr)
library(rgdal)
library(redist)
library(rgeos)
library(maptools)
library(htmlwidgets)
library(acs)
library(tigris)
library(stringr)
library(dplyr)
library(leaflet)

## Import ----

# set key, grab tract spatial and geotag data
api.key.install(key = "1a66d0d3b2a73f7877417f78b20796654ee0e6ff")
<<<<<<< HEAD
tigcounties <- counties(state = "NC", cb = TRUE)
NCgeo <- geo.make(state = "NC", county = "*")
=======
tigtracts <- tracts(state = "NC", cb = TRUE)
NCgeo <- geo.make(state = c("NC", county = "*", tract = "*"))
>>>>>>> 6abbddfe7cd8c1e5c4c5bcb5c4e9fe49ec884369

# Querying for income

incometablenums <- acs.lookup(keyword = "median income", endyear = 2015, case.sensitive = FALSE)
medianincome <- acs.fetch(endyear = 2015, span = 1, geography = NCgeo,
                       table.number = "B06011", col.names = "pretty")
attr(medianincome, "acs.colnames")

<<<<<<< HEAD
# Now we know what the column is called, so make a df

medianincome_df <- data.frame(paste0(str_pad(medianincome@geography$state, 2, "left", pad = "0"),
                                     str_pad(medianincome@geography$county, 3, "left", pad = "0")),
                              medianincome@estimate[,c("B06011. Median Income in the Past 12 Months (in 2015 Inflation-Adjusted Dollars) by Place of Birth in the United States: Median income in the past 12 months -- Total:")], 
                              stringsAsFactors = FALSE)
# Clean

rownames(medianincome_df) <- 1:nrow(medianincome_df)
names(medianincome_df) <- c("GEOID", "medianincome")

# Merge

medianincome_merged <- geo_join(tigcounties, medianincome_df, "GEOID", "GEOID")
medianincome_merged <- medianincome_merged[medianincome_merged$ALAND > 0,]

## Map ----
=======
medianincome_df <- data.frame(paste0(str_pad(medianincome@geography$state, 2, "left", pad="0"), 
                              str_pad(medianincome@geography$county, 3, "left", pad="0"), 
                              str_pad(medianincome@geography$tract, 6, "left", pad="0")), 
                       medianincome@estimate[,c("B06011. Median Income in the Past 12 Months (in 2015 Inflation-Adjusted Dollars) by Place of Birth in the United States: Median income in the past 12 months -- Total:")], 
                       stringsAsFactors = FALSE)

medianincome_df <- select(medianincome_df, 1:2)
rownames(medianincome_df) <- 1:nrow(medianincome_df)
names(medianincome_df) <- c("GEOID", "medianincome")

medianincome_merged <- geo_join(tigtracts, medianincome_df, "GEOID", "GEOID")
medianincome_merged <- medianincome_merged[medianincome_merged$ALAND > 0,]


>>>>>>> 6abbddfe7cd8c1e5c4c5bcb5c4e9fe49ec884369
mappop <- paste0("GEOID: ", medianincome_merged$GEOID, "<br>", "Median Income: ", medianincome_merged$medianincome, "$")
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = medianincome_df$medianincome
)

<<<<<<< HEAD

medianincomecountiesmap <- leaflet() %>%
=======
medianincomemap <- leaflet() %>%
>>>>>>> 6abbddfe7cd8c1e5c4c5bcb5c4e9fe49ec884369
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = medianincome_merged,
              fillColor = ~pal(medianincome),
              color = "#b2aeae",
              fillOpacity = .7,
              weight = 1,
              smoothFactor = .2,
              popup = mappop) %>%
  addLegend(pal = pal,
            values = medianincome_merged$medianincome,
            position = "bottomright",
            title = "Median Income",
            labFormat = labelFormat(suffix = "$"))
<<<<<<< HEAD
medianincomecountiesmap
=======
medianincomemap
>>>>>>> 6abbddfe7cd8c1e5c4c5bcb5c4e9fe49ec884369
