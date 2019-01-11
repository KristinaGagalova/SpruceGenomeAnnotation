#!/bin/bash

##########LIBS
export AUGUSTUS_CONFIG_PATH=/path/to/confil/files/config
export PERL5LIB=$PERL5LIB:/path/to/lib/site_perl/5.20.1/Parallel
###requires: faSomeRecords

scripts_augustus=/path/to/augustus.2.5.5
genome=/path/to/genome.fasta
gff_genes=/path/to/genes.gff
nam=GenesMaker

echo "preparing files for Augustus"
perl $scripts_augustus/scripts/gff2gbSmallDNA.pl $gff_genes $genome 100 ${nam}.gb
${scripts_augustus}/bin/etraining --species=spruce17 ${nam}.gb

