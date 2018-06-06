## Dependencies ##
library(R2WinBUGS)
library(here)

BD <-  "path-to-winbugs-on-your-machine"

#Load point-level (primary) data, neighborhood information, and grid (secondary) data
source('Scripts/Correlation/COS/data-prep.R') # (ART 4 minutes)


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
                    high = high,
                   R = matrix(c(0.02,0,0,0.02),2,2))

  
  #Set initial values
  car.inits <- function() {
    list(z = as.numeric(grid1$total.dets>0),
         b.forest1 = 0,
         b.forest2 = 0,
         p = runif(1),
         alpha = runif(2,-1,1),
         omega= matrix(c(.2,0,0,.2),2,2),
         S = matrix(c(rnorm(2*length(grid1.wbnb$num),-0.01,0.01)),2,length(grid1.wbnb$num)))
  }


  #parameters to monitor

  car.parameters <- c('psi', 'p', "alpha", 'b.forest1','b.forest2')


  out <- bugs(data = car.data,
              inits = car.inits,
              parameters.to.save = car.parameters,
              model.file = here("Models/correlation_with_cos.txt"),
              n.chains = nc,
              n.thin = nt,
              n.iter = ni,
              n.burnin = nb,
              bugs.dir = BD,
              working.directory = here('Output'),
              debug = F)
