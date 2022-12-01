#!/bin/bash

## script to calculate basic descriptive statistics for HRR analysis
## (detection of common HRR across commercial and rural goat populations)

DATA=/home/smarter/hrr_parameters/data/select_sheep_lacaune_SMARTEROAR-top-0.4.7dev_only50
PLINK=/home/biscarinif//software/plink/plink
OUTDIR=/home/smarter/hrr_parameters/Analysis
SPECIES="sheep"

if [ ! -d "$OUTDIR" ]; then
	mkdir $OUTDIR
fi

## plink commands 
## (option --cow to allow for 60 chromosomes in goats)
## there is no option --goat 
## (sheep has 54 chromosomes, therefore --sheep would not work)
$PLINK --cow --allow-extra-chr --bfile $DATA --missing --family --out $OUTDIR/$SPECIES
$PLINK --cow --allow-extra-chr --bfile $DATA --freq --family --out $OUTDIR/$SPECIES

echo "DONE!"

