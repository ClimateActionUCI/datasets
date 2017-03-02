#################################################-
## DATA: CLIMATE
## PRISM monthly temperatures
## URL: https://github.com/ropensci/prism
## Author: C. Nell
#################################################-
## Preliminaries
library(dplyr)
library(magrittr)
library(reshape2)
library(raster)
library(prism)
library(ggplot2)
library(ggmap)
##monthly data at 4 km resolution- 2.5 arcmin
##spatial resolution: climatologies at 30-1rcec
##temporal resolution: 30 year normals, dailys, monthly, annual
library(ClimateAction)

setwd('/Users/colleennell/Dropbox/rstats/CAT/data')
options(prism.path = "/Users/colleennell/Dropbox/rstats/CAT/data/prism_temp")
rm(list=ls())

##data is available from 1891 to 2014
##years pre 1981- 
#get_prism_monthlys(type="ppt", year = 2017, mon = 1:12, keepZip=TRUE)
get_prism_annual(type='tmean', years=2017, keepZip=TRUE)#replace tmean with ppt for precipication data
ls_prism_data()
#prism_image(ls_prism_data()[1,1])
RS <- prism_stack(ls_prism_data()[c(36:39,52:53),1])##raster file
##convert raster to point data
df <- data.frame(rasterToPoints(RS))
m.df <- melt(df, c("x", "y"))
names(m.df)[1:2] <- c("lon", "lat")

stable<-'PRISM_tmean_stable_4kmM3_' #replace tmean with ppt for precipication data
m.df$yearmon<-gsub('PRISM_tmean_provisional_4kmM3_','', m.df$variable)
m.df$yearmon<-gsub(stable,'', m.df$yearmon)
m.df$yearmon<-gsub('_bil','', m.df$yearmon)
m.df<-m.df%>%
  mutate(temp = value)%>%
  dplyr::select(-value)
##save each year as new file
year<-'2000_2009'
#mm.df<-filter(m.df, grepl(year, yearmon))
mm.df<-m.df
name<-paste0("yearly_temp/USA/PRISM_temp_", year,".csv")
write.csv(mm.df, name)
###filter to SW USA
sw.usa.df <- bounding.box.filter(mm.df)##from filter to SW region
output.file.name <- paste0("yearly_temp/SW_USA/PRISM_temp_",year,"_SW.csv")
write.csv(sw.usa.df, output.file.name)
###filter to so cal
socal.bounding.box <- list(minLat=31, maxLat=36, minLon=-124, maxLon=-114)
socal.df<-bounding.box.filter(sw.usa.df, bounding.box=socal.bounding.box)
socal.name <- paste0("yearly_temp/SOCAL/PRISM_temp_",year,"_SOCAL.csv")
write.csv(socal.df, socal.name)

########################
##plot raster data
ggplot()+
  geom_raster(data=socal.df, aes(x=lon,y=lat, fill=log(value+1)))+
  theme_nothing()+
  scale_fill_gradient(low='lightblue', high='darkslateblue')+
  ggtitle('Precipitation Jan 2007')+
  coord_fixed(ratio=1.3)


########################
##plot 1 year
library(maps)
library(mapdata)

usa_map<-map_data("usa")
ggplot()+geom_polygon(data=usa_map, aes(x=long, y=lat, group=group))+
  coord_fixed(1.3)+theme_nothing()
##filter to CA
states<-map_data("state")
ggplot(data = states) + 
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") + 
  coord_fixed(1.3) +
  guides(fill=FALSE)+theme_nothing()

ca_state<-subset(states, region == 'california')

ca_state_map<-ggplot(data=ca_county, aes(x = long, y = lat, group = group))+
  geom_polygon(color="white") + 
  coord_fixed(1.3)+
  guides(fill=FALSE)+
  theme_nothing()
ca_state_map

##CA counties
counties<-map_data("county")
ca_county<-subset(counties, region == 'california')
ca_county_map<-ca_state_map + geom_polygon(data=ca_county,color="white", aes(fill=subregion))
ca_county_map

ca_state_temp<-left_join(ca_state, mm.df, by=c('long'='lon','lat'))
str(ca_state_temp)

map("state", "CALIFORNIA")
data(us.cities)
map.cities(us.cities, country="CA")


##TO DO - crop data to CA
##get annual for all dates
##get daily for 2016-2017
##same for precip
##these data can be filtered to ocations if know coordinates
##then plot data cont
##line plot of avg temp/precip in socal with different cities




##make raster df from df
spg<-m.df
coordinates(spg)<- ~lon + lat ##convert df to SPDF
proj4string(spg)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
rDF<-sp::spTransform(spg, CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
plot(rDF)
