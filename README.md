# heterozygosity_rich_regions

## HRR in goats

- AdaptMap data (background): select commercial and marginal (likely not subjected to intense artificial selection, but also free of major demographic events like bottlenecks) 
- ideally with sample size > 50
- identify common HRR (across selected commercial populations and marginal naive populations)
- likely regions that are conserved irrespective of selection pressure  --> regions conserved in *C. hircus* and that may have a biological function
- fix the parameters for the identification of HRR (may be tweaked) and explore the effect of imputing missing SNP genotypes
- sex chromosomes? (currently, sex info only on 40% of samples --> exclude sex chromosomes for the moment()
- filtering data prior to detectRUNS? MAF (no problems here with monomorphic sites, we are looking for HRR!), missing-rate (standard criteria should suffice):
  -  MAF > 0.05 (within population), missing rate < 0.10 (per sample) < 0.05 (per locus)
- use only one set of parameters (density, minimum run length, n. of homozygous SNPs etc.) for HRR "detection" (ideally to be gauged on one or more immunity-related loci)
- define metrics to evaluate the "accuracy" of detected HRR
- later, extend the analysis to other species (e.g. humans)

## workflow
1. 1.extract_data.sh: script to extract relevant data from the SMARTER goat database
2. 2.descriptove_stats.sh [OPTIONAL]
3. 3.filter_snps.sh: script to filter SNP data based on MAF and call-rate
4. script 3.1.update_pop.sh [OPTIONAL]: script to update population information in the Plink files
5. script 3.2.imputation.sh: script to impute (if needed/wanted) missing SNP genotypes (Beagle inside)
6. 4.distance.sh [OPTIONAL]: script to calculate IBS genetic distances between samples
7. 5.detect_hrr.sh: script to detect HRRs (detectRUNS inside)
8. parse_results.R: script to parse results and produce output tables and plots
