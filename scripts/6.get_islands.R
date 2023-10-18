library("knitr")
library("itertools")
library("tidyverse")
library("detectRUNS")
library("data.table")

writeLines(" - parsing results from HRR experiments")

################################
################################
## OUR DATA
################################
################################

basefolder = "/home/filippo/Documents/SMARTER/human_hrr"
genetic_group = "CEU"
# nchrom = 2
thr_hrr = 0.25
max_gap = 2.5e+4 ## from config.R
analysis = "Analysis/"
outdir = "parsed_results"

## create output directory
dir.create(file.path(basefolder, analysis, genetic_group, outdir), showWarnings = FALSE)

writeLines(" - summary of experiments run so far")

files <- list.files(file.path(basefolder, analysis, genetic_group, "hrr"), recursive = TRUE)
vec <- !(grepl(pattern = "config.R", x = files))
files <- files[vec]
files <- as.data.frame(files)
## BELOW: only for per chromosome analyses
# files <- separate(files, files, into = c("chrom", "file"), sep = "/")

# paste(config$minSNP, config$minLengthBps, config$maxOppRun, config$maxMissRun, sep="_")
files <- separate(files, files, into = c("type","min_snp","min_bps","max_opp","max_miss"), sep = "_")
files$max_miss = gsub("\\.csv","",files$max_miss)
files$max_gap = max_gap

print(paste("Type of detection:", unique(files$type)))
print(paste("Max GAP:", unique(files$max_gap)))

#######################################
## BLOCK BELOW FOR SENSITIVITY ANALYSIS
#######################################
# writeLines(" - overview of experiments")
# 
# dd <- files |>
#   group_by(chrom, min_snp, min_bps, max_opp, max_miss) |>
#   summarise(N = n()) |>
#   spread(key = chrom, value = N)
#   
# kable(dd)


writeLines(" -------------------- ")

writeLines(" - find HRR islands")
print(paste("Threshold to identify HRR islands:", thr_hrr))

files <- files |>
  rowwise() |>
  mutate(fname = file.path(paste("hrr_",min_snp,"_",min_bps, "_", 
                                 max_opp, "_", max_miss, ".csv", 
                                 sep=""))
         )


res = NULL
stats = NULL
islands = NULL
for (i in 1:nrow(files)) {
  
  fname = files$fname[i]
  print(paste("processing file:",fname))
  # chrom = files$chrom[i]
  min_snp = files$min_snp[i]
  min_bps = files$min_bps[i]
  max_opp = files$max_opp[i]
  max_miss = files$max_miss[i]
  
  inpfile = paste(file.path(basefolder, analysis, genetic_group, "hrr", fname))
  mapfile = file.path(basefolder, analysis, genetic_group, "filter", paste(genetic_group, "_autosomes_filtered", ".map", sep=""))
  pedfile = file.path(basefolder, analysis, genetic_group, "filter", paste(genetic_group, "_autosomes_filtered", ".ped", sep=""))
  
  runs = fread(inpfile)
  runs <- runs |> mutate(group = genetic_group, chrom = as.character(chrom))
  
  ## HRR summary stats
  temp <- runs %>%
    group_by(group) %>%
    summarise(n_runs=n(), runs_ind = length(unique(id)), avg_n = n_runs/runs_ind, avg_length = mean(lengthBps))
  
  temp <- mutate(temp, min_snp = min_snp, min_bps = min_bps, max_opp = max_opp, max_miss = max_miss, max_gap = max_gap)
  stats = rbind.data.frame(stats, temp)
  
  ### HRR ISLANDS
  temp = try(tableRuns(runs = runs, genotypeFile = pedfile, mapFile = mapfile, threshold = thr_hrr), silent = TRUE)
  if (!(is.null(nrow(temp)))) {
    
    temp <- mutate(temp, min_snp = min_snp, min_bps = min_bps, max_opp = max_opp, max_miss = max_miss, max_gap = max_gap)
    islands = rbind.data.frame(islands, temp) 
  }
  
  ### percentage of times each SNP falls in a HRR
  runs_dfx <- runs
  names(runs_dfx) <- c("POPULATION","IND","CHROMOSOME","COUNT","START","END","LENGTH")
  mapChrom = fread(mapfile)
  names(mapChrom) <- c("CHR","SNP_NAME","x","POSITION")
  
  temp <- detectRUNS:::snpInsideRuns(runsChrom = runs_dfx, mapChrom = mapChrom, genotypeFile = pedfile)
  
  temp <- mutate(temp, min_snp = min_snp, min_bps = min_bps, max_opp = max_opp, max_miss = max_miss, max_gap = max_gap)
  temp <- filter(temp, PERCENTAGE > 0)
  res = rbind.data.frame(res,temp)
}

### WRITE OUT RESULTS
writeLines(" - writing out results")

fname = file.path(basefolder, outdir, "hrr_exps.csv")
fwrite(x = dd, file = fname, sep = ",")

fname = file.path(basefolder, outdir, "hrr_stats.csv")
fwrite(x = stats, file = fname, sep = ",")

fname = file.path(basefolder, outdir, "hrr_islands.csv")
fwrite(x = islands, file = fname, sep = ",")

fname = file.path(basefolder, outdir, "hrr_snpres.csv")
fwrite(x = res, file = fname, sep = ",")

print("DONE!")