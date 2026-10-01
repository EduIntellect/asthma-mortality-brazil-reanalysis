#' Sensitivity analysis: repeat the numerator-identical analysis using the
#' post-Census-2022 IBGE projection (revision 2024) instead of the 2018
#' revision used for the primary results. Numerators (annual_aggregates.csv,
#' fase2_year_counts.csv) are untouched; only the denominators change.
#' Primary results are NOT overwritten; outputs go to data/sensitivity_*.csv.
here <- function(...) file.path("/home/user/asthma-mortality-brazil-reanalysis/reanalysis", ...)
source(here("R", "04_standardization.R"))
source(here("R", "05_age_groups.R"))
source(here("R", "06_trend_models.R"))

xlsx_2024 <- here("data_raw", "ibge", "projecoes_2024_tab1_idade_simples.xlsx")
if (!file.exists(xlsx_2024)) {
  dir.create(dirname(xlsx_2024), showWarnings = FALSE, recursive = TRUE)
  utils::download.file(
    "https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2024/projecoes_2024_tab1_idade_simples.xlsx",
    xlsx_2024, quiet = TRUE, mode = "wb")
}

read_2024 <- function(path, years = 2014:2021) {
  d <- suppressMessages(readxl::read_excel(path, sheet = 1, skip = 5, col_types = "text"))
  names(d)[1] <- "IDADE"
  b <- d[d$SEXO == "Ambos" & d$SIGLA == "BR", ]
  age <- as.integer(b$IDADE)  # "90" is the open 90+ interval, as in the 2018 file
  by_age <- do.call(rbind, lapply(years, function(y) {
    data.frame(year = y, age = age, population = as.numeric(b[[as.character(y)]]))
  }))
  tot <- stats::aggregate(population ~ year, data = by_age, FUN = sum)
  gt6 <- stats::aggregate(population ~ year, data = by_age[by_age$age > 6, ], FUN = sum)
  list(by_age = by_age, total_population = tot, pop_gt6 = gt6)
}

annual_aggregates <- read.csv(here("annual_aggregates.csv"))
counts_log <- read.csv(here("data", "fase2_year_counts.csv"))
denoms <- list(
  rev2018 = readRDS(here("data", "denominators.rds")),
  rev2024 = read_2024(xlsx_2024)
)

legacy <- function(den, num_lo, num_hi, den_lo, den_hi, label) {
  d <- annual_aggregates[annual_aggregates$age_floor >= num_lo & annual_aggregates$age_floor <= num_hi, ]
  p <- den$by_age[den$by_age$age >= den_lo & den$by_age$age <= den_hi, ]
  m <- merge(stats::aggregate(n_deaths ~ year, data = d, FUN = sum),
             stats::aggregate(population ~ year, data = p, FUN = sum), by = "year")
  data.frame(series = label, year = m$year, n_deaths = m$n_deaths, rate = m$n_deaths / m$population * 1e5)
}

all_series <- list()
for (rev in names(denoms)) {
  den <- denoms[[rev]]
  gt6 <- data.frame(year = counts_log$year, n_deaths = counts_log$N_gt6_valid_age)
  mk <- function(label, popdf) {
    m <- merge(gt6, popdf, by = "year")
    data.frame(series = label, year = m$year, n_deaths = m$n_deaths, rate = m$n_deaths / m$population * 1e5)
  }
  asr <- compute_direct_age_standardization(annual_aggregates, den, 2014)
  ags <- build_age_group_series(annual_aggregates, den)
  s <- rbind(
    mk("brum_crude_national_total_pop", den$total_population),
    mk("brum_crude_national_gt6_pop", den$pop_gt6),
    legacy(den, 7, 17, 0, 17, "legacy_lt18"),
    legacy(den, 18, 59, 18, 59, "legacy_18_59"),
    legacy(den, 60, 90, 60, 90, "legacy_gte60"),
    data.frame(series = "age_standardized_2014std", year = asr$year, n_deaths = asr$n_deaths, rate = asr$asr),
    ags[, c("series", "year", "n_deaths", "rate")]
  )
  fit <- fit_trend_models(s, glm_series = c("brum_crude_national_total_pop",
                                            "brum_crude_national_gt6_pop",
                                            "age_standardized_2014std"))
  fit$denominator_revision <- rev
  all_series[[rev]] <- fit
}
long <- do.call(rbind, all_series)
rownames(long) <- NULL
write.csv(long, here("data", "sensitivity_denominators_by_year.csv"), row.names = FALSE)

summ <- do.call(rbind, lapply(split(long, list(long$denominator_revision, long$series), drop = TRUE), function(d) {
  d <- d[order(d$year), ]
  data.frame(denominator_revision = d$denominator_revision[1], series = d$series[1],
             rate_2014 = d$rate[1], rate_2021 = d$rate[nrow(d)],
             pct_change = d$pct_change[nrow(d)], slope = d$slope[1],
             ci_low = d$ci_low[1], ci_high = d$ci_high[1], p_value = d$p_value[1])
}))
rownames(summ) <- NULL
summ <- summ[order(summ$series, summ$denominator_revision), ]
write.csv(summ, here("data", "sensitivity_denominators_summary.csv"), row.names = FALSE)
print(summ, digits = 4)

## Brum et al.'s code (analysis_and_visualization.qmd, relative_variation*)
## reports the MEAN over 2015-2021 of (rate_t - rate_2014)/rate_2014*100 as
## the "% change", not the end-to-end 2014->2021 change. Reproduce that
## metric explicitly so it is compared like with like.
rel <- do.call(rbind, lapply(split(long, list(long$denominator_revision, long$series), drop = TRUE), function(d) {
  d <- d[order(d$year), ]; r <- d$rate
  data.frame(denominator_revision = d$denominator_revision[1], series = d$series[1],
             end_to_end_pct = (r[length(r)] - r[1]) / r[1] * 100,
             brum_style_mean_rel_variation_pct = mean((r[-1] - r[1]) / r[1] * 100),
             mean_yoy_pct = mean(diff(r) / head(r, -1) * 100))
}))
rownames(rel) <- NULL
write.csv(rel, here("data", "sensitivity_brum_style_change_metrics.csv"), row.names = FALSE)
print(rel[grepl("brum_crude_national_total|legacy_", rel$series), ], digits = 3)

cat("\nPublished Brum et al. (abstract / task brief) targets:\n",
    "national slope 0.03 (95% CI 0.01-0.04, p=0.01); 18-59: ~+19%, slope ~+0.02, p~0.03; >=60: ~-0.5%, p~0.47\n")
