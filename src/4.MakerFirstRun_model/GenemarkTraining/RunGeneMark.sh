#!/bin/bash

##########LIBS

genome=/path/to/the/genome/assembly/genome.fasta
genemark=/path/to/gmes_petap/gmes_petap.pl

perl $genemark --cores 32 --ES --sequence $genome

