process filter_diff {
	container "${params.container}"

	input:
	path(moo)
	tuple val(significance_column), val(significance_cutoff), val(change_column), val(change_cutoff), val(filtering_mode), val(include_estimates), val(round_estimates), val(rounding_decimal_for_percent_cells), val(contrast_filter), val(contrasts), val(groups), val(groups_filter), val(label_font_size), val(label_distance), val(y_axis_expansion), val(fill_colors), val(pie_chart_in_3d), val(bar_width), val(draw_bar_border), val(plot_type), val(plot_titles_fontsize)

	output:
	path("moo_filter_diff.rds"), emit: moo
	path("figures/**"), emit: figures, optional: true

	script:
	"""
	#!/usr/bin/env Rscript

	options(moo_save_plots = TRUE)
	library(MOSuite)

	true <- TRUE
	false <- FALSE
	null <- NULL

	include_estimates <- if (stringr::str_detect("$include_estimates", '^null\$')) { NULL } else { stringr::str_split("$include_estimates", ',')[[1]] }
	contrasts <- if (stringr::str_detect("$contrasts", '^null\$')) { NULL } else { stringr::str_split("$contrasts", ',')[[1]] }
	groups <- if (stringr::str_detect("$groups", '^null\$')) { NULL } else { stringr::str_split("$groups", ',')[[1]] }
	fill_colors <- if (stringr::str_detect("$fill_colors", '^null\$')) { NULL } else { stringr::str_split("$fill_colors", ',')[[1]] }

	moo <- readr::read_rds("$moo") |>
		filter_diff(
			significance_column = "$significance_column",
			significance_cutoff = $significance_cutoff,
			change_column = "$change_column",
			change_cutoff = $change_cutoff,
			filtering_mode = "$filtering_mode",
			include_estimates = include_estimates,
			round_estimates = $round_estimates,
			rounding_decimal_for_percent_cells = $rounding_decimal_for_percent_cells,
			contrast_filter = "$contrast_filter",
			contrasts = contrasts,
			groups = groups,
			groups_filter = "$groups_filter",
			label_font_size = $label_font_size,
			label_distance = $label_distance,
			y_axis_expansion = $y_axis_expansion,
			fill_colors = fill_colors,
			pie_chart_in_3d = $pie_chart_in_3d,
			bar_width = $bar_width,
			draw_bar_border = $draw_bar_border,
			plot_type = "$plot_type",
			plot_titles_fontsize = $plot_titles_fontsize
		)

	readr::write_rds(moo, "moo_filter_diff.rds")
	"""
}
