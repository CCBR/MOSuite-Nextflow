process batch_correct_counts {
	container "${params.container}"

	input:
	path(moo)
	tuple val(covariates_colnames), val(batch_colname), val(label_colname), val(colors_for_plots)

	output:
	path("moo_batch.rds"), emit: moo
	path("figures/**"), emit: figures, optional: true

	script:
	"""
	#!/usr/bin/env Rscript
    rlang::global_entrace()
	options(moo_save_plots = TRUE)
	library(MOSuite)

	true <- TRUE
	false <- FALSE
	null <- NULL

	covariates_colnames <- if (stringr::str_detect("$covariates_colnames", '^null\$')) { NULL } else { stringr::str_split("$covariates_colnames", ',')[[1]] }
	label_colname <- if (stringr::str_detect("$label_colname", '^null\$')) { NULL } else { "$label_colname" }

	moo <- readr::read_rds("$moo") |>
		batch_correct_counts(
			covariates_colnames = covariates_colnames,
			batch_colname = "$batch_colname",
			label_colname = label_colname,
			colors_for_plots = $colors_for_plots,
		)

	readr::write_rds(moo, "moo_batch.rds")
	"""
}
