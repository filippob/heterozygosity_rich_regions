#!/bin/bash

## script to filter SNP genotype data for HRR analysis
## (detection of common HRR across commercial and rural goat populations)

# DATA=/home/smarter/hrr_goat_data/goats
DATA=$HOME/Documents/SMARTER/Analysis/goats
# PLINK=$HOME/software/plink/plink
PLINK=$HOME/Downloads/plink
# OUTDIR=$HOME/hrr/Analysis
OUTDIR=$HOME/Documents/SMARTER/Analysis/filter

if [ ! -d "$OUTDIR" ]; then
	mkdir $OUTDIR
fi

## plink commands 
## (option --cow to allow for 60 chromosomes in goats)
## there is no option --goat 
## (sheep has 54 chromosomes, therefore --sheep would not work)
$PLINK --cow --allow-extra-chr --bfile $DATA --chr 1-29 --bp-space 1 --geno 0.05 --mind 0.10 --maf 0.05 --make-bed --out $OUTDIR/goat_filtered

echo "DONE!"

