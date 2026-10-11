# {{TITLE}}

Francisco Federico García Crespi¹ · Amaury de Souza²

¹ Universidad Miguel Hernández, Elche, Alicante, Spain. ² Institute of Physics, Federal University of Mato Grosso do Sul, Campo Grande, MS, Brazil.

Correspondence: Francisco Federico García Crespi, fedeg@umh.es. Author details and declarations are carried forward from the reviewed PDF for confirmation in the accompanying author checklist.

## Abstract

Objective: To assess whether the reported crude increase in Brazilian asthma mortality during 2014–2021 persists after age standardisation in the national domain of completed ages ≥7, and to examine mortality within ages 5–34.

Methods: We reproduced the historical pipeline, then corrected age to completed calendar years, included U071 in COVID exclusions, and retained an ambiguous pair of 2018 records. Primary denominators were IBGE 2018 and the fixed standard was Brazil 2014, normalised within each domain. IBGE 2024, WHO standardisation, count models, alternative selection rules and pandemic-period restrictions were sensitivity analyses.

Results: {{ABSTRACT_RESULTS}}

Conclusion: Changes in population age composition accounted for much of the crude increase at ages ≥7, without a causal attribution. The primary national age-standardised estimate did not establish an increasing trend or demonstrate stability. Within-5–34 standardisation supported an increase across 2014–2021, including after excluding 2020; the shorter prepandemic series was inconclusive about the annual trend. Surveillance should report crude, age-standardised and age-specific rates jointly.

Keywords: Asthma; Mortality; Age Distribution; Population Dynamics; Reproducibility of Results; Brazil.

## Introduction

{{INTRODUCTION}}

## Methods

### Study design and reference reproduction

This secondary, ecological analysis reassessed national underlying-cause asthma mortality in Brazil, 2014–2021. The national corrected primary domain was completed ages ≥7; ages 5–34 were analysed separately, with the nested 7–34 group as a technical control and 35–59 and ≥60 as additional comparisons. We maintained a distinct reproduction of the historical continuous-age >6 construction. Brazil 2014 and IBGE 2018 remained the primary standard and denominator revision. WHO, IBGE 2024, count models, Kitagawa decomposition and the selection and pandemic sensitivities were robustness or descriptive analyses; no multiple-testing correction was applied.

The reference was the 12-page PDF emailed to Amaury on 10 October 2026, SHA-256 fc552ab83d5254549fa4f1dfe880ab631a26c50bc8d861bfdc433331544e71fe, reconciled with a Word copy of concordant content and repository commit 3884c868a07164710a2e358180b3034f9cdcf642. Current official SIM archives were recovered and verified on 11 October 2026. Their historical selection and year-age aggregates exactly reproduced the versioned pipeline. Historical SIM hashes were available for 2020–2021, but not for the execution of 1 October in 2014–2019; numerical reproduction does not establish byte identity for the latter files.

### Selection, COVID mentions and record identity

Records were selected when CAUSABAS contained ICD-10 J45 or J46 [5]. The corrected COVID rule excluded the union of B342, U072, U071 or literal COVID-19 in LINHAA, LINHAB, LINHAC, LINHAD or LINHAII, retaining the historical five-field scope. Frequencies and overlapping code combinations were logged separately; overlapping mentions were counted once. The original rule without U071 and a rule retaining every COVID mention were separate sensitivities.

The historical reduced key comprised parsed death date, elapsed-days age, underlying cause and the five cause lines. It collapsed source rows 971828 and 971831 in 2018. Inspection of all available fields found differences in occupation and seven administrative fields (NUMEROLOTE, TPPOS, DTCADASTRO, DTRECEBIM, DTRECORIGA, DIFDATA and CONTADOR). The SIM dictionary describes NUMERODO as the death-declaration number, registration date as administrative, and receipt date as the latest central update [12]. NUMERODO is absent from these public CSVs. Matching dates, causes or administrative fields therefore could not establish that both rows describe one death. We retained both in the corrected principal and evaluated the historical-key collapse as a sensitivity, without asserting that the events are distinct or identical. No additional deduplication rule or linkage was invented.

### Calendar ages and analytical domains

Completed age equalled death year minus birth year, minus one if the death preceded that year's anniversary. For a birth on 29 February, the anniversary in a non-leap year was 1 March. Seven-digit day-month-year strings received one leading zero; dates otherwise had to be eight digits and exactly valid in the calendar. Missing or non-interpretable dates and birth after death were excluded and logged separately. No upper-age exclusion was introduced. Ages 90 and above were grouped as 90+ to match IBGE.

Calendar ages defined ≥7, 5–34, 7–34, 35–59 and ≥60. A sensitivity substituted days/365.25 and its floor for single-year bins. The historical reproduction retained its continuous >6 threshold; it was not re-labelled ≥7 or merged with the corrected sample.

### Denominators and direct standardisation

Both-sex national single-year populations came from the 2018 IBGE revision [6], with the post-2022-Census 2024 revision as a sensitivity [7]. The 2018 workbook used the total-population block on sheet BR; the 2024 workbook used SIGLA = BR and SEXO = Ambos. Both provide ages 0–89 and the open 90+ interval. Each corrected crude numerator and denominator covered exactly the same domain. The historical crude reproduction instead divided continuous-age >6 deaths by the entire population; a historical comparator used population ≥7, preserving its small age-domain mismatch for transparency.

