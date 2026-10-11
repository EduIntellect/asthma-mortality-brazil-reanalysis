# Reassessing asthma mortality in Brazil during 2014–2021 through reproduction and age-specific analysis

Francisco Federico García Crespi¹ · Amaury de Souza²

¹ Universidad Miguel Hernández, Elche, Alicante, Spain. ² Institute of Physics, Federal University of Mato Grosso do Sul, Campo Grande, MS, Brazil.

Correspondence. Francisco Federico García Crespi, fedeg@umh.es. Author details and declarations were confirmed during preparation of this revision.

## Abstract

Objective. To assess whether rising crude asthma mortality in Brazil during 2014–2021 persists after standardisation at ages ≥7, and examine mortality within ages 5–34.

Methods. This ecological study reproduced the analysis and revised selection using calendar age, COVID exclusions including U071, and retention of two 2018 records without confirmed shared identity. The primary analysis used Brazilian Institute of Geography and Statistics (IBGE) 2018 denominators and Brazil 2014 standard weights, normalised within each age range. Kitagawa decomposition described the contributions of age composition and age-specific rates to changes in crude mortality. Sensitivities examined IBGE 2024, World Health Organization (WHO) weights, count models, selection rules and pandemic-period restrictions.

Results. Historical selection reproduced 18,583 deaths with continuous age >6; the published count was 18,584. The corrected national analysis of completed ages ≥7 included 18,544 deaths. Aligned crude mortality increased 12.0%; Brazil-2014-standardised mortality changed -4.1% between endpoints (eight-year slope 0.0002; 95% CI -0.0214 to 0.0217; p = 0.986). Within ages 5–34, Brazil-2014-standardised mortality increased 18.0% (0.0328 per 100,000; p = 0.018). Its slope remained positive excluding 2020 (p = 0.040); the 2014–2019 interval included zero (p = 0.107).

Conclusions. Changes in population age composition accounted for much of the crude increase at ages ≥7 in a descriptive decomposition. The primary national age-standardised estimate was compatible with trends in either direction. Within 5–34, primary Brazil-2014 standardisation supported an increase over 2014–2021 and after excluding 2020; the shorter prepandemic series remained inconclusive about the annual trend. Surveillance should report crude, age-standardised and age-specific rates together.

Keywords. Asthma; Mortality; Age Distribution; Population Dynamics; Reproducibility of Results; Brazil.

## Introduction

One nationwide study concluded that "asthma mortality remains high and shows an increasing trend for the first time in the past decades" [1]. That analysis for 2014–2021 identified 18,584 asthma deaths and reported an annual increase of approximately 2.5%. Another study of 2013–2023 concluded that asthma-related deaths had increased [2]. The latter conclusion relied on annual death counts, although the overall mortality rate per 100,000 inhabitants was reported as stable. These measures describe different aspects of mortality. Neither establishes an increase in the national age-standardised rate.

Earlier Brazilian surveillance offers a longer perspective. An earlier study reported a linear decline in age-standardised asthma mortality among people aged 5–34 during 1980–2014 and a non-linear trend in the general population [3]. Differences in periods, age ranges and rate definitions limit direct comparison with recent estimates and prevent identification of a historical trend reversal.

Population ageing is relevant to this comparison because approximately two thirds of asthma deaths occurred among people aged ≥60 [1,2]. Changes in age composition can raise crude mortality even when age-specific rates do not increase. Neither recent study directly age-standardised the national series. Public code for the first study [4] provides an opportunity to examine case selection, population denominators and trend estimates before reassessing the mortality pattern.

We examined whether the reported increase in Brazilian asthma mortality during 2014–2021 persisted when population age structure was held fixed. We first reproduced the first study's analysis and documented agreements and discrepancies with the published results. We then estimated national rates among people aged ≥7 years and rates within ages 5–34, standardising separately within each range. We also used Kitagawa decomposition to describe the contributions of changes in age composition and age-specific rates to the crude-rate change. Post hoc sensitivity analyses examined alternative population projections, WHO weights, count models, selection rules and pandemic-period restrictions.

## Methods

### Study design and reference reproduction

