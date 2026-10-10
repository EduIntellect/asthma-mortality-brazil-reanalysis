# U07.1 re-run: differences against main

Branch `analysis/u071-rerun`, starting commit `02ca50e` (`audit/u071`).
Comparison base: `main` at `3884c86`. Main and the manuscript sources are
unchanged.

## 1. Summary

- Adding U07.1 to the COVID-related exclusion removes one record (2021, age
  24, underlying cause J45, U07.1 in Part II), as the impact audit predicted.
  Counts for 2014–2020 and for ages 35–59 and ≥60 are unchanged.
- **Inferential differences: none.** Across all 6 + 18 + 4 + 48 + 3 trend and
  count-model estimates, no point estimate changes sign, no p value crosses
  0.05 and no 95% CI changes whether it contains zero (rule in
  `u071_compare.py`). Closest cases:
  negative binomial, age-adjusted ≥7, IBGE 2024: +1.144% (CI 0.038 to 2.263;
  p = 0.043) → +1.137% (CI 0.030 to 2.255; p = 0.044), still excluding zero;
  ages 5–34 (primary): p 0.014 → 0.016; WHO-standardised 5–34 (2018): p 0.020
  → 0.022.
- **Numerical differences:** 949 numeric cells change in 21 of 25 committed
  CSVs (detail in `u071_rerun_cells.csv`; one row per estimate in
  `u071_rerun_estimates.md`). At the precision reported in the manuscript,
  27 cited values change (section 5).
- **Interpretative differences: one**, about how the reproduction is
  described (section 6); resolved by the authors' decision to use a single
  corrected rule and declare the deviation. No substantive conclusion changes.

## 2. Execution and verification

Environment check first: the unmodified code (`02ca50e`) was run end to end
in a separate worktree with the same inputs. Every committed CSV and every
LaTeX table was reproduced byte for byte; the Word files had identical text.
The only differences were the capture date in `session_info.txt` and font
rendering in two R-drawn PNGs (`figures_comparative.png`,
`fig1_relative_change.png`; 0.8–0.9% of pixels, same data). Differences
reported below are therefore attributable to the U07.1 change, not to the
environment.

Commits on this branch:

| Commit | Content |
|---|---|
| `1341622` | `01_load_year.R`: `"U071"` added to the exclusion patterns (B342, U072 and "COVID-19" kept) |
| `d5a2e80` | Fixed-count assertions updated after the new counts were obtained and checked against the audit: 18,583 → 18,582 (continuous age >6), 18,544 → 18,543 (completed age ≥7), 1,591 → 1,590 (5–34) |
| `8653ea2` | Pinned 2014–2021 Kitagawa regression values updated; new values computed independently in Python from `annual_aggregates.csv` and the IBGE 2018 denominators. Tolerance (1e-9) unchanged |
| `dc9b328` | All outputs regenerated |

No check was removed or relaxed. Execution order, all with exit code 0:
`run_pipeline.R` (00–06 and 10), `check_fase1_reconciliation.R`,
`07_denominator_sensitivity.R` (IBGE 2024 file present),
`08_count_models_and_who_standard.R`, `09_manuscript_assets.R`,
`build_review_figures.py`, `build_docx.sh`, `build_review_figures.py`.
The first full run stopped, as expected, at the Kitagawa count check; the
second stopped at the pinned 2014–2021 Kitagawa values; both were updated in
the commits above before the final run.

Inputs (downloaded 2026-10-10 from `ckan.saude.gov.br/SIM/csv/`; all inner
CSVs dated 2025-10-21, the version recorded in `docs/data_sources.md`):

| File | sha256 |
|---|---|
| Mortalidade_Geral_2014_csv.zip | a66f562380838d050e0460c10d18b01e534f2b206a86de322fe5cace512d0d1a |
| Mortalidade_Geral_2015_csv.zip | 4a7c1cc3444c730cfecfbbe0f682072a5efb36e7dafa5ab0f88348766a6d29d4 |
| Mortalidade_Geral_2016_csv.zip | 55476c5591858484db259fdf469bf3787e6042aec96f323eccdb3e35528abb17 |
| Mortalidade_Geral_2017_csv.zip | c2ab78d74faeefecb2d6546f1992b14522666684e9e0177a67e0d04df9232893 |
| Mortalidade_Geral_2018_csv.zip | 9d9807bde1a745562504473332add042031b43212792d8aba7d746e11b6dd1f4 |
| Mortalidade_Geral_2019_csv.zip | 66501b7348ad77d8e88bcb6306d86dc555496fe65258333440998f2472c66480 |
| Mortalidade_Geral_2020_csv.zip | ac626dff18876eaa572f724966fb05cd5f42529fc6bdd5507ce5dfbd08146142 |
| Mortalidade_Geral_2021_csv.zip | 6a8fe8077cf11cbf2ae8d783d4b786968de4e7606ca52c2a04c97d864aa89e4f |
| projecoes_2018_populacao_idade_simples.xls | 69e4e6a7171bf1bbf02e5ee413f7d6a31114344711ef123277cad6de1595fc28 (matches `docs/data_sources.md`) |
| projecoes_2024_tab1_idade_simples.xlsx | 6e5c3d21a2e8ff50badd7be2785e1664b41a43277543be541641b0cd802c3205 |

