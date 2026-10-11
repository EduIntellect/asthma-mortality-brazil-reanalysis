ASTHMA MORTALITY IN BRAZIL

Reassessing the reported increase in asthma mortality in Brazil: reproduction and age-specific reanalysis, 2014–2021

Authors: Francisco Federico García Crespi¹ · Amaury de Souza²

¹ Universidad Miguel Hernández, Elche, Alicante, Spain

² Institute of Physics, Federal University of Mato Grosso do Sul (UFMS), Campo Grande, MS, Brazil

Corresponding author: Francisco Federico García Crespi · fedeg@umh.es

Amaury de Souza · amaury.souza@ufms.br · ORCID: 0000-0001-8168-1482

Reassessing the reported increase in asthma mortality in Brazil: reproduction and age-specific reanalysis, 2014–2021

Abstract

Objective: To assess whether rising crude asthma mortality in Brazil (2014–2021) persists after age standardisation and to examine trends at ages 5–34.

Methods: Using published code, national mortality records (ICD-10 J45–J46) and Brazilian Institute of Geography and Statistics (IBGE) projections, we reproduced the original analysis, calculated age-standardised rates (Brazil 2014) and assessed eight-year trends. Count models, an alternative IBGE population projection (2024 revision), World Health Organization (WHO) standardisation and Kitagawa decomposition were post hoc.

Results: We reproduced 18,583 deaths versus 18,584 reported. The crude national rate rose by 12.5% (slope 0.025 per 100,000/year; p = 0.029). Among completed ages ≥7 (18,544 deaths), the aligned crude rate rose by 12.0%, versus a 4.0% fall in the standardised rate (eight-year slope 0.0002 per 100,000/year; 95% CI −0.021 to 0.022; p = 0.983). Age composition accounted for 62–193% of crude-rate increases across six endpoint comparisons. Only one of six age-adjusted count-model specifications, negative binomial regression with 2024 denominators, yielded a positive estimate whose interval excluded zero (+1.14% annually; 95% CI 0.04 to 2.26). Rates at ages 5–34 increased by 20.3% (p = 0.014), consistently across sensitivity analyses.

Conclusion: Changes in population age composition accounted for most of the crude increase, without establishing a causal explanation. The primary age-standardised analysis did not support a comparable national increase, whereas mortality at ages 5–34 rose. Surveillance should report crude, age-standardised and age-specific rates jointly.

Keywords: Asthma; Mortality; Age Distribution; Population Dynamics; Reproducibility of Results; Brazil.

Introduction

Brum et al. concluded that “asthma mortality remains high and shows an increasing trend for the first time in the past decades” [1]. Their nationwide analysis for 2014–2021 identified 18,584 asthma deaths and reported an approximately 2.5% annual increase in asthma mortality. A subsequent study by Cardoso et al., covering 2013–2023, also concluded that asthma-related deaths had increased [2]. However, this conclusion was based on annual death counts, while the same study reported that the overall mortality rate per 100,000 inhabitants remained stable. Thus, the two studies described increasing asthma mortality using different measures, neither of which established an increase in the national age-standardised rate.

Earlier Brazilian surveillance provides a longer perspective. Graudenz et al. reported a linear decline in age-standardised asthma mortality among Brazilians aged 5–34 years during 1980–2014, whereas the trend in the general population was non-linear [3]. Differences in study periods, age ranges and rate definitions prevent direct comparison with more recent estimates or the identification of a historical trend reversal.

Neither Brum et al. nor Cardoso et al. directly age-standardised the national mortality series. This omission matters because approximately two thirds of asthma deaths occurred among individuals aged 60 years or older [1,2], and changes in population age structure can affect crude mortality rates independently of changes in age-specific mortality. Consequently, an increase in deaths or crude mortality cannot, by itself, establish a comparable increase in age-adjusted mortality. The public availability of Brum et al.’s analytical code [4] also makes it possible to examine the reproducibility of their case selection, population denominators and trend estimates before reassessing the interpretation.

We therefore asked to what extent the reported increase in asthma mortality in Brazil during 2014–2021 remains supported when the original analysis is reproduced and population age structure is held fixed. We first reproduced Brum et al.’s analysis and documented agreements and discrepancies with the published results. We then estimated national age-standardised mortality trends and examined mortality among individuals aged 5–34 years. In post hoc robustness analyses, we assessed an alternative population projection, the WHO standard population and count regression models. Our objective was not to dispute the observed increase in crude mortality, but to establish which epidemiological interpretations are supported after accounting for population age structure and examining age-specific trends.

