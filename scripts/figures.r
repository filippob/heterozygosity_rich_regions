library("ggplot2")
library("tidyverse")
library("data.table")

hrr_islands = fread("Analysis/results/breed_hrr_islands.csv")

tb <- table(hrr_islands$chrom)
hrr_islands$nHRR <- tb[match(hrr_islands$chrom,names(tb))]

p <- ggplot(filter(hrr_islands, nHRR > 1), aes(x = from, y = Group, xend = to*10, yend = Group))
p <- p + geom_segment(aes(size = avg_pct, color = Group))
p <- p + facet_wrap(~chrom) + xlab("start position") + ylab("breed")
p <- p + guides(color="none") + theme(axis.text.x = element_text(size = 5),
                                      axis.text.y = element_text(size = 6),
                                      legend.key.size = unit(0.5, 'cm'),
                                      legend.title = element_text(size = 6),
                                      legend.text = element_text(size = 5))
p

ggsave(filename = "figures/hrr_common.png", plot = p, device = "png", dpi = 300, width = 5.5, height = 5.5)
