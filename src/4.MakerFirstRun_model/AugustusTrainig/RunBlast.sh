#!/usr/bin/env bash

########################################
#########Kristina Gagalova##############
############Feb 03 2017#################
########################################

# Description: given a fasta file with nucleotide sequences, blast all against all
# BLAST documentation: https://www.ncbi.nlm.nih.gov/books/NBK279675/

#############################################################
#------------------------------------------------------------
#blast program version
BLAST=/path/to/blast

#seq file that need to be blasted
SEQS=$1

#out names
BASE_OUT=augustus
OUT_DB=$BASE_OUT.db
BLAST_OUT=$BASE_OUT.allvsall.tsv

##############################################################
#     Program here
##############################################################

#-------------------------------------------------------------
#create DB from the file
#-------------------------------------------------------------

$BLAST/makeblastdb -in $SEQS -dbtype nucl -out $OUT_DB > logDB

#-------------------------------------------------------------
#blast sequences with BLASTN
#-------------------------------------------------------------

$BLAST/tblastx -db $OUT_DB -query $SEQS -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovs qcovhsp' -out $BLAST_OUT -num_threads 4
 
rm *nhr *nin *nsq logDB
gzip *.allvsall.tsv

