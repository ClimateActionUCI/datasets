###################################################
##CAT wrangling
##Author: Colleen Nell
## Goals: 
### Introduce R by example  
### Highlight useful data manipulation functions  
### Demonstrate methods for working with spatial data  
### Increase familiarity with climate data  
###################################################

## Getting started  
#Set working directory:  
setwd("yourwd") ##change location to your folder
getwd() #tells you what the current directory is

## Read in data
list_url<-'https://drive.google.com/file/d/0B-TN-iTwt6b3X3E2VzhUanQyOU0/view?usp=sharing'
end_url<-'https://drive.google.com/file/d/0B-TN-iTwt6b3T1k2cjg2dnlQMFU/view?usp=sharing'
download.file(list_url, destfile='data/ENV/listed_sp_ca.csv')
download.file(end_url, destfile='data/ENV/end_sp_ca.csv')

##files from https://drive.google.com/drive/folders/0B-TN-iTwt6b3eHRMREpyZU8yWXM?usp=sharing
listed<-read.csv('data/ENV/listed_sp_ca.csv')
str(listed) ##structure of the data
class(listed$Status) 
levels(listed$Status) ##show levels of a factor

##dplyr for data wrangling
install.packages('dplyr')
library(dplyr)  

##filter
dim(listed)
end_animals<-filter(listed, Status == 'E', kingdom != 'plant') 
dim(end_animals)

##select
df<-dplyr::select(end_animals, Status, kingdom, organism, species, rank, class)
head(df)
df<-select(end_animals, -Species.Listing.Name, -taxonkey) #Deselect columns
colnames(df)

##pipes
df<-listed %>% #original df
  filter(Status == 'E', kingdom != 'plant') %>% 
  select(kingdom:class)  

#Read in new data 
sp.occ<-read.table('data/ENV/end_sp_df.csv', header = TRUE, sep = ",") 

sp.occ$Long<-sp.occ$decimalLongitude 
sp.occ$Lat<-sp.occ$decimalLatitude 
sp.occ<-sp.occ%>%select(-decimalLongitude, -decimalLatitude)
str(sp.occ)#species observations in CA from 2007-2017

##join species from listed that occur in sp.occ
sp.df<-left_join(sp.occ, listed, by='taxonkey') 
colnames(sp.df)

#join by variables with different names
#sp.df<-left_join(sp.occ, listed, by=c('name'='species'))

##group by & summarize
sp.class<-sp.df%>%
  filter(Status == 'E')%>%
  dplyr::group_by(kingdom, class)%>%
  summarize(obs_n= length(species)) #count of obs

sp.class

##mutate & arrange
sp.class<-sp.df%>%
  filter(Status == 'E')%>%
  dplyr::group_by(kingdom, class)%>%
  summarize(sps_n = length(unique(taxonkey)), 
            obs_n= length(species))%>% 
  arrange(desc(obs_n))%>% #sort in descnding order
  mutate(obs_sp = obs_n/sps_n)

## Challenge {.build}  
#How many federally listed species have no records in the last 20 years? Which ones?


###################################################
##spatial data  

##spatial pacakges
library(rgdal) #read in shapefiles
library(sp) #working with spatial* class data

#download shapefile from drive
url<-'https://drive.google.com/file/d/0B-TN-iTwt6b3aFlqSFVsTXVJT3M/view?usp=sharing' ##source of zip file
download.file(url = url, destfile = 'data/BOUNDARY/CA_state')
unzip('BOUNDARY/CA_state', exdir='BOUNDARY')##unzip shapefiles
#read in shapefiles
cali<-readOGR('data/BOUNDARY/CA_state')

#protected areas
capd_url<-'https://drive.google.com/file/d/0B-TN-iTwt6b3Z3VPaktBNTFUQUk/view?usp=sharing'
download.file(url = capd_url, destfile = 'data/BOUNDARY/CAPD')
unzip('BOUNDARY/CAPD', exdir='BOUNDARY')
CAPD<-readOGR(dsn='data/BOUNDARY/CPAD', layer='super_units')##CA protected areas

class(cali)
cali@proj4string ##projection  
head(cali@data) ##attribute data

##spatial points df
plants<-sp.df%>%
  filter(kingdom=='plant')

