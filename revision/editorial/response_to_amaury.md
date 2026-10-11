# Response to Amaury

Reference comments emailed 10 October 2026, 17:49:08 UTC. This document is a prepared response; no email has been sent.

Dear Amaury,

Thank you for reviewing the manuscript. We have addressed the six comments through a corrected primary analysis and an independently checked reproduction of the historical pipeline. The revised package includes the clean manuscript, a marked comparison, supplementary material, figures, all scenario results and provenance records. Below, we explain each change and identify its supporting evidence. Both authors have approved the manuscript and confirmed the author declarations.

## 1. Epidemiological interpretation

We now identify the national population aged ≥7 completed years consistently throughout the manuscript. The corrected Brazil-2014-standardised endpoint change is -4.06%, while the slope over all eight years is 0.00016 per 100,000/year (95% CI -0.02139 to 0.02170). The interval is compatible with trends in either direction and does not demonstrate stability. The negative-binomial age-adjusted model with IBGE 2024 remains positive (1.14% annually, 95% CI 0.03 to 2.26; p = 0.044); all six national specifications are reported so that readers can assess this model sensitivity.

Location and evidence. Abstract; Methods: domains and trends; Results: National domain; Discussion; Table 1; S4.

## 2. Age standardisation

We added the direct-standardisation equation and explained how weights are normalised to sum to one within each age domain. Brazil-2014 weights are fixed across years and independently normalised within ≥7, 5–34 and each other domain; each denominator revision uses its corresponding 2014 population. Ages ≥90 form one matching open interval. WHO calculations aggregate five-year rates, combine the three ≥90 weights, and assign three fifths of the 5–9 weight to 7–9 before renormalisation. Allocating that weight assumes a uniform distribution within the band. Independent calculations verified every rate and weight sum; Brazil-standardised and aligned crude rates agree in the standard year.

Location and evidence. Methods: Denominators and direct standardisation; S5; standard_weights.csv; independent_output_checks.json.

## 3. Age definitions and denominators

Table 1 now includes the aligned crude ≥7 series with slope, interval and absolute/relative endpoint changes. The principal uses completed calendar age, with the 29-February anniversary on 1 March in non-leap years. Invalid dates and birth after death are excluded; no upper-age exclusion is added. Calendar age changed 23 candidate single-year bins (23 retained) without changing membership in the five age domains. A record-level audit documents these changes. The historical continuous >6 construction stays separate and reproducible. The U071 exclusion changes the corrected 2021 aligned crude rate from the original PDF value of 1.258.

Location and evidence. Methods: Calendar ages; Table 1; S1–S2; record_selection_and_age_transitions.csv.

## 4. Kitagawa decomposition

We added Kitagawa's original 1955 reference (doi:10.1080/01621459.1955.10501299), both symmetric equations and the exact identity. All six endpoint pairs were repeated with IBGE 2024. The 2014–2021 composition share is 142.54% under IBGE 2018 and 117.00% under IBGE 2024. A contribution above 100% means that a negative rate component offsets part of the positive composition term. Unrounded identities agree within 1e−12. Independent rounding of each displayed term explains discrepancies in the last digit. The supplement provides age-level contributions and explains the descriptive scope of the decomposition.

Location and evidence. Methods: Kitagawa; Results: Composition; Figure 2; S6; kitagawa_age_contributions.csv.

## 5. Mortality at ages 5–34

The abstract now highlights standardisation within 5–34. Corrected crude mortality increases by 0.0358 per 100,000 (19.69%); the Brazil-standardised increase is 0.0328 (18.03%). These revised estimates account for the selection changes and replace the approximate 0.037 in the reference. Removing 2020 gives a positive within-group-standardised slope (p = 0.040). For 2014–2019 the slope is positive but its interval includes zero (p = 0.107); the response and manuscript therefore distinguish the endpoint increase from evidence for an annual trend. The actual years remain the covariate. The WHO sensitivity with IBGE 2018 also includes zero after excluding 2020 (p = 0.055). The supplement reports the same analyses for 7–34, both denominator revisions, Brazil and WHO standards, and all three count families. Differences in study periods and age definitions prevent identification of a historical reversal or change point.

Location and evidence. Abstract; Results: 5–34 and sensitivities; Discussion; S5, S7; Figure S1.

## 6. Record selection and statistical models

Historical exclusions are separated into 56 COVID-related records and one reduced-key removal. Adding U071 excludes one additional 2021 event; the overlap audit shows 18 U071 records in 2020 already excluded and 18 of 19 in 2021 already excluded by the original rule. The primary analysis retains both ambiguous 2018 rows. Their public fields differ in occupation and seven administrative fields; the death-declaration number is unavailable. Matching dates/causes cannot establish identity. Historical-key collapse and retention of all COVID mentions are explicit one-condition sensitivities. The nine age bands, log-link equations, population offset and reference band are specified. Quasi-Poisson intervals use residual-df t critical values; Poisson and negative binomial use normal Wald intervals. Mean-model convergence, dispersion, theta, warnings and errors are retained. Theta iteration-limit warnings are identified explicitly. They prevent a claim of successful dispersion convergence or exact equivalence to Poisson. Independent matrix/IRLS calculations checked all 252 count models.

Location and evidence. Methods: Selection and models; S1, S4, S8; duplicate_pair_audit.md; independent_model_checks.csv.

## Declarations and journal selection

The no-funding and no-conflicts wording is carried forward from the sent PDF and confirmed by the authors. The author identifies this as an ecological analysis of public records without direct participant contact. The original ethics declaration is included in the submission materials. The author record documents confirmed contributions, affiliations and approval of AI-assisted work. Submission materials have been prepared for Respiratory Research & Clinical Practice; actual journal submission remains outside this execution.

The reference PDF was fixed by SHA-256. The historical pipeline reproduced all selection counts, age aggregates and primary denominator cells exactly with the recovered official files. SIM 2020–2021 hashes match the available historical audit; absence of historical execution hashes for SIM 2014–2019 remains a documentary limitation. R 4.6.1 and current package versions are recorded; very small numerical environment differences, including unstable large-theta estimates near the Poisson limit, are documented.

Best regards,

Federico (draft for both authors to review)
