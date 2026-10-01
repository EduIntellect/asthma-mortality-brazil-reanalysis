#' Builds the English-language figure and the LaTeX table fragments used by
#' manuscript/methods_results.tex, directly from the committed CSV outputs
#' (no numbers are typed by hand into the tables).
here <- function(...) file.path("/home/user/asthma-mortality-brazil-reanalysis/reanalysis", ...)
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

cat("pooled share of deaths aged >=60 (floor-age scheme / continuous total):\n")
aa <- read.csv(here("annual_aggregates.csv"))
cat(sum(aa$n_deaths[aa$age_floor >= 60]), "/", sum(cl$N_gt6_valid_age), "=", round(sum(aa$n_deaths[aa$age_floor >= 60]) / sum(cl$N_gt6_valid_age) * 100, 1), "%\n")
cat("deaths ages 5-34 pooled:", sum(pr$n_deaths[pr$series == "age_5_34"]), "\n")
cat("records removed by exclusions/dedup:", sum(cl$N_J45_J46 - cl$N_post_exclusions), "\n")
cat("totals:", paste(names(tot), tot, collapse = "; "), "\n")
cat("tables:", paste(list.files(here("manuscript", "tables")), collapse = ", "), "\n")
