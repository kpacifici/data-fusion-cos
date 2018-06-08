## Dependencies ##
library(R2WinBUGS)
library(here)

BD <-  "path-to-winbugs-on-your-machine"

#Load point-level (primary) data, neighborhood information, and grid (secondary) data
block <- fread('Data/GridCovariates_No_CoS.csv')
grid1 <- fread('Data/BBA_cleaned.csv')
load('Data/grid1.wbnb.Rdata')
load('Data/coords.Rdata')
load('Data/EE.Rdata')
load('Data/YY.Rdata')

### ### ### ### ### ### ### ### ### ### ### ###

# MCMC Settings
ni = 50000
nb = 10000
nt = 50
nc = 3

### ### ### ### ### ### ### ### ### ### ### ###

# Prepare data, set initial values, and indicate which values to be returned from BUGS #


#Bundle data

car.data <- list(effort = EE,
                 count = YY,
                 Y = grid1$total.dets,
                 num = grid1.wbnb$num, 
                 adj = grid1.wbnb$adj,
                 weights = grid1.wbnb$weights,
                 ncell = length(grid1.wbnb$num),
                 cell = grid1$nearest_block_BBA_ID,
                 nsite = nrow(grid1),
                 forest = block$Forest1)


#Set initial values
car.inits <- function() {
  list(z = as.numeric(grid1$total.dets>0),
       b.forest = runif(1, -1, 1),
       b.effort=runif(1,-1,1),
       b.count=runif(1,-1,1),
       p = runif(1),
       alpha = runif(1,-1,1),
       sd=runif(1,0.1,2),
       S = c(rep(0,length(grid1.wbnb$num))))
}


#parameters to monitor

car.parameters <- c('psi', 'p', "alpha", 'b.forest','b.effort','b.count')


out <- bugs(data = car.data,
            inits = car.inits,
            parameters.to.save = car.parameters,
            model.file = here("Models/covariate.txt"),
            n.chains = nc,
            n.thin = nt,
            n.iter = ni,
            n.burnin = nb,
            bugs.dir = BD,
            working.directory = here('Output'),
            debug = F)
