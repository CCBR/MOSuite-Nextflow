log.info """\
MOSuite-nxf $workflow.manifest.version
=============
NF version   : $nextflow.version
runName      : $workflow.runName
username     : $workflow.userName
configs      : $workflow.configFiles
profile      : $workflow.profile
cmd line     : $workflow.commandLine
start time   : $workflow.start
projectDir   : $workflow.projectDir
launchDir    : $workflow.launchDir
workDir      : $workflow.workDir
homeDir      : $workflow.homeDir
samplesheet  : ${params.samplesheet}
counts       : ${params.counts}
"""
.stripIndent()

include { create_multiOmicDataSet_from_files } from './modules/local/mosuite/create_multiOmicDataSet_from_files/'
include { clean_raw_counts } from './modules/local/mosuite/clean_raw_counts/'

// workflow.onComplete {
//     if (!workflow.stubRun && !workflow.commandLine.contains('-preview')) {
//         def message = Utils.spooker(workflow)
//         if (message) {
//             println message
//         }
//     }
// }

workflow {
    ch_input = Channel.fromPath(file(params.samplesheet, checkIfExists: true))
        .combine(Channel.fromPath(file(params.counts, checkIfExists: true)))

    ch_moo = ch_input |
        create_multiOmicDataSet_from_files
    clean_raw_counts(ch_moo, [ params.aggregate_rows_with_duplicate_gene_names, params.cleanup_column_names, params.split_gene_name, params.gene_name_column_to_use_for_collapsing_duplicates ])
}
