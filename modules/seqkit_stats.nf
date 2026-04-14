process SEQKIT_STATS {
    tag "$sample"
    publishDir "${params.outdir}/04_seqkit", mode: 'copy'

    input:
    tuple val(sample), path(r1), path(r2)

    output:
    path("${sample}.seqkit.stats.txt")

    script:
    """
    seqkit stats -a ${r1} ${r2} > ${sample}.seqkit.stats.txt
    """
}
