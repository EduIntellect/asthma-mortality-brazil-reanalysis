#' Robustness analyses requested after the primary pipeline (not part of the
#' pre-specified protocol; primary results are untouched):
#'  A) count models (Poisson / quasi-Poisson / negative binomial, offset =
#'     log population) instead of OLS on rates, plus an age-adjusted Poisson
#'     trend that needs no standard population;
#'  B) direct standardization with the WHO World Standard Population
#'     (Ahmad et al. 2000; weights checked against
#'     seer.cancer.gov/stdpopulations/world.who.html, total 100.035, normalized).
#' Run for both IBGE denominator revisions (2018 primary, 2024 post-Census).
suppressMessages(library(MASS))
here <- function(...) file.path("/home/user/asthma-mortality-brazil-reanalysis/reanalysis", ...)
source(here("R", "07_denominator_sensitivity.R"))  # defines denoms, annual_aggregates, counts_log, read_2024

## ---------------------------------------------------------------- A) count models
fit_count <- function(df, label, rev) {
  # df: year, deaths, pop
  out <- list()
  for (m in c("poisson", "quasipoisson", "negbin")) {
    fit <- tryCatch({
      if (m == "negbin") MASS::glm.nb(deaths ~ year + offset(log(pop)), data = df)
      else glm(deaths ~ year + offset(log(pop)), family = get(m), data = df)
    }, error = function(e) NULL)
    if (is.null(fit)) next
    co <- coef(summary(fit))["year", ]
    z <- if (m == "quasipoisson") qt(0.975, df.residual(fit)) else qnorm(0.975)
    disp <-if (m == "poisson") sum(residuals(fit, "pearson")^2) / df.residual(fit) else NA_real_
    out[[m]] <- data.frame(
      denominator_revision = rev, series = label, model = m,
      annual_pct_change = (exp(co[1]) - 1) * 100,
      ci_low = (exp(co[1] - z * co[2]) - 1) * 100,
      ci_high = (exp(co[1] + z * co[2]) - 1) * 100,
      p_value = co[length(co)],
      pearson_dispersion_poisson = disp,
      nb_theta = if (m == "negbin") fit$theta else NA_real_)
  }
  do.call(rbind, out)
}

series_def <- function(den) {
  gt6 <- data.frame(year = counts_log$year, deaths = counts_log$N_gt6_valid_age)
  grp <- function(lo, hi) {
    d <- aggregate(n_deaths ~ year, annual_aggregates[annual_aggregates$age_floor >= lo & annual_aggregates$age_floor <= hi, ], sum)
    p <- aggregate(population ~ year, den$by_age[den$by_age$age >= lo & den$by_age$age <= hi, ], sum)
    m <- merge(d, p, by = "year"); data.frame(year = m$year, deaths = m$n_deaths, pop = m$population)
  }
  mk <- function(popdf) { m <- merge(gt6, popdf, by = "year"); data.frame(year = m$year, deaths = m$deaths, pop = m$population) }
  list(
    brum_crude_national_total_pop = mk(den$total_population),
    brum_crude_national_gt6_pop = mk(den$pop_gt6),
    age_5_34 = grp(5, 34), age_7_34_control = grp(7, 34), age_35_59 = grp(35, 59),
    legacy_18_59 = grp(18, 59), legacy_gte60 = grp(60, 90))
}

# age-adjusted Poisson trend (ages >= 7), age bands as a factor
band7 <- function(a) cut(a, c(6, 14, 24, 34, 44, 54, 64, 74, 84, 200),
                         labels = c("7-14", "15-24", "25-34", "35-44", "45-54", "55-64", "65-74", "75-84", "85+"))
fit_age_adjusted <- function(den, rev, ages_lo = 7, label = "age_adjusted_poisson_ge7") {
  d <- annual_aggregates[annual_aggregates$age_floor >= ages_lo, ]
  p <- den$by_age[den$by_age$age >= ages_lo, ]
  d$band <- band7(d$age_floor); p$band <- band7(p$age)
  dd <- aggregate(n_deaths ~ year + band, d, sum)
  pp <- aggregate(population ~ year + band, p, sum)
  m <- merge(pp, dd, by = c("year", "band"), all.x = TRUE); m$n_deaths[is.na(m$n_deaths)] <- 0
  out <- list()
  for (mod in c("poisson", "quasipoisson", "negbin")) {
    fit <- if (mod == "negbin") MASS::glm.nb(n_deaths ~ band + year + offset(log(population)), data = m)
           else glm(n_deaths ~ band + year + offset(log(population)), family = get(mod), data = m)
    co <- coef(summary(fit))["year", ]
    z <- if (mod == "quasipoisson") qt(0.975, df.residual(fit)) else qnorm(0.975)
    out[[mod]] <- data.frame(denominator_revision = rev, series = label, model = mod,
      annual_pct_change = (exp(co[1]) - 1) * 100,
      ci_low = (exp(co[1] - z * co[2]) - 1) * 100, ci_high = (exp(co[1] + z * co[2]) - 1) * 100,
      p_value = co[length(co)],
      pearson_dispersion_poisson = if (mod == "poisson") sum(residuals(fit, "pearson")^2) / df.residual(fit) else NA_real_,
      nb_theta = if (mod == "negbin") fit$theta else NA_real_)
  }
  do.call(rbind, out)
}

