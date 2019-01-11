#!/usr/bin/env bash

fasta_batch=/path/to/list/fasta/files

while read fasta
do
	nam=$(echo $fasta | rev | cut -d/ -f1 | rev | cut -f1 -d. )
	mkdir -p $nam && cd $nam
	cp -p ../maker_exe.ctl ./ && cp -p ../maker_opts.ctl ./ && cp -p ../maker_bopts.ctl ./ && cp -r ../RunMaker.sh ./
	sed -i -e "s#_RePlaCe_#${fasta}#g" maker_opts.ctl
	sed -i -e "s#_RePlaCeNam_#${nam}#g" RunMaker.sh
	sbatch ./RunMaker.sh
	echo $nam
	cd ..

done < $fasta_batch
