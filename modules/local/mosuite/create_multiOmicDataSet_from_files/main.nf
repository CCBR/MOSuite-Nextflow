process create_multiOmicDataset_from_files {
    container "${params.container}"

    input:
    tuple path(samplesheet), path(counts)

    output:
    path("moo*.rds")

    script:
    """
    #!/usr/bin/env Rscript

    library(MOSuite)
    moo <- create_multiOmicDataset_from_files(
        sample_metadata_filepath = "$samplesheet",
        feature_counts_filepath = "$counts"
    )
    readr::write_rds(moo, "moo.rds")
    """
}
