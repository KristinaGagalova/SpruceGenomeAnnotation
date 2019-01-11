#!/usr/bin/env bash

############################
#####Kristina Gagalova######
############################

#Description: Run EvidentialGene for the selection of complete transcripts

dataset=$1

tr2aacds.pl -mrnaseq $dataset -NCPU=12 -MAXMEM=100000

