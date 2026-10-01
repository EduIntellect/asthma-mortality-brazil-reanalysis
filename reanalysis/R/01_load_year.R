#' Load and pre-filter one SIM mortality year.
#'
#' Faithfully reproduces the filter order of the original Brum et al. script:
#' J45/J46 selection on CAUSABAS, age derivation as
#' (dtobito - dtnasc) / 365.25, idade_quantidade > 6 filter, then the
#' COVID-related exclusions on LINHAA-D/LINHAII. Because the COVID exclusion
#' pattern does not depend on age, applying it before or after the age slice
#' yields an identical final record set; this function keeps every
#' intermediate count for the FASE 2 audit log, including the full
#' single-year age distribution (N_by_age_group) needed by later phases
#' (age-standardization, 5-34, 7-34, 35-59) without re-reading the raw file.
load_and_filter_sim_year <- function(input_path,
                                     year,
                                     col_select = NULL) {
  cols <- c("CAUSABAS", "DTOBITO", "DTNASC",
            "LINHAA", "LINHAB", "LINHAC", "LINHAD", "LINHAII")
  if (!is.null(col_select)) cols <- col_select

  raw <- vroom::vroom(
    input_path,
    delim = ";",
    col_select = dplyr::all_of(cols),
    col_types = vroom::cols(.default = "c"),
    quote = "\"",
    locale = vroom::locale(encoding = "latin1"),
    na = c("", "NA"),
    progress = FALSE
  )
  n_raw <- nrow(raw)

  is_asthma <- grepl("J45", raw$CAUSABAS) | grepl("J46", raw$CAUSABAS)
  df_j <- raw[is_asthma, ]
  n_j45_j46 <- nrow(df_j)
  rm(raw)

  parse_ddmmyyyy <- function(x) {
    x <- ifelse(!is.na(x) & nchar(x) == 7, paste0("0", x), x)
    as.Date(x, format = "%d%m%Y")
  }
  dtobito_date <- parse_ddmmyyyy(df_j$DTOBITO)
  dtnasc_date  <- parse_ddmmyyyy(df_j$DTNASC)
  idade_quantidade <- as.numeric(difftime(dtobito_date, dtnasc_date, units = "days")) / 365.25
  n_missing_or_invalid_birthdate <- sum(is.na(idade_quantidade))

  patterns <- c("B342", "U072", "COVID-19")
  pattern_regex <- paste(patterns, collapse = "|")
  excl_cols <- c("LINHAA", "LINHAB", "LINHAC", "LINHAD", "LINHAII")
  is_covid <- Reduce(`|`, lapply(excl_cols, function(col) {
    v <- df_j[[col]]
    out <- grepl(pattern_regex, v)
    out[is.na(v)] <- FALSE
    out
  }))

  df_excl <- data.frame(
    dtobito_date = dtobito_date,
    idade_quantidade = idade_quantidade,
    stringsAsFactors = FALSE
  )[!is_covid, ]
  df_excl <- df_excl[!duplicated(df_excl), ]
  n_post_exclusions <- nrow(df_excl)

  df_valid_age <- df_excl[!is.na(df_excl$idade_quantidade), ]
  n_valid_age <- nrow(df_valid_age)

  df_gt6 <- df_valid_age[df_valid_age$idade_quantidade > 6, ]
  n_gt6 <- nrow(df_gt6)

  age_floor <- floor(df_valid_age$idade_quantidade)
  age_floor <- pmin(age_floor, 90L)
  by_age <- as.data.frame(table(age_floor), stringsAsFactors = FALSE)
  names(by_age) <- c("age_floor", "n_deaths")
  by_age$age_floor <- as.integer(by_age$age_floor)
  by_age$year <- year

  list(
    data_gt6 = df_gt6,
    data_valid_age = df_valid_age,
    by_age = by_age,
    counts = data.frame(
      year = year,
      N_raw = n_raw,
      N_J45_J46 = n_j45_j46,
      N_post_exclusions = n_post_exclusions,
      N_valid_age = n_valid_age,
      N_missing_or_invalid_birthdate = n_missing_or_invalid_birthdate,
      N_gt6_valid_age = n_gt6
    )
  )
}
