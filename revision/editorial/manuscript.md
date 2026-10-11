# Reassessing the reported increase in asthma mortality in Brazil: reproduction and age-specific reanalysis, 2014–2021

Francisco Federico García Crespi¹ · Amaury de Souza²

¹ Universidad Miguel Hernández, Elche, Alicante, Spain. ² Institute of Physics, Federal University of Mato Grosso do Sul, Campo Grande, MS, Brazil.

Correspondence: Francisco Federico García Crespi, fedeg@umh.es. Author details and declarations are carried forward from the reviewed PDF for confirmation in the accompanying author checklist.

## Abstract

Objective: To assess whether the reported crude increase in Brazilian asthma mortality during 2014–2021 persists after age standardisation in the national domain of completed ages ≥7, and to examine mortality within ages 5–34.

Methods: We reproduced the historical pipeline, then corrected age to completed calendar years, included U071 in COVID exclusions, and retained an ambiguous pair of 2018 records. Primary denominators were IBGE 2018 and the fixed standard was Brazil 2014, normalised within each domain. IBGE 2024, WHO standardisation, count models, alternative selection rules and pandemic-period restrictions were sensitivity analyses.

Results: Historical selection reproduced 18,583 deaths with continuous age >6, versus 18,584 published. The corrected national analysis of completed ages ≥7 included 18,544 deaths: aligned crude mortality increased 12.0%, whereas Brazil-2014-standardised mortality changed -4.1% between endpoints (eight-year slope 0.0002; 95% CI -0.0214 to 0.0217; p = 0.986). Within ages 5–34, Brazil-2014-standardised mortality increased 18.0% (0.0328 per 100,000; p = 0.018). Its slope remained positive excluding 2020 (p = 0.040); the 2014–2019 interval included zero (p = 0.107).

Conclusion: Changes in population age composition accounted for much of the crude increase at ages ≥7, without a causal attribution. The primary national age-standardised estimate did not establish an increasing trend or demonstrate stability. Within-5–34 standardisation supported an increase across 2014–2021, including after excluding 2020; the shorter prepandemic series was inconclusive about the annual trend. Surveillance should report crude, age-standardised and age-specific rates jointly.

Keywords: Asthma; Mortality; Age Distribution; Population Dynamics; Reproducibility of Results; Brazil.

## Introduction

Brum et al. concluded that "asthma mortality remains high and shows an increasing trend for the first time in the past decades" [1]. Their nationwide analysis for 2014–2021 identified 18,584 asthma deaths and reported an approximately 2.5% annual increase in asthma mortality. A subsequent study by Cardoso et al., covering 2013–2023, also concluded that asthma-related deaths had increased [2]. However, this conclusion was based on annual death counts, while the same study reported that the overall mortality rate per 100,000 inhabitants remained stable. Thus, the two studies described increasing asthma mortality using different measures, neither of which established an increase in the national age-standardised rate.

Earlier Brazilian surveillance provides a longer perspective. Graudenz et al. reported a linear decline in age-standardised asthma mortality among Brazilians aged 5–34 years during 1980–2014, whereas the trend in the general population was non-linear [3]. Differences in study periods, age ranges and rate definitions prevent direct comparison with more recent estimates or the identification of a historical trend reversal.

Neither Brum et al. nor Cardoso et al. directly age-standardised the national mortality series. This omission matters because approximately two thirds of asthma deaths occurred among individuals aged 60 years or older [1,2], and changes in population age structure can affect crude mortality rates independently of changes in age-specific mortality. Consequently, an increase in deaths or crude mortality cannot, by itself, establish a comparable increase in age-adjusted mortality. The public availability of Brum et al.'s analytical code [4] also makes it possible to examine the reproducibility of their case selection, population denominators and trend estimates before reassessing the interpretation.

We therefore asked to what extent the reported increase in asthma mortality in Brazil during 2014–2021 remains supported when the original analysis is reproduced and population age structure is held fixed. We first reproduced Brum et al.'s analysis and documented agreements and discrepancies with the published results. We then estimated national age-standardised mortality trends and examined mortality among individuals aged 5–34 years. In post hoc robustness analyses, we assessed an alternative population projection, the WHO standard population and count regression models. Our objective was not to dispute the observed increase in crude mortality, but to establish which epidemiological interpretations are supported after accounting for population age structure and examining age-specific trends.

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

