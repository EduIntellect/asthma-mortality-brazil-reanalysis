---
title: "Reassessing the reported increase in asthma mortality in Brazil: reproduction and age-specific reanalysis, 2014–2021"
---

# Abstract

**Objective:** To assess whether rising crude asthma mortality in Brazil (2014–2021) persists after age standardisation and to examine trends at ages 5–34.

**Methods:** Using published code, national mortality records (ICD-10 J45–J46) and Brazilian Institute of Geography and Statistics (IBGE) projections, we reproduced the original analysis, calculated age-standardised rates (Brazil 2014) and assessed eight-year trends. Count models, an alternative IBGE population projection (2024 revision), World Health Organization (WHO) standardisation and Kitagawa decomposition were post hoc.

**Results:** We reproduced 18,583 deaths versus 18,584 reported. The crude national rate rose by 12.5% (slope 0.025 per 100,000/year; p = 0.029). Among completed ages ≥7 (18,544 deaths), the aligned crude rate rose by 12.0%, versus a 4.0% fall in the standardised rate (eight-year slope 0.0002 per 100,000/year; 95% CI −0.021 to 0.022; p = 0.983). Age composition accounted for 62–193% of crude-rate increases across six endpoint comparisons. Only one of six age-adjusted count-model specifications, negative binomial regression with 2024 denominators, yielded a positive estimate whose interval excluded zero (+1.14% annually; 95% CI 0.04 to 2.26). Rates at ages 5–34 increased by 20.3% (p = 0.014), consistently across sensitivity analyses.

**Conclusion:** Changes in population age composition accounted for most of the crude increase, without establishing a causal explanation. The primary age-standardised analysis did not support a comparable national increase, whereas mortality at ages 5–34 rose. Surveillance should report crude, age-standardised and age-specific rates jointly.

**Keywords:** [AUTHOR INPUT REQUIRED]

<!-- BEGIN MAIN TEXT -->

# Introduction

Brum et al. concluded that "asthma mortality remains high and shows an increasing trend for the first time in the past decades" [1]. Their nationwide analysis for 2014–2021 identified 18,584 asthma deaths and reported an approximately 2.5% annual increase in asthma mortality. A subsequent study by Cardoso et al., covering 2013–2023, also concluded that asthma-related deaths had increased [2]. However, this conclusion was based on annual death counts, while the same study reported that the overall mortality rate per 100,000 inhabitants remained stable. Thus, the two studies described increasing asthma mortality using different measures, neither of which established an increase in the national age-standardised rate.

Earlier Brazilian surveillance provides a longer perspective. Graudenz et al. reported a linear decline in age-standardised asthma mortality among Brazilians aged 5–34 years during 1980–2014, whereas the trend in the general population was non-linear [3]. Differences in study periods, age ranges and rate definitions prevent direct comparison with more recent estimates or the identification of a historical trend reversal.

Neither Brum et al. nor Cardoso et al. directly age-standardised the national mortality series. This omission matters because approximately two thirds of asthma deaths occurred among individuals aged 60 years or older [1,2], and changes in population age structure can affect crude mortality rates independently of changes in age-specific mortality. Consequently, an increase in deaths or crude mortality cannot, by itself, establish a comparable increase in age-adjusted mortality. The public availability of Brum et al.'s analytical code [4] also makes it possible to examine the reproducibility of their case selection, population denominators and trend estimates before reassessing the interpretation.

We therefore asked to what extent the reported increase in asthma mortality in Brazil during 2014–2021 remains supported when the original analysis is reproduced and population age structure is held fixed. We first reproduced Brum et al.'s analysis and documented agreements and discrepancies with the published results. We then estimated national age-standardised mortality trends and examined mortality among individuals aged 5–34 years. In post hoc robustness analyses, we assessed an alternative population projection, the WHO standard population and count regression models. Our objective was not to dispute the observed increase in crude mortality, but to establish which epidemiological interpretations are supported after accounting for population age structure and examining age-specific trends.

# Methods

## Study design

We conducted a secondary analysis of publicly available mortality data, reproducing the national asthma mortality analysis by Brum et al. for 2014–2021 [1] and examining two extensions: direct age standardisation of national mortality rates and mortality trends among individuals aged 5–34 years. The project documentation identifies these as the primary questions, with ages 7–34 years as a technical control and ages 35–59 years as an additional comparison. The Brazil 2014 population was selected as the primary standard. Reproduction was assessed against a tolerance of 2% for the total number of deaths and agreement in the direction and approximate magnitude of the original age-group trends. Count regression models, the WHO standard population and an alternative population projection were subsequently introduced as post hoc robustness analyses.

