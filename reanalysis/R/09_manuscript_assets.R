#' Builds the English-language figure and the LaTeX table fragments used by
#' manuscript/methods_results.tex, directly from the committed CSV outputs
#' (no numbers are typed by hand into the tables).
#' Run with: Rscript reanalysis/R/09_manuscript_assets.R (from any directory),
#' after run_pipeline.R and 10_kitagawa_endpoints.R have written their outputs.
.cmd <- commandArgs(trailingOnly = FALSE)
.file_arg <- grep("^--file=", .cmd, value = TRUE)
.root <- if (length(.file_arg) == 1L) {
  dirname(dirname(normalizePath(sub("^--file=", "", .file_arg), mustWork = TRUE)))
} else {
  normalizePath("reanalysis", mustWork = TRUE)
}
here <- function(...) file.path(.root, ...)
dir.create(here("manuscript", "tables"), showWarnings = FALSE, recursive = TRUE)
dir.create(here("manuscript", "figures"), showWarnings = FALSE, recursive = TRUE)

pr   <- read.csv(here("primary_results.csv"))
cl   <- read.csv(here("data", "fase2_year_counts.csv"))
leg  <- read.csv(here("data", "fase1_legacy_reconciliation.csv"))
brs  <- read.csv(here("data", "sensitivity_brum_style_change_metrics.csv"))
cnt  <- read.csv(here("data", "robustness_count_models.csv"))
sens <- read.csv(here("data", "sensitivity_denominators_summary.csv"))
who  <- read.csv(here("data", "robustness_who_standard_summary.csv"))

f <- function(x, d = 3) formatC(x, format = "f", digits = d, big.mark = "")
fp <- function(p) ifelse(p < 0.001, "$<$0.001", f(p, 3))
fn <- function(x) formatC(x, format = "d", big.mark = ",")
fm <- function(x, d) ifelse(x < 0, paste0("$-$", f(abs(x), d)), f(x, d))
ci <- function(lo, hi, d = 4) paste0("(", fm(lo, d), " to ", fm(hi, d), ")")
sg <- function(x, d = 1) ifelse(x >= 0, paste0("+", f(x, d)), paste0("$-$", f(abs(x), d)))
sgn <- function(x, d = 4) ifelse(x >= 0, f(x, d), paste0("$-$", f(abs(x), d)))
write_tab <- function(lines, name) writeLines(lines, here("manuscript", "tables", name))

## ---- Table: case flow by year
tot <- colSums(cl[, c("N_raw", "N_J45_J46", "N_post_exclusions", "N_valid_age", "N_missing_or_invalid_birthdate", "N_gt6_valid_age")])
rows <- apply(cl, 1, function(r) paste(r["year"], fn(r["N_raw"]), fn(r["N_J45_J46"]), fn(r["N_post_exclusions"]),
                                        fn(r["N_valid_age"]), fn(r["N_gt6_valid_age"]), sep = " & "))
write_tab(c("\\begin{tabular}{rrrrrr}", "\\toprule",
  "Year & All records & Asthma (J45--J46) & After exclusions$^{a}$ & Valid birth date & Age $>$6 years \\\\", "\\midrule",
  paste0(rows, " \\\\"), "\\midrule",
  paste0("Total & ", paste(fn(tot[c("N_raw", "N_J45_J46", "N_post_exclusions", "N_valid_age", "N_gt6_valid_age")]), collapse = " & "), " \\\\"),
  "\\bottomrule", "\\end{tabular}"), "tab_flow.tex")

## ---- Table: deaths and rates by series and year (two panels so the table stays legible at full size)
ser <- c(brum_crude_national_total_pop = "Crude national rate", age_standardized_2014std = "Age-standardised (Brazil 2014)",
         age_5_34 = "Ages 5--34", age_7_34_control = "Ages 7--34", age_35_59 = "Ages 35--59")
val <- function(s, y, what) { d <- pr[pr$series == s & pr$year == y, ]; if (what == "n") fn(d$n_deaths) else f(d$rate, 3) }
panel <- function(what) vapply(names(ser), function(s) paste0(paste(c(ser[[s]], vapply(2014:2021, function(y) val(s, y, what), "")), collapse = " & "), " \\\\"), "")
write_tab(c("\\begin{tabular}{lrrrrrrrr}", "\\toprule", paste("Series &", paste(2014:2021, collapse = " & "), "\\\\"), "\\midrule",
  "\\multicolumn{9}{l}{\\emph{Deaths}} \\\\", panel("n"), "\\midrule",
  "\\multicolumn{9}{l}{\\emph{Rate per 100,000}} \\\\", panel("r"), "\\bottomrule", "\\end{tabular}"), "tab_series.tex")