Methods

Study design

We conducted a secondary analysis of publicly available mortality data, reproducing the national asthma mortality analysis by Brum et al. for 2014–2021 [1] and examining two extensions: direct age standardisation of national mortality rates and mortality trends among individuals aged 5–34 years. The project documentation identifies these as the primary questions, with ages 7–34 years as a technical control and ages 35–59 years as an additional comparison. The Brazil 2014 population was selected as the primary standard. Reproduction was assessed against a tolerance of 2% for the total number of deaths and agreement in the direction and approximate magnitude of the original age-group trends. Count regression models, the WHO standard population and an alternative population projection were subsequently introduced as post hoc robustness analyses.

Mortality data and case selection

Mortality records for 2014–2021 were obtained from the Brazilian Mortality Information System (SIM) [5] on 1 October 2026. The original source URLs were no longer fully accessible, so all years were retrieved from the current official archives. Possible retrospective revisions of these data may affect exact reproduction.

Deaths were selected when the underlying cause contained ICD-10 J45 or J46. Records containing the COVID-related codes B342 or U072, or the text “COVID-19”, in the cause-of-death lines were excluded. Age was calculated from birth and death dates as the elapsed number of days divided by 365.25. Records with invalid or missing birth dates were excluded from age-specific analyses.

Duplicate records were identified using the birth and death dates, underlying cause and five available cause-of-death fields. This procedure uses the variables loaded by our pipeline but does not exactly reproduce the original full-record deduplication.

To reproduce Brum et al., we retained deaths with calculated age greater than six years. The 5–34-year analysis instead used all age-valid records, including deaths at ages five and six.

Population denominators

The original population workbook was unavailable. We reconstructed denominators using IBGE national population projections by single year of age and both sexes combined. The 2018 revision was used in the primary analysis [6], and the 2024 revision, incorporating the 2022 Census, in sensitivity analyses [7]. The exact population series used by Brum et al. could not be recovered.

Mortality rates and age standardisation

For the reproduction of the national crude series, deaths above six years of age were divided by the total population, following the construction inferred from the published code [4]. We also calculated a version restricted to the population above six years. Original age groups were reproduced using their apparent numerator and denominator definitions, with unresolved denominator differences documented in the reproducibility audit.

Direct age standardisation used single-year age-specific mortality rates and the corresponding population weights from Brazil in 2014. Ages were represented as completed years from 7 to 89, with ages 90 and above grouped together. Consequently, this analysis used completed ages of at least seven years, whereas the reproduction retained the original continuous-age threshold greater than six years. These definitions were kept distinct rather than treated as identical samples.

Rates for ages 5–34, 7–34 and 35–59 years used deaths and population denominators restricted to the corresponding ages. Post hoc analyses also used the WHO World Standard Population [8].

Statistical analysis

The primary trend models followed those of the published analysis: Gaussian generalised linear regression for national annual rates and ordinary least squares for age-group rates. Eight annual observations were available for each series. Slopes were expressed as deaths per 100,000 population per year, with 95% confidence intervals calculated using the t distribution with six degrees of freedom. We also reported changes between 2014 and 2021. For comparison with Brum et al., we calculated the mean of annual relative differences from the 2014 rate, their reported change metric.

Post hoc analyses used Poisson, quasi-Poisson and negative binomial regression [9], with population offsets. A national age-adjusted count model included calendar year and nine age bands. Overdispersion was assessed to guide interpretation of count-model uncertainty. In a further post hoc analysis, the change in the crude rate for completed ages of 7 years and older was split into an age-composition component and an age-specific-rate component with the symmetric Kitagawa decomposition, using single years of age and the 2018 projection. Because a comparison between two years depends on its endpoints, the decomposition was repeated for six pairs of years. No correction for multiple comparisons was applied; secondary estimates were interpreted descriptively.

Software, data and code availability

Analyses were performed in R 4.3.3 [10]. The analysis code, intermediate aggregate tables, generated results and reproduction audit are available at https://github.com/EduIntellect/asthma-mortality-brazil-reanalysis. Mortality and population data were obtained from public Brazilian sources.

