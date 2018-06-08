# Supress package warnings for data prep script
options(warn = -1)

library(sp)
library(data.table)
library(rgeos)
library(spdep)


### ### ### ### ### ### ### ### ###
###     CORRELATION *NO* COS    ###
###         DATA  PREP          ###
### ### ### ### ### ### ### ### ###

# There are a few ways to summarize information about smaller cells 
# that are contained within larger cells (spatial misalignment).

# Here, we illustrate this by averaging the values from the smaller cells 
# to get one value for the larger cell. 




# Prepare and load point-level information

# Read in master data files (Key across data files is 'BBA_ID')
block <- data.table::fread("Data/BlockCovariates.csv") # Grid information (Covariates associated with each grid cell)
ebird <- data.table::fread('Data/eBird.csv')           # eBird Information (Secondary data source - coarser resolution)

# First, need to spatially align all data so that their Key matches in the data frames and in space

# Create a unique ID based on unique combination of Longitude and Latitude.
block[, Centroid_ID := .GRP, by = .(Lon2, Lat2)]

#Reduce the number of points down to the larger grid cells
centroids <- block[!duplicated(Centroid_ID)]

#make centoids spatial
coordinates(centroids) <- ~Lon2 + Lat2
proj4string(centroids) <- CRS("+init=epsg:4326")

#make block spatial
coordinates(block) <- ~Lon2 + Lat2
proj4string(block) <- CRS("+init=epsg:4326")

# Add centroid ID for grid cells
block$nearest_block_BBA_ID <- apply(gDistance(centroids, block, byid = TRUE), 1, which.min)

#After assigning spatial Key, combine with eBird data (merge prior to converting to data.table)
block <- merge(block, ebird, by = "BBA_ID")
block <- as.data.table(block)

#Create new columns that averages the eBird information in each larger cell
coarse.block <- block[, `:=`(total.eLists = (sum(eLists)/.N),
                                total.eHours = (sum(eHours)/.N),
                                total.eNumObs = (sum(eNumObs)/.N),
                                total.eCount = (sum(eCount)/.N)),
                         by = .(nearest_block_BBA_ID)]

#Just need one row per Centroid_ID
coarse.block <- coarse.block[!(duplicated(Centroid_ID))]



#Need to do a similiar process, but for the smallest grid size

#Refresh data sources
block <- data.table::fread("Data/BlockCovariates.csv") 
bba <- data.table::fread("Data/BBA.csv")              
ebird <- data.table::fread('Data/eBird.csv') 

#make column of unique Cell_IDs
block[, Centroid_ID := .GRP, by = .(Lon1, Lat1)]

#Won't reduce the number of rows since we are at the finest grid, but need it to assign spatial keys
centroids <- block[!duplicated(Centroid_ID)]

#make centoids spatial
coordinates(centroids) <- ~Lon1 + Lat1
proj4string(centroids) <- CRS("+init=epsg:4326")

#make tmp.bl spatial
coordinates(block) <- ~Lon1 + Lat1
proj4string(block) <- CRS("+init=epsg:4326")

#add centroid info for grid cells (ART 30 seconds)
block$nearest_block_BBA_ID <- apply(gDistance(centroids, block, byid = TRUE), 1, which.min)

block <- merge(block, ebird, by = "BBA_ID")
block <- as.data.table(block)

fine.block <- block[, `:=`(total.eLists = (sum(eLists)/.N),
                                total.eHours = (sum(eHours)/.N),
                                total.eNumObs = (sum(eNumObs)/.N),
                                total.eCount = (sum(eCount)/.N)),
                         by = .(nearest_block_BBA_ID)]


#make fine.block spatial
coordinates(fine.block) <- ~Lon1 + Lat1
proj4string(fine.block) <- CRS("+init=epsg:4326")

#make coarse.block spatial
coordinates(coarse.block) <- ~Lon2 + Lat2
proj4string(coarse.block) <- CRS("+init=epsg:4326")


fine.block$nearest_coarse_block <- apply(gDistance(coarse.block, fine.block, byid = TRUE), 1, which.min)
fine.block <- as.data.table(fine.block)
coarse.block <- as.data.table(coarse.block)
coarse.block <- coarse.block[,.(total.eCount, total.eHours)]
coarse.block[, rn := seq_len(.N)]


block <- merge.data.frame(fine.block, coarse.block, by.x = "nearest_coarse_block", by.y = 'rn')
setnames(block, old = c('total.eCount.y','total.eHours.y'), new = c('avg.eCount', 'avg.eHours'))

### ### ### ### ### ### ### ### ###
### ### ### ### ### ### ### ### ###


# Create a spatial neighborhood for the grid
# First, calculate distance between centroid points to create a neighborhood based on distance
# We used queen's rule, so needed latitudinal/longitudinal distances as well as diagonal distance
dist <- sp::spDists(centroids, y = centroids, longlat = TRUE)

# Make neighborhood based on distances from the `dist` object
grid1.nb <- spdep::dnearneigh(centroids, d1 = (min(dist[dist[,1]>0,1]-1)), d2 = (dist[9,1]+1),longlat = TRUE)

# Visualize neighborhood to make sure this looks right
# plot.nb(grid1.nb, centroids@coords)

# This step creates a neighborhood data structure recognizable by BUGS software
grid1.wbnb <- spdep::nb2WB(grid1.nb)

# Option to save neighborhood object
# save(grid1.wbnb, file = "Data/grid1.wbnb.Rdata")

### ### ### ### ### ### ### ### ###
### ### ### ### ### ### ### ### ###

# Read in prepped bba data
# See data-prep script in Shared COS for steps on cleaning this file
grid1 <- fread('Data/BBA_cleaned.csv')

rm(coarse.block, fine.block, dist, ebird, grid1.nb,bba, centroids)
#Restore original warning setting
options(warn = 0)