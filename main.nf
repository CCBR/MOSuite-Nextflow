
// modules
include { create_multiOmicDataSet_from_files } from './modules/local/mosuite/create_multiOmicDataSet_from_files/'
include { clean_raw_counts } from './modules/local/mosuite/clean_raw_counts/'
include { filter_counts } from './modules/local/mosuite/filter_counts/'
include { normalize_counts } from './modules/local/mosuite/normalize_counts/'
include { batch_correct_counts } from './modules/local/mosuite/batch_correct_counts/'

// plugins
include { validateParameters; paramsSummaryLog } from 'plugin/nf-schema'

// workflow.onComplete {
//     if (!workflow.stubRun && !workflow.commandLine.contains('-preview')) {
//         def message = Utils.spooker(workflow)
//         if (message) {
//             println message
//         }
//     }
// }


workflow LOG {
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

    log.info paramsSummaryLog(workflow)
}


workflow {
    LOG()
    validateParameters()

    ch_input = Channel.fromPath(file(params.samplesheet, checkIfExists: true))
        .combine(Channel.fromPath(file(params.counts, checkIfExists: true)))

    ch_input |
        create_multiOmicDataSet_from_files |
        set{ ch_moo }
    clean_raw_counts(
        ch_moo,
        [ params.aggregate_rows_with_duplicate_gene_names, params.cleanup_column_names, params.split_gene_name, params.gene_name_column_to_use_for_collapsing_duplicates ]
    ).moo.set{ ch_moo }
    filter_counts(
        ch_moo,
        [ params.filter_group_colname, params.filter_label_colname, params.filter_minimum_count_value_to_be_considered_nonzero, params.filter_minimum_number_of_samples_with_nonzero_counts_in_total, params.filter_minimum_number_of_samples_with_nonzero_counts_in_a_group, params.filter_use_cpm_counts, params.filter_use_group_based ]
    ).moo.set{ ch_moo }
    normalize_counts(
        ch_moo,
        [ params.norm_group_colname, params.norm_label_colname, params.norm_input_in_log_counts, params.voom_normalization_method ]
    ).moo.set{ ch_moo }
    batch_correct_counts(
        ch_moo,
        [ params.batch_covariates_colnames, params.batch_colname, params.batch_label_colname, params.batch_colors_for_plots ]
    ).moo.set{ ch_moo }

}