Use of artificial intelligence

Generative AI tools, including Claude Code (Anthropic) and GitHub Copilot (GitHub), were used to generate and review analysis scripts and to examine analytical results. The authors wrote and finalised the manuscript.

The figures were rendered programmatically from analytical outputs rather than generated as images by an AI image-generation tool.

Ethics

The study used publicly accessible SIM mortality data and aggregated population projections without direct contact with participants. No identifying personal information was included in the reported results.

Results

Reproduction of the original analysis

The SIM files for 2014–2021 contained 19,105 deaths with asthma as the underlying cause. After the COVID-19-related exclusion and removal of duplicates (57 records, 56 of them in 2020–2021) and exclusion of 15 deaths without a valid date of birth, the reproduction included 18,583 deaths above 6 years of age, against 18,584 reported by Brum et al. [1] (Supplementary Table S1). Of these, 68.2% occurred at 60 years or older, as in the original study.

The crude national rate rose from 1.01 to 1.14 per 100,000 between 2014 and 2021 (+12.5%), with a maximum of 1.26 in 2020 (Supplementary Table S2). The linear trend was 0.025 per 100,000 per year (95% CI 0.004 to 0.046; p = 0.029; Table 1), against 0.03 (95% CI 0.01 to 0.04; p = 0.01) in the original paper. A negative binomial model gave an annual increase of 2.3% (95% CI 1.0 to 3.6), close to the 2.5% reported originally. The published annual rates were 1.8% to 5.4% higher than ours, with a gap that widened over the period, which points to a different population series; we could not identify it.

For the age groups of the original analysis, our slopes agreed in sign and significance class with the published ones: no trend below 18 years (p = 0.85), an increase at 18–59 years (slope 0.021; p = 0.044) and a non-significant decrease at 60 years or older (slope −0.071; p = 0.14). The magnitude of the changes did not match exactly, and the largest difference, at 60 years or older, could not be reconciled (Supplementary Table S3). The reproduction thus met the criteria defined in the project documentation: total deaths within 2% and agreement in the sign of the age-group trends.

National trend after age standardisation

Using the same completed-age population of 7 years and older for both calculations, the crude rate increased from 1.123 to 1.258 per 100,000 between 2014 and 2021 (+12.0%), whereas the directly age-standardised rate decreased from 1.123 to 1.078 (−4.0%; Table 1; Figure 1). The estimated slope of the age-standardised series over all eight years was 0.0002 per 100,000 per year (95% CI −0.0213 to 0.0217; p = 0.983). Thus, the analysis did not support an increasing national age-standardised trend, although the confidence interval did not establish equivalence to a zero trend.

In post hoc count models (Supplementary Table S4), the age-adjusted national trend was +0.00% per year with quasi-Poisson intervals (95% CI −1.12 to 1.14) and +0.9% (−0.2 to 2.1; p = 0.10) with a negative binomial model. With the 2024 population projection, the negative binomial estimate was +1.1% per year (95% CI 0.04 to 2.3; p = 0.043), the only one of six age-adjusted specifications whose interval excluded zero. The crude series was overdispersed (dispersion 5.9); its annual increase of 2.3% had p = 0.029 with quasi-Poisson and p < 0.001 with negative binomial intervals. Using the WHO standard population, the standardised rate changed by −4.2% (p = 0.99) with the 2018 projection and by −2.0% (p = 0.73) with the 2024 projection (Supplementary Table S5).

Decomposition of the change in the crude rate

The age-composition component accounted for 62% to 193% of the observed crude-rate increase across the six endpoint comparisons, while the component associated with age-specific mortality rates changed sign (Figure 2; exact values in Supplementary Table S6). For 2014–2021, the positive composition effect (+0.191 per 100,000) exceeded the net increase (+0.135) and was partly offset by changes in age-specific rates (−0.057). Approximately 95% of the composition component arose among individuals aged 60 years or older.

Ages 5–34 years

