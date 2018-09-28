library(tidyverse)

counts <- read_table2('/OSM/CBR/NRCA_FINCHGENOM/analysis/2016-09-21_telomere/subsamples/telomere_counts.txt', 
                     col_names=c('File','kmer','count'))
counts <- separate(counts, File, sep = '.subset.', into = c('name','reads'), convert = TRUE)

counts <- mutate(counts, scaled= count/reads)
ggplot(data = counts, aes(x=reads, y=scaled, group=name, col=name)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(trans='log10') +
  ylab('scaled telo-mer') +
  theme(legend.position='none')

  
