#################################################-
## DATA: POLITICAL
## US & CA POLITICAL BOUNDARY SHAPEFILES
## SOURCE: https://www.census.gov/geo/maps-data/data/tiger-line.html
## Author: C. Nell
#################################################-
library(sp)
library(ggmap)
setwd("/Users/colleennell/Dropbox/rstats/CAT/data/shapefiles")
#################################################-
##Retrieving shapefiles for spatial data
##USA states
#################################################-
download.file("ftp://ftp2.census.gov/geo/tiger/TIGER2016/STATE/tl_2016_us_state.zip",
              destfile="tl_2016_us_state.zip",mode="wb")
unzip("tl_2016_us_state.zip")
states<-readOGR(".","tl_2016_us_state")
##transform coordinate system
states<-spTransform(states,CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
writeOGR(states,".","USA_states/USA_states",driver="ESRI Shapefile")

CA_state<-states[states@data$NAME == "California",]#subset CA
writeOGR(CA_state,".","CA_state/CA_state",driver="ESRI Shapefile")

#################################################-
##USA counties
#################################################-
download.file("ftp://ftp2.census.gov/geo/tiger/TIGER2016/COUNTY/tl_2016_us_county.zip",
              destfile="tl_2016_us_county.zip",mode="wb")
unzip("tl_2016_us_county.zip")
county<-readOGR(".", "tl_2016_us_county")
county<-spTransform(county, CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
proj4string(county)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
writeOGR(county,".","USA_county/USA_county",driver="ESRI Shapefile")

CA_state@data$STATEFP##FP for CA (corresponds to NAME col in county df)
CA_counties<-county[county@data$STATEFP == '06',]##subset CA counties
writeOGR(CA_counties,".","CA_county/CA_county",driver="ESRI Shapefile")
