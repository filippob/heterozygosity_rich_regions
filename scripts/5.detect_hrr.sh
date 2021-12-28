#!/bin/bash

## script to detect HRR
## the bash scripts first thins and transform the input data
## then calls an R script to detect HRR (detectRUNS inside)

# DATA=/home/smarter/hrr_goat_data/goats
DATA=$HOME/Documents/SMARTER/Analysis/filter
# PLINK=$HOME/software/plink/plink
PLINK=$HOME/Downloads/plink
# OUTDIR=$HOME/hrr/Analysis
OUTDIR=$HOME/Documents/SMARTER/Analysis/hrr
RSCRIPT=$HOME/Documents/SMARTER/hrr_goats/scripts/detect_hrr.R
minSNP=15
maxGap=10^6
minBps=250*10^3
maxOpp=3
maxMiss=2

if [ ! -d "$OUTDIR" ]; then
	mkdir $OUTDIR
fi

## Thinning
echo "1. Thinning"

## plink commands 
## (option --cow to allow for 60 chromosomes in goats)
## there is no option --goat 
## (sheep has 54 chromosomes, therefore --sheep would not work)
$PLINK --cow --bfile $DATA/goat_filtered --thin 0.15 --recode --out $OUTDIR/goat_thin


## Configuration file
echo "2. Creating the configuration file"

echo "config = data.frame(" > $OUTDIR/config.R
echo "base_folder = '~/Documents/SMARTER/Analysis/hrr/'," >> $OUTDIR/config.R
echo "genotypes = '$OUTDIR/goat_thin.ped'," >> $OUTDIR/config.R
echo "mapfile = '$OUTDIR/goat_thin.map'," >> $OUTDIR/config.R
echo "minSNP = $minSNP," >> $OUTDIR/config.R
echo "ROHet = TRUE," >> $OUTDIR/config.R
echo "maxGap = $maxGap," >> $OUTDIR/config.R
echo "minLengthBps = $minBps," >> $OUTDIR/config.R
echo "maxOppRun = $maxOpp," >> $OUTDIR/config.R
echo "maxMissRun = $maxMiss," >> $OUTDIR/config.R
echo "force_overwrite = FALSE)" >> $OUTDIR/config.R

## detect RUNS
echo "3. Detecting HRR"
Rscript --vanilla $RSCRIPT $OUTDIR/config.R

## house cleaning
echo "4. Cleaning"
rm $OUTDIR/goat_thin*
rm $OUTDIR/config.R

echo "DONE!"

