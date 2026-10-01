#' Main driver: FASE 0 (provenance) through FASE 6 (outputs).
#' Sequential, low-memory, one SIM year at a time. No parallelism.

suppressMessages({
  library(vroom)
  library(dplyr)
})

here <- function(...) file.path("/home/user/asthma-mortality-brazil-reanalysis/reanalysis", ...)
source(here("R", "00_provenance.R"))
source(here("R", "01_load_year.R"))
source(here("R", "02_aggregate_annual.R"))
source(here("R", "03_denominators.R"))
source(here("R", "04_standardization.R"))
source(here("R", "05_age_groups.R"))
source(here("R", "06_trend_models.R"))

dir.create(here("data_raw"), showWarnings = FALSE)
dir.create(here("data", "annual"), showWarnings = FALSE, recursive = TRUE)

YEARS <- 2014:2021
SIM_URL_TMPL <- "https://s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/SIM/csv/Mortalidade_Geral_%d_csv.zip"
ORIGINAL_URL_TMPL_2014_2020 <- "https://diaad.s3.sa-east-1.amazonaws.com/sim/Mortalidade_Geral_%d.csv"
ORIGINAL_URL_2021 <- "https://s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/SIM/Mortalidade_Geral_2021.csv"

## ---- FASE 2: per-year low-memory processing ----------------------------

all_counts <- list()
all_by_age <- list()

for (yr in YEARS) {
  message(sprintf("=== Year %d ===", yr))

  zip_path <- here("data_raw", sprintf("Mortalidade_Geral_%d_csv.zip", yr))
  csv_path <- here("data_raw", sprintf("Mortalidade_Geral_%d.csv", yr))

  if (!file.exists(zip_path)) {
    url <- sprintf(SIM_URL_TMPL, yr)
    message("Downloading: ", url)
    status <- utils::download.file(url, zip_path, quiet = TRUE, mode = "wb")
    if (status != 0) stop("Download failed for year ", yr)
  }

  if (!file.exists(csv_path)) {
    utils::unzip(zip_path, exdir = here("data_raw"))
  }

  res <- load_and_filter_sim_year(csv_path, yr)
  aggregate_annual_deaths(res, yr, here("data", "annual", sprintf("annual_%d.csv", yr)))

  all_counts[[as.character(yr)]] <- res$counts
  all_by_age[[as.character(yr)]] <- res$by_age

  rm(res)
  gc(full = TRUE)

  file.remove(csv_path)
}

counts_log <- do.call(rbind, all_counts)
annual_aggregates <- do.call(rbind, all_by_age)
rownames(annual_aggregates) <- NULL

write.csv(counts_log, here("data", "fase2_year_counts.csv"), row.names = FALSE)
write.csv(annual_aggregates, here("annual_aggregates.csv"), row.names = FALSE)

message("FASE 2 complete. Counts log:")
print(counts_log)

## ---- FASE 3: denominators -----------------------------------------------

ibge_xls <- here("data_raw", "ibge", "projecoes_2018_populacao_idade_simples.xls")
if (!file.exists(ibge_xls)) {
  dir.create(dirname(ibge_xls), showWarnings = FALSE, recursive = TRUE)
  utils::download.file(
    "https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2018/projecoes_2018_populacao_idade_simples_2010_2060_20201209.xls",
    ibge_xls, quiet = TRUE, mode = "wb"
  )
}

denom <- reconstruct_ibge_denominators(ibge_xls, output_path = here("data", "ibge_denominators_by_age.csv"))

saveRDS(denom, here("data", "denominators.rds"))

message("FASE 3 complete.")

## ---- FASE 1 reconciliation: Brum crude national reproduction -----------

## IMPORTANT: use the continuous idade_quantidade > 6 count from counts_log
## (N_gt6_valid_age), NOT a floor(age) > 6 filter on annual_aggregates.
## annual_aggregates bins deaths by integer floor(idade_quantidade), so a
## death aged e.g. 6.5 years falls in the age_floor == 6 bucket and would be
## silently dropped by an age_floor > 6 filter, even though it correctly
## satisfies the original continuous idade_quantidade > 6 criterion. Using
## the floor-bucketed version here undercounted the literal Brum
## reproduction by 39 deaths (18,539 vs. the correct 18,578) while leaving
## the FASE 2 tolerance check (which does use the continuous filter)
## unaffected. The floor-based age domain is still appropriate -- and used
## as-is -- for the age-standardization and age-group series below, which
## need single-year-age resolution to match the IBGE denominators and are
## new extensions, not a literal reproduction of Brum's cutoff.
deaths_gt6_by_year <- counts_log %>%
  transmute(year, n_deaths = N_gt6_valid_age)

total_deaths_reproduced <- sum(deaths_gt6_by_year$n_deaths)

brum_total_pop <- merge(deaths_gt6_by_year, denom$total_population, by = "year")
brum_total_pop$rate <- brum_total_pop$n_deaths / brum_total_pop$population * 1e5
brum_total_pop$denominator_basis <- "total_population"

brum_gt6_pop <- merge(deaths_gt6_by_year, denom$pop_gt6, by = "year")
brum_gt6_pop$rate <- brum_gt6_pop$n_deaths / brum_gt6_pop$population * 1e5
brum_gt6_pop$denominator_basis <- "population_gt6"

write.csv(
  rbind(brum_total_pop[, c("year","n_deaths","population","rate","denominator_basis")],
        brum_gt6_pop[, c("year","n_deaths","population","rate","denominator_basis")]),
  here("data", "denominator_comparison.csv"), row.names = FALSE
)

## ---- FASE 4: age-standardization (2014 Brazil standard) ----------------

asr_series <- compute_direct_age_standardization(annual_aggregates, denom, standard_population_year = 2014)
write.csv(asr_series, here("data", "age_standardized_series.csv"), row.names = FALSE)

## ---- FASE 4/5: age groups (5-34, 7-34 control, 35-59) -------------------

age_group_series <- build_age_group_series(annual_aggregates, denom)
write.csv(age_group_series, here("data", "age_group_series.csv"), row.names = FALSE)

## ---- FASE 5: trend models ------------------------------------------------

brum_series <- brum_total_pop %>%
  transmute(series = "brum_crude_national_total_pop", year, n_deaths, rate)
brum_series_gt6pop <- brum_gt6_pop %>%
  transmute(series = "brum_crude_national_gt6_pop", year, n_deaths, rate)

asr_input <- asr_series %>% transmute(series = "age_standardized_2014std", year, n_deaths, rate = asr)

age_group_input <- age_group_series %>% transmute(series, year, n_deaths, rate)

combined <- rbind(brum_series, brum_series_gt6pop, asr_input, age_group_input)

primary_results <- fit_trend_models(
  combined,
  glm_series = c("brum_crude_national_total_pop", "brum_crude_national_gt6_pop", "age_standardized_2014std")
)

## Flag small-count years (< 20 deaths) per series
primary_results$small_count_flag <- primary_results$n_deaths < 20

write.csv(primary_results, here("primary_results.csv"), row.names = FALSE)

message("Pipeline complete.")
print(primary_results)
