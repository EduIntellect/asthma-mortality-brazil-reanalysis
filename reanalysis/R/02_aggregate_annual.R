#' Aggregate one year into compact annual outputs.
#'
#' Takes the `by_age` single-year-age table produced by
#' `load_and_filter_sim_year()` (already COVID-excluded, valid-age-only,
#' ages 0-90+) and writes/accumulates it. The caller is responsible for
#' dropping the per-year raw data frames and calling `gc()` between years;
#' this function only ever touches the small aggregated table.
aggregate_annual_deaths <- function(filtered_year_data,
                                    year,
                                    output_path) {
  by_age <- filtered_year_data$by_age

  if (!is.null(output_path)) {
    utils::write.csv(by_age, output_path, row.names = FALSE)
  }

  by_age
}
