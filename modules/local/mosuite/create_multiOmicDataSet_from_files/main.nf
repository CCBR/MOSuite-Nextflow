process create_multiOmicDataSet_from_files {
    container "${params.container}"

    input:
    tuple path(samplesheet), path(counts)

    output:
    path("moo*.rds"), emit: moo

    script:
    """
    #!/usr/bin/env Rscript

    library(MOSuite)
    moo <- create_multiOmicDataSet_from_files(
        sample_meta_filepath = "$samplesheet",
        feature_counts_filepath = "$counts"
    )
    readr::write_rds(moo, "moo.rds")
    """
}
