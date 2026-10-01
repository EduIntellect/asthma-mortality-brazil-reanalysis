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
## reproduction by 39 deaths relative to the continuous-filter total (see
## audit_reproduction.md for the exact before/after figures) while leaving
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

## ---- FASE 6: single comparative figure, only after primary_results is
## frozen above. type="cairo" (with a UTF-8 locale) is required here: the
## default png() device under the session's "C" locale cannot render
## accented characters or "¿", and silently replaced them with ".." in an
## earlier, non-reproducible, ad hoc version of this plot.
old_locale <- Sys.getlocale("LC_CTYPE")
try(Sys.setlocale("LC_CTYPE", "C.utf8"), silent = TRUE)

fig_series <- c("brum_crude_national_total_pop", "age_standardized_2014std", "age_5_34")
fig_labels <- c(
  brum_crude_national_total_pop = "Tasa cruda nacional (Brum, reproducida)",
  age_standardized_2014std = "Estandarizada por edad (estándar 2014)",
  age_5_34 = "Grupo 5-34 años"
)
fig_cols <- c(brum_crude_national_total_pop = "grey40", age_standardized_2014std = "black", age_5_34 = "firebrick")
fig_ltys <- c(brum_crude_national_total_pop = 2, age_standardized_2014std = 1, age_5_34 = 1)

grDevices::png(here("figures_comparative.png"), width = 1600, height = 1100, res = 180, type = "cairo")
par(mar = c(4.5, 4.5, 2, 1))
plot(NULL, xlim = c(2014, 2021), ylim = c(-25, 30), xlab = "Año",
     ylab = "Cambio % respecto a 2014",
     main = "¿Persiste el aumento 2014-2021 tras estandarizar y en 5-34 años?")
abline(h = 0, col = "grey70", lty = 3)
for (s in fig_series) {
  d <- primary_results[primary_results$series == s, ]
  d <- d[order(d$year), ]
  lines(d$year, d$pct_change, col = fig_cols[s], lwd = 2.5, lty = fig_ltys[s])
  points(d$year, d$pct_change, col = fig_cols[s], pch = 19, cex = 0.9)
}
legend("topleft", legend = fig_labels[fig_series], col = fig_cols[fig_series],
       lty = fig_ltys[fig_series], lwd = 2.5, bty = "n", cex = 0.85)
grDevices::dev.off()

try(Sys.setlocale("LC_CTYPE", old_locale), silent = TRUE)

## ---- FASE 0 (written last, so it can hash the IBGE file that FASE 3
## already downloaded, and so it reflects the exact code/data state that
## produced the outputs above rather than a disconnected manual capture) --

sim_sources <- c(
  "- Original repo URLs (2014-2020): https://diaad.s3.sa-east-1.amazonaws.com/sim/Mortalidade_Geral_{year}.csv -- still reachable (HTTP 206) for 2014-2020 only.",
  "- Original repo URL for 2021: https://s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/SIM/Mortalidade_Geral_2021.csv -- returns AWS AccessDenied (dead link), confirmed by direct request.",
  "- SUBSTITUTION USED for all 8 years (2014-2021): https://s3.sa-east-1.amazonaws.com/ckan.saude.gov.br/SIM/csv/Mortalidade_Geral_{year}_csv.zip",
  "  Resolved via the official portal dadosabertos.saude.gov.br/dataset/sim (Ministerio da Saude, SIM dataset, CKAN resource list), confirmed reachable (HTTP 206) for all years 2014-2021.",
  "  Delimiter: semicolon; quoted fields; latin1 encoding. Columns used: CAUSABAS, DTOBITO, DTNASC, LINHAA, LINHAB, LINHAC, LINHAD, LINHAII."
)
ibge_sha256 <- tryCatch(
  digest::digest(ibge_xls, algo = "sha256", file = TRUE),
  error = function(e) "sha256 unavailable (digest package not installed)"
)
ibge_sources <- c(
  "- populacao_ano.xlsx is NOT present in the original repository (confirmed). Reconstructed from the public IBGE source directly.",
  paste0("- PRIMARY source used: ", "https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2018/projecoes_2018_populacao_idade_simples_2010_2060_20201209.xls"),
  "  IBGE Projection revision 2018 (pre-2022 Census), single-year-age population, Brazil (sheet BR, block POPULACAO TOTAL - IDADES SIMPLES, both sexes).",
  "  Chosen as primary because it is the revision contemporaneous with the original 2024 publication.",
  "- ALTERNATIVE source available for robustness (not used in primary run): https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2024/projecoes_2024_tab1_idade_simples.xlsx (post-2022-Census revision).",
  paste0("- IBGE workbook sha256: ", ibge_sha256, "  ", ibge_xls)
)

record_provenance(
  original_repo_sha = "8d527a5 (mobrant94/asthma_mortality, 15 mayo 2024)",
  sim_sources = sim_sources,
  ibge_sources = ibge_sources,
  output_path = here("session_info.txt")
)

message("Pipeline complete.")
print(primary_results)
