# Supress package warnings for data prep script
options(warn = -1)




### ### ### ### ### ### ### ### ###
###         SHARED COS          ###
###         DATA  PREP          ###
### ### ### ### ### ### ### ### ###



# Prepare and load point-level information

# Read in master data files (Key across data files is 'BBA_ID')
block <- data.table::fread("Data/BlockCovariates.csv") # Grid information (Covariates associated with each grid cell)
bba <- data.table::fread("Data/BBA.csv")               # Breeding Bird Atlas information (Primary data source)
ebird <- data.table::fread('Data/eBird.csv')           # eBird Information (Secondary data source - coarser resolution)


# First, need to spatially align all data so that their Key matches in the data frames and in space

# Create a unique ID based on unique combination of Longitude and Latitude.
block[, Centroid_ID := .GRP, by = .(Lon1, Lat1)]

# Create 'Centroid' object
# We used this step so that we could eventually merge the block and bba data together, by spatial location
# The Centroid object serves as the vehicle for this merge
centroids <- block[!duplicated(block$Centroid_ID)]


# Make block a Spatial* object
sp::coordinates(block) <- ~Lon1 + Lat1
sp::proj4string(block) <- CRS("+init=epsg:4326")


# Make centoids Spatial*
# To increase spatial resoltuion of the grid, substitute any combination of Lon/Lat columns (e.g., Lon4, Lat4)
coordinates(centroids) <- ~Lon1 + Lat1
proj4string(centroids) <- CRS("+init=epsg:4326")


# Make bba Spatial*
coordinates(bba) <- ~Longitude + Latitude
proj4string(bba) <- CRS("+init=epsg:4326")


# Add centroid info to point layer (ART 3 minutes)
# Find the distance between all points and centroids, but return only the nearest centroid for each point
# Assign this centroid to each row of bba data
# The value returned is the row name from `centroids`
bba$nearest_block_BBA_ID <- apply(rgeos::gDistance(centroids, bba, byid = TRUE), 1, which.min)

# Add centroid info for grid cells (ART 30 seconds)
block$nearest_block_BBA_ID <- apply(gDistance(centroids, block, byid = TRUE), 1, which.min)

# Merge point-level information with grid level data
tmp <- merge(bba, block, by.x = "nearest_block_BBA_ID", by.y = row.names(centroids))
tmp <- as.data.table(tmp)


# Create a spatial neighborhood for the grid
# First, calculate distance between centroid points to create a neighborhood based on distance
# We used queen's rule, so needed latitudinal/longitudinal distances as well as diagonal distance
dist <- sp::spDists(centroids, y = centroids, longlat = TRUE)

# Make neighborhood based on distances from the `dist` object
grid1.nb <- spdep::dnearneigh(centroids, d1 = (min(dist[dist[,1]>0,1]-1)), d2 = (dist[9,1]+1),longlat = TRUE)

# Visualize neighborhood to make sure this looks right
plot.nb(grid1.nb, centroids@coords)

# This step creates a neighborhood data structure recognizable by BUGS software
grid1.wbnb <- spdep::nb2WB(grid1.nb)

# Option to save neighborhood object
# save(grid1.wbnb, file = "Data/grid1.wbnb.Rdata")

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ## 
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ## 

# Now merge in eBird data with the tmp object
# Note that there are some cells where we have no BBA data but we have eBird data in all grids
merged <- merge(tmp , ebird, by = "BBA_ID", all = TRUE)

# Remove unnecessary columns
merged <- merged[, c("eKM","eHA"):=NULL]

# Make NA values zeros in V1:V5
merged[, 8:12][is.na(merged[, 8:12])] <- 0

# Create unique BBA ID for calculating the total number of detections for each BBA survey
# BBA_ID has more than one BBA survey with it, so this is a work around to summarize by row
merged[, new_BBA := paste0("BBA_ID.", seq_len(.N))]

# Sum number of detections by new_BBA
merged[, `:=`(total.dets = sum(v1,v2,v3,v4,v5)),
       by = .(new_BBA)]

# Only need rows that actually contain BBA data
merged <- merged[complete.cases(Longitude)]

# Sum eBird effort and counts by grid cell
merged[, `:=`(total.eLists = sum(eLists),
              total.eHours = sum(eHours),
              total.eNumObs = sum(eNumObs),
              total.eCount = sum(eCount)),
       by = .(nearest_block_BBA_ID)]

# Reduce the number of columns in merged and rename to something meaningful
grid1 <- merged[, .(BBA_ID, Lat1, Lon1,Forest1, total.dets, Longitude, Latitude,
                    total.eLists, total.eHours, total.eNumObs, total.eCount, 
                    Centroid_ID, nearest_block_BBA_ID,new_BBA)]

# Create new column that numbers each of the points within a grid 
grid1 <- grid1[, Point_ID:= seq_len(.N), by = nearest_block_BBA_ID]

#reorder columns
data.table::setcolorder(grid1, c('BBA_ID','Centroid_ID','Point_ID','Lon1','Lat1',
                                 'Forest1', 'total.dets','Longitude','Latitude','total.eLists',
                                 'total.eHours','total.eNumObs', 'total.eCount','nearest_block_BBA_ID',
                                 'new_BBA'))
### ###
# Option to save grid1 data
# data.table::fwrite(grid1, file ="Data/grid1_allpoints.csv")
### ###

#clean up environment
rm(merged, bba, block, grid1.nb, tmp, dist, ebird)


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###


# Summarize information for secondary data source with coarser spatial resolution than primary data
block <- data.table::fread("Data/BlockCovariates.csv")
ebird <- data.table::fread('Data/eBird.csv')

#make column of unique Cell_IDs
block <- block[, Centroid_ID := .GRP, by = .(Lon2, Lat2)]

#make copy
centroids <- block
centroids <- centroids[!duplicated(centroids$Centroid_ID)]

#make centoids spatial
coordinates(centroids) <- ~Lon2 + Lat2
proj4string(centroids) <- CRS("+init=epsg:4326")

#make block spatial
coordinates(block) <- ~Lon2 + Lat2
proj4string(block) <- CRS("+init=epsg:4326")

#add centroid info for grid cells
block$nearest_block_BBA_ID <- apply(gDistance(centroids, block, byid = TRUE), 1, which.min)

block <- merge(block, ebird, by = "BBA_ID")
block <- as.data.table(block)

block[, `:=`(total.eLists = (sum(eLists)/.N),
             total.eHours = (sum(eHours)/.N),
             total.eNumObs = (sum(eNumObs)/.N),
             total.eCount = (sum(eCount)/.N)),
             by = .(nearest_block_BBA_ID)]
coarse.block <- block[!(duplicated(Centroid_ID))]
rm(centroids, ebird,block)


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###


# Identify which grid cell is within coarser grid cells (ART 1 min)
source('Scripts/Shared/COS/grid_cells_in_larger_cells.R')

# Prep low/high for shared model
# This informs winbugs how many finer grid cells are within a coarser grid cell
cell_order=matrix(NA,nrow=nrow(greater_cells),2)
low=rep(1,nrow(greater_cells))
high=rep(1,nrow(greater_cells))
for(j in 1:nrow(greater_cells)){
  these <- which(greater_cells$nearest_in_grid2==j)
  nnn <- length(these)
  high[j] <- low[j] + nnn -1
  # browser()
  cell_order[j,]=c(low[j],high[j] )
}
#
for(n in 1:nrow(greater_cells)){
  if(high[n]==0){high[n]=1}
}
rm(cell_order, j, n, nnn, these)



#Restore original warning setting
options(warn = 0)