## Mortality data and case selection

Mortality records for 2014–2021 were obtained from the Brazilian Mortality Information System (SIM) [5] on 1 October 2026. The original source URLs were no longer fully accessible, so all years were retrieved from the current official archives. Possible retrospective revisions of these data may affect exact reproduction.

Deaths were selected when the underlying cause contained ICD-10 J45 or J46. Records containing the COVID-related codes B342 or U072, or the text "COVID-19", in the cause-of-death lines were excluded. Age was calculated from birth and death dates as the elapsed number of days divided by 365.25. Records with invalid or missing birth dates were excluded from age-specific analyses.

Duplicate records were identified using the birth and death dates, underlying cause and five available cause-of-death fields. This procedure uses the variables loaded by our pipeline but does not exactly reproduce the original full-record deduplication.

To reproduce Brum et al., we retained deaths with calculated age greater than six years. The 5–34-year analysis instead used all age-valid records, including deaths at ages five and six.

## Population denominators

The original population workbook was unavailable. We reconstructed denominators using IBGE national population projections by single year of age and both sexes combined. The 2018 revision was used in the primary analysis [6], and the 2024 revision, incorporating the 2022 Census, in sensitivity analyses [7]. The exact population series used by Brum et al. could not be recovered.

## Mortality rates and age standardisation

For the reproduction of the national crude series, deaths above six years of age were divided by the total population, following the construction inferred from the published code [4]. We also calculated a version restricted to the population above six years. Original age groups were reproduced using their apparent numerator and denominator definitions, with unresolved denominator differences documented in the reproducibility audit.

Direct age standardisation used single-year age-specific mortality rates and the corresponding population weights from Brazil in 2014. Ages were represented as completed years from 7 to 89, with ages 90 and above grouped together. Consequently, this analysis used completed ages of at least seven years, whereas the reproduction retained the original continuous-age threshold greater than six years. These definitions were kept distinct rather than treated as identical samples.

Rates for ages 5–34, 7–34 and 35–59 years used deaths and population denominators restricted to the corresponding ages. Post hoc analyses also used the WHO World Standard Population [8].

## Statistical analysis

The primary trend models followed those of the published analysis: Gaussian generalised linear regression for national annual rates and ordinary least squares for age-group rates. Eight annual observations were available for each series. Slopes were expressed as deaths per 100,000 population per year, with 95% confidence intervals calculated using the t distribution with six degrees of freedom. We also reported changes between 2014 and 2021. For comparison with Brum et al., we calculated the mean of annual relative differences from the 2014 rate, their reported change metric.

Post hoc analyses used Poisson, quasi-Poisson and negative binomial regression [9], with population offsets. A national age-adjusted count model included calendar year and nine age bands. Overdispersion was assessed to guide interpretation of count-model uncertainty. In a further post hoc analysis, the change in the crude rate for completed ages of 7 years and older was split into an age-composition component and an age-specific-rate component with the symmetric Kitagawa decomposition, using single years of age and the 2018 projection. Because a comparison between two years depends on its endpoints, the decomposition was repeated for six pairs of years. No correction for multiple comparisons was applied; secondary estimates were interpreted descriptively.

## Software, data and code availability

Analyses were performed in R 4.3.3 [10]. The analysis code, intermediate aggregate tables, generated results and reproduction audit are available at https://github.com/EduIntellect/asthma-mortality-brazil-reanalysis. Mortality and population data were obtained from public Brazilian sources.

## Use of artificial intelligence

Generative AI coding assistants were used in developing and debugging the analysis pipeline, including scripts for data retrieval, case selection, denominator construction, age standardisation, statistical modelling and generation of tables and figures. The repository history identifies work performed using Claude Code (Anthropic) and the GitHub Copilot coding agent (GitHub).

[AUTHOR CONFIRMATION REQUIRED: one-sentence statement of the human review actually completed; see AUTHOR_REVIEW_CHECKLIST.md.]

The figures were rendered programmatically from analytical outputs rather than generated as images by an AI image-generation tool.

## Ethics

The study used publicly accessible SIM mortality data and aggregated population projections without direct contact with participants. No identifying personal information was included in the reported results.

[AUTHOR/INSTITUTIONAL CONFIRMATION REQUIRED: Confirm the applicable Brazilian ethics-review exemption and the wording required by the journal.]

# Results

## Reproduction of the original analysis

