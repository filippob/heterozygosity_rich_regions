#!/bin/bash

## script to detect ROH
## the bash scripts first thins and transform the input data
## then calls an R script to detect ROH (detectRUNS inside)

prjfolder=/home/smarter/runs_from_sequences
species="goat"
DATA=$prjfolder/Analysis/2.filter
PLINK=$HOME/software/plink/plink
OUTDIR=$prjfolder/Analysis/ROH/500k
RSCRIPT=$HOME/hrr_parameters/heterozygosity_rich_regions/scripts/detect_roh.R
#$PLINK --cow --allow-extra-chr --bfile $DATA --chr 1-26 --bp-space 1 --geno $GENO --mind $MIND --maf $MAF --make-bed --out $OUTDIR/${SPECIES}_filtered

minSNP=20
maxGap=1*10^6
minBps=5*10^4
maxOpp=1
maxMiss=0

if [ ! -d "$OUTDIR/$species" ]; then
	mkdir -p $OUTDIR/$species
fi

## Thinning
echo "1. Thinning"

## plink commands 
## (option --cow to allow for 60 chromosomes in goats)
## there is no option --goat 
## (sheep has 54 chromosomes, therefore --sheep would not work)

## SELECT ONE OF THE FOLLOWING BY COMMENTING/UNCOMMENTING
## 1) all data are used
#$PLINK --cow --bfile $DATA/${species}_filtered --thin 0.99 --recode --out $OUTDIR/${species}_thin
## 2) below, to simulate SNP arrays with different densities (only chromosome 1 is used)
$PLINK --cow --bfile $DATA/${species}_filtered --thin-count 31215 --recode --out $OUTDIR/${species}_thin


## Configuration file
echo "2. Creating the configuration file"

echo "config = data.frame(" > $OUTDIR/config.R
echo "base_folder = '$OUTDIR'," >> $OUTDIR/config.R
echo "genotypes = '$OUTDIR/${species}_thin.ped'," >> $OUTDIR/config.R
echo "mapfile = '$OUTDIR/${species}_thin.map'," >> $OUTDIR/config.R
echo "minSNP = $minSNP," >> $OUTDIR/config.R
echo "ROHet = FALSE," >> $OUTDIR/config.R
echo "maxGap = $maxGap," >> $OUTDIR/config.R
echo "minLengthBps = $minBps," >> $OUTDIR/config.R
echo "maxOppRun = $maxOpp," >> $OUTDIR/config.R
echo "maxMissRun = $maxMiss," >> $OUTDIR/config.R
echo "species = '$species'," >> $OUTDIR/config.R
echo "force_overwrite = FALSE)" >> $OUTDIR/config.R

## detect RUNS
echo "3. Detecting ROH"
Rscript --vanilla $RSCRIPT $OUTDIR/config.R

## house cleaning
echo "4. Cleaning"
rm $OUTDIR/${species}_thin.log
rm $OUTDIR/${species}_thin.nosex
#rm $OUTDIR/config.R


echo "DONE!"

