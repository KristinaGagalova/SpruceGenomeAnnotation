#!/usr/bin/env bash

#Description: run GeneValidator on batches of proteins

fasta=/path/to/fasta/annotated/proteins
blast_db=/path/to/blast/db

genevalidator -d $blast_db -n 24 -b /path/to/blast -b /path/to/bin $fasta
