nextflow.enable.dsl = 2

include { FETCH_SRA }     from './modules/fetch_sra'
include { FASTP }         from './modules/fastp'
include { SKESA }         from './modules/skesa'
include { SEQKIT_STATS }  from './modules/seqkit_stats'

params.input   = params.input ?: null
params.sra_ids = params.sra_ids ?: null
params.outdir  = params.outdir ?: 'results'

workflow {

    Channel.empty().set { reads_ch }

    if ( params.sra_ids ) {
        Channel
            .from( params.sra_ids.tokenize(',') )
            .map { it.trim() }
            .filter { it }
            .set { sra_ch }

        FETCH_SRA(sra_ch)
        reads_ch = FETCH_SRA.out.reads

    } else if ( params.input ) {
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

    } else {
        error "Provide either --sra_ids 'SRRXXXXXX,SRRYYYYYY' or --input assets/test_samplesheet.csv"
    }

    FASTP(reads_ch)

    cleaned_reads_ch = FASTP.out.cleaned

    SKESA(cleaned_reads_ch)
    SEQKIT_STATS(cleaned_reads_ch)
}