##convert lat/long coordinates to spdf
plant.spdf<-SpatialPointsDataFrame(coords=plants[,c('Long','Lat')], 
                                   data=plants, proj4string = CRS("+proj=longlat +ellps=WGS84 +no_defs"))##assign projection
summary(plant.spdf)

## Subset Spatial* points  
CA_occ<-plant.spdf[cali,] ##subset observations to those within CA
plot(CA_occ)

## Spatial overlay 
At the spatial locations of x, retrieve attributes of y:  
  ```{r}
#are species observed in protected areas?
pts.capd<-over(x = plant.spdf, y = CAPD, returnList=FALSE)
str(pts.capd) 
Look at species richness across parks:    
  ```{r}
plant.spdf$PARK_NAME<-pts.capd$PARK_NAME 
#look at species richness & observations across parks
protected<-plant.spdf@data%>%
  left_join(CAPD@data[,c('PARK_NAME','ACRES','MNG_AGENCY')], by='PARK_NAME')%>%
  group_by(PARK_NAME)%>% 
  summarize(sps_n = length(unique(name)), obs_n = length(name),
            total_acres = sum(ACRES), 
            mgmt = paste(unique(MNG_AGENCY), collapse=', '))%>% #concatenate mng_agency
  mutate(sps_area = obs_n/log(total_acres))%>%
  arrange(desc(sps_n))
View(protected)

##  San Bernardino National Forest
sbnf<-CAPD[CAPD$PARK_NAME == 'San Bernardino National Forest',]
rm(CAPD)

plot(sbnf, col = 'darkgreen')

###################################################
## spatial - Raster data  

## PRISM climate  
library(prism)
options(prism.path = "/Volumes/collnell/CAT/data/prism/prism_temp")
get_prism_normals(type = 'tmax', resolution = '800m', mon = 07, keepZip = TRUE)##July ma temperatures
ls_prism_data(name=FALSE) #all prism data files in working directory
filein<-2 ##select corresponding row number

RS <- prism_stack(ls_prism_data()[filein,1]) ##raster file of data
proj4string(RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") ##assign projection
filename<-paste0('PRISM_tmax_30yr_norm_07')
writeRaster(RS, filename=filename, overwrite=TRUE) ##save raster file

##structure
tmax_norm<-raster(filename) ##read in raster (.tiff, .grd, asc)
tmax_norm@extent ##dimensions of the layer
tmax_norm@crs ##raster projection

## Crop raster by extent  
sb.box<-extent(sbnf) 
sb.box

sb.norms<-crop(tmax_norm, sb.box)
plot(sb.norms)

## Crop raster to polygon  
norm.sbnf<-mask(sb.norms, sbnf)
norm.sbnf<-trim(norm.sbnf)
rm(tmax_norm)
plot(norm.sbnf, main="Average annual maximum temperature")

## Calculate temperature anomaly  
tmax_url<-'https://drive.google.com/file/d/0B-TN-iTwt6b3Z3JyM21KNUZidm8/view?usp=sharing'
download.file(url = tmax_url, destfile = 'data/CMIP5_NA/tmax_2050_a1b')
unzip('CMIP5_NA/tmax_2050_a1b', exdir='CMIP5_NA')
tmax_2050<-raster('data/climate/CMIP5_NA/tmax_2050_a1b.grd')
tamx_anom<-overlay(x = tmax_2050, y = norm.sbnf, fun=function(x,y){return(x-y)})
##C to F
tamx_anom@data@values<-tamx_anom@data@values*1.8+32
plot(tamx_anom, main='Projected max temp increase by 2050')

## Extract values from raster  
sb.anom<-extract(tamx_anom, sbnf, fun=mean, na.rm=TRUE, sp=TRUE)
sb.anom@data$layer 

## Extract values from raster 
sb.plants<-plant.spdf[sbnf,]##subset plant observations
sb.anom<-extract(tamx_anom, sb.plants, buffer=5, na.rm=TRUE, sp=TRUE)  ##sp adds to df

##which species will endure hottest heat?
heat<-sb.anom@data%>%group_by(name)%>%summarize(hot=mean(layer, na.rm=TRUE))%>%arrange(desc(hot))
heat

