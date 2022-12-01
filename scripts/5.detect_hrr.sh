#!/bin/bash

## script to detect HRR
## the bash scripts first thins and transform the input data
## then calls an R script to detect HRR (detectRUNS inside)

prjfolder=/home/smarter/hrr_parameters
species="cow"
DATA=$prjfolder/Analysis/filter
PLINK=$HOME/software/plink/plink
OUTDIR=$prjfolder/Analysis/hrr
RSCRIPT=$HOME/hrr_parameters/heterozygosity_rich_regions/scripts/detect_hrr.R
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
$PLINK --cow --bfile $DATA/${species}_filtered --thin 0.99 --recode --out $OUTDIR/${species}_thin


## Configuration file
echo "2. Creating the configuration file"

echo "config = data.frame(" > $OUTDIR/config.R
echo "base_folder = '${prjfolder}/Analysis/hrr/'," >> $OUTDIR/config.R
echo "genotypes = '$OUTDIR/${species}_thin.ped'," >> $OUTDIR/config.R
echo "mapfile = '$OUTDIR/${species}_thin.map'," >> $OUTDIR/config.R
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
rm $OUTDIR/${species}_thin.log
rm $OUTDIR/${species}_thin.nosex
#rm $OUTDIR/config.R

echo "DONE!"

