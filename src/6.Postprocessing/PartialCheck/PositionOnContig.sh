#!/bin/bash

##########################################
#########Kristina Gagalova################
##########################################
############4 Dec 2018####################
##########################################


#------------------------------------------------------------
# Usage
#------------------------------------------------------------

PROGRAM=$(basename $0)
read -r -d '' USAGE <<HEREDOC
Usage: $PROGRAM <gff3_file> <contigs_len> 

Description:

Given a gff file with the mRNA coordinates and a tab file with contig name and contig len, give the number of bases upstream the start and downstream the end of the mRNA coordinates.
output is the following

<name_mRNA><name_contig><length_contig><bp_upstream_gene><bp_downstream_gene><strand>

HEREDOC

# we expect 2 file arguments
if [ $# -lt 2  ]; then
    echo "Error: number of file args must be  2" >&2
	echo "$USAGE" >&2
	exit 1
fi

gff_file=$1; shift;
len_fasta=$1; shift;

awk '$3 == "mRNA" {print $0}' $gff_file > mRNA.gff
if [ ! -s mRNA.gff ]
then
	echo "Your gff file does not contain mRNA coordinates. Stopping execution"
	exit 0
fi

awk '{print $9}' mRNA.gff | cut -d";" -f1 | sed 's/ID=//' > nams.in
paste -d'\t' mRNA.gff nams.in > mRNA.tmp

LANG=en_EN
join -1 1 -2 1 -e NA -a 1 <(sort -k1,1 mRNA.tmp) <(sort -k1,1 $len_fasta) | tr ' ' '\t' > length.mRNA.gff

awk -v OFS='\t' '{print $10,$1,$11,$4,$11-$5,$7}' length.mRNA.gff > length.mRNA.tmp
awk -v OFS='\t' ' $6 == "-" { temp = $5; $5 = $4; $4 = temp } 1' length.mRNA.tmp > length.mRNA.out

rm *tmp mRNA.gff nams.in length.mRNA.gff
