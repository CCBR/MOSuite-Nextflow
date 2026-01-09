process clean_raw_counts {
    container "${params.container}"

    input:
    path(moo)
    tuple val(aggregate_rows_with_duplicate_gene_names), val(cleanup_column_names), val(split_gene_name), val(gene_column_name_to_use_for_collapsing_duplicates)

    output:
    path("moo_clean.rds"), emit: 'moo'
    path("figures/**"), emit: figures

    script:
    """
    #!/usr/bin/env Rscript

    options(MOO_SAVE_PLOTS = TRUE)
    library(MOSuite)

    true <- TRUE
    false <- FALSE
    null <- NULL

    moo <- readr::read_rds("$moo") |>
        clean_raw_counts(
            aggregate_rows_with_duplicate_gene_names = $aggregate_rows_with_duplicate_gene_names,
            cleanup_column_names = $cleanup_column_names,
            split_gene_name = $split_gene_name
            )

    readr::write_rds(moo, "moo_clean.rds")
    """
}
