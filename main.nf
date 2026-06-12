#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Load subworkflow
include { summarize_controls } from './subworkflows/summarize_controls.nf'

// Define input channels
cohorts_ch = Channel.fromPath(params.cohorts)
    | splitCsv(header: true, sep: ',')
    | map { row -> [
        row.cohort, row.key,
        file(row.file), file(row.index)
    ] }

// 'Pathogenic,Damaging,Splicing,High,PTV,Stop,Rare'
category_ch = Channel.of(params.categories.split(','))

// Run the main workflow
workflow  {
    summarize_controls( 
        cohorts_ch,
        category_ch
    )

    // summary
    //     | filter { it[3] != 'snplist' && it[3] != 'rlist'}
    //     | collectFile (
    //         keepHeader: true,
    //         storeDir: "${params.output_dir}/summary",
    //     )
    //     { it -> [ "${it[0]}.${it[2]}.${it[3]}.tsv", it[4] ] }
}
