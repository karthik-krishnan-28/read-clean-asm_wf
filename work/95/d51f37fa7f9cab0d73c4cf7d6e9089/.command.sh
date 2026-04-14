#!/bin/bash -ue
fastp       --in1 SRR28760303_1.fastq.gz       --in2 SRR28760303_2.fastq.gz       --out1 PA01.clean_R1.fastq.gz       --out2 PA01.clean_R2.fastq.gz       --thread 2       --html PA01.fastp.html       --json PA01.fastp.json
