#!/bin/bash

## script to extract SMARTER data for HRR analysis
## (detection of common HRR across commercial and rural goat populations)

DATA=/home/smarter/sequencing/Abergelle_goats.vcf.gz
DATA=/home/smarter/sequencing/Merino-output_chr1.snp.filtered.vcf.gz
PLINK=/home/biscarinif/software/plink/plink
CHROMS=1
OUTDIR=/home/smarter/runs_from_sequences/1.2.extract

if [ ! -d $OUTDIR ]; then
	echo "creating folder $OUTDIR"
	mkdir -p $OUTDIR
fi

echo "extracting chromosomes from source files"
#$PLINK --sheep --bfile $DATA --keep $IDS --recode --out goats
$PLINK --cow --allow-extra-chr --vcf $DATA --chr $CHROMS --make-bed --out $OUTDIR/sheep_chrom$CHROMS

rm $OUTDIR/*.nosex

echo "DONE!"

