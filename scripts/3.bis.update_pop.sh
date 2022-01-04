#!/bin/bash

## script that updates breed/population inforamtion
## the bash scripts calls an R script to create the update.ids file
## then calls Plink to update fam id information in the plink files

# DATA=/home/smarter/hrr_goat_data/goats
DATA=$HOME/Documents/SMARTER/Analysis/filter
# PLINK=$HOME/software/plink/plink
PLINK=$HOME/Downloads/plink
# OUTDIR=$HOME/hrr/Analysis
OUTDIR=$HOME/Documents/SMARTER/Analysis/filter
RSCRIPT=$HOME/Documents/SMARTER/hrr_goats/scripts/update_pop.R

if [ ! -d "$OUTDIR" ]; then
	mkdir $OUTDIR
fi


## Configuration file
echo "1. Creating the configuration file"

echo "config = data.frame(" > $OUTDIR/config.R
echo "base_folder = '~/Documents/SMARTER/Analysis/filter/'," >> $OUTDIR/config.R
echo "fam = '$OUTDIR/goat_filtered.fam'," >> $OUTDIR/config.R
echo "force_overwrite = FALSE)" >> $OUTDIR/config.R

## detect RUNS
echo "2. Creating the file update.ids"
Rscript --vanilla $RSCRIPT $OUTDIR/config.R


## plink commands 
## (option --cow to allow for 60 chromosomes in goats)
## there is no option --goat 
## (sheep has 54 chromosomes, therefore --sheep would not work)

$PLINK --cow --bfile $DATA/goat_filtered --update-ids $DATA/update.ids --make-bed --out $OUTDIR/goat_filtered

## house cleaning
echo "4. Cleaning"
#rm $OUTDIR/goat_thin*
#rm $OUTDIR/config.R

echo "DONE!"

