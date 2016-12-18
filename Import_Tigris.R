## Packages ----
library(acs)
library(tigris)
library(stringr)
library(leaflet)

## Import ----

# set key, grab tract spatial and geotag data
api.key.install(key = "1a66d0d3b2a73f7877417f78b20796654ee0e6ff")
tigtracts <- tracts(state = "NC", cb = TRUE)
NCgeo <- geo.make(state = c("NC", tract = "*"))

# Querying for income

incometablenums <- acs.lookup(keyword = "median income", endyear = 2015, case.sensitive = FALSE)
medianincome <- acs.fetch(endyear = 2015, span = 1, geography = NCgeo,
                       table.number = "B06011", col.names = "auto")
attr(medianincome, "acs.colnames")

medianincome_df <- data.frame(paste0(str_pad(medianincome@geography$state, 2, "left", pad="0"), 
                              str_pad(medianincome@geography$county, 3, "left", pad="0"), 
                              str_pad(medianincome@geography$tract, 6, "left", pad="0")), 
                       medianincome@estimate[,c("B06011_001")], 
                       stringsAsFactors = FALSE)
medianincome_df
