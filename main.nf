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

    ch_input | create_multiOmicDataSet_from_files
}
