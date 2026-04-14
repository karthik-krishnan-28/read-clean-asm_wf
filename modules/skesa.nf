process SKESA {
    tag "$sample"
    publishDir "${params.outdir}/03_skesa", mode: 'copy'

    conda 'bioconda::skesa=2.5.1'

    input:
    tuple val(sample), path(r1), path(r2)

    output:
    path("${sample}.skesa.fasta")

    script:
    """
    skesa \
      --reads ${r1},${r2} \
      --cores 2 \
      --vector_percent 1 \
      > ${sample}.skesa.fasta
    """
}
