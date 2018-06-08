# Resolving misaligned spatial data with integrated distribution models  

### Krishna Pacifici, Brian Reich, David Miller, and Brent Pease  

### Please contact Krishna Pacifici (jkpacifi@ncsu.edu) for questions about the code or data  

---  

## Abstract:  
Interest in evaluating how species respond to changing environmental conditions paired with novel abilities to collect and store data has led to a boom in developing and applying methods that integrate multiple streams of data to model species distributions. Combining different sources of information increases spatial coverage, improving accuracy in estimates of species’ distributions.  However, a central problem of fusing multiple streams of data is that the temporal and spatial resolutions of data sources may be mismatched.  Often the different sources of data have fluctuating geographic coverage, varying spatial scales and resolutions, and suffer from different sources of bias and sparsity.  Ignoring the misalignment of different data sources will result in statistical issues including bias in both the point estimates and uncertainty, and ultimately inaccurate predictions of species distributions.  We outline the issue of misaligned data as it relates to integrated distribution models and provide a general solution building off work in the statistical literature for the *change of support* problem.  Specifically, we leverage spatial correlation and repeat observations at multiple scales to make statistically valid predictions at ecologically relevant scales of inference.  Additionally, addressing differences in spatial resolution between data sets allows for the evaluation and calibration of lesser quality sources in many instances. Through a series of data examples and simulations, we highlight the utility of this modeling approach and the consequences of not reconciling misaligned spatial data. We conclude with a brief discussion of the upcoming challenges and obstacles for species distribution modeling via data fusion.  

**Key words**: change of support, occupancy modeling, integrated distribution modeling, spatial modeling

## Folder structure and file contents

1. **Data** - contains data files needed to fit models in winBUGS   
   * *BlockCovariates_cleaned.csv* = Grid information containing coordinates for each grid size as well as average forest cover for each grid cell (covariate information) 
   * *coarse_block.csv* = eBird data for black-and-white warblers (*Mniotilta varia*) in Pennsylvania, USA summarized within misaligned grid cells.
   * *grid1.wbnb.Rdata* = Spatial neighborhood information for the finest grid.    
   * *grid1_allpoints.csv* = Breeding Bird Atlas data from Pennsylvania, USA for black-and-white warblers. This serves as the primary data source.    
2. **Models** - contains winBUGS code for data fusion models    
   * *Shared* - Change of Support (CoS) and No CoS    
   * *Correlation* - CoS and No CoS    
   * *Covariate*    
   * *Single*     
3. **Scripts** - folder containing `R` scripts for fitting models in winBUGS via `R2WinBUGS`



