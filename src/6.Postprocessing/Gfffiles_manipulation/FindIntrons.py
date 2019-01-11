#!/usr/bin/env

########################################
########Kristina Gagalova###############
########################################

#Description: given a file containing the exons annoatted as chr, start, stop, transcript name and strand, give the introns.
#The input file needs to be sorted by transcript and exons coordinates (sort -k 5,5 -k 1,1n -k 2,2n -k 3,3n File)
#Example below:
#7	127228399	127228619	ENSG00000004059	ENST00000000233	+
#7	127229137	127229217	ENSG00000004059	ENST00000000233	+
#7	127229539	127229648	ENSG00000004059	ENST00000000233	+
#7	127230120	127230191	ENSG00000004059	ENST00000000233	+
#7	127231017	127231142	ENSG00000004059	ENST00000000233	+
#7	127231267	127231759	ENSG00000004059	ENST00000000233	+
#12	9092961	9094536	ENSG00000003056	ENST00000000412	-
#12	9095012	9095138	ENSG00000003056	ENST00000000412	-
#12	9096001	9096131	ENSG00000003056	ENST00000000412	-
#12	9096397	9096506	ENSG00000003056	ENST00000000412	-
#12	9098014	9098180	ENSG00000003056	ENST00000000412	-
#12	9098825	9099001	ENSG00000003056	ENST00000000412	-
#12	9102084	9102551	ENSG00000003056	ENST00000000412	-

#The script runs in the following way: python FindIntronsEns.py <input_file> <out_file>
#The output is out_file.out which contains the unique introns with ens gene annotation

#Run as:
#python 3.FindIntronsEns.py ExonEnsSorted.tab IntronsEnsDB
#filter output for duplicated entries with bash: awk '$2 > $3 { temp = $3; $3 = $2; $2 = temp } 1' OFS='\t' IntronsEnsDB.out | awk '!seen[$0]++'  > IntronsEnsDB.sort.uniq.out

import sys
import csv

exons = open(sys.argv[1], "r")
output_name = sys.argv[2]

#open writing files
out = open(output_name + ".out", "w")

#initialize variables
transcript = str()
prevStart = int()
prevStop = int()


#print the introns in a tab format
def print_introns(chrom, start, stop, gene, strand):
	st = {"+": "1", "-":"2"}
	return str(chrom) + "\t" + str(int(stop) + 1) + "\t" + str(int(start) - 1) + "\t" + st.get(strand, 0) + "\t" + gene + "\n"

##process each line from the exon file
for exon in exons:
	
	feat = exon.rstrip().split("\t")
	
	#if the coordinate belong to the same transcript, print it to the file
	if transcript == feat[4]:

		out.write(print_introns(feat[0], feat[1], prevStop, feat[4], feat[5])) #prints transcript annotation
					
		
	#if new transcript, reset the variables	
	else:

		prevStart = int()
		prevStop = int()	
		transcript = feat[4]
	
	#assign variables from previous coordinate
	prevStart = feat[1] 
	prevStop = feat[2]

#close files
exons.close()
out.close()
