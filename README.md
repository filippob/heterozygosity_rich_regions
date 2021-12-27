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
