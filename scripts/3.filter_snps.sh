#!/bin/bash

## script to extract SMARTER data for HRR analysis
## (detection of common HRR across commercial and rural goat populations)

DATA=/home/smarter/hrr_goat_data/goats
PLINK=$HOME/software/plink/plink
OUTDIR=$HOME/hrr/Analysis

if [ ! -d "$OUTDIR" ]; then
	mkdir $OUTDIR
fi

## plink commands 
## (option --cow to allow for 60 chromosomes in goats)
## there is no option --goat 
## (sheep has 54 chromosomes, therefore --sheep would not work)
$PLINK --cow --allow-extra-chr --bfile $DATA --chr 1-29 --bp-space 1 --geno 0.05 --mind 0.10 --maf 0.05 --recode --out $OUTDIR/goat_filtered

echo "DONE!"

