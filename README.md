# Resolving misaligned spatial data with integrated distribution models  

### Krishna Pacifici, Brian Reich, David Miller, and Brent Pease  

### Please contact Krishna Pacifici (jkpacifi@ncsu.edu) for questions about the code or data  

---  

## Abstract:  
Interest in evaluating how species respond to changing environmental conditions paired with novel abilities to collect and store data has led to a boom in developing and applying methods that integrate multiple streams of data to model species distributions. Combining different sources of information increases spatial coverage, improving accuracy in estimates of species’ distributions.  However, a central problem of fusing multiple streams of data is that the temporal and spatial resolutions of data sources may be mismatched.  Often the different sources of data have fluctuating geographic coverage, varying spatial scales and resolutions, and suffer from different sources of bias and sparsity.  Ignoring the misalignment of different data sources will result in statistical issues including bias in both the point estimates and uncertainty, and ultimately inaccurate predictions of species distributions.  We outline the issue of misaligned data as it relates to integrated distribution models and provide a general solution building off work in the statistical literature for the *change of support* problem.  Specifically, we leverage spatial correlation and repeat observations at multiple scales to make statistically valid predictions at ecologically relevant scales of inference.  Additionally, addressing differences in spatial resolution between data sets allows for the evaluation and calibration of lesser quality sources in many instances. Through a series of data examples and simulations, we highlight the utility of this modeling approach and the consequences of not reconciling misaligned spatial data. We conclude with a brief discussion of the upcoming challenges and obstacles for species distribution modeling via data fusion.  

**Key words**: change of support, occupancy modeling, integrated distribution modeling, spatial modeling

## Folder structure and file contents

1. Data - contains primary data files    
    *BBA.csv = Breeding bird atlas data from Pennsylvania, USA for black-and-white warblers (Mniotilta varia). This serves as the primary data source.    
    *BlockCovariates.csv = Grid information containing coordinates for each grid size as well as average forest cover for each grid cell (covariate information)    
    *eBird.csv = eBird data for black-and-white warblers across Pennsylvania. This serves as the secondary data source that we integrate with our primary data.    
    *grid1.wbnb.Rdata = Spatial neighborhood information for the finest grid.    
    *grid1_allpoints.csv = *edited* BBA data that contains columns allowing a point to be assigned to a grid.    
2. Models - contains winBUGS code for data fusion models    
    *Shared - Change of Support (CoS) and No CoS    
    *Correlation - CoS and No CoS    
    *Covariate    
    *Single    
3. Output - folder to store winBUGS output    
4. Scripts - folder containing `R` scripts for data prep and 


1. Item
2. Item
   * Mixed
   * Mixed  
3. Item