Software: R 4.3.3; vroom 1.7.1, dplyr 1.2.1 and broom 1.0.13 (same as the
original `session_info.txt`); MASS 7.3-60.0.1; readxl 1.5.0.1; Python 3.13
with matplotlib 3.11.2, numpy 2.5.3, python-docx; pandoc 3.1.3.

## 3. Counts

| Quantity | main | U07.1 |
|---|---|---|
| 2021 after exclusions / valid birth date | 2,459 / 2,459 | 2,458 / 2,458 |
| 2021 continuous age >6 | 2,428 | 2,427 |
| Total after exclusions, 2014–2021 | 19,048 | 19,047 |
| Records removed by exclusion + deduplication (of them in 2020–2021) | 57 (56) | 58 (57) |
| Total with valid birth date | 19,033 | 19,032 |
| Continuous age >6 (reproduction) | 18,583 | 18,582 |
| Completed age ≥7 (standardisation, Kitagawa) | 18,544 | 18,543 |
| Ages 5–34 / 7–34, 2014–2021 | 1,591 / 1,520 | 1,590 / 1,519 |
| 2021 deaths at ages 5–34 / 7–34 | 210 / 202 | 209 / 201 |
| Share of deaths at ≥60 years | 68.2% | 68.2% |

## 4. Estimates

Full tables, one row per estimate with CI, p and flag:
`u071_rerun_estimates.md`. Main series (OLS, IBGE 2018):

| Series | % change main → U07.1 | Slope main → U07.1 (95% CI) | p main → U07.1 |
|---|---|---|---|
| Crude national (total population) | +12.49 → +12.45 | 0.0250 (0.0036 to 0.0463) → 0.0249 (0.0035 to 0.0463) | 0.029 → 0.029 |
| Crude national (population >6) | +11.9 → +11.9 | 0.0268 → 0.0268 | 0.032 → 0.033 |
| Age-standardised ≥7 (Brazil 2014) | −4.0 → −4.1 | 0.00020 (−0.0213 to 0.0217) → 0.00015 (−0.0214 to 0.0217) | 0.983 → 0.987 |
| Ages 5–34 | +20.3 → +19.7 | 0.0080 (0.0023 to 0.0138) → 0.0079 (0.0021 to 0.0138) | 0.014 → 0.016 |
| Ages 7–34 | +23.5 → +22.9 | 0.0094 (0.0031 to 0.0156) → 0.0093 (0.0029 to 0.0156) | 0.011 → 0.012 |
| Ages 35–59 | unchanged | unchanged | unchanged |

Kitagawa (completed ages ≥7, IBGE 2018). Pairs ending in 2019, 2020 and 2018
are unchanged; pairs ending in 2021:

| Pair | Crude change | Composition | Age-specific rates | Composition share | ≥60 share of composition |
|---|---|---|---|---|---|
| 2014–2021 | 0.1348 → 0.1343 | 0.19142 → 0.19144 | −0.0566 → −0.0571 | 142.0% → 142.5% | 94.8% → 94.8% |
| 2015–2021 | 0.0869 → 0.0864 | 0.1674 → 0.1674 | −0.0805 → −0.0810 | 192.7% → 193.8% | 94.9% → 94.9% |
| 2016–2021 | 0.0732 → 0.0726 | 0.1399 → 0.1399 | −0.0668 → −0.0673 | 191.3% → 192.7% | 95.2% → 95.2% |

The composition component remains positive in all six pairs; the age-specific
component keeps its sign in all six.

Tables: in every LaTeX fragment, the only rows that change are 2021 values and
summaries computed from them (`git diff main -- reanalysis/manuscript/tables/`).
Figures: pixel differences in `fig1_relative_change_ge7.jpg`,
`fig2_kitagawa_sensitivity.jpg` and `figS1_age_5_34_mortality.jpg` are
confined to the 2021 points and segments and to the age-specific bars of the
pairs ending in 2021 (plus JPEG noise along unchanged lines).

## 5. Manuscript values that change at reported precision

`manuscript.md` was not modified. These cited values are now stale:

