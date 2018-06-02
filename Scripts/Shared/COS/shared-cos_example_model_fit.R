## Dependencies ##
require(R2WinBUGS)

BD <-  "path-to-winbugs-on-your-machine"

#Load point-level (primary) data, neighborhood information, and grid (secondary) data
source('Scripts/Shared/COS/data-prep.R') # (ART 4 minutes)


### ### ### ### ### ### ### ### ### ### ### ###

# MCMC Settings
ni = 50000
nb = 10000
nt = 50
nc = 3

### ### ### ### ### ### ### ### ### ### ### ###

# Prepare data, set initial values, and indicate which values to be returned from BUGS #


  #Bundle data

  car.data <- list(Y = grid1$total.dets,
                    E = coarse.block$total.eHours,
                    W = coarse.block$total.eCount,
                    num = grid1.wbnb$num, 
                    adj = grid1.wbnb$adj,
                    weights = grid1.wbnb$weights,
                    ncell = length(grid1.wbnb$num),
                    cell = grid1$nearest_block_BBA_ID,
                    nsite = nrow(grid1),
                    forest = block$Forest1,
                    ncell_eb = nrow(coarse.block),
                    low = low,
                    high = high)


  
  #Set initial values
  car.inits <- function() {
    list(z = as.numeric(grid1$total.dets>0),
         alpha = runif(1,-1,1), 
         b.forest = runif(1, -1, 1), 
         S = rep(0, length(grid1.wbnb$num)),
         p = runif(1))
  }


  #parameters to monitor

  car.parameters <- c('psi', 'p', "alpha", 'b.forest')


  out <- bugs(data = car.data,
              inits = car.inits,
              parameters.to.save = car.parameters,
              model.file = here("Models/shared_with_cos.txt"),
              n.chains = nc,
              n.thin = nt,
              n.iter = ni,
              n.burnin = nb,
              bugs.dir = BD,
              working.directory = here('Output'),
              debug = F)
