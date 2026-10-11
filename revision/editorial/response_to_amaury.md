# Response to Amaury — scientific revision prepared for author review

Reference: comments emailed 10 October 2026, 17:49:08 UTC. This document is a prepared response; no email has been sent.

Dear Amaury,

Thank you for your review. We have implemented all six scientific clarification requests using the corrected primary configuration and an independently checked reproduction of the historical pipeline. The revised package includes the clean manuscript, comparison copy, supplementary material, figures, full scenario results and provenance records. The following responses describe completed changes; author declarations and approval of the final interpretation remain for both authors.

## 1. Epidemiological interpretation

The national domain of completed ages ≥7 is explicit in the abstract, methods, results, Table 1, figures and discussion. The corrected Brazil-2014-standardised endpoint change is -4.06%, while the slope over all eight years is 0.00016 per 100,000/year (95% CI -0.02139 to 0.02170). We do not interpret non-significance as stability. The negative-binomial age-adjusted model with IBGE 2024 remains positive (1.14% annually, 95% CI 0.03 to 2.26; p = 0.044); it is reported alongside all six national specifications, not selected as the preferred model.

Location and evidence: Abstract; Methods: domains and trends; Results: National domain; Discussion; Table 1; S4.

## 2. Age standardisation

We added the direct-standardisation equation and weights summing to one within each analysed domain. Brazil-2014 weights are fixed across years and independently normalised within ≥7, 5–34 and each other domain; each denominator revision uses its corresponding 2014 population. Ages ≥90 form one matching open interval. WHO calculations aggregate five-year rates, combine the three ≥90 weights, and assign three fifths of the 5–9 weight to 7–9 before renormalisation. The latter is explicitly described as a uniform-within-band approximation. Independent calculations checked every rate and weight sum; Brazil-standardised and aligned crude rates agree in the standard year.

Location and evidence: Methods: Denominators and direct standardisation; S5; standard_weights.csv; independent_output_checks.json.

## 3. Age definitions and denominators

Table 1 now includes the aligned crude ≥7 series with slope, interval and absolute/relative endpoint changes. The principal uses completed calendar age, with the 29-February anniversary on 1 March in non-leap years. Invalid dates and birth after death are excluded; no upper-age exclusion is added. Calendar age changed 23 candidate single-year bins (23 retained), without changing membership in the five named domains; the record-by-record audit is provided. The historical continuous >6 construction stays separate and reproducible. The corrected 2021 aligned crude rate differs from the original PDF because of U071; the original 1.258 is not imposed on the revision.

Location and evidence: Methods: Calendar ages; Table 1; S1–S2; record_selection_and_age_transitions.csv.

## 4. Kitagawa decomposition

We added Kitagawa's original 1955 reference (doi:10.1080/01621459.1955.10501299), both symmetric equations and the exact identity. All six endpoint pairs were repeated with IBGE 2024. The 2014–2021 composition share is 142.54% under IBGE 2018 and 117.00% under IBGE 2024. Contributions over 100% mean a negative rate component offsets composition. Unrounded identities pass at 1e−12; each displayed term is rounded independently, explaining last-digit discrepancies. Age-level contributions are supplied and the interpretation remains non-causal.

Location and evidence: Methods: Kitagawa; Results: Composition; Figure 2; S6; kitagawa_age_contributions.csv.

## 5. Mortality at ages 5–34

The abstract now highlights standardisation within 5–34. Corrected crude mortality increases by 0.0358 per 100,000 (19.69%); the Brazil-standardised increase is 0.0328 (18.03%). These replace the approximate 0.037 from the reference rather than retaining it after selection changes. Removing 2020 gives a positive within-group-standardised slope (p = 0.040). For 2014–2019 the slope is positive but its interval includes zero (p = 0.107); we therefore removed the assertion that every sensitivity establishes a significant trend. The actual years remain the covariate. The same analyses for 7–34, both denominator revisions, Brazil and WHO standards, and three count families are provided. We do not claim a historical reversal or change point.

Location and evidence: Abstract; Results: 5–34 and sensitivities; Discussion; S5, S7; Figure S1.

## 6. Record selection and statistical models

Historical exclusions are separated into 56 COVID-related records and one reduced-key removal. Adding U071 excludes one additional 2021 event; the overlap audit shows 18 U071 records in 2020 already excluded and 18 of 19 in 2021 already excluded by the original rule. The principal retains both ambiguous 2018 rows: all public fields were inspected, but occupation and seven administrative fields differ and the death-declaration number is unavailable. Matching dates/causes cannot establish identity. Historical-key collapse and retention of all COVID mentions are explicit one-condition sensitivities. The nine age bands, log-link equations, population offset and reference band are specified. Quasi-Poisson intervals use residual-df t critical values; Poisson and negative binomial use normal Wald intervals. Mean-model convergence, dispersion, theta, warnings and errors are retained. Negative-binomial theta iteration-limit warnings are disclosed rather than described as exact Poisson equivalence or omitted. Independent matrix/IRLS calculations checked all 252 count models.

Location and evidence: Methods: Selection and models; S1, S4, S8; duplicate_pair_audit.md; independent_model_checks.csv.

## Declarations and journal selection

The no-funding and no-conflicts wording is carried forward from the sent PDF, explicitly requiring confirmation from both authors. No formally granted ethics approval or exemption is asserted. A separate checklist identifies the institutional/journal determination still needed, along with final contributions, affiliations and review of AI-assisted work. Journal selection and submission remain outside this execution.

The reference PDF was fixed by SHA-256. The historical pipeline reproduced all selection counts, age aggregates and primary denominator cells exactly with the recovered official files. SIM 2020–2021 hashes match the available historical audit; absence of historical execution hashes for SIM 2014–2019 remains a documentary limitation. R 4.6.1 and current package versions are recorded; very small numerical environment differences, including unstable large-theta estimates near the Poisson limit, are documented.

Best regards,

Federico — draft for both authors to review