res_count <- list()
for (rev in names(denoms)) {
  sd <- series_def(denoms[[rev]])
  for (s in names(sd)) res_count[[paste(rev, s)]] <- fit_count(sd[[s]], s, rev)
  res_count[[paste(rev, "adj")]] <- fit_age_adjusted(denoms[[rev]], rev)
}
count_tab <- do.call(rbind, res_count); rownames(count_tab) <- NULL
# glm.nb warns "iteration limit reached" when theta diverges (no overdispersion): NB then equals Poisson.
count_tab$nb_note <- ifelse(!is.na(count_tab$nb_theta) & count_tab$nb_theta > 1e5,
                            "theta diverged: no overdispersion, NB equals Poisson", "")
write.csv(count_tab, here("data", "robustness_count_models.csv"), row.names = FALSE)

## ---------------------------------------------------------------- B) WHO standard
who_w <- c("5-9" = 8.69, "10-14" = 8.60, "15-19" = 8.47, "20-24" = 8.22, "25-29" = 7.93, "30-34" = 7.61,
           "35-39" = 7.15, "40-44" = 6.59, "45-49" = 6.04, "50-54" = 5.37, "55-59" = 4.55, "60-64" = 3.72,
           "65-69" = 2.96, "70-74" = 2.21, "75-79" = 1.52, "80-84" = 0.91, "85-89" = 0.44,
           "90+" = 0.15 + 0.04 + 0.005)
band5 <- function(a) {
  lab <- ifelse(a >= 90, "90+", paste0(floor(a / 5) * 5, "-", floor(a / 5) * 5 + 4))
  lab
}
who_asr <- function(den, lo, hi, rev, label) {
  d <- annual_aggregates[annual_aggregates$age_floor >= lo & annual_aggregates$age_floor <= hi, ]
  p <- den$by_age[den$by_age$age >= lo & den$by_age$age <= hi, ]
  d$band <- band5(d$age_floor); p$band <- band5(p$age)
  dd <- aggregate(n_deaths ~ year + band, d, sum); pp <- aggregate(population ~ year + band, p, sum)
  m <- merge(pp, dd, by = c("year", "band"), all.x = TRUE); m$n_deaths[is.na(m$n_deaths)] <- 0
  # standard weight of each band restricted to the ages actually covered (e.g. 7-9 is 3/5 of band 5-9)
  cover <- aggregate(age ~ band, data.frame(age = lo:min(hi, 94), band = band5(lo:min(hi, 94))), length)
  full <- ifelse(cover$band == "90+", 1, 5); frac <- setNames(pmin(cover$age / full, 1), cover$band)
  m$w <- who_w[m$band] * frac[m$band]
  m$rate <- m$n_deaths / m$population * 1e5
  asr <- do.call(rbind, lapply(split(m, m$year), function(x)
    data.frame(year = x$year[1], n_deaths = sum(x$n_deaths), rate = sum(x$w * x$rate) / sum(x$w))))
  fit <- lm(rate ~ year, data = asr); co <- coef(summary(fit)); tc <- qt(.975, df.residual(fit))
  list(by_year = cbind(denominator_revision = rev, series = label, asr),
       summary = data.frame(denominator_revision = rev, series = label,
         rate_2014 = asr$rate[1], rate_2021 = asr$rate[nrow(asr)],
         pct_change = (asr$rate[nrow(asr)] - asr$rate[1]) / asr$rate[1] * 100,
         slope = co[2, 1], ci_low = co[2, 1] - tc * co[2, 2], ci_high = co[2, 1] + tc * co[2, 2], p_value = co[2, 4]))
}
who_res <- list()
for (rev in names(denoms)) {
  who_res[[paste(rev, "ge7")]] <- who_asr(denoms[[rev]], 7, 90, rev, "who_standardized_ge7")
  who_res[[paste(rev, "534")]] <- who_asr(denoms[[rev]], 5, 34, rev, "who_standardized_5_34")
}
who_sum <- do.call(rbind, lapply(who_res, `[[`, "summary")); rownames(who_sum) <- NULL
who_year <- do.call(rbind, lapply(who_res, `[[`, "by_year")); rownames(who_year) <- NULL
write.csv(who_sum, here("data", "robustness_who_standard_summary.csv"), row.names = FALSE)
write.csv(who_year, here("data", "robustness_who_standard_by_year.csv"), row.names = FALSE)

options(width = 200)
cat("\n=== A) Count models (annual % change; offset = log population) ===\n")
print(count_tab[count_tab$denominator_revision == "rev2018", c("series", "model", "annual_pct_change", "ci_low", "ci_high", "p_value", "pearson_dispersion_poisson", "nb_theta")], digits = 3, row.names = FALSE)
cat("\n=== B) WHO standard, direct standardization, OLS trend on ASR ===\n")
print(who_sum, digits = 3, row.names = FALSE)
