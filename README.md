# Data sources   
Files listed in tables below can be downloaded from: https://drive.google.com/drive/folders/0B-TN-iTwt6b3eHRMREpyZU8yWXM?usp=sharing  

| Domain | Source | Short description | Folder | Data type | Temporal coverage | Temporal Resolution | Spatial coverage | Spatial resolution | Source URL |      
| ---- | ----- | ------------ | -- | ------- | ---------- | ---------- | ----------- | ----- |  ----------------- |  
| Climate | PRISM | Current & historical climate | PRISM | raster | 1895-present | annual, monthly, daily, norms | USA | 4km or 800m | http://prism.oregonstate.edu/ |   
| Climate | WorldClim | CMIP5/IPCC current & future climate projections | CMIP5 | raster | 2050, 2070 | monthly | World | 10, 5, 2.5 min(~4km), 30secs | http://worldclim.org/version1 |   
| Climate | adaptwest | Ensemble CMIP5 projections | CMIP5_NA | raster | 2020, 2050, 2080 | monthly | North America | 1 km | https://adaptwest.databasin.org/pages/adaptwest-climatena |  
| Eco | GBIF | Species occurrence data | ENV | coordinates | varies | Day | World | lat/long | http://www.gbif.org/ |  
| Eco | USFWS | Endangered species critival habitats | ENV | shapefiles | current | -- | -- | -- |  https://ecos.fws.gov/ecp/report/table/critical-habitat.html |  
| Political boundaries | US census | state & county boundaries | BOUNDARY | shapefile | -- | -- | USA | -- | ftp://ftp2.census.gov/geo/tiger/TIGER2016/ |   


### Spatial conventions  
+ SW USA is between 31 & 42 degrees latitude, -124 to -104 longitude  
+ coordinate system: `+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs`  

___________________________   

## Climate 
### PRISM  - past & current climate  
R package: https://github.com/ropensci/prism  
Tutorials: [Getting PRISM data in R](http://rpubs.com/collnell/get_prism)  

| Files | Short description | Data type |  Source | Temporal coverage | Temporal Resolution | Spatial coverage | Spatial resolution | Source URL | 
| -------------- | ----------------- | --------- | --------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ | 
| -------------- | Spatial climate | raster | PRISM | Norms, daily, monthly, annual | 1895-present | USA | 4km or 800m | http://www.prism.oregonstate.edu/ |  

### CMIP5 - future climate projections, baseline       
Documentation: get_CMIP5.R  
WorldClim: http://worldclim.org/version1 - 19 GCMs     
AdaptWest: https://adaptwest.databasin.org/pages/adaptwest-climatena - ensemble data    

| Files | Source | Short description | Data type |  Temporal Resolution | Spatial coverage | Spatial resolution | Source URL |  
| -------------- | ----------------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ |     
| all models for all variables | WorldClim | Projected climate & bioclimatic variables | raster | monthly for 2050, 2070 | World | 2.5min | http://worldclim.org/cmip5_2.5m |   
| ensemble model | AdaptWest | Projected NA ensemble model | raster | monthly for 2050, 2070 | World | 2.5min | http://worldclim.org/cmip5_2.5m |

 
## Ecological/environmental Data  
### Species occurrences  
R package to search and retrieve data from the Global Biodiverity Information Facilty (GBIF).
CRAN: https://cran.r-project.org/web/packages/rgbif/index.html  
Tutorial: [Getting species occurrence data](http://rpubs.com/collnell/get_spdata)  

### Vegetation  
Critical habitat for endangered species: https://ecos.fws.gov/ecp/report/table/critical-habitat.html    

| File | Short description | Data type | Data generation | Temporal Resolution | Spatial coverage | Spatial resolution | Source URL | 
| ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ |  
| end_sp_df | Observations of listed species  | csv | GBIF | 2007-2017 | Western USA | coordinates | ------------------ |  
| listed_sp_ca | Federally listed species in CA | csv | Federal list | CA | ---------------- |  https://ecos.fws.gov/ecp0/reports/species-listed-by-state-report?state=CA&status=listed | ------------------ |   
| crithab_all_layer | Aggregate critical habitats | shapefile | USFWS | -- | USA | -- | https://ecos.fws.gov/ecp/report/table/critical-habitat.html |  
| crithab_all_shapefiles | Individual critical habitats for endangered species | shapefile | USFWS | -- | USA | -- | https://ecos.fws.gov/ecp/report/table/critical-habitat.html |  

### FedData
Federated geospatial data including National Elevation Dataset (NED), Soil Survey Geographic (SSURGO) database and Global Historical Climatology Network (GHCN).
Website: https://github.com/bocinsky/FedData

## Political boundaries    
Documentation: get_shapefiles.R
Tutorials: Working with spatial data 

| File | Short description | Data type | Projection | Files | Data generation | Temporal Resolution | Spatial coverage | Spatial resolution | Source URL | 
| -------------- | ----------------- | --------- | --------- | --------------- | ----------------- | ------------------- | ---------------- | ------------------ | ------------ |
| USA_state | USA state boundaries | shapefile | '+proj=longlat +ellps=WGS84' | --------------- | 2016 | --------------- | USA | ------------------ | ftp://ftp2.census.gov/geo/tiger/TIGER2016/STATE/tl_2016_us_state.zip |
| CA_state | CA state boundary | shapefile | '+proj=longlat +ellps=WGS84' | --------------- | 2016 | --------------- | CA | ------------------ | ftp://ftp2.census.gov/geo/tiger/TIGER2016/STATE/tl_2016_us_state.zip |
| USA_county | USA county boundaries | shapefile | '+proj=longlat +ellps=WGS84' | --------------- | 2016 | --------------- | USA | ------------------ | ftp://ftp2.census.gov/geo/tiger/TIGER2016/STATE/tl_2016_us_state.zip |
| CA_county | CA county boundaries | shapefile | '+proj=longlat +ellps=WGS84' | --------------- | 2016 | --------------- | CA | ------------------ | ftp://ftp2.census.gov/geo/tiger/TIGER2016/STATE/tl_2016_us_county.zip | 
| CAPD | CA protected areas | shapefile | '+proj=longlat +ellps=WGS84' | holdings, superunit, units | 2016 | --------------- | CA | ------------------ | --------- | 




