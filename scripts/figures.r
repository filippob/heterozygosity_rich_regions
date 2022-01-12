library("ggplot2")
library("tidyverse")
library("data.table")


## plot HRR islands
hrr_islands = fread("Analysis/results/breed_hrr_islands.csv")

tb <- table(hrr_islands$chrom)
hrr_islands$nHRR <- tb[match(hrr_islands$chrom,names(tb))]

p <- ggplot(filter(hrr_islands, nHRR > 1), aes(x = from, y = Group, xend = to*10, yend = Group))
p <- p + geom_segment(aes(size = avg_pct, color = Group))
p <- p + facet_wrap(~chrom) + xlab("position") + ylab("breed")
p <- p + guides(color="none") + theme(axis.text.x = element_text(size = 5),
                                      axis.text.y = element_text(size = 6),
                                      legend.key.size = unit(0.5, 'cm'),
                                      legend.title = element_text(size = 6),
                                      legend.text = element_text(size = 5))
p

ggsave(filename = "figures/hrr_common.png", plot = p, device = "png", dpi = 300, width = 5.5, height = 5.5)

(50477+22696)/1051


## plot SNP in runs
library("detectRUNS")
runs = fread("/home/filippo/Documents/SMARTER/Analysis/hrr/hrr_goats.csv")
pedfile = "/home/filippo/Documents/SMARTER/Analysis/hrr/goat_thin.ped"
mapfile = "/home/filippo/Documents/SMARTER/Analysis/hrr/goat_thin.map"

plot_SnpsInRuns(runs = filter(runs, chrom == 12) %>% mutate(chrom = as.character(chrom)), genotypeFile = pedfile, mapFile = mapfile,
                savePlots = TRUE, outputName = "figures/snps_in_runs_chrom12.pdf")

## plot runs
plot_Runs(runs = filter(runs, chrom == 12) %>% mutate(group = factor(group, levels = c("ALP","BOE","SAA","BRK","CRE","LNR"))), 
          savePlots = TRUE, 
          outputName = "figures/runs.pdf")