The rate at ages 5–34 years rose from 0.182 to 0.219 per 100,000 between 2014 and 2021 (+20.3%; slope 0.0080 per year, 95% CI 0.0023 to 0.0138; p = 0.014; Table 1). The group had 1,591 deaths over the period, between 172 and 236 per year, with the lowest rate in 2017 (0.175) and the highest in 2020 (0.244) (Supplementary Figure S1). The control group aged 7–34 years gave a similar result (+23.5%; p = 0.011; Supplementary Figure S1); it contains nearly all the deaths of the 5–34 group, so it shows that the estimate does not depend on ages 5 and 6 rather than replicating it independently.

The increase persisted in post hoc analyses. Overdispersion was negligible (1.07), and the quasi-Poisson model gave an annual increase of 4.0% (95% CI 1.2 to 7.0; p = 0.013); with the 2024 projection it was 4.2% (p = 0.011). Standardised to the WHO population within the group, the rate rose by 16.9% (p = 0.020) with the 2018 projection and by 19.1% (p = 0.015) with the 2024 projection.

At 35–59 years the evidence was inconclusive: the rate rose from 0.719 to 0.830 (+15.5%; p = 0.13), and the count models disagreed (p = 0.13 with quasi-Poisson and p = 0.036 with negative binomial).

Discussion

We reproduced the crude increase in asthma mortality reported by Brum et al. for 2014–2021, with one death of difference in the total count and the same direction of the national and age-group trends. After direct age standardisation, however, the national age-standardised trend was not statistically distinguishable from zero: the standardised rate fell by 4.0% and its slope over the eight years was close to zero, with a confidence interval that admits small changes in either direction. In a decomposition of the crude change, shifts in the age composition of the population accounted for most of the increase, and in the 2014–2021 comparison for more than all of it. The rise in mortality at 5–34 years, by contrast, persisted across every specification we examined.

These results do not contradict the crude series of Brum et al.; they qualify its interpretation. A rising crude rate measures a rising burden of deaths in the population, which is relevant for health services. It does not by itself show that the risk of dying from asthma at a given age has increased. Cardoso et al. reported an increase in the number of asthma deaths over 2013–2023 while noting that the overall rate per 100,000 inhabitants remained stable [2]. Together, these studies illustrate why trends in death counts and crude rates should be distinguished from age-adjusted trends. In our reanalysis, changes in population age composition accounted for much of the crude increase. The statement that asthma mortality “shows an increasing trend for the first time in the past decades” [1] is consistent with the crude-rate increase reported by Brum et al., but our analysis does not establish a comparable increase in national age-standardised mortality during 2014–2021.

The Kitagawa decomposition gives this reading a quantitative form, but it is an accounting decomposition, not a causal one. It splits a difference between two years into a component due to the age distribution and a component due to age-specific rates; it does not identify why either changed. Because two-year comparisons depend on their endpoints, we repeated it for six pairs of years. The composition component was positive in all of them, and about 95% of it arose at 60 years or older, the age range whose share of the population grew from 13.3% to 16.3%. The age-specific component changed sign with the endpoints, and was largest in the comparison ending in 2020, the year with the highest rates. We therefore treat the eight-year standardised trend as the main evidence, with the decomposition describing contributions to the crude increase.

The national age-adjusted result was not uniform across specifications. One of six count-model specifications, the negative binomial model with the 2024 population projection, estimated an increase of 1.1% per year whose interval excluded zero. The remaining specifications gave estimates between 0% and 0.9% per year with intervals that included zero. With eight annual observations, these data cannot establish that age-adjusted mortality was constant; the age-adjusted point estimates were generally smaller than the crude estimate, although the confidence intervals did not rule out increases of comparable magnitude under some specifications.

The increase at ages 5–34 requires separate interpretation. The rate rose by about 20% between 2014 and 2021, and the estimate held with count models, with the WHO standard population and with the alternative projection. This age range was used in earlier Brazilian surveillance, in which Graudenz et al. reported a decline in age-standardised mortality from 1980 to 2014 [3]. Our primary estimate for this group is not standardised within the group, and the two studies differ in period and methods, so the comparison does not establish a change point in 2014. The finding rests on 172 to 236 deaths per year, and the highest rate occurred in 2020. It warrants monitoring with longer series rather than a firm conclusion about a reversal.

