#!/usr/bin/env Rscript
## Impact audit: ICD-10 U07.1 in the COVID-related exclusion (SIM 2020-2021).
##
## Audit only. It does not modify the canonical pipeline or any frozen
## table, figure or CSV. Outputs are written to reanalysis/audit/.
##
## The canonical rule (01_load_year.R, reproducing Brum et al.) excludes
## asthma deaths (CAUSABAS J45/J46) whose cause-of-death lines LINHAA-D or
## LINHAII contain "B342", "U072" or "COVID-19". U07.1 is not in that list.
## This script:
##   1. re-runs the canonical loader on 2020 and 2021 and checks that the
##      downloaded files reproduce the committed counts
##      (data/fase2_year_counts.csv);
##   2. counts asthma records with U07.1 in any cause line, how many of them
##      the current rule already excludes, and how many it would add;
##   3. applies the same downstream steps as the canonical pipeline
##      (deduplication on the loaded fields, valid birth date, age filters)
##      with and without U07.1 in the exclusion, by year and age group.
## Only aggregate counts are written; no record-level data leave data_raw/.
##
## Usage (from the repository root, after the SIM files are in
## reanalysis/data_raw/; see docs/data_sources.md):
##   Rscript reanalysis/R/11_audit_u071.R

suppressPackageStartupMessages({
  library(vroom)
})

args <- commandArgs(trailingOnly = FALSE)
script_path <- sub("^--file=", "", args[grep("^--file=", args)])
root <- normalizePath(file.path(dirname(script_path), ".."))
source(file.path(root, "R", "01_load_year.R"))

years <- c(2020L, 2021L)
raw_dir <- file.path(root, "data_raw")
out_dir <- file.path(root, "audit")
dir.create(out_dir, showWarnings = FALSE)

committed <- read.csv(file.path(root, "data", "fase2_year_counts.csv"))
line_cols <- c("LINHAA", "LINHAB", "LINHAC", "LINHAD", "LINHAII")
current_regex <- "B342|U072|COVID-19"

any_line <- function(df, regex) {
  Reduce(`|`, lapply(line_cols, function(col) {
    v <- df[[col]]
    out <- grepl(regex, v)
    out[is.na(v)] <- FALSE
    out
  }))
}

## Same steps as load_and_filter_sim_year() after the exclusion mask,
## returning counts by analytical group.
downstream_counts <- function(df, excl) {
  kept <- df[!excl, c("dtobito_date", "idade_quantidade", "CAUSABAS", line_cols)]
  kept <- kept[!duplicated(kept), ]
  valid <- kept[!is.na(kept$idade_quantidade), ]
  a <- floor(valid$idade_quantidade)
  c(
    post_exclusions = nrow(kept),
    valid_birth_date = nrow(valid),
    continuous_age_gt6 = sum(valid$idade_quantidade > 6),
    completed_age_ge7 = sum(a >= 7),
    age_5_34 = sum(a >= 5 & a <= 34),
    age_7_34 = sum(a >= 7 & a <= 34),
    age_35_59 = sum(a >= 35 & a <= 59),
    age_ge60 = sum(a >= 60)
  )
}

impact <- list()
by_line <- list()
for (yr in years) {
  path <- file.path(raw_dir, sprintf("Mortalidade_Geral_%d.csv", yr))
  stopifnot(file.exists(path))

  ## 1. Canonical loader must reproduce the committed counts.
  canon <- load_and_filter_sim_year(path, yr)$counts
  ref <- committed[committed$year == yr, ]
  for (k in c("N_J45_J46", "N_post_exclusions", "N_valid_age", "N_gt6_valid_age")) {
    if (canon[[k]] != ref[[k]]) {
      stop(sprintf("%d: %s = %d, committed %d; downloaded file differs",
                   yr, k, canon[[k]], ref[[k]]))
    }
  }

  ## 2. Asthma records and U07.1 flags (same parsing as the loader).
  raw <- vroom::vroom(path, delim = ";",
                      col_select = dplyr::all_of(c("CAUSABAS", "DTOBITO", "DTNASC", line_cols)),
                      col_types = vroom::cols(.default = "c"), quote = "\"",
                      locale = vroom::locale(encoding = "latin1"),
                      na = c("", "NA"), progress = FALSE)
  df <- as.data.frame(raw[!is.na(raw$CAUSABAS) &
                            (grepl("J45", raw$CAUSABAS) | grepl("J46", raw$CAUSABAS)), ])
  rm(raw)
  parse_ddmmyyyy <- function(x) {
    x <- ifelse(!is.na(x) & nchar(x) == 7, paste0("0", x), x)
    as.Date(x, format = "%d%m%Y")
  }
  df$dtobito_date <- parse_ddmmyyyy(df$DTOBITO)
  df$idade_quantidade <- as.numeric(difftime(df$dtobito_date,
                                             parse_ddmmyyyy(df$DTNASC),
                                             units = "days")) / 365.25
  stopifnot(nrow(df) == canon$N_J45_J46)

  excl_current <- any_line(df, current_regex)
  has_u071 <- any_line(df, "U071")
  excl_with_u071 <- excl_current | has_u071

  cur <- downstream_counts(df, excl_current)
  stopifnot(cur[["post_exclusions"]] == ref$N_post_exclusions,
            cur[["valid_birth_date"]] == ref$N_valid_age,
            cur[["continuous_age_gt6"]] == ref$N_gt6_valid_age)
  new <- downstream_counts(df, excl_with_u071)

  impact[[length(impact) + 1]] <- data.frame(
    year = yr,
    measure = names(cur),
    current_rule = as.integer(cur),
    with_u071 = as.integer(new),
    difference = as.integer(new - cur)
  )

  ## Where U07.1 appears among the records it would newly exclude, and other
  ## COVID-related U codes (U09.9, U10.9) for information only.
  add <- df[has_u071 & !excl_current, ]
  a_add <- floor(add$idade_quantidade)
  by_line[[length(by_line) + 1]] <- data.frame(
    year = yr,
    item = c("asthma_records_J45_J46",
             "records_with_U071_any_line",
             "U071_already_excluded_by_current_rule",
             "U071_additional_exclusions_before_dedup",
             paste0("additional_U071_in_", line_cols),
             "additional_underlying_J45", "additional_underlying_J46",
             "additional_missing_birth_date",
             "additional_completed_age_ge7", "additional_age_5_34",
             "records_with_U099_any_line", "records_with_U109_any_line"),
    n = c(nrow(df), sum(has_u071), sum(has_u071 & excl_current), nrow(add),
          vapply(line_cols, function(col) sum(grepl("U071", add[[col]])), integer(1)),
          sum(grepl("J45", add$CAUSABAS)), sum(grepl("J46", add$CAUSABAS)),
          sum(is.na(add$idade_quantidade)),
          sum(a_add >= 7, na.rm = TRUE), sum(a_add >= 5 & a_add <= 34, na.rm = TRUE),
          sum(any_line(df, "U099")), sum(any_line(df, "U109")))
  )
  rm(df, add)
  gc(verbose = FALSE)
}

impact <- do.call(rbind, impact)
by_line <- do.call(rbind, by_line)
write.csv(impact, file.path(out_dir, "u071_impact_counts.csv"), row.names = FALSE)
write.csv(by_line, file.path(out_dir, "u071_record_profile.csv"), row.names = FALSE)
print(impact, row.names = FALSE)
print(by_line, row.names = FALSE)
