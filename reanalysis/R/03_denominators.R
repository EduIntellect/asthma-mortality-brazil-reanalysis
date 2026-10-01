#' Reconstruct IBGE denominators by year and age.
#'
#' Parses the IBGE "Projecao_da_Populacao_2018" single-year-age workbook
#' (sheet "BR"), which stacks three blocks vertically in the same sheet:
#' male population, female population, and total (both sexes) population,
#' each with an "IDADE" header row holding the calendar years in columns,
#' a "TOTAL" row, and then one row per single year of age (0..89, plus a
#' closing "90+" open interval). Only the "TOTAL - IDADES SIMPLES" (both
#' sexes) block is used, matching how `populacao_ano.xlsx` fed the
#' national-level denominator in the original script (no sex stratification
#' was used downstream).
#'
#' `populacao_ano.xlsx` is not present in the original repository (FASE 0
#' finding); this reconstructs the same quantity from the public IBGE
#' source document directly, which is the documented substitution.
reconstruct_ibge_denominators <- function(input_paths,
                                          output_path = NULL,
                                          source_version = "ibge_2018_revision",
                                          years = 2014:2021) {
  xls_path <- if (is.list(input_paths)) input_paths$xls_path else input_paths

  raw <- suppressMessages(readxl::read_excel(xls_path, sheet = "BR", col_names = FALSE))
  col1 <- as.character(unlist(raw[[1]]))

  block_headers <- grep("IDADES SIMPLES", col1)
  total_header_row <- max(block_headers)

  year_row  <- total_header_row + 1
  total_row <- total_header_row + 2
  age_start <- total_header_row + 3

  year_values <- as.numeric(unlist(raw[year_row, -1]))

  age_labels <- as.character(unlist(raw[age_start:nrow(raw), 1]))
  is_age_row <- grepl("^[0-9]+$", age_labels) | age_labels == "90+"
  last_age_offset <- max(which(is_age_row)) - 1
  age_end <- age_start + last_age_offset

  age_block <- raw[age_start:age_end, ]
  age_labels <- as.character(unlist(age_block[[1]]))
  age_int <- ifelse(age_labels == "90+", 90L, as.integer(age_labels))

  get_year_col <- function(y) {
    idx <- which(year_values == y)
    if (length(idx) == 0) stop("Year not found in IBGE workbook: ", y)
    idx + 1
  }

  by_age_list <- lapply(years, function(y) {
    col_idx <- get_year_col(y)
    data.frame(
      year = y,
      age = age_int,
      population = as.numeric(unlist(age_block[[col_idx]])),
      source_version = source_version,
      stringsAsFactors = FALSE
    )
  })
  by_age <- do.call(rbind, by_age_list)

  total_population <- data.frame(
    year = years,
    population = vapply(years, function(y) {
      col_idx <- get_year_col(y)
      as.numeric(raw[[col_idx]][total_row])
    }, numeric(1)),
    source_version = source_version,
    stringsAsFactors = FALSE
  )

  pop_gt6 <- stats::aggregate(
    population ~ year,
    data = by_age[by_age$age > 6, ],
    FUN = sum
  )
  pop_gt6$source_version <- source_version

  if (!is.null(output_path)) {
    utils::write.csv(by_age, output_path, row.names = FALSE)
  }

  list(
    by_age = by_age,
    total_population = total_population,
    pop_gt6 = pop_gt6
  )
}
