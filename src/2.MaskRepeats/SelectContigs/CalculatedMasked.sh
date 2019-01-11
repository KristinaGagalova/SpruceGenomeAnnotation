#!/bin/bash

#############################
#####Kristina Gagalova#######
#############################
########12 April 2018########
#############################

#Description: use the gff annoatation to calculate the number of bp repeats and output statistics per contig  
#Output: Contig_number	Totbp_contig	Bp_repeats	Bp_gaps	

#Requires: bedtools

lista=list_allDemo

while read line
do
fasta=$(echo $line | cut -d" " -f1)
gff=$(echo $line | cut -d" " -f2)
nam=$(echo $fasta | rev | cut -d"/" -f1 | rev)
echo $fasta
#mask repeats with X
bedtools maskfasta -fi $fasta -bed $gff -fo file.tmp -mc X
#tmp files
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < file.tmp | sed '/^$/d' | grep -v ">" > ${nam}.tmp
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < file.tmp | sed '/^$/d' | grep ">" | sed 's/>//g' > ${nam}.fastaheaders.tmp
awk '{ print length($0); }' ${nam}.tmp > lengths.tmp
tr -d -c 'X\n' < ${nam}.tmp | awk '{ print length; }' > ${nam}X.tmp
tr -d -c 'N\n' < ${nam}.tmp | awk '{ print length; }' > ${nam}N.tmp
#final file output
paste ${nam}.fastaheaders.tmp lengths.tmp ${nam}X.tmp ${nam}N.tmp > $nam
done < $lista

rm *tmp
