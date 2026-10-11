# {{TITLE}}

Francisco Federico García Crespi¹ · Amaury de Souza²

¹ Universidad Miguel Hernández, Elche, Alicante, Spain. ² Institute of Physics, Federal University of Mato Grosso do Sul, Campo Grande, MS, Brazil.

Correspondence. Francisco Federico García Crespi, fedeg@umh.es. Author details and declarations are retained from the reviewed PDF and require confirmation in the accompanying checklist.

## Abstract

Objective. To assess whether the reported increase in crude asthma mortality in Brazil during 2014–2021 persists after age standardisation among people aged ≥7 years, and to examine mortality within ages 5–34.

Methods. We reproduced the historical analysis and revised record selection using completed calendar age, COVID exclusions including U071, and retention of two 2018 records whose identity could not be established. The primary analysis used IBGE 2018 denominators and Brazil 2014 standard weights, normalised within each age range. Kitagawa decomposition described the contributions of age composition and age-specific rates to changes in crude mortality. Sensitivities examined IBGE 2024, WHO weights, count models, alternative selection rules and pandemic-period restrictions.

Results. {{ABSTRACT_RESULTS}}

Conclusion. Changes in population age composition accounted for much of the crude increase at ages ≥7 in a descriptive decomposition. The primary national age-standardised estimate was compatible with trends in either direction. Standardisation within 5–34 supported an increase over 2014–2021 and after excluding 2020; the shorter prepandemic series remained inconclusive about the annual trend. Surveillance should report crude, age-standardised and age-specific rates together.

Keywords. Asthma; Mortality; Age Distribution; Population Dynamics; Reproducibility of Results; Brazil.

## Introduction

Brum et al. concluded that "asthma mortality remains high and shows an increasing trend for the first time in the past decades" [1]. Their nationwide analysis for 2014–2021 identified 18,584 asthma deaths and reported an annual increase of approximately 2.5%. Cardoso et al., studying 2013–2023, also concluded that asthma-related deaths had increased [2]. They based this conclusion on annual death counts and reported a stable overall mortality rate per 100,000 habitants. These measures describe different aspects of mortality. Neither establishes an increase in the national age-standardised rate.

Earlier Brazilian surveillance offers a longer perspective. Graudenz et al. reported a linear decline in age-standardised asthma mortality among people aged 5–34 during 1980–2014 and a non-linear trend in the general population [3]. Differences in periods, age ranges and rate definitions limit direct comparison with recent estimates and prevent identification of a historical trend reversal.

Population ageing is relevant to this comparison because approximately two thirds of asthma deaths occurred among people aged ≥60 [1,2]. Changes in age composition can raise crude mortality even when age-specific rates do not increase. Neither Brum et al. nor Cardoso et al. directly age-standardised the national series. Brum et al.'s public code [4] provides an opportunity to examine case selection, population denominators and trend estimates before reassessing the mortality pattern.

We examined whether the reported increase in Brazilian asthma mortality during 2014–2021 persisted when population age structure was held fixed. We first reproduced Brum et al.'s analysis and documented agreements and discrepancies with the published results. We then estimated national rates among people aged ≥7 years and rates within ages 5–34, standardising separately within each range. We also used Kitagawa decomposition to describe the contributions of changes in age composition and age-specific rates to the crude-rate change. Post hoc sensitivity analyses examined alternative population projections, WHO weights, count models, selection rules and pandemic-period restrictions. These analyses distinguish the observed crude increase from the national and age-specific trends supported by the data.

## Methods

### Study design and reference reproduction

This secondary ecological analysis examined national underlying-cause asthma mortality in Brazil during 2014–2021. The corrected primary population comprised people aged ≥7 completed years. We analysed ages 5–34 separately and used the nested 7–34 group to assess sensitivity to ages five and six; 35–59 and ≥60 provided further comparisons. The historical analysis using continuous age >6 was reproduced separately. The primary analysis retained IBGE 2018 denominators and Brazil 2014 standard weights. WHO, IBGE 2024, count models, Kitagawa decomposition and alternative selection and periods provided sensitivity or descriptive analyses. We applied no multiple-testing correction.

We reproduced the historical analysis against the archived manuscript and versioned analytical code. Provenance details are reported under Software, reproducibility and ethics.

### Selection, COVID mentions and record identity

We selected records whose underlying cause field, CAUSABAS, contained ICD-10 J45 or J46 [5]. To retain the historical search scope, the corrected COVID rule searched LINHAA, LINHAB, LINHAC, LINHAD and LINHAII for B342, U072, U071 or literal COVID-19. A match in any field excluded the record once. We logged each code frequency and overlapping combination separately. Sensitivities used the original rule without U071 or retained all records with COVID mentions.

