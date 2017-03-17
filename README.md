# Datasets

# Climate 
## PRISM  - past & current climate  
R package: https://github.com/ropensci/prism  
Documentation: get_prism.R  
Tutorials: [Getting PRISM data in R](http://rpubs.com/collnell/prism)  


| File | Short description | Data type | Files | Data generation | Temporal Resolution | Spatial coverage | Spatial resolution | Source URL | 
| -------------- | ----------------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |  


## CMIP5 - future climate projections     
Documentation: get_CMIP5.R

| File | Short description | Data type | Files | Data generation | Temporal Resolution | Spatial coverage | Spatial resolution | Source URL | 
| -------------- | ----------------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |  

## FedData
Federated geospatial data including National Elevation Dataset (NED), Soil Survey Geographic (SSURGO) database and Global Historical Climatology Network (GHCN).

Website: https://github.com/bocinsky/FedData
 
# Biodiversity Data
R package to search and retrieve data from the Global Biodiverity Information Facilty (GBIF).
CRAN: https://cran.r-project.org/web/packages/rgbif/index.html  
Tutorial: [Getting species occurrence data](http://rpubs.com/collnell/get_spdata)  
Documentation: https://ropensci.org/tutorials/rgbif_tutorial.html  

| File | Short description | Data type | Data generation | Temporal Resolution | Spatial coverage | Spatial resolution | Source URL | 
| ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | 
| end_sp_df | Observations of CA endangered and threatened species  | csv | GBIF | 2007-2017 | Western USA | coordinates | ------------------ | 
| listed_sp_ca | List of CA federally listed species and classification | csv | Federal list | CA | ---------------- |  https://ecos.fws.gov/ecp0/reports/species-listed-by-state-report?state=CA&status=listed | ------------------ | 

# Shapefiles  
Documentation: get_shapefiles.R
Tutorials: Working with spatial data 

| File | Short description | Data type | Projection | Files | Data generation | Temporal Resolution | Spatial coverage | Spatial resolution | Source URL | 
| -------------- | ----------------- | --------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |
| USA_state | USA state boundaries | shapefile | '+proj=longlat +ellps=WGS84' | --------------- | 2016 | --------------- | USA | ------------------ | ftp://ftp2.census.gov/geo/tiger/TIGER2016/STATE/tl_2016_us_state.zip |
| CA_state | CA state boundary | shapefile | '+proj=longlat +ellps=WGS84' | --------------- | 2016 | --------------- | CA | ------------------ | ftp://ftp2.census.gov/geo/tiger/TIGER2016/STATE/tl_2016_us_state.zip |
| USA_county | USA county boundaries | shapefile | '+proj=longlat +ellps=WGS84' | --------------- | 2016 | --------------- | USA | ------------------ | ftp://ftp2.census.gov/geo/tiger/TIGER2016/STATE/tl_2016_us_state.zip |
| CA_county | CA county boundaries | shapefile | '+proj=longlat +ellps=WGS84' | --------------- | 2016 | --------------- | CA | ------------------ | ftp://ftp2.census.gov/geo/tiger/TIGER2016/STATE/tl_2016_us_county.zip | 
| CAPD | CA protected areas | shapefile | '+proj=longlat +ellps=WGS84' | holdings, superunit, units | 2016 | --------------- | CA | ------------------ | --------- | 




