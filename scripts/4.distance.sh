#!/bin/bash

## script to calculate SNP-based distances between samples (breeds)

# DATA=/home/smarter/hrr_goat_data/goats
DATA=$HOME/Documents/SMARTER/Analysis/filter
# PLINK=$HOME/software/plink/plink
PLINK=$HOME/Downloads/plink
# OUTDIR=$HOME/hrr/Analysis
OUTDIR=$HOME/Documents/SMARTER/Analysis/distance

if [ ! -d "$OUTDIR" ]; then
	mkdir $OUTDIR
fi

## plink commands 
## (option --cow to allow for 60 chromosomes in goats)
## there is no option --goat 
## (sheep has 54 chromosomes, therefore --sheep would not work)
$PLINK --cow --file $DATA/goat_filtered --distance square 1-ibs --out $OUTDIR/goat_filtered

echo "DONE!"

