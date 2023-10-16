## Script to prepare file with sex information
## that will be used to update sex in the Plink files

library("tidyverse")
library("data.table")

## PARAMETERS
basefolder = "/home/smarter/human_hrr"
input_fam = "Analysis/Yoruba/filter/temp.fam"
sample_file = "1000_human_genomes/igsr-yri.tsv.tsv"
ouput_file = "Analysis/Yoruba/filter/upd.sex"

writeLines(" - reading input files")
## READ .fam FILE
fname = file.path(basefolder, input_fam)
fam = fread(fname)

## READ SAMPLE FILE
fname = file.path(basefolder, sample_file)
samples = fread(fname)

samples <- samples |> select(`Sample name`, Sex)

## JOIN FILES
writeLines(" - preparing data to update sex information")
fam <- fam |>
  select(V1,V2) |>
  inner_join(samples, by = c("V1" = "Sample name"))

fam$Sex = toupper(substr(fam$Sex,1,1))

## WRITE OUT RESULTS
writeLines(" - writing out file to update sex information in Plink")
fname = file.path(basefolder, ouput_file)
fwrite(x = fam, file = fname, sep = "\t", col.names = FALSE)

print("DONE!")
