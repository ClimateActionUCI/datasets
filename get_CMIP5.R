#################################################-
## CLIMATE
## Retrieve and crop CMIP5 climate projections
## ORiginal by W. Petry
#################################################-
## Preliminaries
library(rdrop2)
library(dplyr)
library(rgdal)
library(raster)

rm(list=ls())
options(timeout=1000)

##CMIP5 data
#http://cmip-pcmdi.llnl.gov/cmip5/
##gridded climate data ~1 km resolution

#RCMIP5 package
#https://cran.r-project.org/web/packages/RCMIP5/vignettes/atmospheric_co2.html
# package documentation https://github.com/JGCRI/RCMIP5

library(RCMIP5)

setwd('/Volumes/collnell/CAT/data/climate')

#################################################-
## Get model output, crop to focal region, write output
#################################################-
##rcp= representative concentration pathways
##4 scenarios in IPCC report
##numbers represent range of radiative forcing in yr 2100 relative to preindustrial values
#2.6 assumes global annual GHG emissions (CO2) peak between 2010-2020, decline
##8.5- continue to rise throughout 21st centrury

AR5<-'AR5 temperature increase projections'
ar5.df<-data.frame('Scenario' = c('RCP2.6','RCP4.5','RCP6.0','RCP8.5'),
                   '2046 - 2065' = c('1.0 (0.4 to 1.6)','1.4 (0.9 to 2.0)','1.3 (0.8 to 1.8)','2.0 (1.4 to 2.6)'),
                   '2081 - 2100' = c('1.0 (0.3 to 1.7)','1.8 (1.1 to 2.6)','1.2 (1.4 to 3.1)','3.7 (2.6 to 4.8)'))
mod<-'"AC","BC","CC","CE","CN","GF","GD","GS",HD","HG","HE","IN","IP",
                          "MI","MR","MC","MP","MG",'
mods<-expand.grid(var=c("tn","tx","pr"),#tn, tx, pr, or bi, no bi?
                  rcp=c(26,45,60,85), ##26, 45, 60, 85
                  model=c("MC","MG","MI","MP"),##changing these to retreive missing files
                  year=c(70),##50 or 70
                  res="2_5m") %>%
  mutate(filename=paste0(tolower(model),rcp,var,year),
         url=paste0("http://biogeo.ucdavis.edu/data/climate/cmip5/",res,"/",filename,".zip"))

path<-"/Volumes/collnell/CAT/data/climate/cmip5/"
dir.create(path)
urls<-mods$url

dwnldfxn<-function(aurl,filename){
  try(raster:::.download(aurl,filename))
}
urls<-mods$url
zipfile<-paste0(path,substr(urls,nchar(urls)-12+1,nchar(urls)))
mapply(dwnldfxn,aurl=urls,filename=zipfile)

###########################################################
## Subset files
###########################################################
path<-'/Volumes/collnell/CAT/data/climate/cmip5'
zfs<-list.files(path,pattern="zip",full.names=T)
str(zfs)
# Check that all files were downloaded
counts<-c(2,4,4,1,3,3,3,4,4,2,4,2,4,4,4,4,3,4,4)*3*2
names(counts)<-c("ac","bc","cc","ce","cn","gf","gd","gs","hd","hg","he","in","ip","mi","mr","mc","mp","mg","no")
counts
table(substr(zfs,1,2))

##subset data to sw usa
cat.bbox<-bbox(matrix(c(-124,-104,31,42),nrow=2,byrow=F))
dir<-'/Volumes/collnell/CAT/data/climate/cmip5'

for(i in zfs[c(1:139, 174:338)]){ ##140:173
  unzip(i,exdir=path)  # unzip file
  #unlink(i)  # remove zip file
  patt<-substr(i,nchar(i)-12+1,nchar(i)-4)
  gtifs<-list.files(dir,pattern=patt,full.names=T)[c(2, 6:13, 3:5)]##reorder
  tempstack<-stack(gtifs) ##rasterbrick
  ctempstack<-crop(tempstack,cat.bbox) ##filtered
  writeRaster(ctempstack,paste0(dir,"/",patt,".grd"),"raster")
  unlink(gtifs)
  print(paste0("Finished with file ",patt," (",which(zfs==i)," out of ",length(zfs),")"))
}
##creates .grd and .gri files for each .zip
##https://adaptwest.databasin.org/pages/adaptwest-climatena
##curated climate data
#https://www.r-bloggers.com/on-ncdf-climate-datasets/



