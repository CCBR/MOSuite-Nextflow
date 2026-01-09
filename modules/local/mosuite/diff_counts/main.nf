process diff_counts {
	container "${params.container}"

	input:
	path(moo)
	tuple val(covariates_colnames), val(contrast_colname), val(contrasts), val(input_in_log_counts), val(return_mean_and_sd), val(voom_normalization_method)

	output:
	path("moo_diff.rds"), emit: moo
	path("figures/**"), emit: figures, optional: true

	script:
	"""
	#!/usr/bin/env Rscript

	options(moo_save_plots = TRUE)
	library(MOSuite)

	true <- TRUE
	false <- FALSE
	null <- NULL

	covariates_colnames <- if (stringr::str_detect("$covariates_colnames", '^null\$')) { NULL } else { stringr::str_split("$covariates_colnames", ',')[[1]] }
	contrast_colname <- if (stringr::str_detect("$contrast_colname", '^null\$')) { NULL } else { stringr::str_split("$contrast_colname", ',')[[1]] }
	contrasts <- if (stringr::str_detect("$contrasts", '^null\$')) { NULL } else { stringr::str_split("$contrasts", ',')[[1]] }

	moo <- readr::read_rds("$moo") |>
		diff_counts(
			covariates_colnames = covariates_colnames,
			contrast_colname = contrast_colname,
			contrasts = contrasts,
			input_in_log_counts = $input_in_log_counts,
			return_mean_and_sd = $return_mean_and_sd,
			voom_normalization_method = "$voom_normalization_method"
		)

	readr::write_rds(moo, "moo_diff.rds")
	"""
}
