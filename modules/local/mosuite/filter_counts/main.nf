process filter_counts {
    container "${params.container}"

    input:
    path(moo)
    tuple val(group_colname), val(label_colname), val(minimum_count_value_to_be_considered_nonzero), val(minimum_number_of_samples_with_nonzero_counts_in_total), val(minimum_number_of_samples_with_nonzero_counts_in_a_group), val(use_cpm_counts_to_filter), val(use_group_based_filtering)

    output:
    path("moo_filter.rds"), emit: moo
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
        filter_counts(
            group_colname = "$group_colname",
            label_colname = label_colname,
            minimum_count_value_to_be_considered_nonzero = $minimum_count_value_to_be_considered_nonzero,
            minimum_number_of_samples_with_nonzero_counts_in_total = $minimum_number_of_samples_with_nonzero_counts_in_total,
            minimum_number_of_samples_with_nonzero_counts_in_a_group = $minimum_number_of_samples_with_nonzero_counts_in_a_group,
            use_cpm_counts_to_filter = $use_cpm_counts_to_filter,
            use_group_based_filtering = $use_group_based_filtering
        )

    readr::write_rds(moo, "moo_filter.rds")
    """
}