The historical deduplication key combined parsed death date, elapsed-days age, underlying cause and the five cause lines. It collapsed 2018 source rows 971828 and 971831. Inspection of all public fields found differences in occupation and seven administrative fields (NUMEROLOTE, TPPOS, DTCADASTRO, DTRECEBIM, DTRECORIGA, DIFDATA and CONTADOR). The SIM dictionary identifies NUMERODO as the death-declaration number and describes registration and receipt dates as administrative information [12]. NUMERODO is absent from these CSVs. The available fields therefore do not establish whether the rows refer to the same death. We retained both in the primary analysis and assessed their collapse under the historical key as a sensitivity.

### Calendar ages and analytical domains

Completed age was the difference between death and birth years, reduced by one if death preceded that year's birthday. For births on 29 February, the anniversary in a non-leap year was 1 March. We added a leading zero to seven-digit day-month-year strings and required an eight-digit valid calendar date. Missing or uninterpretable dates and birth after death were excluded and logged separately. We applied no upper-age exclusion and grouped ages ≥90 into the IBGE 90+ interval.

Calendar age defined the ≥7, 5–34, 7–34, 35–59 and ≥60 groups. One sensitivity used days/365.25, with its floor defining single-year bins. The historical reproduction retained the continuous >6 threshold as a separate population.

### Denominators and direct standardisation

National single-year populations for both sexes came from IBGE's 2018 revision [6]; the 2024 revision following the 2022 Census provided a sensitivity [7]. We used the total-population block on sheet BR in the 2018 workbook and SIGLA = BR with SEXO = Ambos in the 2024 workbook. Both provide ages 0–89 and an open 90+ interval. Corrected crude rates matched each numerator to the same population age range. To reproduce the historical construction, we divided continuous-age >6 deaths by the entire population and separately by population ≥7. The latter comparator retains the small mismatch between its historical numerator and denominator.

For age domain D and year t, we calculated the directly standardised rate as follows.

ASR(t,D) = Σ[a∈D] w(a,D) × 100,000 × deaths(a,t) / population(a,t).

w(a,D) = population(a,2014) / Σ[j∈D] population(j,2014), so Σ[a∈D] w(a,D) = 1.

Weights were fixed across years and normalised separately within each age domain, including 5–34 and 7–34. Each denominator revision supplied its own Brazil 2014 standard population. Deaths and population at ≥90 shared one open interval. WHO standardisation used five-year bands [8], combining the 90–94, 95–99 and ≥100 weights for 90+. We allocated three fifths of the WHO 5–9 weight to 7–9 before normalisation, assuming a uniform distribution within that band. Missing death-count cells were assigned zero; population cells had to be complete and positive. We checked that Brazil-2014-standardised and aligned crude rates were equal in 2014.

### Trends, count models and sensitivity scenarios

We fitted Gaussian-family GLMs to national crude and Brazil-standardised annual rates and ordinary least squares to age-group and WHO-standardised rates. The identity-link Gaussian trends are numerically equivalent to OLS. Slopes were expressed as deaths per 100,000 per year, with t intervals using n−2 residual degrees of freedom. We reported absolute and relative endpoint changes separately from annual slopes.

Count models used log-link Poisson, quasi-Poisson and negative binomial families [9]. For unadjusted age domains, log E[Y(t)] = α + β × year(t) + log population(t). The national age-adjusted model was log E[Y(b,t)] = α + γ(b) + β × year(t) + log population(b,t). Its nine categorical bands were 7–14 (reference), 15–24, 25–34, 35–44, 45–54, 55–64, 65–74, 75–84 and 85+. Annual percentage change was APC = 100 × (exp β − 1), with intervals obtained by transforming β ± critical value × SE. Quasi-Poisson used the t distribution with model residual degrees of freedom; Poisson and negative binomial used normal Wald intervals.

Quasi-Poisson scales Poisson coefficient variance by estimated dispersion. Negative binomial estimates the quadratic variance function μ + μ²/θ and can change coefficients as well as uncertainty. For every specification, we recorded Pearson dispersion, θ, mean-model convergence, iterations, errors and warnings. Large θ estimates with iteration warnings were interpreted as approaching the Poisson limit; these warnings prevent a claim of successful θ convergence or exact equivalence to Poisson.

Each sensitivity changed one condition from the corrected primary analysis. We examined elapsed-days age, the original COVID rule, retention of all COVID mentions, the historical deduplication key, exclusion of 2020 and restriction to 2014–2019. The last two focused on 5–34 and 7–34 and retained actual calendar years as covariates. Excluding 2020 left seven observations and 5 trend residual degrees of freedom; restriction to 2014–2019 left six and 4. We evaluated both denominator revisions and both standards and reported every model regardless of statistical significance.

### Kitagawa accounting decomposition

For the corrected ≥7 population, symmetric Kitagawa decomposition [11] partitioned crude differences into an age-composition term C and an age-specific-rate term R.

C = Σ[a] (w(a,1) − w(a,0)) × (r(a,0) + r(a,1)) / 2.

R = Σ[a] (r(a,1) − r(a,0)) × (w(a,0) + w(a,1)) / 2.

Crude(1) − crude(0) = C + R, with r in deaths per 100,000 and each year's w normalised within ≥7.

