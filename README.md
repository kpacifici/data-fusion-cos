# Resolving misaligned spatial data with integrated species distribution models  

### Krishna Pacifici, Brian Reich, David Miller, and Brent Pease  

### Please contact Krishna Pacifici (jkpacifi@ncsu.edu) for questions about the code or data  

---  

## Abstract:  
Interest in evaluating how species respond to changing environmental conditions paired with novel abilities to collect and store data has led to a boom in developing and applying methods that integrate multiple streams of data to model species distributions. Combining different sources of information increases spatial coverage, improving accuracy in estimates of species’ distributions.  However, a central problem of fusing multiple streams of data is that the temporal and spatial resolutions of data sources may be mismatched.  Often the different sources of data have fluctuating geographic coverage, varying spatial scales and resolutions, and suffer from different sources of bias and sparsity.  Ignoring the misalignment of different data sources will result in statistical issues including bias in both the point estimates and uncertainty, and ultimately inaccurate predictions of species distributions.  We outline the issue of misaligned data as it relates to integrated distribution models and provide a general solution building off work in the statistical literature for the *change of support* problem.  Specifically, we leverage spatial correlation and repeat observations at multiple scales to make statistically valid predictions at ecologically relevant scales of inference.  Additionally, addressing differences in spatial resolution between data sets allows for the evaluation and calibration of lesser quality sources in many instances. Through a series of data examples and simulations, we highlight the utility of this modeling approach and the consequences of not reconciling misaligned spatial data. We conclude with a brief discussion of the upcoming challenges and obstacles for species distribution modeling via data fusion. Advances in species distribution modeling continue to be driven by a need to predict species responses to environmental change coupled with increasing data availability. Recent work has focused on development of methods that integrate multiple streams of data to model species distributions. Combining sources of information increases spatial coverage and can improve accuracy in estimates of species distributions. However, when fusing multiple streams of data, the temporal and spatial resolutions of data sources may be mismatched. This occurs when data sources have fluctuating geographic coverage, varying spatial scales and resolutions, and differing sources of bias and sparsity. It is well documented in the spatial statistics literature that ignoring the misalignment of different data sources will result in bias in both the point estimates and uncertainty. This will ultimately lead to inaccurate predictions of species distributions. Here, we examine the issue of misaligned data as it relates specifically to integrated species distribution models. We then provide a general solution that builds off work in the statistical literature for the change of support problem. Specifically, we leverage spatial correlation and repeat observations at multiple scales to make statistically valid predictions at the ecologically relevant scale of inference. An added feature of the approach is that addressing differences in spatial resolution between data sets can allow for the evaluation and calibration of lesser quality sources in many instances. Using both simulations and data examples, we highlight the utility of this modeling approach and the consequences of not reconciling misaligned spatial data. We conclude with a brief discussion of the upcoming challenges and obstacles for species distribution modeling via data fusion. 

**Key words**: change of support, occupancy modeling, integrated species distribution modeling, spatial modeling

## Folder structure and file contents

1. **Data** - contains data files needed to fit models in winBUGS   
   * *BBA_cleaned.csv* = Breeding Bird Atlas data from Pennsylvania, USA for black-and-white warblers (*Mniotilta varia*). This serves as the primary data source.    
   * *eBird_grid.csv* = eBird data for black-and-white warblers in Pennsylvania, USA summarized within misaligned grid cells.    
   * *GridCovariates_CoS.csv* = Grid information containing coordinates for each grid size as well as average forest cover for each grid cell (covariate information). This file should be used with the **Change of Support** models. 
   * *GridCovariates_No_CoS.csv* = Grid information containing coordinates for each grid size as well as average forest cover for each grid cell (covariate information). This file should be used with **No Change of Support** models.    
   * *grid1.wbnb.Rdata* = Spatial neighborhood information for the finest grid.    
   * *high.Rdata* = This file is for Change of Support models. Informs winBUGS how many finer grid cells are within coarser grid cells.    
   * *low.Rdata* = This file is for Change of Support models. Informs winBUGS how many finer grid cells are within coarser grid cells.   
   * *coords.Rdata* = This file is for the covariate model. Coordinates of eBird grid cells.  
   * *EE.Rdata* = This file is for the covariate model. Smoothed eBird effort using `mgcv::gam`    
   * *YY.Rdata* = This file is for the covariate model. Smoothed eBird counts using `mgcv::gam`    
   
2. **Models** - contains winBUGS code for data fusion models    
   * *Shared* - Change of Support (CoS) and No CoS    
   * *Correlation* - CoS and No CoS    
   * *Covariate*    
   * *Single*     
3. **Scripts** - folder containing `R` scripts for fitting models in winBUGS via `R2WinBUGS`



