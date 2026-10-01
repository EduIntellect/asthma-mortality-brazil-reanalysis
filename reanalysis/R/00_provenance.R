#' Record provenance metadata for reproducibility.
record_provenance <- function(original_repo_sha = NULL,
                              sim_sources = NULL,
                              ibge_sources = NULL,
                              output_path = NULL) {
  pkgs <- c("vroom", "dplyr", "lubridate", "readxl", "janitor",
            "stringr", "purrr", "tidyr", "broom", "readr", "digest")
  pkg_versions <- vapply(pkgs, function(p) as.character(utils::packageVersion(p)), character(1))

  lines <- c(
    "# Session and provenance information",
    "",
    paste0("Captured at: ", Sys.time()),
    "Original analysis repository: mobrant94/asthma_mortality",
    paste0("Original repository commit SHA used as reference: ", original_repo_sha),
    "",
    "## R package versions",
    paste0("- ", names(pkg_versions), ": ", pkg_versions),
    "",
    "## SIM data sources",
    sim_sources,
    "",
    "## IBGE denominator sources",
    ibge_sources,
    "",
    "## sessionInfo()",
    utils::capture.output(print(sessionInfo()))
  )

  if (!is.null(output_path)) {
    writeLines(lines, output_path)
  }
  invisible(lines)
}