For domain D and year t, direct standardisation was:

ASR(t,D) = Σ[a∈D] w(a,D) × 100,000 × deaths(a,t) / population(a,t).

w(a,D) = population(a,2014) / Σ[j∈D] population(j,2014), so Σ[a∈D] w(a,D) = 1.

Weights were fixed across years and normalised separately within each domain, including 5–34 and 7–34. For each denominator revision, the Brazil-2014 standard was that revision's 2014 population. The 90+ deaths and population used a single matching open interval. WHO standardisation used five-year bands [8], adding the 90–94, 95–99 and ≥100 weights for 90+. For 7–9, three fifths of the WHO 5–9 weight was allocated before domain normalisation. This is a uniform-within-band approximation, not an observed age distribution. Missing death-count cells were filled with zero; population cells had to be complete and positive. Brazil-2014-standardised and aligned crude rates were checked for equality in 2014.

### Trends, count models and sensitivity scenarios

National crude and Brazil-standardised annual rates used Gaussian-family GLMs; age-group and WHO-standardised rates used ordinary least squares. These identity-link Gaussian trends are numerically equivalent to OLS. Slopes were in deaths per 100,000 per year, with t intervals using n−2 residual degrees of freedom. Endpoint absolute and relative changes were reported separately from fitted annual slopes.

Count models used log-link Poisson, quasi-Poisson and negative binomial families [9]. For unadjusted domains, log E[Y(t)] = α + β × year(t) + log population(t). The national age-adjusted model was log E[Y(b,t)] = α + γ(b) + β × year(t) + log population(b,t), with nine categorical bands: 7–14 (reference), 15–24, 25–34, 35–44, 45–54, 55–64, 65–74, 75–84 and 85+. APC = 100 × (exp β − 1); intervals transformed β ± critical value × SE. Quasi-Poisson used the t distribution with model residual degrees of freedom; Poisson and negative binomial used normal Wald intervals. Quasi-Poisson scales the Poisson coefficient variance by estimated dispersion; negative binomial instead estimates a quadratic variance function μ + μ²/θ, which can also change coefficients. Pearson dispersion, θ, mean-model convergence, iterations, errors and warnings were recorded for every specification. A large θ with an iteration warning was reported as an approximation toward the Poisson limit, not exact equivalence or successful θ convergence.

Alongside the historical reference and corrected principal, one condition at a time was changed: elapsed-days age, original COVID rule, retention of all COVID mentions, historical deduplication key, exclusion of 2020, or restriction to 2014–2019. The latter two focused on 5–34 and 7–34. Actual calendar years were retained as covariates: exclusion of 2020 left seven observations and 5 trend residual degrees of freedom; 2014–2019 left six and 4. Both denominator revisions and both standards were evaluated, and no model was selected for statistical significance.

### Kitagawa accounting decomposition

For the same corrected ≥7 population, the symmetric Kitagawa decomposition [11] partitioned crude differences into composition C and age-specific-rate R terms:

C = Σ[a] (w(a,1) − w(a,0)) × (r(a,0) + r(a,1)) / 2.

R = Σ[a] (r(a,1) − r(a,0)) × (w(a,0) + w(a,1)) / 2.

Crude(1) − crude(0) = C + R, with r in deaths per 100,000 and each year's w normalised within ≥7.

The same six endpoint pairs were used with IBGE 2018 and 2024: 2014–2021, 2014–2019, 2014–2020, 2015–2021, 2016–2021 and 2014–2018. Full-precision identities were checked before rounding. Each displayed component was rounded independently, so the final displayed digit need not add exactly. Shares greater than 100% indicate an opposing negative rate term. This descriptive accounting does not identify causal mechanisms.

### Software, reproducibility and ethics

Reproduction and revision used R 4.6.1 [10]; package versions, configurations, input hashes, warnings and independent checks accompany the code. R 4.3.3 was reported in the reference. Historical numerical differences under the current environment are documented without claiming an identical software stack. Public inputs, verified extraction code and isolated scenario outputs support reruns. The original repository is https://github.com/EduIntellect/asthma-mortality-brazil-reanalysis; this revision is prepared locally for author review and has not been published there.

Generative AI tools were used in the historical workflow (Claude Code and GitHub Copilot) and in this revision (Codex) for code, analysis checking and editorial drafting. Figures were plotted from results, not generated as AI images. This statement does not assert that both authors have completed their review or approved the revision.

The study used public SIM mortality records and aggregate IBGE projections, with no participant contact. Only aggregate results are reported. No formally granted ethics approval or exemption is claimed; applicable institutional and journal wording requires author confirmation, as listed in the accompanying checklist.

## Results

### Historical reproduction and corrected selection

