process normalize_counts {
    container "${params.container}"

    input:
    path(moo)
    tuple val(group_colname), val(label_colname), val(input_in_log_counts), val(voom_normalization_method)

    output:
    path("moo_norm.rds"), emit: moo
    path("figures/**"), emit: figures, optional: true

    script:
    """
    #!/usr/bin/env Rscript

    options(moo_save_plots = TRUE)
    library(MOSuite)

    true <- TRUE
    false <- FALSE
    null <- NULL

    label_colname <- if (stringr::str_detect("$label_colname", '^null\$')) { NULL } else { "$label_colname" }

    moo <- readr::read_rds("$moo") |>
        normalize_counts(
            group_colname = "$group_colname",
            label_colname = label_colname,
            input_in_log_counts = $input_in_log_counts,
            voom_normalization_method = "$voom_normalization_method"
            )

    readr::write_rds(moo, "moo_norm.rds")
    """
}