The eight official files contained 11,169,644 records, including 19,105 underlying-cause asthma records. Corrected COVID exclusions removed 57 records: 27 in 2020 and 30 in 2021. No record was removed as a proven duplicate; 15 had non-interpretable dates and none had birth after death, leaving 19,033 age-valid records. The ≥7 domain contained 18,544 deaths, including 12,678 (68.4%) at ≥60. Calendar age changed the single-year bin of 23 candidates (23 retained), but none crossed the ≥7, 5–34, 7–34, 35–59 or ≥60 domain boundaries relative to floor(days/365.25). Ages above 90 were retained in the 90+ interval. The corrected total ≥7 equals the historical total by coincidence: retaining one 2018 record adds a death and excluding the additional 2021 U071 record removes one.

### National domain of completed ages ≥7

For completed ages ≥7, the aligned crude series rose from 1.123 to 1.257 per 100,000 (+12.0%; absolute change +0.1343), with slope 0.0270 per year (95% CI 0.0030 to 0.0509; p = 0.033). Brazil-2014-standardised mortality changed from 1.123 to 1.077 per 100,000 (-4.1%; absolute change -0.0456), with slope 0.0002 per year (95% CI -0.0214 to 0.0217; p = 0.986). The endpoint decrease and the slope across eight annual observations answer different questions. The interval does not demonstrate equivalence to zero or stability.

With 2018 denominators, the age-adjusted national estimate was +0.00% per year (95% CI -1.13 to 1.14; p = 0.999) under quasi-Poisson and +0.93% per year (95% CI -0.20 to 2.06; p = 0.106) under negative binomial regression. With 2024 denominators, the negative binomial estimate was +1.14% per year (95% CI 0.03 to 2.26; p = 0.044), the only one of the six corrected national age-adjusted specifications with an interval excluding zero. The national Poisson Pearson dispersion was 3.11; different uncertainty and variance assumptions contribute to differences between families. All mean-model iterations converged. Negative binomial fits for some unadjusted age-group series issued theta iteration-limit warnings; these rows are reported explicitly in Supplementary Table S4, not treated as successful dispersion convergence or exact identity with Poisson.

### Composition of the crude-rate change at ≥7

Across six pairs, the composition component was positive under both revisions. With IBGE 2018 it accounted for 61.5–193.8% of the net increase, compared with 55.0–153.5% under IBGE 2024. For 2014–2021, the 2018 net change of +0.134 per 100,000 comprised composition +0.191 and age-specific rates -0.057; 94.8% of composition arose at ≥60. The corresponding 2024 terms were +0.146, +0.170 and -0.025. Contributions above 100% mean that a negative rate component partly offset the positive composition component; they are accounting quantities, not causal fractions.

### Mortality within ages 5–34 and sensitivity analyses

Ages 5–34 contributed 1,590 corrected deaths (172–236 annually). Their crude rate rose from 0.182 to 0.218 per 100,000 (+19.7%; absolute change +0.0358), with slope 0.0079 per year (95% CI 0.0021 to 0.0138; p = 0.016). Standardising within 5–34 to Brazil 2014 yielded 0.182 to 0.215 per 100,000 (+18.0%; absolute change +0.0328), with slope 0.0075 per year (95% CI 0.0018 to 0.0132; p = 0.018); WHO standardisation yielded 0.178 to 0.207 per 100,000 (+16.4%; absolute change +0.0291), with slope 0.0068 per year (95% CI 0.0014 to 0.0122; p = 0.022). Thus the crude absolute increase was 0.0358, and the within-group-standardised absolute increase was 0.0328 per 100,000. The nested 7–34 control gave 0.181 to 0.220 per 100,000 (+21.0%; absolute change +0.0381), with slope 0.0088 per year (95% CI 0.0026 to 0.0149; p = 0.013); it is a technical control, not independent replication. The crude 5–34 quasi-Poisson estimate was +4.00% per year (95% CI 1.13 to 6.95; p = 0.014).

