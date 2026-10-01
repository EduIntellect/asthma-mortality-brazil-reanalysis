#' Load and pre-filter one SIM mortality year.
load_and_filter_sim_year <- function(input_path,
                                     year,
                                     col_select = NULL) {
  # TODO: Load one SIM DBC/CSV year with col_select.
  # TODO: Filter CID-10 J45/J46 immediately after loading.
  # TODO: Apply original COVID-related exclusions on LINHAA-D and LINHAII.
  # TODO: Derive age as (dtobito - dtnasc) / 365.25.
  # TODO: Apply idade_quantidade > 6 filter.
}