## ---- Table: primary trend estimates
ser_tr <- c(brum_crude_national_total_pop = "Crude national rate", brum_crude_national_gt6_pop = "Crude national rate, population $>$6 years",
          age_standardized_2014std = "Age-standardised (Brazil 2014)", age_5_34 = "Ages 5--34", age_7_34_control = "Ages 7--34", age_35_59 = "Ages 35--59")
rows <- vapply(names(ser_tr), function(s) {
  d <- pr[pr$series == s, ]; d <- d[order(d$year), ]
  paste(ser_tr[[s]], f(d$rate[1], 3), f(d$rate[8], 3), sg(d$pct_change[8], 1), sgn(d$slope[1], 4),
        ci(d$ci_low[1], d$ci_high[1]), fp(d$p_value[1]), sep = " & ")
}, "")
write_tab(c("\\begin{tabular}{lrrrrlr}", "\\toprule",
  "Series & Rate 2014 & Rate 2021 & Change (\\%) & Slope$^{a}$ & 95\\% CI & $p$ \\\\", "\\midrule",
  paste0(rows, " \\\\"), "\\bottomrule", "\\end{tabular}"), "tab_trends.tex")

## ---- Table: age groups as defined in the original analysis
lab <- c(legacy_lt18 = "Ages 7--17$^{a}$", legacy_18_59 = "Ages 18--59", legacy_gte60 = "Ages $\\geq$60")
rows <- vapply(names(lab), function(s) {
  l <- leg[leg$series == s, ]; b <- brs[brs$series == s & brs$denominator_revision == "rev2018", ]
  paste(lab[[s]], paste0(fn(l$n_2014), " / ", fn(l$n_2021)), paste0(f(l$rate_2014, 3), " / ", f(l$rate_2021, 3)),
        sg(l$pct_change_2014_2021, 1), sg(b$brum_style_mean_rel_variation_pct, 1), sgn(l$slope, 4), fp(l$p_value), sep = " & ")
}, "")
write_tab(c("\\begin{tabular}{lrrrrrr}", "\\toprule",
  "Group & Deaths 2014 / 2021 & Rate 2014 / 2021 & Change 2014--2021 (\\%) & Mean relative variation$^{b}$ (\\%) & Slope & $p$ \\\\", "\\midrule",
  paste0(rows, " \\\\"), "\\bottomrule", "\\end{tabular}"), "tab_groups_original.tex")

## ---- Table: count models
cs <- c(brum_crude_national_total_pop = "Crude national rate", age_adjusted_poisson_ge7 = "Age-adjusted, ages $\\geq$7",
        age_5_34 = "Ages 5--34", age_7_34_control = "Ages 7--34", age_35_59 = "Ages 35--59")
g <- function(s, m, r) cnt[cnt$series == s & cnt$model == m & cnt$denominator_revision == r, ]
rows <- vapply(names(cs), function(s) {
  q <- g(s, "quasipoisson", "rev2018"); nb <- g(s, "negbin", "rev2018"); p <- g(s, "poisson", "rev2018"); q24 <- g(s, "quasipoisson", "rev2024")
  paste(cs[[s]], f(p$pearson_dispersion_poisson, 2), paste0(sg(q$annual_pct_change, 2), " ", ci(q$ci_low, q$ci_high, 2)), fp(q$p_value),
        fp(nb$p_value), paste0(sg(q24$annual_pct_change, 2), " (", fp(q24$p_value), ")"), sep = " & ")
}, "")
write_tab(c("\\begin{tabular}{lrllrl}", "\\toprule",
  "Series & Dispersion$^{a}$ & Quasi-Poisson, annual change (\\%) & $p$ & $p$, neg.\\ binomial & 2024 denominators$^{b}$ \\\\", "\\midrule",
  paste0(rows, " \\\\"), "\\bottomrule", "\\end{tabular}"), "tab_count_models.tex")

## ---- Table: standard population / denominator sensitivity
srow <- function(label, d) paste(label, f(d$rate_2014, 3), f(d$rate_2021, 3), sg(d$pct_change, 1),
                                   sgn(d$slope, 4), ci(d$ci_low, d$ci_high), fp(d$p_value), sep = " & ")