The reproduction also revealed limits to exact comparison with published estimates. Our population denominators differed from those of the original study, so our annual national crude rates were 1.8% to 5.4% lower, and the magnitude of the change at 60 years or older could not be reconciled. The original code made it possible to identify these differences, but the exact population series could not be recovered. Reporting the denominators used, together with age-standardised rates alongside crude rates, would make national asthma surveillance comparable across studies and years.

Several limitations remain. The design is ecological and descriptive. The count models, the WHO standard population, the alternative projection and the decomposition were added after the main analyses and should be read as robustness or descriptive analyses, and we made no adjustment for multiple comparisons. The SIM files may have been revised since the original analysis, our deduplication did not reproduce the original procedure exactly, and changes in death certification or coding during the period, including during the COVID-19 pandemic, cannot be excluded. The questions were defined in the project documentation, but we could not document their timing relative to the analyses independently.

Overall, the increase in crude asthma mortality in Brazil between 2014 and 2021 is reproducible, but it was not accompanied by a comparable increase in age-standardised mortality, and changes in population age structure accounted for most of it. Mortality at 5–34 years did increase over the period. National surveillance should report age-standardised and age-specific trends together with crude rates, because in this case they lead to different conclusions about the direction of asthma mortality.

Funding

No funding was received for this study.

Conflicts of interest

The authors declare no conflicts of interest.

References

Brum M, Henz J, Boeira M, Soares S, Friedrich F, Pitrez PM. Recent increase in asthma mortality in Brazil: a warning sign for the public health system. J Bras Pneumol. 2024;50(5):e20240138. doi:10.36416/1806-3756/e20240138

Cardoso ADRO, Ferreira ACG, Rabahi MF. Asthma-related deaths in Brazil: data from an ecological study. J Bras Pneumol. 2024;50(6):e20240296. doi:10.36416/1806-3756/e20240296

Graudenz GS, Carneiro DP, Vieira RP. Trends in asthma mortality in the 0- to 4-year and 5- to 34-year age groups in Brazil. J Bras Pneumol. 2017;43(1):24-31. doi:10.1590/S1806-37562015000000253

Brum M, et al. Analysis code accompanying reference 1. GitHub repository, commit 8d527a5 (15 May 2024). Available from: https://github.com/mobrant94/asthma_mortality

Ministério da Saúde (Brasil). Sistema de Informação sobre Mortalidade (SIM). Portal de Dados Abertos do SUS. Available from: https://dadosabertos.saude.gov.br/dataset/sim

Instituto Brasileiro de Geografia e Estatística. Projeção da População do Brasil e das Unidades da Federação, revisão 2018: população por idade simples, 2010–2060. Available from: https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2018/ (accessed 1 October 2026)

Instituto Brasileiro de Geografia e Estatística. Projeções da População, revisão 2024: população por idade simples. Available from: https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2024/ (accessed 1 October 2026)

Ahmad OB, Boschi-Pinto C, Lopez AD, Murray CJL, Lozano R, Inoue M. Age standardization of rates: a new WHO standard. GPE Discussion Paper Series No. 31. Geneva: World Health Organization; 2001.

Venables WN, Ripley BD. Modern applied statistics with S. 4th ed. New York: Springer; 2002.

R Core Team. R: a language and environment for statistical computing. Vienna: R Foundation for Statistical Computing; 2024. Available from: https://www.R-project.org/

Tables

Table 1. Trend estimates, Brazil, 2014–2021. aChange in the rate, per 100,000 per year, from a Gaussian-family generalised linear model (crude and age-standardised national series) or ordinary least squares (age groups), eight annual observations, 95% confidence intervals from the t distribution with 6 degrees of freedom. Change (%) is the relative change between 2014 and 2021. The two crude rows reproduce the original analysis (deaths above 6 years of continuous age) and differ only in the population base; the age-standardised row uses completed ages of 7 years or more. Population: IBGE 2018 projection.

Series

Rate 2014

Rate 2021

Change (%)

Slopea

95% CI

p

Crude national rate

1.012

1.138

+12.5

0.0250

(0.0036 to 0.0463)

0.029

Crude national rate, population >6 years

1.126

1.260

+11.9

0.0268

(0.0031 to 0.0505)

0.032

Age-standardised (Brazil 2014)

1.123

1.078

−4.0

0.0002

(−0.0213 to 0.0217)

0.983

Ages 5–34

0.182

0.219

+20.3

0.0080

(0.0023 to 0.0138)

