process FASTP {
    tag "$sample"
    publishDir "${params.outdir}/02_fastp", mode: 'copy'

    input:
    tuple val(sample), path(r1), path(r2)

    output:
    tuple val(sample), path("${sample}.clean_R1.fastq.gz"), path("${sample}.clean_R2.fastq.gz"), emit: cleaned
    path("${sample}.fastp.html"), emit: html
    path("${sample}.fastp.json"), emit: json

    script:
    """
    fastp \
      --in1 ${r1} \
      --in2 ${r2} \
      --out1 ${sample}.clean_R1.fastq.gz \
      --out2 ${sample}.clean_R2.fastq.gz \
      --thread 2 \
      --html ${sample}.fastp.html \
      --json ${sample}.fastp.json
    """
}