sv <- function(s, r) sens[sens$series == s & sens$denominator_revision == r, ]
wv <- function(s, r) who[who$series == s & who$denominator_revision == r, ]
rows <- c("\\multicolumn{7}{l}{\\emph{Ages $\\geq$7, age-standardised}} \\\\",
  paste0(srow("Brazil 2014 standard, 2018 projection (primary)", sv("age_standardized_2014std", "rev2018")), " \\\\"),
  paste0(srow("Brazil 2014 standard, 2024 projection", sv("age_standardized_2014std", "rev2024")), " \\\\"),
  paste0(srow("WHO standard, 2018 projection", wv("who_standardized_ge7", "rev2018")), " \\\\"),
  paste0(srow("WHO standard, 2024 projection", wv("who_standardized_ge7", "rev2024")), " \\\\"),
  "\\midrule", "\\multicolumn{7}{l}{\\emph{Ages 5--34}} \\\\",
  paste0(srow("Crude group rate, 2018 projection (primary)", sv("age_5_34", "rev2018")), " \\\\"),
  paste0(srow("Crude group rate, 2024 projection", sv("age_5_34", "rev2024")), " \\\\"),
  paste0(srow("WHO standard, 2018 projection", wv("who_standardized_5_34", "rev2018")), " \\\\"),
  paste0(srow("WHO standard, 2024 projection", wv("who_standardized_5_34", "rev2024")), " \\\\"))
write_tab(c("\\begin{tabular}{lrrrrlr}", "\\toprule",
  "Specification & Rate 2014 & Rate 2021 & Change (\\%) & Slope & 95\\% CI & $p$ \\\\", "\\midrule",
  rows, "\\bottomrule", "\\end{tabular}"), "tab_sensitivity.tex")

## ---- Figure (English, relative change from 2014)
fs <- c("brum_crude_national_total_pop", "age_standardized_2014std", "age_5_34")
fl <- c("Crude national rate", "Age-standardised rate (Brazil 2014 standard)", "Ages 5-34 years")
fc <- c("grey40", "black", "firebrick"); ft <- c(2, 1, 1)
rng <- range(pr$pct_change[pr$series %in% fs]); mg <- diff(rng) * 0.1
draw <- function() {
  par(mar = c(4.5, 4.5, 1, 1))
  plot(NULL, xlim = c(2014, 2021), ylim = rng + c(-mg, mg), xlab = "Year", ylab = "Relative change from 2014 (%)")
  abline(h = 0, col = "grey70", lty = 3)
  for (i in seq_along(fs)) {
    d <- pr[pr$series == fs[i], ]; d <- d[order(d$year), ]
    lines(d$year, d$pct_change, col = fc[i], lwd = 2.5, lty = ft[i]); points(d$year, d$pct_change, col = fc[i], pch = 19, cex = 0.9)
  }
  legend("topleft", legend = fl, col = fc, lty = ft, lwd = 2.5, bty = "n", cex = 0.85)
}
grDevices::cairo_pdf(here("manuscript", "figures", "fig1_relative_change.pdf"), width = 7, height = 4.8); draw(); invisible(dev.off())
grDevices::png(here("manuscript", "figures", "fig1_relative_change.png"), width = 2100, height = 1440, res = 300, type = "cairo"); draw(); invisible(dev.off())

## ---- Full-article assets (RRCP: black-and-white charts, JPEG >= 300 dpi).
## The letter keeps fig1_relative_change.*; the article uses the series below,
## in which the crude and the age-standardised rates cover the same deaths and
## population (completed ages >= 7, IBGE 2018 projection).
aa_all <- read.csv(here("annual_aggregates.csv"))
pop_all <- read.csv(here("data", "ibge_denominators_by_age.csv"))
stopifnot(all(pop_all$source_version == "ibge_2018_revision"))
crude_ge7 <- do.call(rbind, lapply(2014:2021, function(y) {
  n <- sum(aa_all$n_deaths[aa_all$year == y & aa_all$age_floor >= 7])
  p <- sum(pop_all$population[pop_all$year == y & pop_all$age >= 7])
  data.frame(year = y, n_deaths = n, population = p, rate = 1e5 * n / p)
}))
crude_ge7$pct_change <- 100 * (crude_ge7$rate / crude_ge7$rate[1] - 1)
std_ser <- pr[pr$series == "age_standardized_2014std", ]; std_ser <- std_ser[order(std_ser$year), ]
kit <- read.csv(here("data", "kitagawa_endpoint_sensitivity.csv"))
# Consistency checks: same domain as the standardised rate and the decomposition.
stopifnot(sum(crude_ge7$n_deaths) == 18543L,
          abs(crude_ge7$rate[1] - std_ser$rate[1]) < 1e-10,  # 2014 is the standard year
          abs(crude_ge7$rate[crude_ge7$year == 2021] -
                kit$crude_rate_end[kit$start_year == 2014 & kit$end_year == 2021]) < 1e-10)
