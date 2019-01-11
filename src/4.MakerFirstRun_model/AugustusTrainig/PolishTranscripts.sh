#!/bin/bash

###requires: bedtools, faSomeRecords, RunBlast.sh

gff_orig=/path/to/alignments.gff
fasta=/path/to/fasta

#select only complete
paste <(awk '$3 == "mRNA" {print $0}' $gff_orig) <(awk '$3 == "mRNA" {print $9}' $gff_orig | awk -F "coverage=" '{print $2}' | cut -d";" -f1) <(awk '$3 == "mRNA" {print $9}' $gff_orig | awk -F "identity=" '{print $2}' | cut -d";" -f1)  <(awk '$3 == "mRNA" {print $9}' $gff_orig | awk -F "Name=" '{print $2}' | cut -d";" -f1) > alignGCATFinalCovIdent.tmp
############################################################
#get only the complete transcripts to train
#use 95% cov && ident
###########################################################
awk '$10 >= 95 && $11 >= 95 {print $0}' alignGCATFinalCovIdent.tmp > alignGCATFinalCovIdentCompl.tmp
awk '{print $12}' alignGCATFinalCovIdentCompl.tmp | sort | uniq > list_GCAT.in
echo "selecting transcripts"
while read line; do grep "$line" $gff_orig; done < list_GCAT.in > alignGCATCompl.gff
rm *tmp list_GCAT.in

#merge intervals
#echo "checking for non-verlapping intervals"
awk '$3 == "mRNA" {print $0}' alignGCATCompl.gff | sort -k1,1 -k4,4n > alignGCATComplmRNA.tmp
bedtools intersect -a alignGCATComplmRNA.tmp -b alignGCATComplmRNA.tmp -wao | awk '$9 != $18 {print $9}' | awk -F "Name=" '{print $2}' | cut -d";" -f1 | sort | uniq > ToRem.in
faSomeRecords -exclude $fasta ToRem.in ToBlast.fa
rm *tmp

#remove redundant peptides, 6 frames translated
echo "removing redundant"
bash ./RunBlast.sh ToBlast.fa
#Exclude similar transcripts/peptides
awk '$1 != $2 {print $0}' *.allvsall.tsv | awk '$3 > 70 && $13 > 50 {print $2}' | sort | uniq > ToRemBlast.in
faSomeRecords -exclude ToBlast.fa ToRemBlast.in NoRedundant.tmp
grep ">" NoRedundant.tmp | sed 's/>//' > ToKeep.in
rm *tmp

echo "selecting gff intervals"
while read line; do grep $line alignGCATCompl.gff; done < ToKeep.in > alignGCATComplPolished.gff

rm ToRem.in ToBlast.fa ToRemBlast.in

#############after testing Augustus remove sequences that are not complete (augustus will output warnings) 
while read line; do grep $line alignGCATCompl.gff; done < ToKeep_secondIt.in > alignGCATComplPolished2.gff
