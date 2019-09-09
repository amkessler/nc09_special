library(sf)

anson <- st_read("geo_data/doc.kml")

plot(anson)
plot(anson[1])