This secondary ecological analysis used the Brazilian Mortality Information System (SIM) to examine national underlying-cause asthma mortality in Brazil during 2014–2021. The corrected primary population comprised people aged ≥7 completed years. We analysed ages 5–34 separately and used the nested 7–34 group to assess sensitivity to ages five and six; 35–59 and ≥60 provided further comparisons. The historical analysis using continuous age >6 was reproduced separately. The primary analysis retained IBGE 2018 denominators and Brazil 2014 standard weights. Sensitivity analyses and descriptive decomposition complemented the primary estimates. We applied no multiple-testing correction.

We reproduced the historical analysis against the archived manuscript and versioned analytical code. Provenance details are reported under Software, reproducibility and ethics.

### Selection, COVID mentions and record identity

We selected records whose underlying cause field, CAUSABAS, contained International Classification of Diseases, tenth revision (ICD-10), J45 or J46 [5]. To retain the historical search scope, the corrected COVID rule searched LINHAA, LINHAB, LINHAC, LINHAD and LINHAII for B342, U072, U071 or literal COVID-19. A match in any field excluded the record once. We logged each code frequency and overlapping combination separately. Sensitivities used the original rule without U071 or retained all records with COVID mentions.

The historical key combined death date, elapsed-days age, underlying cause and five cause lines. It collapsed two 2018 records with differences in occupation and administrative fields. The death-declaration identifier NUMERODO, described in the SIM dictionary [6], is absent from the public CSVs. Available fields therefore cannot establish a shared death. We retained both records and assessed their collapse as a sensitivity. Supplementary methods document the rows and fields.

### Calendar ages and analytical domains

Completed age was the difference between death and birth years, reduced by one if death preceded that year's birthday. For births on 29 February, the anniversary in a non-leap year was 1 March. Missing or invalid dates and birth after death were excluded and logged separately. We applied no upper-age exclusion and grouped ages ≥90 into the IBGE 90+ interval. Date parsing is detailed in the supplement.

Calendar age defined the ≥7, 5–34, 7–34, 35–59 and ≥60 groups. One sensitivity used days/365.25, with its floor defining single-year bins. The historical reproduction retained the continuous >6 threshold as a separate population.

### Denominators and direct standardisation

National single-year populations for both sexes came from the Brazilian Institute of Geography and Statistics (IBGE) 2018 revision [7]; the 2024 revision following the 2022 Census provided a sensitivity [8]. Both revisions provide single-year ages 0–89 and an open 90+ interval; workbook extraction is documented in the supplement. Corrected crude rates matched each numerator to the same population age range. To reproduce the historical construction, we divided continuous-age >6 deaths by the entire population and separately by population ≥7. The latter comparator retains the small mismatch between its historical numerator and denominator.

For age domain D and year t, we calculated the directly age-standardised rate (ASR) as follows.

ASR(t,D) = Σ[a∈D] w(a,D) × 100,000 × deaths(a,t) / population(a,t).

w(a,D) = population(a,2014) / Σ[j∈D] population(j,2014), so Σ[a∈D] w(a,D) = 1.

Weights were fixed across years and normalised separately within each age domain, including 5–34 and 7–34. Each denominator revision supplied its own Brazil 2014 standard population. Deaths and population at ≥90 shared one open interval. World Health Organization (WHO) standardisation used five-year bands [9], combining the 90–94, 95–99 and ≥100 weights for 90+. We allocated three fifths of the WHO 5–9 weight to 7–9 before normalisation, assuming a uniform distribution within that band. Missing death-count cells were assigned zero; population cells had to be complete and positive. We checked that Brazil-2014-standardised and aligned crude rates were equal in 2014.

### Trends, count models and sensitivity scenarios

We fitted Gaussian-family generalised linear models (GLMs) to national crude and Brazil-standardised annual rates and ordinary least squares (OLS) to age-group and WHO-standardised rates. The identity-link Gaussian trends are numerically equivalent to OLS. Slopes were expressed as deaths per 100,000 per year, with t intervals using n−2 residual degrees of freedom. We reported absolute and relative endpoint changes separately from annual slopes.

Count models used log-link Poisson, quasi-Poisson and negative binomial families [10]. For unadjusted age domains, log E[Y(t)] = α + β × year(t) + log population(t). The national age-adjusted model was log E[Y(b,t)] = α + γ(b) + β × year(t) + log population(b,t). Its nine categorical bands were 7–14 (reference), 15–24, 25–34, 35–44, 45–54, 55–64, 65–74, 75–84 and 85+. Annual percentage change was APC = 100 × (exp β − 1), with intervals obtained by transforming β ± critical value × standard error (SE). Quasi-Poisson used the t distribution with model residual degrees of freedom; Poisson and negative binomial used normal Wald intervals.

