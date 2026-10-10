# Post hoc Kitagawa decomposition of crude asthma mortality rate changes.
# Standalone: operates only on committed annual aggregates and IBGE 2018 denominators.
# Run from any working directory: Rscript reanalysis/R/10_kitagawa_endpoints.R
#
# The two components partition a difference in rates (not a causal effect):
# C = sum_a (w1_a-w0_a)*(r0_a+r1_a)/2
# R = sum_a (r1_a-r0_a)*(w0_a+w1_a)/2
# Delta crude rate = C+R, exactly (up to floating-point precision).
# All rates are per 100,000 inhabitants; w sums to one over completed ages >=7.
# This is post hoc, distinct from the primary national 8-year trend analysis.

cmd <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", cmd, value = TRUE)
if (length(file_arg) != 1L) stop("Run this script with Rscript.")
script_file <- normalizePath(sub("^--file=", "", file_arg[1]), mustWork = TRUE)
root <- dirname(dirname(script_file))
input_deaths <- file.path(root, "annual_aggregates.csv")
input_population <- file.path(root, "data", "ibge_denominators_by_age.csv")
output_csv <- file.path(root, "data", "kitagawa_endpoint_sensitivity.csv")
output_details <- file.path(root, "data", "kitagawa_age_contributions.csv")

deaths <- read.csv(input_deaths, stringsAsFactors = FALSE)
population <- read.csv(input_population, stringsAsFactors = FALSE)
stopifnot(all(c("age_floor", "n_deaths", "year") %in% names(deaths)),
          all(c("age", "population", "year") %in% names(population)))
if (!all(population$source_version == "ibge_2018_revision"))
  stop("Only the IBGE 2018 denominator revision is allowed in this analysis.")
if (anyNA(deaths[, c("age_floor", "n_deaths", "year")]) ||
    anyNA(population[, c("age", "population", "year")]))
  stop("Missing values found in age, year, death count, or denominator.")

# The annual age aggregates contain ONLY positive-count rows for some ages:
# fill omitted ages with zero. Age 90 represents 90 years and older.
years <- 2014:2021
ages <- 7:90
grid <- expand.grid(year = years, age = ages)
names(deaths)[names(deaths) == "age_floor"] <- "age"
d <- merge(grid, deaths[, c("year", "age", "n_deaths")],
           by = c("year", "age"), all.x = TRUE, sort = TRUE)
d$n_deaths[is.na(d$n_deaths)] <- 0
p <- population[population$year %in% years & population$age %in% ages,
                c("year", "age", "population")]
if (anyDuplicated(p[, c("year", "age")]) || anyDuplicated(d[, c("year", "age")]))
  stop("Duplicate year-age records found.")
merged <- merge(d, p, by = c("year", "age"), all.x = TRUE, sort = TRUE)
if (nrow(merged) != length(years) * length(ages) ||
    anyNA(merged$population) || any(merged$population <= 0))
  stop("Expected a complete positive-denominator year-age grid.")
merged$age_specific_rate <- 1e5 * merged$n_deaths / merged$population
merged$weight <- merged$population /
  ave(merged$population, merged$year, FUN = sum)

# Exact count and standardisation checks against committed primary outputs.
count_log <- read.csv(file.path(root, "data", "fase2_year_counts.csv"))
if (sum(count_log$N_gt6_valid_age) != 18583L ||
    sum(merged$n_deaths) != 18544L)
  stop("Age-domain audit check failed (expected 18583 vs 18544).")
std <- read.csv(file.path(root, "data", "age_standardized_series.csv"))
w2014 <- merged[merged$year == 2014, c("age", "weight")]
reference <- merge(merged, w2014, by = "age", suffixes = c("", "_2014"))
recalc <- aggregate(reference$age_specific_rate * reference$weight_2014,
                    by = list(year = reference$year), FUN = sum)
names(recalc)[2] <- "asr"
chk <- merge(recalc, std[, c("year", "asr")], by = "year",
             suffixes = c("_calculated", "_repo"))
if (nrow(chk) != length(years) ||
    any(abs(chk$asr_calculated - chk$asr_repo) > 1e-10))
  stop("Direct standardisation fails to reproduce committed series.")

pairs <- matrix(c(2014,2021, 2014,2019, 2014,2020,
                  2015,2021, 2016,2021, 2014,2018),
                byrow = TRUE, ncol = 2)
decompose <- function(start_year, end_year) {
  a <- merged[merged$year == start_year,
              c("age", "weight", "age_specific_rate", "n_deaths")]
  b <- merged[merged$year == end_year,
              c("age", "weight", "age_specific_rate", "n_deaths")]
  x <- merge(a, b, by = "age", suffixes = c("_start", "_end"))
  x$composition_contribution <-
    (x$weight_end - x$weight_start) *
    (x$age_specific_rate_start + x$age_specific_rate_end) / 2
  x$rate_contribution <-
    (x$age_specific_rate_end - x$age_specific_rate_start) *
    (x$weight_start + x$weight_end) / 2
  crude0 <- sum(x$weight_start * x$age_specific_rate_start)
  crude1 <- sum(x$weight_end * x$age_specific_rate_end)
  delta <- crude1 - crude0
  comp <- sum(x$composition_contribution)
  rate <- sum(x$rate_contribution)
  if (abs(delta - comp - rate) > 1e-10)
    stop("Kitagawa identity failed for ", start_year, "-", end_year)
  if (delta == 0 || comp == 0)
    stop("Zero component makes relative share undefined for this endpoint pair.")
  x$start_year <- start_year
  x$end_year <- end_year
  row <- data.frame(
    start_year = start_year, end_year = end_year,
    n_deaths_start = sum(x$n_deaths_start),
    n_deaths_end = sum(x$n_deaths_end),
    crude_rate_start = crude0, crude_rate_end = crude1,
    crude_rate_change = delta,
    composition_effect = comp, age_specific_rate_effect = rate,
    composition_share_percent = 100 * comp / delta,
    age60plus_composition_effect =
      sum(x$composition_contribution[x$age >= 60]),
    age60plus_share_of_composition_percent =
      100 * sum(x$composition_contribution[x$age >= 60]) / comp,
    age60plus_population_share_start_percent =
      100 * sum(x$weight_start[x$age >= 60]),
    age60plus_population_share_end_percent =
      100 * sum(x$weight_end[x$age >= 60])
  )
  list(summary = row,
       details = x[, c("start_year", "end_year", "age",
                       "composition_contribution", "rate_contribution")])
}
ans <- lapply(seq_len(nrow(pairs)), function(i)
  decompose(pairs[i, 1], pairs[i, 2]))
results <- do.call(rbind, lapply(ans, `[[`, "summary"))
details <- do.call(rbind, lapply(ans, `[[`, "details"))
if (abs(results$crude_rate_change[1] - 0.13482333086012) > 1e-9 ||
    abs(results$composition_effect[1] - 0.19142353592597) > 1e-9 ||
    abs(results$age_specific_rate_effect[1] + 0.05660020506585) > 1e-9)
  stop("Primary 2014-2021 regression check failed.")
dir.create(dirname(output_csv), recursive = TRUE, showWarnings = FALSE)
write.csv(results, output_csv, row.names = FALSE)
write.csv(details, output_details, row.names = FALSE)
print(results, digits = 6, row.names = FALSE)
cat("Kitagawa sensitivity written to:", output_csv, "\n")