write.csv(crude_ge7, here("data", "crude_rate_ge7_series.csv"), row.names = FALSE)

d534 <- pr[pr$series == "age_5_34", ]; d534 <- d534[order(d534$year), ]
f1 <- list(
  list(d = crude_ge7, lab = "Crude rate, ages 7 years and older", lty = 2, pch = 1),
  list(d = std_ser,   lab = "Age-standardised rate, ages 7 years and older (Brazil 2014 standard)", lty = 1, pch = 19),
  list(d = d534,      lab = "Rate at ages 5-34 years", lty = 4, pch = 17))
rng1 <- range(unlist(lapply(f1, function(s) s$d$pct_change))); mg1 <- diff(rng1) * 0.12
draw_article <- function() {
  par(mar = c(4.5, 4.5, 1, 1), family = "sans")
  plot(NULL, xlim = c(2014, 2021), ylim = rng1 + c(-mg1, mg1), xlab = "Year",
       ylab = "Relative change from 2014 (%)", las = 1)
  abline(h = 0, col = "black", lty = 3, lwd = 0.8)
  for (s in f1) {
    lines(s$d$year, s$d$pct_change, col = "black", lwd = 2, lty = s$lty)
    points(s$d$year, s$d$pct_change, col = "black", bg = "black", pch = s$pch, cex = 1)
  }
  legend("topleft", legend = vapply(f1, `[[`, "", "lab"), col = "black",
         lty = vapply(f1, `[[`, 0, "lty"), pch = vapply(f1, `[[`, 0, "pch"),
         lwd = 2, bty = "n", cex = 0.8)
}
grDevices::cairo_pdf(here("manuscript", "figures", "fig1_relative_change_ge7.pdf"), width = 7, height = 4.8); draw_article(); invisible(dev.off())
grDevices::jpeg(here("manuscript", "figures", "fig1_relative_change_ge7.jpg"), width = 2100, height = 1440, res = 300,
                quality = 100, type = "cairo"); draw_article(); invisible(dev.off())

## ---- Table: Kitagawa decomposition and endpoint sensitivity (post hoc)
rows <- vapply(seq_len(nrow(kit)), function(i) {
  k <- kit[i, ]
  paste(paste0(k$start_year, "--", k$end_year),
        paste0(f(k$crude_rate_start, 3), " / ", f(k$crude_rate_end, 3)),
        sg(k$crude_rate_change, 3), sg(k$composition_effect, 3), sg(k$age_specific_rate_effect, 3),
        f(k$composition_share_percent, 0), f(k$age60plus_share_of_composition_percent, 0), sep = " & ")
}, "")
write_tab(c("\\begin{tabular}{lrrrrrr}", "\\toprule",
  "Years compared & Crude rate, start / end & Change & Age composition & Age-specific rates & Composition share (\\%)$^{a}$ & Ages $\\geq$60 in composition (\\%) \\\\",
  "\\midrule", paste0(rows, " \\\\"), "\\bottomrule", "\\end{tabular}"), "tab_kitagawa.tex")

cat("pooled share of deaths aged >=60 (floor-age scheme / continuous total):\n")
aa <- read.csv(here("annual_aggregates.csv"))
cat(sum(aa$n_deaths[aa$age_floor >= 60]), "/", sum(cl$N_gt6_valid_age), "=", round(sum(aa$n_deaths[aa$age_floor >= 60]) / sum(cl$N_gt6_valid_age) * 100, 1), "%\n")
cat("deaths ages 5-34 pooled:", sum(pr$n_deaths[pr$series == "age_5_34"]), "\n")
cat("records removed by exclusions/dedup:", sum(cl$N_J45_J46 - cl$N_post_exclusions), "\n")
cat("totals:", paste(names(tot), tot, collapse = "; "), "\n")
cat("tables:", paste(list.files(here("manuscript", "tables")), collapse = ", "), "\n")
