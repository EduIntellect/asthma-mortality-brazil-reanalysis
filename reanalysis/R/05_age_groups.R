#' Build age-group specific mortality series.
#'
#' `annual_aggregates` is the single-year-age death table built from
#' `df_valid_age` in `load_and_filter_sim_year()` -- i.e. COVID-excluded and
#' valid-age-only, but WITHOUT the idade_quantidade > 6 filter. Ages 5 and 6
#' are therefore already present and correctly counted, satisfying the
#' requirement to "go back to the original SIM data" for the 5-34 group
#' rather than treating it as a subset of the >6-filtered 18-59 group.
build_age_group_series <- function(annual_aggregates, denominators) {
  make_series <- function(age_lo, age_hi, label) {
    d <- annual_aggregates[annual_aggregates$age_floor >= age_lo &
                              annual_aggregates$age_floor <= age_hi, ]
    p <- denominators$by_age[denominators$by_age$age >= age_lo &
                                denominators$by_age$age <= age_hi, ]

    deaths_yr <- stats::aggregate(n_deaths ~ year, data = d, FUN = sum)
    pop_yr <- stats::aggregate(population ~ year, data = p, FUN = sum)

    out <- merge(deaths_yr, pop_yr, by = "year")
    out$rate <- out$n_deaths / out$population * 1e5
    out$series <- label
    out[order(out$year), c("series", "year", "n_deaths", "population", "rate")]
  }

  rbind(
    make_series(5, 34, "age_5_34"),
    make_series(7, 34, "age_7_34_control"),
    make_series(35, 59, "age_35_59")
  )
}