The SIM files for 2014–2021 contained 19,105 deaths with asthma as the underlying cause. After the COVID-19-related exclusion and removal of duplicates (57 records, 56 of them in 2020–2021) and exclusion of 15 deaths without a valid date of birth, the reproduction included 18,583 deaths above 6 years of age, against 18,584 reported by Brum et al. [1] (Supplementary Table S1). Of these, 68.2% occurred at 60 years or older, as in the original study.

The crude national rate rose from 1.01 to 1.14 per 100,000 between 2014 and 2021 (+12.5%), with a maximum of 1.26 in 2020 (Supplementary Table S2). The linear trend was 0.025 per 100,000 per year (95% CI 0.004 to 0.046; p = 0.029; Table 1), against 0.03 (95% CI 0.01 to 0.04; p = 0.01) in the original paper. A negative binomial model gave an annual increase of 2.3% (95% CI 1.0 to 3.6), close to the 2.5% reported originally. The published annual rates were 1.8% to 5.4% higher than ours, with a gap that widened over the period, which points to a different population series; we could not identify it.

For the age groups of the original analysis, our slopes agreed in sign and significance class with the published ones: no trend below 18 years (p = 0.85), an increase at 18–59 years (slope 0.021; p = 0.044) and a non-significant decrease at 60 years or older (slope −0.071; p = 0.14). The magnitude of the changes did not match exactly, and the largest difference, at 60 years or older, could not be reconciled (Supplementary Table S3). The reproduction thus met the criteria defined in the project documentation: total deaths within 2% and agreement in the sign of the age-group trends.

## National trend after age standardisation

Using the same completed-age population of 7 years and older for both calculations, the crude rate increased from 1.123 to 1.258 per 100,000 between 2014 and 2021 (+12.0%), whereas the directly age-standardised rate decreased from 1.123 to 1.078 (−4.0%; Table 1; Figure 1). The estimated slope of the age-standardised series over all eight years was 0.0002 per 100,000 per year (95% CI −0.0213 to 0.0217; p = 0.983). Thus, the analysis did not support an increasing national age-standardised trend, although the confidence interval did not establish equivalence to a zero trend.

In post hoc count models (Supplementary Table S4), the age-adjusted national trend was +0.00% per year with quasi-Poisson intervals (95% CI −1.12 to 1.14) and +0.9% (−0.2 to 2.1; p = 0.10) with a negative binomial model. With the 2024 population projection, the negative binomial estimate was +1.1% per year (95% CI 0.04 to 2.3; p = 0.043), the only one of six age-adjusted specifications whose interval excluded zero. The crude series was overdispersed (dispersion 5.9); its annual increase of 2.3% had p = 0.029 with quasi-Poisson and p < 0.001 with negative binomial intervals. Using the WHO standard population, the standardised rate changed by −4.2% (p = 0.99) with the 2018 projection and by −2.0% (p = 0.73) with the 2024 projection (Supplementary Table S5).

## Decomposition of the change in the crude rate

The age-composition component accounted for 62% to 193% of the observed crude-rate increase across the six endpoint comparisons, while the component associated with age-specific mortality rates changed sign (Figure 2; exact values in Supplementary Table S6). For 2014–2021, the positive composition effect (+0.191 per 100,000) exceeded the net increase (+0.135) and was partly offset by changes in age-specific rates (−0.057). Approximately 95% of the composition component arose among individuals aged 60 years or older.

## Ages 5–34 years

The rate at ages 5–34 years rose from 0.182 to 0.219 per 100,000 between 2014 and 2021 (+20.3%; slope 0.0080 per year, 95% CI 0.0023 to 0.0138; p = 0.014; Table 1). The group had 1,591 deaths over the period, between 172 and 236 per year, with the lowest rate in 2017 (0.175) and the highest in 2020 (0.244) (Supplementary Figure S1). The control group aged 7–34 years gave a similar result (+23.5%; p = 0.011; Supplementary Figure S1); it contains nearly all the deaths of the 5–34 group, so it shows that the estimate does not depend on ages 5 and 6 rather than replicating it independently.

The increase persisted in post hoc analyses. Overdispersion was negligible (1.07), and the quasi-Poisson model gave an annual increase of 4.0% (95% CI 1.2 to 7.0; p = 0.013); with the 2024 projection it was 4.2% (p = 0.011). Standardised to the WHO population within the group, the rate rose by 16.9% (p = 0.020) with the 2018 projection and by 19.1% (p = 0.015) with the 2024 projection.