0.014

Ages 7–34

0.181

0.224

+23.5

0.0094

(0.0031 to 0.0156)

0.011

Ages 35–59

0.719

0.830

+15.5

0.0221

(−0.0089 to 0.0532)

0.132

Figures

Figure 1. Relative changes in asthma mortality rates

Relative change in each rate from its 2014 value, Brazil, 2014–2021: crude rate (dashed line, open circles) and age-standardised rate (Brazil 2014 standard; solid line, filled circles), both for completed ages of 7 years and older and the same deaths and population, and rate at ages 5–34 years (dash-dot line, triangles). Annual data; population from the IBGE 2018 projection.

Figure 2. Kitagawa decomposition of crude-rate change

Kitagawa decomposition of the change in the crude rate, completed ages 7 years and older, for six pairs of years (post hoc analysis), Brazil. Black bars: age-composition component; hatched bars: age-specific-rate component. The two components sum to the change in the crude rate. Deaths per 100,000; population from the IBGE 2018 projection. The components are accounting terms, not causal effects. Exact values in Supplementary Table S6.

Supplementary material

Reassessing the reported increase in asthma mortality in Brazil: reproduction and age-specific reanalysis, 2014–2021

Supplementary Table S1. Death records by year and stage of case selection. aAfter the COVID-19-related exclusion (B34.2, U07.2 or “COVID-19” in the cause-of-death lines) and removal of duplicate records. The last column is the sample of the reproduction: asthma deaths above 6 years of age with a valid date of birth.

Year

All records

Asthma (J45–J46)

After exclusionsa

Valid birth date

Age >6 years

2014

1,227,039

2,129

2,129

2,127

2,041

2015

1,264,175

2,232

2,232

2,231

2,148

2016

1,309,774

2,249

2,249

2,247

2,190

2017

1,312,663

2,477

2,477

2,476

2,423

2018

1,316,719

2,307

2,306

2,302

2,249

2019

1,349,801

2,488

2,488

2,486

2,426

2020

1,556,824

2,735

2,708

2,705

2,678

2021

1,832,649

2,488

2,459

2,459

2,428

Total

11,169,644

19,105

19,048

19,033

18,583

Supplementary Table S2. Deaths (upper panel) and rates per 100,000 (lower panel) by year. The crude national rate uses deaths above 6 years of age and the total population; the age-standardised rate uses the 2014 Brazilian age distribution within completed ages of 7 or more. Rates for the age groups are per 100,000 persons of that age. Population: IBGE 2018 projection.

Series

2014

2015

2016

2017

2018

2019

2020

2021

Deaths

Crude national rate

2,041

2,148

2,190

2,423

2,249

2,426

2,678

2,428

Age-standardised (Brazil 2014)

2,035

2,142

2,187

2,418

2,243

2,419

2,677

2,423

Ages 5–34

182

189

184

172

200

218

236

210

Ages 7–34

171

174

179

164

190

208

232

202

Ages 35–59

452

485

515

567

504

524

709

591

Rate per 100,000

Crude national rate

1.012

1.056

1.067

1.172

1.079

1.154

1.265

1.138

Age-standardised (Brazil 2014)

1.123

1.144

1.132

1.209

1.089

1.140

1.230

1.078

Ages 5–34

0.182

0.190

0.186

0.175

0.204

0.224

0.244

0.219

Ages 7–34

0.181

0.186

0.192

0.177

0.207

0.228

0.256

0.224

Ages 35–59

0.719

0.756

0.787

0.851

0.743

0.759

1.011

0.830

Supplementary Table S3. Age groups as constructed in the original analysis, reproduced with the 2018 projection. aLabelled “below 18” in the original analysis; the numerator contains deaths at 7–17 years and the denominator the population aged 0–17. bMean over 2015–2021 of the relative difference from the 2014 rate, which is the quantity reported by the original analysis. Rates per 100,000 in the stated age group.

Group

Deaths 2014 / 2021

Rate 2014 / 2021

Change 2014–2021 (%)

Mean relative variationb (%)

Slope

p

Ages 7–17a

43 / 37

0.076 / 0.069

−9.2

+12.1

−0.0005

0.852

Ages 18–59

580 / 756

0.478 / 0.587

+22.9

+16.5

0.0212

0.044

