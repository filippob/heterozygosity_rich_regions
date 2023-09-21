#!/bin/bash

## script to filter SNP genotype data for HRR analysis
## (detection of common HRR across commercial and rural goat populations)

# DATA=/home/smarter/hrr_goat_data/goats
DATA=/home/smarter/human_hrr/Analysis/CEU/CEU.vcf.gz
# PLINK=$HOME/software/plink/plink
PLINK=$HOME/software/plink/plink
# OUTDIR=$HOME/hrr/Analysis
OUTDIR=/home/smarter/human_hrr/Analysis/CEU/filter
SPECIES="CEU"
newmap=/home/smarter/human_hrr/Analysis/CEU/new_map
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

echo " - filtering out SNPs with excess missing rate (${GENO} and low frequency ($MAF))"
$PLINK --allow-extra-chr --vcf $DATA --autosome --bp-space 1 --geno $GENO --maf $MAF --make-bed --out $OUTDIR/temp

echo " - filtering out samples with excess missing genotypes (threshold: ${MIND})"
$PLINK --allow-extra-chr --bfile $OUTDIR/temp --autosome --mind $MIND --maf $MAF --update-map $newmap --make-bed --out $OUTDIR/${SPECIES}_autosomes_filtered

## removing temporary file
echo " - removing temporary files"
rm $OUTDIR/temp*

echo "DONE!"