Excluding 2020 while retaining calendar-year values, the within-5–34 Brazil-2014-standardised slope was 0.0058 (95% CI 0.0004 to 0.0112; p = 0.040). In 2014–2019 it was 0.0068 (95% CI -0.0023 to 0.0158; p = 0.107); the endpoint increase was 22.4%. For the 7–34 control, the respective standardised trend p values were 0.021 and 0.067. The primary standardised prepandemic interval therefore does not establish a positive annual trend. With WHO standardisation and IBGE 2018, excluding 2020 gives p = 0.055, with an interval including zero. In 2014–2019, count-model inference also differs: the crude 5–34 Poisson and negative-binomial Wald intervals exclude zero, whereas the quasi-Poisson t interval includes it; negative-binomial theta has an iteration warning. Results for both revisions, both standards and count models are supplied rather than selected by significance.

The original COVID rule removes 56 records; adding U071 removes one further record in 2021, within both young domains. Of 18 U071 mentions in 2020, all were already excluded; of 19 in 2021, 18 overlapped the original rule. Retaining all COVID mentions raises the primary ≥7 numerator from 18,544 to 18,601. Calendar-age, original-COVID, all-COVID-retained and historical-key sensitivities change one condition at a time (Supplementary Table S8). At 35–59 the crude slope remained imprecise (p = 0.132); uncertainty is not evidence of stability.

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

1. Brum M, Henz J, Boeira M, Soares S, Friedrich F, Pitrez PM. Recent increase in asthma mortality in Brazil: a warning sign for the public health system. J Bras Pneumol. 2024;50(5):e20240138. doi:10.36416/1806-3756/e20240138
2. Cardoso ADRO, Ferreira ACG, Rabahi MF. Asthma-related deaths in Brazil: data from an ecological study. J Bras Pneumol. 2024;50(6):e20240296. doi:10.36416/1806-3756/e20240296
3. Graudenz GS, Carneiro DP, Vieira RP. Trends in asthma mortality in the 0- to 4-year and 5- to 34-year age groups in Brazil. J Bras Pneumol. 2017;43(1):24-31. doi:10.1590/S1806-37562015000000253
4. Brum M, et al. Analysis code accompanying reference 1. GitHub repository, commit 8d527a5 (15 May 2024). Available from: https://github.com/mobrant94/asthma_mortality
5. Ministério da Saúde (Brasil). Sistema de Informação sobre Mortalidade (SIM). Portal de Dados Abertos do SUS. Available from: https://dadosabertos.saude.gov.br/dataset/sim
6. Instituto Brasileiro de Geografia e Estatística. Projeção da População do Brasil e das Unidades da Federação, revisão 2018: população por idade simples, 2010–2060. Available from: https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2018/ (accessed 1 October 2026)
7. Instituto Brasileiro de Geografia e Estatística. Projeções da População, revisão 2024: população por idade simples. Available from: https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2024/ (accessed 1 October 2026)
8. Ahmad OB, Boschi-Pinto C, Lopez AD, Murray CJL, Lozano R, Inoue M. Age standardization of rates: a new WHO standard. GPE Discussion Paper Series No. 31. Geneva: World Health Organization; 2001.
9. Venables WN, Ripley BD. Modern applied statistics with S. 4th ed. New York: Springer; 2002.
10. R Core Team. R: a language and environment for statistical computing. Vienna: R Foundation for Statistical Computing; 2026. Available from: https://www.R-project.org/
11. Kitagawa EM. Components of a difference between two rates. J Am Stat Assoc. 1955;50(272):1168–1194. doi:10.1080/01621459.1955.10501299
12. Ministério da Saúde. Estrutura de Dados SIM. Secretaria de Vigilância em Saúde. Official data dictionary, archived by UFBA. https://ccvisat.ufba.br/wp-content/uploads/2019/10/Estrutura-do-SIM-para-o-CD-ROM.pdf (accessed 11 October 2026).

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
