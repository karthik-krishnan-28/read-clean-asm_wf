#!/bin/bash -ue
seqkit stats -a PA01.clean_R1.fastq.gz PA01.clean_R2.fastq.gz > PA01.seqkit.stats.txt
