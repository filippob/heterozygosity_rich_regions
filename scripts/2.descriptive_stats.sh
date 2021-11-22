#!/bin/bash

## script to extract SMARTER data for HRR analysis
## (detection of common HRR across commercial and rural goat populations)

DATA=~/Documents/SMARTER/Analysis/goats
PLINK=/home/filippo/Downloads/plink
OUTDIR=~/Documents/SMARTER/Analysis/stats

if [ ! -d "$OUTDIR" ]; then
	mkdir $OUTDIR
fi

## plink commands
$PLINK --cow --allow-extra-chr --bfile $DATA --missing --family --out $OUTDIR/goats
$PLINK --cow --allow-extra-chr --bfile $DATA --freq --family --out $OUTDIR/goats

echo "DONE!"
