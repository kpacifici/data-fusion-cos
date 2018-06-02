library(data.table)
library(sp)
library(spdep)
library(raster)
library(rgdal)
library(rgeos)
library(maptools)

# Read in data file
block <- fread("Data/BlockCovariates.csv")

block1 <- block[,c('Lon1','Lat1')]
block1 <- block1[, Centroid_ID := .GRP, by = .(Lon1, Lat1)]
block1 <- block1[!(duplicated(Centroid_ID))]
block1 <- block1[,rn := seq_len(.N)]

grid2 <- block[,c('Lon2', 'Lat2')]
grid2 <- grid2[, Centroid_ID := .GRP, by = .(Lon2, Lat2)]
grid2 <- grid2[!(duplicated(Centroid_ID))]
grid2 <- grid2[,rn := seq_len(.N)]


grid3 <- block[,c('Lon3', 'Lat3')]
grid3 <- grid3[, Centroid_ID := .GRP, by = .(Lon3, Lat3)]
grid3 <- grid3[!(duplicated(Centroid_ID))]
grid3 <- grid3[,rn := seq_len(.N)]

grid4 <- block[,c('Lon4', 'Lat4')]
grid4 <- grid4[, Centroid_ID := .GRP, by = .(Lon4, Lat4)]
grid4 <- grid4[!(duplicated(Centroid_ID))]
grid4 <- grid4[,rn := seq_len(.N)]

block1sp <- SpatialPointsDataFrame(block1[,1:2], data = block1[,3:4])
grid2sp <- SpatialPointsDataFrame(grid2[,1:2], data = grid2[,3:4])
grid3sp <- SpatialPointsDataFrame(grid3[,1:2], data = grid3[,3:4])
grid4sp <- SpatialPointsDataFrame(grid4[,1:2], data = grid4[,3:4])

block1$nearest_in_grid2 <- apply(gDistance(grid2sp, block1sp,  byid=TRUE), 1, which.min)
block1$nearest_in_grid3 <- apply(gDistance(grid3sp, block1sp,  byid=TRUE), 1, which.min)
block1$nearest_in_grid4 <- apply(gDistance(grid4sp, block1sp,  byid=TRUE), 1, which.min)

#update SPDF
block1sp <- SpatialPointsDataFrame(block1[,1:2], data = block1[,3:7])
grid2sp <- SpatialPointsDataFrame(grid2[,1:2], data = grid2[,3:4])
grid3sp <- SpatialPointsDataFrame(grid3[,1:2], data = grid3[,3:4])
grid4sp <- SpatialPointsDataFrame(grid4[,1:2], data = grid4[,3:4])

# Option to save data
#data.table::fwrite(block1, file = 'grid_cells_in_larger_cells.csv')

#rename for use in other scripts
greater_cells <- block1
rm(grid2, grid2sp, grid3, grid3sp, grid4, grid4sp, block1, block1sp)