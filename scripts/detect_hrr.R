# library("devtools")
# devtools::install_github("bioinformatics-ptp/detectRUNS/detectRUNS")
library("tidyverse")
library("detectRUNS")
library("data.table")

args = commandArgs(trailingOnly=TRUE)
if (length(args) >= 1) {
  
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
    #base_folder = '~/Documents/SMARTER/Analysis/hrr/',
    #genotypes = "Analysis/hrr/goat_thin.ped",
    mapfile = "Analysis/hrr/goat_thin.map",
    minSNP = 15,
    ROHet = TRUE,
    maxGap = 10^6,
    minLengthBps = 250000,
    maxOppRun = 3,
    maxMissRun = 2,
    species = '',
    force_overwrite = FALSE
  ))
}

writeLines(' - current values of parameters')
print(paste("species is:", config$species))
print(paste("genotype file:", config$genotypes))
print(paste("mapfile:", config$mapfile))
print(paste("min n. of SNP:", config$minSNP))
print(paste("maximum gap between SNPs:", config$maxGap))
print(paste("min length of hrr (bps):", config$minLengthBps))
print(paste("max homozygous SNP on hrr:", config$maxOppRun))
print(paste("max missing SNP in hrr:", config$maxMissRun))

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

tmp = paste(config$minSNP, config$minLengthBps, config$maxOppRun, config$maxMissRun, sep="_")
fname = paste("hrr_", tmp, ".csv", sep="")
fpath = file.path(config$base_folder, config$species, fname)

writeLines(" - writing out results (HRRs) to file")
print(paste("output file name:",fpath))
fwrite(consecutiveRuns, file = fpath, sep = ",")
	      