At 35–59 years the evidence was inconclusive: the rate rose from 0.719 to 0.830 (+15.5%; p = 0.13), and the count models disagreed (p = 0.13 with quasi-Poisson and p = 0.036 with negative binomial).

# Discussion

We reproduced the crude increase in asthma mortality reported by Brum et al. for 2014–2021, with one death of difference in the total count and the same direction of the national and age-group trends. After direct age standardisation, however, the national age-standardised trend was not statistically distinguishable from zero: the standardised rate fell by 4.0% and its slope over the eight years was close to zero, with a confidence interval that admits small changes in either direction. In a decomposition of the crude change, shifts in the age composition of the population accounted for most of the increase, and in the 2014–2021 comparison for more than all of it. The rise in mortality at 5–34 years, by contrast, persisted across every specification we examined.

These results do not contradict the crude series of Brum et al.; they qualify its interpretation. A rising crude rate measures a rising burden of deaths in the population, which is relevant for health services. It does not by itself show that the risk of dying from asthma at a given age has increased. Cardoso et al. reported an increase in the number of asthma deaths over 2013–2023 while noting that the overall rate per 100,000 inhabitants remained stable [2]. Together, these studies illustrate why trends in death counts and crude rates should be distinguished from age-adjusted trends. In our reanalysis, changes in population age composition accounted for much of the crude increase. The statement that asthma mortality "shows an increasing trend for the first time in the past decades" [1] is consistent with the crude-rate increase reported by Brum et al., but our analysis does not establish a comparable increase in national age-standardised mortality during 2014–2021.

The Kitagawa decomposition gives this reading a quantitative form, but it is an accounting decomposition, not a causal one. It splits a difference between two years into a component due to the age distribution and a component due to age-specific rates; it does not identify why either changed. Because two-year comparisons depend on their endpoints, we repeated it for six pairs of years. The composition component was positive in all of them, and about 95% of it arose at 60 years or older, the age range whose share of the population grew from 13.3% to 16.3%. The age-specific component changed sign with the endpoints, and was largest in the comparison ending in 2020, the year with the highest rates. We therefore treat the eight-year standardised trend as the main evidence, with the decomposition describing contributions to the crude increase.

The national age-adjusted result was not uniform across specifications. One of six count-model specifications, the negative binomial model with the 2024 population projection, estimated an increase of 1.1% per year whose interval excluded zero. The remaining specifications gave estimates between 0% and 0.9% per year with intervals that included zero. With eight annual observations, these data cannot establish that age-adjusted mortality was constant; the age-adjusted point estimates were generally smaller than the crude estimate, although the confidence intervals did not rule out increases of comparable magnitude under some specifications.

The increase at ages 5–34 requires separate interpretation. The rate rose by about 20% between 2014 and 2021, and the estimate held with count models, with the WHO standard population and with the alternative projection. This age range was used in earlier Brazilian surveillance, in which Graudenz et al. reported a decline in age-standardised mortality from 1980 to 2014 [3]. Our primary estimate for this group is not standardised within the group, and the two studies differ in period and methods, so the comparison does not establish a change point in 2014. The finding rests on 172 to 236 deaths per year, and the highest rate occurred in 2020. It warrants monitoring with longer series rather than a firm conclusion about a reversal.

The reproduction also revealed limits to exact comparison with published estimates. Our population denominators differed from those of the original study, so our annual national crude rates were 1.8% to 5.4% lower, and the magnitude of the change at 60 years or older could not be reconciled. The original code made it possible to identify these differences, but the exact population series could not be recovered. Reporting the denominators used, together with age-standardised rates alongside crude rates, would make national asthma surveillance comparable across studies and years.

Several limitations remain. The design is ecological and descriptive. The count models, the WHO standard population, the alternative projection and the decomposition were added after the main analyses and should be read as robustness or descriptive analyses, and we made no adjustment for multiple comparisons. The SIM files may have been revised since the original analysis, our deduplication did not reproduce the original procedure exactly, and changes in death certification or coding during the period, including during the COVID-19 pandemic, cannot be excluded. The questions were defined in the project documentation, but we could not document their timing relative to the analyses independently.

Overall, the increase in crude asthma mortality in Brazil between 2014 and 2021 is reproducible, but it was not accompanied by a comparable increase in age-standardised mortality, and changes in population age structure accounted for most of it. Mortality at 5–34 years did increase over the period. National surveillance should report age-standardised and age-specific trends together with crude rates, because in this case they lead to different conclusions about the direction of asthma mortality.

<!-- END MAIN TEXT -->

