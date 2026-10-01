#' Fit pre-specified trend models for each series.
#'
#' `series_table` is long format: series, year, n_deaths, rate (one row per
#' series x year). `glm_series` names the series fit with
#' glm(rate ~ year, family = gaussian) (replicating the original national
#' model); every other series is fit with lm(rate ~ year), as in the
#' original age-group analysis. Returns one row per series x year with the
#' year-level n_deaths/rate plus the series-level slope, 95% CI and p-value
#' (repeated across that series' rows) and the percent change relative to
#' the first year, matching `primary_results.csv`.
fit_trend_models <- function(series_table, glm_series = character(0)) {
  series_table <- series_table[order(series_table$series, series_table$year), ]

  out <- lapply(split(series_table, series_table$series), function(s) {
    use_glm <- unique(s$series) %in% glm_series

    if (use_glm) {
      fit <- stats::glm(rate ~ year, data = s, family = stats::gaussian())
    } else {
      fit <- stats::lm(rate ~ year, data = s)
    }

    co <- stats::coef(summary(fit))
    # Wald/t-based CI computed directly from the coefficient table to avoid
    # a MASS dependency (MASS::confint.glm is unavailable for this R
    # version); for a gaussian-family glm this is numerically equivalent
    # to profile-likelihood confint(), since gaussian GLM = OLS.
    df_resid <- stats::df.residual(fit)
    tcrit <- stats::qt(0.975, df_resid)

    slope <- co["year", "Estimate"]
    se_slope <- co["year", "Std. Error"]
    p_value <- co["year", ncol(co)]
    ci_low <- slope - tcrit * se_slope
    ci_high <- slope + tcrit * se_slope

    first_rate <- s$rate[which.min(s$year)]
    s$pct_change <- (s$rate - first_rate) / first_rate * 100
    s$slope <- slope
    s$ci_low <- ci_low
    s$ci_high <- ci_high
    s$p_value <- p_value
    s
  })

  res <- do.call(rbind, out)
  res <- res[, c("series", "year", "n_deaths", "rate", "pct_change",
                 "slope", "ci_low", "ci_high", "p_value")]
  rownames(res) <- NULL
  res
}
