#!/bin/bash

## script to filter SNP genotype data for HRR analysis
## (detection of common HRR across commercial and rural goat populations)

# DATA=/home/smarter/hrr_goat_data/goats
DATA=/home/smarter/hrr_parameters/data/select_sheep_lacaune_SMARTEROAR-top-0.4.7dev_only50
# PLINK=$HOME/software/plink/plink
PLINK=$HOME/software/plink/plink
# OUTDIR=$HOME/hrr/Analysis
OUTDIR=/home/smarter/hrr_parameters/Analysis/filter
SPECIES="sheep"
MAF=0.05
GENO=0.05
MIND=0.10

if [ ! -d "$OUTDIR" ]; then
	mkdir $OUTDIR
fi

## plink commands 
## (option --cow to allow for 60 chromosomes in goats)
## there is no option --goat 
## (sheep has 54 chromosomes, therefore --sheep would not work)
$PLINK --sheep --allow-extra-chr --bfile $DATA --chr 1-26 --bp-space 1 --geno $GENO --mind $MIND --maf $MAF --make-bed --out $OUTDIR/${SPECIES}_filtered

echo "DONE!"

