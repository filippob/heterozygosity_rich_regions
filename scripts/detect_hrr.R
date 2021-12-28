# library("devtools")
# devtools::install_github("bioinformatics-ptp/detectRUNS/detectRUNS")
library("tidyverse")
library("detectRUNS")
library("data.table")

args = commandArgs(trailingOnly=TRUE)
if (length(args) == 1) {
  
  #loading the parameters
  source(args[1])
  # source("Analysis/hrr/config.R")

  } else {
  #this is the default configuration, used for development and debug
  writeLines('Using default config')
  
  #this dataframe should be always present in config files, and declared
  #as follows
  config = NULL
  config = rbind(config, data.frame(
    base_folder = '~/Documents/SMARTER/Analysis/hrr/',
    genotypes = "Analysis/hrr/goat_thin.ped",
    mapfile = "Analysis/hrr/goat_thin.map",
    minSNP = 15,
    ROHet = TRUE,
    maxGap = 10^6,
    minLengthBps = 250000,
    maxOppRun = 3,
    maxMissRun = 2,
    force_overwrite = FALSE
  ))
}

# genotypeFilePath <- system.file(
#   "extdata", "Kijas2016_Sheep_subset.ped", package="detectRUNS")
# mapFilePath <- system.file(
#   "extdata", "Kijas2016_Sheep_subset.map", package="detectRUNS")

## detect HRR
writeLines(' - detecting HRR with the consecutive method (Marras et al., 2016)')

consecutiveRuns <- consecutiveRUNS.run(
  genotypeFile = config$genotypes,
  mapFile = config$mapfile,
  minSNP = config$minSNP,
  ROHet = config$ROHet,
  maxGap = config$maxGap,
  minLengthBps = config$minLengthBps,
  maxOppRun = config$maxOppRun,
  maxMissRun = config$maxMissRun
)
