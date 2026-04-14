process FETCH_SRA {
    tag "$sra_id"
    publishDir "${params.outdir}/01_sra", mode: 'copy'

    conda 'bioconda::sra-tools=3.2.1 bioconda::pigz=2.8'

    input:
    val sra_id

    output:
    tuple val(sra_id), path("${sra_id}_1.fastq.gz"), path("${sra_id}_2.fastq.gz"), emit: reads

    script:
    """
    fasterq-dump ${sra_id} --split-files --threads 2
    pigz -p 2 ${sra_id}_1.fastq ${sra_id}_2.fastq
    """
}