The complete historical pipeline reproduced 19,105 underlying-cause candidates, 56 COVID exclusions, one reduced-key removal, 15 non-interpretable ages and 18,583 deaths at continuous age >6, versus 18,584 in Brum et al. [1]. All versioned selection counts, annual age aggregates and IBGE-2018 denominators matched exactly. Rate and trend differences were at floating-point scale; negative-binomial theta differed slightly under the current environment in models approaching the Poisson limit, without changing the reported significance classes. The unresolved original population series and age-group discrepancies remain in the historical audit (Supplementary Table S3).

{{SELECTION_RESULTS}}

### National domain of completed ages ≥7

{{NATIONAL_RESULTS}}

{{COUNT_RESULTS}}

### Composition of the crude-rate change at ≥7

{{KITAGAWA_RESULTS}}

### Mortality within ages 5–34 and sensitivity analyses

{{YOUNG_RESULTS}}

{{PANDEMIC_RESULTS}}

{{COVID_RESULTS}}

## Discussion

The corrected analysis reproduced the historical crude finding while separating it from the national domain of completed ages ≥7. Aligned crude mortality increased between 2014 and 2021, but the Brazil-2014-standardised endpoint change was negative and the slope across all eight years was close to zero. Its uncertainty admits trends in either direction and cannot demonstrate stability. The positive negative-binomial estimate using IBGE 2024 also prevents a claim that all national age-adjusted specifications exclude an increase.

The decomposition showed positive age-composition contributions across every endpoint pair with both denominator revisions. For some pairs the composition term exceeded the net crude increase because the age-specific-rate term was negative. These quantities describe changes in rates and population composition rather than identify causes of death, certification changes, treatment access or pandemic effects. Endpoint contrasts should not substitute for the trend across all annual observations.

Within ages 5–34, both crude and standardised mortality increased across 2014–2021. Standardising inside the range matters because even a comparatively young domain can change its internal age distribution. The primary Brazil-standardised slope retained a positive interval after removal of 2020, while the WHO sensitivity with IBGE 2018 included zero. The shorter prepandemic primary estimate was imprecise and its interval included zero. Neither that imprecision nor the positive endpoint contrast establishes a prepandemic annual trend. The nested 7–34 analysis supports sensitivity to the inclusion of ages five and six, rather than independent confirmation. These findings warrant continued surveillance but do not establish a change point or a reversal of the earlier decline reported by Graudenz et al. [3].

The U071 correction, explicit calendar ages and conservative treatment of the ambiguous pair improve the transparency of selection. Equality of the revised and historical ≥7 totals masks different individual records and distributions. Calendar age shifted single-year bins even without changing the five named domain memberships, which can affect direct standardisation and band-based models. Alternative COVID rules, retention of mentions and key-based deduplication are reported as sensitivity scenarios rather than silently blended corrections.

Limitations include the ecological design, short annual series, post hoc robustness analyses, unadjusted multiple comparisons and possible changes in death certification. Public-field linkage cannot determine the true identity of the 2018 pair. For SIM 2014–2019, absent historical execution hashes prevent verification of byte identity, despite exact reproduction of recorded counts and aggregates. The population workbook used by Brum et al. remains unavailable. Negative-binomial theta iteration warnings near the Poisson limit also limit claims about dispersion convergence; they do not justify hiding models or selecting a family by its p value. Statistical intervals quantify model uncertainty rather than uncertainty from record selection, certification or population reconstruction.

The study supports joint reporting of aligned crude, age-standardised and age-specific mortality. Population composition accounted for much of the corrected crude increase at ≥7. Evidence of an increase within 5–34 over 2014–2021 merits attention, with the prepandemic uncertainty and sensitivity to modelling clearly stated.

## Funding

No funding was received for this study. This declaration is retained from the reviewed PDF and awaits confirmation of both authors' circumstances in the accompanying checklist.

## Conflicts of interest

The authors declare no conflicts of interest. This declaration is retained from the reviewed PDF and awaits confirmation by both authors.

## Author contributions

Author order and affiliations are carried forward from the reviewed PDF. Final CRediT contributions and completion of each author's scientific review require confirmation before submission; no completed validation is asserted here.

## References

{{REFERENCES}}

## Table 1. Historical comparators and corrected primary rates, Brazil, 2014–2021

{{TABLE1}}

Rates and absolute changes are per 100,000. Slopes are per 100,000 per year with t-based 95% intervals, six residual degrees of freedom. Δ is the endpoint difference; Δ % is the relative endpoint change. Corrected rows use calendar age, U071-inclusive COVID exclusions and retention of both ambiguous 2018 records. Historical rows retain continuous >6 and their original denominators. IBGE 2018 is used throughout this table; primary ASR uses Brazil 2014 weights normalised inside the specified domain.

## Figure 1. Relative changes from 2014

![Figure 1. Corrected aligned crude and Brazil-2014-standardised national rates for completed ages ≥7, plus rates standardised within 5–34. IBGE 2018 denominators; changes relative to each series' own 2014 rate.](figures/Figure1.png)

## Figure 2. Kitagawa sensitivity to population revision

![Figure 2. Corrected ≥7 crude-rate changes partitioned into age-composition and age-specific-rate components for six pairs, with IBGE 2018 and 2024. Components sum to net change before rounding and are not causal effects.](figures/Figure2.png)