Quasi-Poisson scales Poisson coefficient variance by estimated dispersion. Negative binomial estimates the quadratic variance function μ + μ²/θ and can change coefficients as well as uncertainty. For every specification, we recorded Pearson dispersion, θ, mean-model convergence, iterations, errors and warnings. Large θ estimates with iteration warnings were interpreted as approaching the Poisson limit; these warnings prevent a claim of successful θ convergence or exact equivalence to Poisson.

Each sensitivity changed one condition from the corrected primary analysis. We examined elapsed-days age, the original COVID rule, retention of all COVID mentions, the historical deduplication key, exclusion of 2020 and restriction to 2014–2019. The last two focused on 5–34 and 7–34 and retained actual calendar years as covariates. Excluding 2020 left seven observations and 5 trend residual degrees of freedom; restriction to 2014–2019 left six and 4. We evaluated both denominator revisions and both standards and reported every model regardless of statistical significance.

### Kitagawa accounting decomposition

For the corrected ≥7 population, symmetric Kitagawa decomposition [11] partitioned crude differences into an age-composition term C and an age-specific-rate term R.

C = Σ[a] (w(a,1) − w(a,0)) × (r(a,0) + r(a,1)) / 2.

R = Σ[a] (r(a,1) − r(a,0)) × (w(a,0) + w(a,1)) / 2.

Crude(1) − crude(0) = C + R, with r in deaths per 100,000 and each year's w normalised within ≥7.

We used the same six endpoint pairs with IBGE 2018 and 2024, namely 2014–2021, 2014–2019, 2014–2020, 2015–2021, 2016–2021 and 2014–2018. We checked the identities at full precision before rounding each displayed component independently. This can produce a discrepancy in the last displayed digit. Shares above 100% indicate that a negative rate term offsets part of the composition term. The decomposition is descriptive and does not identify causal mechanisms.

### Software, reproducibility and ethics

We used R 4.6.1 [12] for reproduction and revision; the reference reported R 4.3.3. The code records versions, configurations, hashes, warnings and independent checks. Public inputs and separate scenario outputs support reproduction. Code and revision outputs are available at https://github.com/EduIntellect/asthma-mortality-brazil-reanalysis/tree/revision/amaury-review .

Recovered official SIM archives reproduced the recorded selection counts and year-age aggregates exactly. Historical execution hashes exist only for 2020–2021, preventing confirmation of historical file identity for 2014–2019. The supplement and provenance manifest document the manuscript reference, concordant Word, code commit and input hashes.

Codex assisted code revision and analysis checking. Figures were plotted directly from analytical results. Editorial AI assistance is disclosed in Acknowledgements.

The study used publicly accessible SIM mortality data and aggregated population projections without direct contact with participants. No identifying personal information was included in the reported results.

## Results

### Historical reproduction and corrected selection

The historical pipeline reproduced 19,105 underlying-cause candidates, 56 COVID exclusions, one reduced-key removal, 15 uninterpretable ages and 18,583 deaths at continuous age >6. The original study reported 18,584 deaths [1]. All versioned selection counts, annual age aggregates and IBGE-2018 denominators matched exactly. Rate and trend differences were at floating-point scale. Negative binomial θ estimates differed slightly under the current environment in models approaching the Poisson limit, with no change in significance classifications. Supplementary Table S3 documents the unresolved original population series and age-group discrepancies.

The eight official files contained 11,169,644 records, including 19,105 underlying-cause asthma records. Corrected COVID exclusions removed 57 records, comprising 27 in 2020 and 30 in 2021. No record was removed as a proven duplicate; 15 had non-interpretable dates and none had birth after death, leaving 19,033 age-valid records. The ≥7 domain contained 18,544 deaths, including 12,678 (68.4%) at ≥60. Calendar age changed the single-year bin of 23 candidates (23 retained), but none crossed the ≥7, 5–34, 7–34, 35–59 or ≥60 domain boundaries relative to floor(days/365.25). Ages above 90 were retained in the 90+ interval. The corrected total ≥7 equals the historical total because retaining one 2018 record and excluding the additional 2021 U071 record cancel in the total.

### National domain of completed ages ≥7

