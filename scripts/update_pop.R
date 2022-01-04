# library("devtools")
# devtools::install_github("bioinformatics-ptp/detectRUNS/detectRUNS")
library("tidyverse")
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
    base_folder = '~/Documents/SMARTER/Analysis/filter/',
    fam = "Analysis/filter/goat_filtered.fam",
    force_overwrite = FALSE
  ))
}

writeLines(' - current values of parameters')
print(paste("fam file:", config$fam))
# print(paste("mapfile:", config$mapfile))
# print(paste("min n. of SNP:", config$minSNP))


# genotypeFilePath <- system.file("extdata", "Kijas2016_Sheep_subset.ped", package="detectRUNS")
# mapFilePath <- system.file("extdata", "Kijas2016_Sheep_subset.map", package="detectRUNS")

## update population
writeLines(' - updating population information')

print("ALP. BOE, SAA --> commercial")
print("BRK. CRE, LNR --> local")

fam = fread(config$fam)
fam = rename(fam, pop = V1, id = V2)

## PLINK : --update-ids expects input with the following four fields:
# Old family ID
# Old within-family ID
# New family ID
# New within-family ID
########

newpop = c("commercial","commercial","local","local","local","commercial")
oldpop = unique(fam$pop)

fam$newpop = newpop[match(fam$pop, oldpop)]
fam = mutate(fam, newid = id) %>% select(c(pop,id,newpop,newid))

writeLines(" - writing out results (HRRs) to file")
fname = paste(config$base_folder,"update.ids", sep="")
print(paste("output file name:",fname))
fwrite(fam, file = fname, sep = "\t", col.names = FALSE)
	      
