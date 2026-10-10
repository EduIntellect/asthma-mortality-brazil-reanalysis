# Audit: U07.1 in the COVID-related exclusion (SIM 2020–2021)

Status: impact audit, completed. Outcome: the authors adopted a single selection
rule that adds U07.1; the full re-run and its comparison with the previous outputs
are in `u071_rerun_diff.md`. Figures below are those of the audit (before the
re-run); for example, 18,544 is the completed-age ≥7 total under the original rule.

## Question

The canonical case selection (`R/01_load_year.R`, reproducing Brum et al.)
excludes asthma deaths (underlying cause J45/J46) whose cause-of-death lines
(LINHAA–LINHAD, LINHAII) contain `B342`, `U072` or the text `COVID-19`.
ICD-10 U07.1 (COVID-19, virus identified) is not in that list. The co-author
review asked whether this omission changes the analytical sample.

## Method

`R/11_audit_u071.R`:

1. Re-runs the canonical loader on the SIM files for 2020 and 2021 and stops
   unless they reproduce the committed counts in `data/fase2_year_counts.csv`
   (J45/J46 records, post-exclusion, valid birth date, continuous age >6).
   Both years matched the committed counts exactly.
2. Flags asthma records with `U071` in any cause line, and those already
   excluded by the current rule.
3. Applies the canonical downstream steps (deduplication on the loaded
   fields, valid birth date, age filters) with and without U07.1 added to
   the exclusion, by year and analytical group.

Only aggregate counts are written. U07.1 was introduced in 2020, so earlier
years cannot contain it.

Input files (official portal, `ckan.saude.gov.br/SIM/csv/`, downloaded
2026-10-10; inner CSVs dated 2025-10-21, the same version recorded in
`docs/data_sources.md`):

| File | sha256 |
|---|---|
| Mortalidade_Geral_2020.csv | 2fdd9fcc8924d8da0db6f816d528a9221a56164c8e494803ce0085368c07464f |
| Mortalidade_Geral_2021.csv | 79cfbfff330f3ee545a0417ddf969e3d3cff4caa3f67ca2bdbc8fad9e459b424 |

## Results

Outputs: `audit/u071_impact_counts.csv`, `audit/u071_record_profile.csv`.

| | 2020 | 2021 |
|---|---|---|
| Asthma records (J45/J46) | 2,735 | 2,488 |
| With U07.1 in any cause line | 18 | 19 |
| Already excluded by the current rule | 18 | 18 |
| Additional exclusions if U07.1 is added | 0 | 1 |

The single additional record (2021) has underlying cause J45, U07.1 in Part II
(LINHAII, contributing conditions), a valid birth date and a completed age in
7–34 years. It therefore belongs to the analytical population and to the
continuous-age >6, completed-age ≥7, 5–34 and 7–34 samples.

Effect on analytical counts (2021 only; 2020 unchanged):

| Sample | Current rule | With U07.1 |
|---|---|---|
| Continuous age >6 (reproduction) | 2,428 | 2,427 |
| Completed age ≥7 (standardisation, Kitagawa) | 2,423 | 2,422 |
| Ages 5–34 | 210 | 209 |
| Ages 7–34 | 202 | 201 |
| Ages 35–59 and ≥60 | unchanged | unchanged |

Approximate effect on the 5–34 and 7–34 trends, recomputed from the committed
annual series with the 2021 count reduced by one (same OLS specification; not
a pipeline re-run):

| Series | Change 2014–2021 | Slope per year | p |
|---|---|---|---|
| 5–34, current | +20.3% | 0.0080 | 0.014 |
| 5–34, with U07.1 | +19.7% | 0.0079 | 0.016 |
| 7–34, current | +23.5% | 0.0094 | 0.011 |
| 7–34, with U07.1 | +22.9% | 0.0093 | 0.012 |

For the national series the record is 1 of 18,544 deaths at completed ages ≥7
(0.005%); its effect on the standardised trend and the decomposition was not
recomputed.

For information only: two 2021 asthma records mention U09.9 (post-COVID-19
condition); neither rule excludes them.

## Reproduce

```sh
# SIM 2020 and 2021 in reanalysis/data_raw/ (see docs/data_sources.md)
Rscript reanalysis/R/11_audit_u071.R   # requires vroom and dplyr
```

Run the script at commit `02ca50e`. It checks the canonical loader against the
committed counts of the original rule, so from `1341622` onwards (U07.1 added
to `01_load_year.R`, outputs regenerated) its first check stops by design.