For completed ages ≥7, the aligned crude series rose from 1.123 to 1.257 per 100,000 (+12.0%; absolute change +0.1343), with slope 0.0270 per year (95% CI 0.0030 to 0.0509; p = 0.033). Brazil-2014-standardised mortality changed from 1.123 to 1.077 per 100,000 (-4.1%; absolute change -0.0456), with slope 0.0002 per year (95% CI -0.0214 to 0.0217; p = 0.986). The endpoint comparison describes the difference between 2014 and 2021. The slope uses all eight annual observations, and its interval includes trends in both directions.

Table 1 summarises the rate estimates. Figure 1 compares changes from 2014.

With 2018 denominators, the age-adjusted national estimate was +0.00% per year (95% CI -1.13 to 1.14; p = 0.999) under quasi-Poisson and +0.93% per year (95% CI -0.20 to 2.06; p = 0.106) under negative binomial regression. With 2024 denominators, the negative binomial estimate was +1.14% per year (95% CI 0.03 to 2.26; p = 0.044), the only one of the six corrected national age-adjusted specifications whose interval excluded zero. The national Poisson Pearson dispersion was 3.11; different uncertainty and variance assumptions contribute to differences between families. All mean-model iterations converged. Some unadjusted age-group negative binomial fits reached the theta iteration limit. Supplementary Table S4 identifies these warnings; convergence of the mean model alone does not establish dispersion convergence.

### Composition of the crude-rate change at ≥7

Across six pairs, the composition component was positive under both revisions. With IBGE 2018 it accounted for 61.5–193.8% of the net increase, compared with 55.0–153.5% under IBGE 2024. For 2014–2021, the 2018 net change of +0.134 per 100,000 comprised composition +0.191 and age-specific rates -0.057; 94.8% of composition arose at ≥60. The corresponding 2024 terms were +0.146, +0.170 and -0.025. Contributions above 100% mean that a negative rate component partly offset the positive composition component; these proportions describe the decomposition and do not estimate causal effects.

Figure 2 compares the decomposition under both population revisions.

### Age-domain mortality and sensitivity analyses

Ages 5–34 contributed 1,590 corrected deaths (172–236 annually). Their crude rate rose from 0.182 to 0.218 per 100,000 (+19.7%; absolute change +0.0358), with slope 0.0079 per year (95% CI 0.0021 to 0.0138; p = 0.016). Standardising within 5–34 to Brazil 2014 yielded 0.182 to 0.215 per 100,000 (+18.0%; absolute change +0.0328), with slope 0.0075 per year (95% CI 0.0018 to 0.0132; p = 0.018); WHO standardisation yielded 0.178 to 0.207 per 100,000 (+16.4%; absolute change +0.0291), with slope 0.0068 per year (95% CI 0.0014 to 0.0122; p = 0.022). Thus the crude absolute increase was 0.0358, and the within-group-standardised absolute increase was 0.0328 per 100,000. The nested 7–34 comparison gave 0.181 to 0.220 per 100,000 (+21.0%; absolute change +0.0381), with slope 0.0088 per year (95% CI 0.0026 to 0.0149; p = 0.013); it tests sensitivity to including ages five and six. The crude 5–34 quasi-Poisson estimate was +4.00% per year (95% CI 1.13 to 6.95; p = 0.014).

Excluding 2020 while retaining calendar-year values, the within-5–34 Brazil-2014-standardised slope was 0.0058 (95% CI 0.0004 to 0.0112; p = 0.040). In 2014–2019 it was 0.0068 (95% CI -0.0023 to 0.0158; p = 0.107); the endpoint increase was 22.4%. For the 7–34 control, the respective standardised trend p values were 0.021 and 0.067. The primary standardised prepandemic interval therefore does not establish a positive annual trend.

With WHO standardisation and IBGE 2018, excluding 2020 gives p = 0.055, with an interval including zero. In 2014–2019, count-model inference also differs. The crude 5–34 Poisson and negative binomial Wald intervals exclude zero; the quasi-Poisson t interval includes it; negative-binomial theta has an iteration warning. Supplementary Table S7 reports results for both revisions, both standards and all three count families. These comparisons show that inference depends on the standard and variance assumptions.

