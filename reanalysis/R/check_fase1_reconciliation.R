#' FASE 1 reconciliation check: reproduce the original <18 / 18-59 / >=60
#' age-group series exactly as the original script grouped them (numerator
#' restricted to idade_quantidade > 6, denominator using the UNRESTRICTED
#' IBGE population for each named bin -- i.e. "<18" numerator is really
#' ages 7-17 but is divided by total population 0-17, reproducing the
#' same numerator/denominator mismatch documented in FASE 0).
here <- function(...) file.path("/home/user/asthma-mortality-brazil-reanalysis/reanalysis", ...)
annual_aggregates <- read.csv(here("annual_aggregates.csv"))
denom <- readRDS(here("data", "denominators.rds"))

make_legacy_series <- function(num_lo, num_hi, den_lo, den_hi, label) {
  d <- annual_aggregates[annual_aggregates$age_floor >= num_lo & annual_aggregates$age_floor <= num_hi, ]
  p <- denom$by_age[denom$by_age$age >= den_lo & denom$by_age$age <= den_hi, ]
  deaths_yr <- aggregate(n_deaths ~ year, data = d, FUN = sum)
  pop_yr <- aggregate(population ~ year, data = p, FUN = sum)
  out <- merge(deaths_yr, pop_yr, by = "year")
  out$rate <- out$n_deaths / out$population * 1e5
  out$series <- label
  out[order(out$year), ]
}

lt18 <- make_legacy_series(7, 17, 0, 17, "legacy_lt18")
a1859 <- make_legacy_series(18, 59, 18, 59, "legacy_18_59")
gte60 <- make_legacy_series(60, 90, 60, 90, "legacy_gte60")

summarize_series <- function(s) {
  fit <- lm(rate ~ year, data = s)
  co <- coef(summary(fit))
  pct_change <- (s$rate[s$year == 2021] - s$rate[s$year == 2014]) / s$rate[s$year == 2014] * 100
  data.frame(
    series = unique(s$series),
    n_2014 = s$n_deaths[s$year == 2014],
    n_2021 = s$n_deaths[s$year == 2021],
    rate_2014 = s$rate[s$year == 2014],
    rate_2021 = s$rate[s$year == 2021],
    pct_change_2014_2021 = pct_change,
    slope = co["year", "Estimate"],
    p_value = co["year", ncol(co)]
  )
}

res <- rbind(summarize_series(lt18), summarize_series(a1859), summarize_series(gte60))
print(res)

write.csv(res, here("data", "fase1_legacy_reconciliation.csv"), row.names = FALSE)

cat("\nProportion of deaths in >=60 group (pooled 2014-2021):\n")
## Use the continuous idade_quantidade > 6 total (fase2_year_counts.csv),
## not a floor(age) > 6 filter on annual_aggregates -- same reasoning as
## run_pipeline.R's brum_crude fix: floor-bucketing silently drops deaths
## with continuous age in (6,7) years, understating this denominator by
## ~0.2% and shifting the reported percentage at the first decimal place.
counts_log <- read.csv(here("data", "fase2_year_counts.csv"))
total_deaths <- sum(counts_log$N_gt6_valid_age)
deaths_60 <- sum(gte60$n_deaths)
cat(round(deaths_60 / total_deaths * 100, 1), "%\n")