# Acknowledgments

Generative AI tools were used for language editing of the manuscript text. [AUTHOR INPUT REQUIRED: name the tools and versions, and state whether they were also used to draft text.] [AUTHOR CONFIRMATION REQUIRED: once all authors have reviewed the AI-suggested changes, add a sentence stating that the authors reviewed them and take full responsibility for the content.]

# Funding

[AUTHOR INPUT REQUIRED]

# Conflicts of interest

[AUTHOR INPUT REQUIRED]

# Author contributions

**Provisional CRediT assignments (subject to both authors' approval):** Francisco Federico García Crespi — Conceptualization, Methodology, Software, Formal analysis, Data curation, Visualization, and Writing – original draft. Amaury de Souza — Writing – review & editing, Validation (epidemiological and scientific interpretation), and scientific review of the manuscript. Contributions are assignments for review, not confirmation that all listed tasks are complete. Final author order and any additional contributors require author confirmation.

# References

1. Brum M, Henz J, Boeira M, Soares S, Friedrich F, Pitrez PM. Recent increase in asthma mortality in Brazil: a warning sign for the public health system. J Bras Pneumol. 2024;50(5):e20240138. doi:10.36416/1806-3756/e20240138
2. Cardoso ADRO, Ferreira ACG, Rabahi MF. Asthma-related deaths in Brazil: data from an ecological study. J Bras Pneumol. 2024;50(6):e20240296. doi:10.36416/1806-3756/e20240296
3. Graudenz GS, Carneiro DP, Vieira RP. Trends in asthma mortality in the 0- to 4-year and 5- to 34-year age groups in Brazil. J Bras Pneumol. 2017;43(1):24-31. doi:10.1590/S1806-37562015000000253
4. Brum M, et al. Analysis code accompanying reference 1. GitHub repository, commit 8d527a5 (15 May 2024). Available from: https://github.com/mobrant94/asthma_mortality
5. Ministério da Saúde (Brasil). Sistema de Informação sobre Mortalidade (SIM). Portal de Dados Abertos do SUS. Available from: https://dadosabertos.saude.gov.br/dataset/sim
6. Instituto Brasileiro de Geografia e Estatística. Projeção da População do Brasil e das Unidades da Federação, revisão 2018: população por idade simples, 2010–2060. Available from: https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2018/ (accessed 1 October 2026)
7. Instituto Brasileiro de Geografia e Estatística. Projeções da População, revisão 2024: população por idade simples. Available from: https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2024/ (accessed 1 October 2026)
8. Ahmad OB, Boschi-Pinto C, Lopez AD, Murray CJL, Lozano R, Inoue M. Age standardization of rates: a new WHO standard. GPE Discussion Paper Series No. 31. Geneva: World Health Organization; 2001.
9. Venables WN, Ripley BD. Modern applied statistics with S. 4th ed. New York: Springer; 2002.
10. R Core Team. R: a language and environment for statistical computing. Vienna: R Foundation for Statistical Computing; 2024. Available from: https://www.R-project.org/

# Tables

Table: **Table 1.** Trend estimates, Brazil, 2014–2021. ^a^Change in the rate, per 100,000 per year, from a Gaussian-family generalised linear model (crude and age-standardised national series) or ordinary least squares (age groups), eight annual observations, 95% confidence intervals from the t distribution with 6 degrees of freedom. Change (%) is the relative change between 2014 and 2021. The two crude rows reproduce the original analysis (deaths above 6 years of continuous age) and differ only in the population base; the age-standardised row uses completed ages of 7 years or more. Population: IBGE 2018 projection.

{{TABLE:tab_trends}}


# Figure legends

**Figure 1.** Relative change in each rate from its 2014 value, Brazil, 2014–2021: crude rate (dashed line, open circles) and age-standardised rate (Brazil 2014 standard; solid line, filled circles), both for completed ages of 7 years and older and the same deaths and population, and rate at ages 5–34 years (dash-dot line, triangles). Annual data; population from the IBGE 2018 projection. File: fig1_relative_change_ge7.jpg.

**Figure 2.** Kitagawa decomposition of the change in the crude rate, completed ages 7 years and older, for six pairs of years (post hoc analysis), Brazil. Black bars: age-composition component; hatched bars: age-specific-rate component. The two components sum to the change in the crude rate. Deaths per 100,000; population from the IBGE 2018 projection. The components are accounting terms, not causal effects. Exact values in Supplementary Table S6. File: fig2_kitagawa_sensitivity.jpg.
