#' Compute direct age-standardized mortality rates.
#'
#' ASR_t = sum_a(weight_a_2014 * rate_a_t), where weight_a_2014 is the 2014
#' Brazil age distribution restricted to the same age domain as the
#' numerator (age > 6, matching the original idade_quantidade > 6 filter),
#' and rate_a_t = deaths_a,t / population_a,t * 100,000. Keeping the 2014
#' age composition fixed isolates whether the 2014-2021 trend survives once
#' the aging of the population is no longer free to drive the crude rate.
compute_direct_age_standardization <- function(annual_aggregates,
                                               denominators,
                                               standard_population_year = 2014) {
  deaths <- annual_aggregates[annual_aggregates$age_floor > 6, ]
  pop <- denominators$by_age[denominators$by_age$age > 6, ]

  merged <- merge(
    deaths, pop,
    by.x = c("age_floor", "year"), by.y = c("age", "year"),
    all.x = TRUE
  )
  merged$rate <- merged$n_deaths / merged$population * 1e5

  std_weights <- pop[pop$year == standard_population_year, c("age", "population")]
  std_weights$weight <- std_weights$population / sum(std_weights$population)
  names(std_weights)[names(std_weights) == "age"] <- "age_floor"

  merged <- merge(merged, std_weights[, c("age_floor", "weight")], by = "age_floor")

  asr <- stats::aggregate(
    rate * weight ~ year, data = merged, FUN = sum
  )
  names(asr) <- c("year", "asr")

  n_deaths_by_year <- stats::aggregate(n_deaths ~ year, data = deaths, FUN = sum)
  asr <- merge(asr, n_deaths_by_year, by = "year")
  asr <- asr[order(asr$year), ]
  asr
}
