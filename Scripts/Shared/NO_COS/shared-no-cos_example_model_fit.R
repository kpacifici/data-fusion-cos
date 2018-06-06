## Dependencies ##
library(R2WinBUGS)
library(here)

BD <-  "path-to-winbugs-on-your-machine"

#Load point-level (primary) data, neighborhood information, and grid (secondary) data
source('Scripts/Shared/NO_COS/data-prep.R') # (ART 1 minute)


### ### ### ### ### ### ### ### ### ### ### ###

# MCMC Settings
ni = 50000
nb = 10000
nt = 50
nc = 3

### ### ### ### ### ### ### ### ### ### ### ###

# Prepare data, set initial values, and indicate which values to be returned from BUGS #


#Bundle data

car.data <- list(R = matrix(c(0.02,0,0,0.02),2,2),
                 Y = grid1$total.dets,
                 E = block$avg.eHours,
                 W = block$avg.eCount,
                 num = grid1.wbnb$num, 
                 adj = grid1.wbnb$adj,
                 weights = grid1.wbnb$weights,
                 ncell = length(grid1.wbnb$num),
                 cell = grid1$nearest_block_BBA_ID,
                 nsite = nrow(grid1),
                 forest = block$Forest1)


#Set initial values
car.inits <- function() {
  list(z = (as.numeric(grid1$total.dets>0)),
       b.forest = runif(1, -1, 1),
       p = runif(1),
       alpha = c(runif(1,-1,1),runif(1,-1,1)),
       omega= matrix(c(.2,0,0,.2),2,2),
       S = matrix(c(rnorm(2*nrow(block),-0.01,0.01)),2,nrow(block)))
}


#parameters to monitor

car.parameters <- c('psi', 'p', "alpha", 'b.forest')


out <- bugs(data = car.data,
            inits = car.inits,
            parameters.to.save = car.parameters,
            model.file = here("Models/shared_without_cos.txt"),
            n.chains = nc,
            n.thin = nt,
            n.iter = ni,
            n.burnin = nb,
            bugs.dir = BD,
            working.directory = here('Output'),
            debug = F)
