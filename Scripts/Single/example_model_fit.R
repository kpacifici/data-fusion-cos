## Preamble ##
require(R2WinBUGS)

source('Scripts/Single/data-prep.R')

BD <- "path-to-winbugs-on-your-machine"


### ### ### ### ### ### ### ### ### ### ### ###

# MCMC Settings #
ni = 50000  # Number of iterations
nb = 10000  # Number of burn-ins
nt = 50     # Number of thins
nc = 3      # Number of chains

### ### ### ### ### ### ### ### ### ### ### ### 

# Prepare data, set initial values, and indicate which values to be returned from BUGS #

  
  # Bundle data
  # Values needed:
      # Y = A vector with length equal to number of sampling locations (nsite) containing information about counts of detections of focal species. Range of Integer value = (0, number of visits)
      # num = A vector of length ncell (number of grid cells) giving the number of neighbors for each cell
      # adj = A vector listing the ID numbers of the adjacent cells for each cell.
      # weights = A vector of length `adj` giving unnormalized wights associated with each pair of cells. 
      # ncell = An integer value for the number of grid cells. Usually the number of areas of interest for the secondary data source
      # cell = A vector listing the ID numbers of the point-level sampling locations within a particular cell. 
      # nsite = An integer value for the number of point-level sampling locations.
      # forest = A vector of length ncell. This can be any covariate(s) of interest, we used average forest cover in a grid cell.

  car.data <- list (Y = grid1$total.dets,              # Detections of focal species       
                    num = grid1.wbnb$num,              # Number of neighbors for each cell
                    adj = grid1.wbnb$adj,              # Which cell is a neighbor 
                    weights = grid1.wbnb$weights,      # Weight of each neighbor
                    ncell = length(grid1.wbnb$num),    # No. of grid cells for 2nd data source
                    cell = grid1$nearest_block_BBA_ID, # Which cell is point located in
                    nsite = nrow(grid1),               # No. of primary data points
                    forest = centroids@data$Forest1)   # Covariate of interest at cell resolution
  
  #Set initial values
  car.inits <- function() {
    list(z = as.numeric(Y>0),
         alpha = runif(1,-1,1), 
         b.forest = runif(1, -1, 1), 
         S = rep(0, nrow(ncell)),
         p = runif(1))
  }
  
  #parameters to be monitored
  car.parameters <- c('psi',"alpha","b.forest",'p')
  

  # Run bugs
  out <- bugs(data = car.data,
              inits = car.inits,
              parameters.to.save = car.parameters,
              model.file = here('Models/single.txt'),
              n.thin = nt, n.iter = ni, n.burnin = nb, n.chain = nc,
              bugs.dir = BD,
              working.directory = here('Output'),
              debug = TRUE)