The original COVID rule removes 56 records; adding U071 removes one further record in 2021, within both young domains. Of 18 U071 mentions in 2020, all were already excluded; of 19 in 2021, 18 overlapped the original rule. Retaining all COVID mentions raises the primary ≥7 numerator from 18,544 to 18,601. Calendar-age, original-COVID, all-COVID-retained and historical-key sensitivities change one condition at a time (Supplementary Table S8).

At 35–59 the crude slope remained imprecise (p = 0.132); uncertainty is not evidence of stability.

## Discussion

The corrected analysis found an increase in aligned crude asthma mortality among people aged ≥7 between 2014 and 2021. With Brazil 2014 age weights held fixed, the endpoint change was negative and the slope across all eight years was close to zero. Endpoint comparisons and slopes across all annual observations describe different aspects of the series. The interval was compatible with trends in either direction and does not demonstrate stability. The positive age-adjusted negative binomial estimate with IBGE 2024 shows that national trend inference also depends on the model and population revision.

Age composition contributed positively to the crude change for every endpoint pair under both population revisions. In some pairs, the composition term exceeded the net increase because the age-specific-rate term was negative. The decomposition combines composition and rates arithmetically; it cannot identify effects of certification, treatment access or the pandemic.

Both crude and standardised mortality within ages 5–34 increased over 2014–2021. Standardising within this range accounts for changes in its internal age distribution. The nested 7–34 analysis assesses how including ages five and six affects the estimate and does not provide independent replication.

Extension of the finding across periods depends on the analysis. The primary Brazil-standardised slope retained a positive interval after excluding 2020; the corresponding WHO sensitivity with IBGE 2018 included zero. The shorter prepandemic primary estimate was imprecise and its interval included zero. Its positive endpoint contrast alone does not establish an annual trend over 2014–2019. The observed increase over 2014–2021 warrants continued surveillance, while differences in study periods and age definitions prevent identification of a change point or reversal of the earlier decline reported previously [3].

Interpretation also depends on which records enter each analysis. The selection audit shows why equal ≥7 totals need not represent the same records. Retaining one ambiguous 2018 record and excluding one additional U071 record in 2021 cancel in the total. Calendar age also changed single-year bins without changing membership in the five age domains, affecting the age distribution used in standardisation and count models. Separate sensitivities identify the effect of each alternative selection rule.

The ecological design, short annual series, post hoc sensitivity analyses, unadjusted multiple comparisons and possible changes in death certification limit interpretation. Public fields cannot establish whether the 2018 pair represents one death. Historical execution hashes for SIM 2014–2019 and the population workbook used in the original study remain unavailable. Exact reproduction of recorded counts and aggregates therefore cannot establish historical file identity.

Negative binomial θ iteration warnings near the Poisson limit constrain confidence in dispersion estimation. We retained every model and its warnings to make these limitations visible. Statistical intervals quantify model uncertainty; they do not capture uncertainty in record selection, certification or population reconstruction.

These findings support reporting aligned crude, age-standardised and age-specific mortality together. Age composition accounted for much of the crude increase among people aged ≥7. The increase within 5–34 over 2014–2021 merits attention, with interpretation bounded by prepandemic uncertainty and sensitivity to model assumptions.

## Acknowledgements

Claude Code and GitHub Copilot supported the historical workflow. Codex assisted editorial drafting and revision. Both authors reviewed and approved the final manuscript and take responsibility for its content.

## Funding

No funding was received for this study.

## Conflicts of interest

The authors declare no conflicts of interest.

## Author contributions

Francisco Federico García Crespi contributed conceptualisation, methodology, software, formal analysis, data curation, visualisation and writing the original draft. Amaury de Souza contributed validation of epidemiological and scientific interpretation, and writing, review and editing. Both authors approved the final manuscript.

## References

1. Brum M, Henz J, Boeira M, Soares S, Friedrich F, Pitrez PM. Recent increase in asthma mortality in Brazil: a warning sign for the public health system. J Bras Pneumol. 2024;50(5):e20240138. doi:10.36416/1806-3756/e20240138

2. Cardoso ADRO, Ferreira ACG, Rabahi MF. Asthma-related deaths in Brazil: data from an ecological study. J Bras Pneumol. 2024;50(6):e20240296. doi:10.36416/1806-3756/e20240296

3. Graudenz GS, Carneiro DP, Vieira RP. Trends in asthma mortality in the 0- to 4-year and 5- to 34-year age groups in Brazil. J Bras Pneumol. 2017;43(1):24-31. doi:10.1590/S1806-37562015000000253

