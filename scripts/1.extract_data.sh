#!/bin/bash

## script to extract SMARTER data for HRR analysis
## (detection of common HRR across commercial and rural goat populations)

DATA=~/Documents/SMARTER/FTP/SMARTER-CH-ARS1-top-0.4.2
PLINK=/home/filippo/Downloads/plink
IDS=~/Documents/SMARTER/Config/goat_data_for_hrr
OUTDIR=~/Documents/SMARTER/Analysis

#$PLINK --sheep --bfile $DATA --keep $IDS --recode --out goats
$PLINK --cow --allow-extra-chr --bfile $DATA --keep $IDS --make-bed --out $OUTDIR/goats


echo "DONE!"

