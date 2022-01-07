#!/bin/bash

#########################
## SET UP
#########################

# DATA=/home/smarter/hrr_goat_data/goats
DATA=$HOME/Documents/SMARTER/Analysis/filter
# PLINK=$HOME/software/plink/plink
PLINK=$HOME/Downloads/plink
# OUTDIR=$HOME/hrr/Analysis
OUTDIR=$HOME/Documents/SMARTER/Analysis/imputation
BEAGLE=~/Documents/software/beagle5/beagle.28Sep18.793.jar


if [ ! -d "$OUTDIR" ]; then
	mkdir $OUTDIR
fi

#########################
## IMPUTATION
#########################

## imputation of missing genotypes

## prepare data
$PLINK --cow --bfile $DATA/goat_filtered --recode vcf --out $OUTDIR/goat_filtered

if [ $BEAGLE = beagle ]; then
	beagle gt=$OUTDIR/goat_filtered.vcf out=$OUTDIR/goat_imputed
else
	java -Xmx4g -jar $BEAGLE gt=$OUTDIR/goat_filtered.vcf out=$OUTDIR/goat_imputed
fi

## convert back to Plink files
$PLINK  --vcf $OUTDIR/goat_imputed.vcf.gz --make-bed --out $OUTDIR/goat_imputed

## house cleaning
echo "4. Cleaning"
rm $OUTDIR/goat_filtered*
rm $OUTDIR/goat_imputed.ped
rm $OUTDIR/goat_imputed.map

echo "DONE!"