4. Brum M, et al. Analysis code accompanying reference 1. GitHub repository, commit 8d527a5 (15 May 2024). Available from: https://github.com/mobrant94/asthma_mortality

5. Ministério da Saúde (Brasil). Sistema de Informação sobre Mortalidade (SIM). Portal de Dados Abertos do SUS. Available from: https://dadosabertos.saude.gov.br/dataset/sim

6. Ministério da Saúde. Estrutura de Dados SIM. Secretaria de Vigilância em Saúde. Official data dictionary, archived by UFBA. https://ccvisat.ufba.br/wp-content/uploads/2019/10/Estrutura-do-SIM-para-o-CD-ROM.pdf (accessed 11 October 2026).

7. Instituto Brasileiro de Geografia e Estatística. Projeção da População do Brasil e das Unidades da Federação, revisão 2018: população por idade simples, 2010–2060. Available from: https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2018/ (accessed 1 October 2026)

8. Instituto Brasileiro de Geografia e Estatística. Projeções da População, revisão 2024: população por idade simples. Available from: https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2024/ (accessed 1 October 2026)

9. Ahmad OB, Boschi-Pinto C, Lopez AD, Murray CJL, Lozano R, Inoue M. Age standardization of rates: a new WHO standard. GPE Discussion Paper Series No. 31. Geneva: World Health Organization; 2001.

10. Venables WN, Ripley BD. Modern applied statistics with S. 4th ed. New York: Springer; 2002.

11. Kitagawa EM. Components of a difference between two rates. J Am Stat Assoc. 1955;50(272):1168–1194. doi:10.1080/01621459.1955.10501299

12. R Core Team. R: a language and environment for statistical computing. Vienna: R Foundation for Statistical Computing; 2026. Available from: https://www.R-project.org/

## Table 1. Historical comparators and corrected primary rates, Brazil, 2014–2021

| Series | 2014 | 2021 | Δ rate | Δ % | Slope (95% CI) | p |
| --- | --- | --- | --- | --- | --- | --- |
| Corrected crude ≥7 | 1.123 | 1.257 | +0.134 | +12.0 | 0.0270 (0.0030, 0.0509) | 0.033 |
| Brazil 2014 ASR ≥7 | 1.123 | 1.077 | -0.046 | -4.1 | 0.0002 (-0.0214, 0.0217) | 0.986 |
| Crude 5–34 | 0.182 | 0.218 | +0.036 | +19.7 | 0.0079 (0.0021, 0.0138) | 0.016 |
| Brazil 2014 ASR 5–34 | 0.182 | 0.215 | +0.033 | +18.0 | 0.0075 (0.0018, 0.0132) | 0.018 |
| Crude 7–34 | 0.181 | 0.223 | +0.042 | +22.9 | 0.0093 (0.0029, 0.0156) | 0.012 |
| Crude 35–59 | 0.719 | 0.830 | +0.111 | +15.5 | 0.0221 (-0.0089, 0.0532) | 0.132 |
| Historical >6 / all population | 1.012 | 1.138 | +0.126 | +12.5 | 0.0250 (0.0036, 0.0463) | 0.029 |
| Historical >6 / ≥7 population | 1.126 | 1.260 | +0.134 | +11.9 | 0.0268 (0.0031, 0.0505) | 0.032 |

Rates and absolute changes are per 100,000. Slopes are per 100,000 per year with t-based 95% intervals, six residual degrees of freedom. Δ is the endpoint difference; Δ % is the relative endpoint change. Corrected rows use calendar age, U071-inclusive COVID exclusions and retention of both ambiguous 2018 records. Historical rows retain continuous >6 and their original denominators. IBGE 2018 is used throughout this table; primary ASR uses Brazil 2014 weights normalised inside the specified domain.

## Figure 1. Relative changes from 2014

![Figure 1. Corrected aligned crude and Brazil-2014-standardised national rates for completed ages ≥7, plus rates standardised within 5–34. IBGE 2018 denominators; changes relative to each series' own 2014 rate.](figures/Figure1.png)

## Figure 2. Kitagawa sensitivity to population revision

![Figure 2. Corrected ≥7 crude-rate changes partitioned into age-composition and age-specific-rate components for six pairs, with IBGE 2018 and 2024. Components sum to net change before rounding and are not causal effects.](figures/Figure2.png)
