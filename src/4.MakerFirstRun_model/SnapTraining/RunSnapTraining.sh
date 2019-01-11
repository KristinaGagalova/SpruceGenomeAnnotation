#!/usr/bin/env bash

########################################
#########Kristina Gagalova##############
############Sept## 2017#################
########################################

#gff file containing sequences and coordinates from previous Maker Run
gff_ann=/path/to/gff/predicted/genes.gff

/path/to/maker/2.31.9/libexec/bin/maker2zff $gff_ann

fathom -categorize 1000 genome.ann genome.dna
fathom -export 1000 -plus uni.ann uni.dna
forge export.ann export.dna
hmm-assembler.pl pyu . > step2maker.hmm
