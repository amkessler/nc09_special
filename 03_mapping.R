# https://r-spatial.github.io/sf/articles/sf1.html

library(sf)

anson <- st_read("geo_data/anson.kml")

plot(anson[1])

anson


union <- st_read("geo_data/union.kml")

plot(union[1])




merged <- st_read("geo_data/mergedKML_NC09precincts.kml")

plot(merged)
plot(merged[3])