We used the same six endpoint pairs with IBGE 2018 and 2024, namely 2014–2021, 2014–2019, 2014–2020, 2015–2021, 2016–2021 and 2014–2018. We checked the identities at full precision before rounding each displayed component independently. This can produce a discrepancy in the last displayed digit. Shares above 100% indicate that a negative rate term offsets part of the composition term. The decomposition is descriptive and does not identify causal mechanisms.

### Software, reproducibility and ethics

We used R 4.6.1 [10] for reproduction and revision; the reference reported R 4.3.3. The code records package versions, configurations, input hashes, warnings and independent checks, including numerical differences under the current environment. Public inputs, verified extraction code and separate scenario outputs support reproduction. Code and revision outputs are available at https://github.com/EduIntellect/asthma-mortality-brazil-reanalysis/tree/revision/amaury-review .

We reconciled the archived 12-page manuscript of 10 October 2026 with a Word copy of concordant content and repository commit 3884c868a07164710a2e358180b3034f9cdcf642. Official SIM archives recovered on 11 October 2026 reproduced the versioned selection counts and year-age aggregates exactly. Historical execution hashes were available for SIM 2020–2021 only, so byte identity with the historical 2014–2019 files could not be established. The accompanying provenance manifest records the reference PDF hash and all verified input hashes.

The historical workflow used Claude Code and GitHub Copilot. This revision used Codex for code, analysis checking and editorial drafting. Figures were plotted directly from analytical results. Both authors' review and approval of the final work remain pending.

The study used public SIM mortality records and aggregate IBGE projections, with no participant contact, and reports only aggregate results. Formal ethics approval or exemption has not been documented. The applicable institutional and journal wording requires author confirmation, as detailed in the accompanying checklist.

## Results

### Historical reproduction and corrected selection

The historical pipeline reproduced 19,105 underlying-cause candidates, 56 COVID exclusions, one reduced-key removal, 15 uninterpretable ages and 18,583 deaths at continuous age >6. Brum et al. reported 18,584 deaths [1]. All versioned selection counts, annual age aggregates and IBGE-2018 denominators matched exactly. Rate and trend differences were at floating-point scale. Negative binomial θ estimates differed slightly under the current environment in models approaching the Poisson limit, with no change in significance classifications. Supplementary Table S3 documents the unresolved original population series and age-group discrepancies.

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

The corrected analysis found an increase in aligned crude asthma mortality among people aged ≥7 between 2014 and 2021. With Brazil 2014 age weights held fixed, the endpoint change was negative and the slope across all eight years was close to zero. The interval was compatible with trends in either direction and does not demonstrate stability. The positive age-adjusted negative binomial estimate with IBGE 2024 shows that national trend inference also depends on the model and population revision.

Age composition contributed positively to the crude change for every endpoint pair under both population revisions. In some pairs, the composition term exceeded the net increase because the age-specific-rate term was negative. The decomposition explains how population composition and rates combine arithmetically; it cannot identify effects of death certification, treatment access or the pandemic. Endpoint comparisons and slopes across all annual observations describe different aspects of the series.

Both crude and standardised mortality within ages 5–34 increased over 2014–2021. Standardising within this range accounts for changes in its internal age distribution. The nested 7–34 analysis assesses how including ages five and six affects the estimate and does not provide independent replication.

Extension of the finding across periods depends on the analysis. The primary Brazil-standardised slope retained a positive interval after excluding 2020; the corresponding WHO sensitivity with IBGE 2018 included zero. The shorter prepandemic primary estimate was imprecise and its interval included zero. Its positive endpoint contrast alone does not establish an annual trend over 2014–2019. The observed increase over 2014–2021 warrants continued surveillance, while differences in study periods and age definitions prevent identification of a change point or reversal of the earlier decline reported by Graudenz et al. [3].

Interpretation also depends on which records enter each analysis. The selection audit shows why equal ≥7 totals need not represent the same records. Retaining one ambiguous 2018 record and excluding one additional U071 record in 2021 cancel in the total. Calendar age also changed single-year bins without changing membership in the five age domains, affecting the age distribution used in standardisation and count models. Separate sensitivities identify the effect of each alternative selection rule.

The ecological design, short annual series, post hoc sensitivity analyses, unadjusted multiple comparisons and possible changes in death certification limit interpretation. Public fields cannot establish whether the 2018 pair represents one death. Historical execution hashes for SIM 2014–2019 and the population workbook used by Brum et al. remain unavailable. Exact reproduction of recorded counts and aggregates therefore cannot establish historical file identity.

Negative binomial θ iteration warnings near the Poisson limit limit confidence in dispersion estimation. We retained every model and its warnings to make these limitations visible. Statistical intervals quantify model uncertainty; they do not capture uncertainty in record selection, certification or population reconstruction.

These findings support reporting aligned crude, age-standardised and age-specific mortality together. Age composition accounted for much of the crude increase among people aged ≥7. The increase within 5–34 over 2014–2021 merits attention, with interpretation bounded by prepandemic uncertainty and sensitivity to model assumptions.

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