| Location | main | U07.1 |
|---|---|---|
| Abstract, Results §1 | 18,583 deaths | 18,582 |
| Abstract, Results §2 | crude rate rose by 12.5% | 12.4% |
| Abstract | 18,544 deaths (≥7) | 18,543 |
| Abstract, Results §2, Discussion | standardised rate fell 4.0% | 4.1% |
| Abstract, Results §2 | p = 0.983 | 0.987 |
| Results §2 | 95% CI −0.0213 to 0.0217 | −0.0214 to 0.0217 |
| Results §2 | crude ≥7 rate 1.258 | 1.257 (change still +12.0%) |
| Results §2 | standardised rate 1.078 | 1.077 |
| Abstract, Results §3 | composition 62–193% | 62–194% |
| Results §3 | net increase +0.135 | +0.134 |
| Abstract, Results | NB 2024 CI 0.04 to 2.26 / 0.04 to 2.3; p = 0.043 | 0.03 to 2.26 / 0.03 to 2.3; p = 0.044 |
| Results | NB 2018 age-adjusted p = 0.10 | 0.11 |
| Results | QP age-adjusted CI −1.12 to 1.14 | −1.13 to 1.14 |
| Results | WHO ≥7, 2018: −4.2% | −4.3% |
| Results | WHO ≥7, 2024: −2.0% | −2.1% |
| Results §1 | 57 records removed, 56 in 2020–2021 | 58, 57 |
| Results §1, Discussion | published rates 1.8% to 5.4% higher | 1.8% to 5.5% |
| Results §1 | 18–59 p = 0.044 | 0.045 |
| Abstract, Results §4 | 5–34 +20.3%, p = 0.014 | +19.7%, p = 0.016 |
| Results §4 | 5–34 rate 0.219; slope 0.0080; CI 0.0023 | 0.218; 0.0079; 0.0021 |
| Results §4 | 1,591 deaths | 1,590 |
| Results §4 | 7–34 +23.5%, p = 0.011 | +22.9%, p = 0.012 |
| Results §4 | QP 5–34: 4.0% (1.2 to 7.0; p = 0.013); 2024: 4.2% (p = 0.011) | 4.0% (1.1 to 6.9; p = 0.014); 4.2% (p = 0.012) |
| Results §4 | WHO 5–34: 16.9% (p = 0.020); 19.1% (p = 0.015) | 16.4% (p = 0.022); 18.5% (p = 0.016) |
| Discussion | "one death of difference in the total count" | two deaths, one already present under the original rule and one from U07.1 |

Unchanged at reported precision: 0.025 and 0.004 to 0.046 (crude slope),
p = 0.029, 2.3% (1.0 to 3.6) negative binomial crude, dispersion 5.9, 68.2%,
13.3% to 16.3%, ~95% at ≥60, 172 to 236 deaths per year, lowest 2017 (0.175),
highest 2020 (0.244), 0.0002 slope, 35–59 results. Amaury's suggested
absolute increase for 5–34 becomes 0.036 per 100,000 (was 0.037).

Repository documentation that quotes the old counts (README, 
`audit_reproduction.md`) was not edited on this branch.

## 6. Interpretative difference and decision

The "reproduction" reported so far applied Brum et al.'s code, which does not
exclude U07.1. With the corrected rule the total at continuous age >6 is
18,582 against 18,584 published (difference 0.011%, within the 2% criterion).
The two-death difference has two sources and must not be attributed entirely
to U07.1:

- one death was already missing under the original rule (18,583). Its source
  has not been identified; the documented, unverified explanations are
  deduplication on a narrower column set than the original `distinct()` and
  possible retrospective revision of the SIM files (`audit_reproduction.md`);
- one death is the additional U07.1 exclusion (2021).

Decision (authors, 2026-10-10): a single selection rule including U07.1 is
used throughout, including the comparison with Brum et al., and the deviation
from the original code is declared. The corrected results are therefore a
reanalysis with a declared deviation, not an exact replication; values
obtained with the original rule (18,583; 18,544; 1,591) are historical and
are labelled as such in `audit_reproduction.md` and the README.

Every other claim in the Abstract, Results and Discussion keeps its direction
and significance class:

- national age-standardised trend not distinguishable from zero (p = 0.987);
- only one of six age-adjusted count specifications excludes zero (NB, IBGE
  2024), and it still does;
- composition component positive in all six pairs and larger than the net
  increase where age-specific rates fall;
- increase at ages 5–34 significant in all reported specifications
  (largest p = 0.022).

## 7. Reproduce the comparison

```sh
python3 reanalysis/audit/u071_compare.py main   # writes u071_rerun_cells.csv
```
