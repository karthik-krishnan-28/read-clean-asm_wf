nextflow.enable.dsl = 2

include { FASTP }        from './modules/fastp'
include { SKESA }        from './modules/skesa'
include { SEQKIT_STATS } from './modules/seqkit_stats'

workflow {

    Channel
        .fromPath(params.input, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            tuple(
                row.sample,
                file(row.r1, checkIfExists: true),
                file(row.r2, checkIfExists: true)
            )
        }
        .set { reads_ch }

    FASTP(reads_ch)

    cleaned_reads_ch = FASTP.out.cleaned

    SKESA(cleaned_reads_ch)
    SEQKIT_STATS(cleaned_reads_ch)
}