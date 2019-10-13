# Post processing steps

## Renaming and preparation

### Functional annotation
1. Run InterProScan and annotate functional domains. Follow point 3 for sequences cleaning.
2. Blast against a well annotatated database. This can be SwissProt plant. Keep hits with e-value < 1e-5. Keep the best alignment hits based on the length of the alignment (query)

### Viral sequences removal
2. Run InterProScan and annotate functional domains. Exclude all the GENES (not only transcripts) that contain a Pfam domain from viral origin. I have prepared a Pfam blacklist that I did not want to include in the annotation. Despite repeats filters it is still likely that some viral sequences are annotated.
3. Remove all the genes in the gff and fasta files. Do the same on the InterProScan annotations

### Renaming
4. Change names of MAKER annotated sequences

## Filtering

1. Select sequences that are annotated with either a Pfam domain (no-viral) or Blast hit
2. Run GAG and keep the transcripts with gene length > 1000 bp and introns > 10 bp
3. Remove the transcripts that have their five or tree prime closer to the end of a scaffold (500 bp)