Ages ≥60

1,412 / 1,630

5.853 / 5.203

−11.1

−1.9

−0.0712

0.135

Supplementary Table S4. Count models with population offset (post hoc analysis), 2018 projection unless stated. aPearson chi-square divided by degrees of freedom in the Poisson model; values well above 1 indicate overdispersion. The age-adjusted model uses nine age bands as a factor. For ages 5–34 and 7–34 the negative binomial model is equivalent to the Poisson model. bAnnual change (%) from quasi-Poisson models with the 2024 projection, with the p value in parentheses.

Series

Dispersiona

Quasi-Poisson, annual change (%)

p

p, neg. binomial

2024 denominatorsb

Crude national rate

5.91

+2.25 (0.32 to 4.22)

0.029

<0.001

+2.40 (0.022)

Age-adjusted, ages ≥7

3.11

+0.00 (−1.12 to 1.14)

0.994

0.104

+0.29 (0.602)

Ages 5–34

1.07

+4.04 (1.20 to 6.96)

0.013

<0.001

+4.22 (0.011)

Ages 7–34

1.13

+4.65 (1.64 to 7.75)

0.009

<0.001

+4.83 (0.007)

Ages 35–59

5.54

+2.78 (−1.08 to 6.79)

0.130

0.036

+2.84 (0.123)

Supplementary Table S5. Sensitivity to the standard population and to the population projection (post hoc analysis). For each row the slope is in rate units per year, from ordinary least squares on eight annual values. The WHO standard population is applied in five-year bands, and the age-standardised rows for ages 7 or more use the 5–9 band at three fifths of its weight.

Specification

Rate 2014

Rate 2021

Change (%)

Slope

95% CI

p

Ages ≥7, age-standardised

Brazil 2014 standard, 2018 projection (primary)

1.123

1.078

−4.0

0.0002

(−0.0213 to 0.0217)

0.983

Brazil 2014 standard, 2024 projection

1.128

1.112

−1.5

0.0040

(−0.0176 to 0.0255)

0.668

WHO standard, 2018 projection

1.095

1.049

−4.2

−0.0001

(−0.0207 to 0.0205)

0.990

WHO standard, 2024 projection

1.102

1.080

−2.0

0.0031

(−0.0176 to 0.0237)

0.727

Ages 5–34

Crude group rate, 2018 projection (primary)

0.182

0.219

+20.3

0.0080

(0.0023 to 0.0138)

0.014

Crude group rate, 2024 projection

0.183

0.222

+21.7

0.0085

(0.0026 to 0.0144)

0.012

WHO standard, 2018 projection

0.178

0.208

+16.9

0.0069

(0.0015 to 0.0122)

0.020

WHO standard, 2024 projection

0.179

0.213

+19.1

0.0075

(0.0021 to 0.0130)

0.015

Supplementary Table S6. Kitagawa decomposition of the change in the crude rate, completed ages 7 years and older (post hoc analysis). Rates and components per 100,000; population from the IBGE 2018 projection. The two components sum to the change in the crude rate. aAge-composition component as a percentage of the change in the crude rate; it exceeds 100% when the age-specific-rate component is negative, that is, when changes in age-specific rates partly offset the effect of the changing age composition.

Years compared

Crude rate, start / end

Change

Age composition

Age-specific rates

Composition share (%)a

Ages ≥60 in composition (%)

2014–2021

1.123 / 1.258

+0.135

+0.191

−0.057

142

95

2014–2019

1.123 / 1.276

+0.154

+0.138

+0.016

90

95

2014–2020

1.123 / 1.401

+0.278

+0.171

+0.107

62

94

2015–2021

1.171 / 1.258

+0.087

+0.167

−0.081

193

95

2016–2021

1.184 / 1.258

+0.073

+0.140

−0.067

191

95

2014–2018

1.123 / 1.194

+0.071

+0.107

−0.036

151

94

Supplementary Figure S1. Mortality at ages 5–34 years

Asthma mortality at ages 5–34 years, Brazil, 2014–2021. Upper panel: rate per 100,000 at ages 5–34 (solid line, filled circles) and at ages 7–34, the control group matching the age filter of the original analysis (dashed line, open squares). Lower panel: annual asthma deaths at ages 5–34. Population from the IBGE 2018 projection.