# Reanálisis: mortalidad por asma en Brasil (2014-2021)

Reanálisis reproducible de Brum et al. (mortalidad por asma en Brasil, microdatos SIM/DATASUS,
2014-2021). Repositorio de referencia: `mobrant94/asthma_mortality`, commit `8d527a5`.

Pregunta: ¿persiste el aumento de mortalidad reportado para 2014-2021 (a) tras estandarización
directa por edad y (b) en el grupo de edad 5-34 años?

## Resultado (ver `reanalysis/audit_reproduction.md` y `reanalysis/primary_results.csv`)

Regla de selección única: exclusión COVID del código de Brum (B342, U072, "COVID-19") más U07.1
(ver `reanalysis/audit/u071_rerun_diff.md`). Es un reanálisis con una desviación declarada
respecto al procedimiento original, no una replicación exacta.

- Total frente al publicado (18.584 muertes, edad continua >6): 18.582 (0,011 % de diferencia).
  De las 2 muertes de diferencia, 1 ya existía con el protocolo original (18.583, valor
  histórico) y 1 procede de la exclusión adicional por U07.1 (2021).
- Tasa cruda nacional (denominador de Brum): sube +12,4 % 2014→2021, p=0,029.
- **Tras estandarizar por edad** (estándar poblacional Brasil 2014): el aumento **no persiste**
  — pendiente ≈0 (p=0,99).
- **Grupo 5-34 años**: el aumento **sí persiste** y es significativo (+19,7 %, p=0,016),
  confirmado por el grupo control 7-34 (compatible con el filtro de edad original).
- Robustez (fuera del protocolo): con modelos de conteos el 5-34 se mantiene (+4,0 %/año,
  cuasi-Poisson p=0,014) y el estándar WHO da lo mismo; la tendencia nacional ajustada por edad
  queda entre 0 y +1 %/año según el modelo. Ver `reanalysis/R/08_count_models_and_who_standard.R`.
- Sensibilidad con población post-censo 2022 (IBGE, revisión 2024): mismas conclusiones
  (estandarizada p=0,67; 5-34 p=0,013). Ver `reanalysis/R/07_denominator_sensitivity.R`.

## Estructura

- `reanalysis/R/`: pipeline en R, un script por fase (`00_provenance.R` a `06_trend_models.R`),
  más `run_pipeline.R` (orquestador, procesa un año de SIM cada vez, memoria acotada) y
  `check_fase1_reconciliation.R` (verificación de los grupos de edad originales de Brum).
- `reanalysis/audit_reproduction.md`: auditoría completa — procedencia de los datos, sustituciones
  de fuentes documentadas, chequeo de tolerancia, discrepancias y correcciones aplicadas.
- `reanalysis/docs/data_sources.md`: URLs, versiones y hashes de las fuentes SIM/IBGE usadas.
- `reanalysis/primary_results.csv`: tabla principal de resultados (todas las series, por año).
- `reanalysis/annual_aggregates.csv`: muertes J45/J46 por año y edad simple, tras todos los
  filtros y exclusiones.
- `reanalysis/data/`: denominadores IBGE, comparaciones de denominador, series intermedias.
- `reanalysis/figures_comparative.png`: figura única comparando las tres series clave.
- `reanalysis/session_info.txt`: versiones de R/paquetes y procedencia completa de la ejecución.

## Reproducir

```
Rscript reanalysis/R/run_pipeline.R
Rscript reanalysis/R/check_fase1_reconciliation.R
```

Descarga los microdatos SIM (2014-2021) y el fichero de proyección poblacional IBGE la primera vez
que se ejecuta (ver `reanalysis/docs/data_sources.md` para las URLs exactas); las ejecuciones
siguientes reutilizan los ficheros ya descargados en `reanalysis/data_raw/` (no versionado, ver
`.gitignore`).


## Manuscript tables and figures (generation order)

`run_pipeline.R` produces the analytical outputs and then runs the Kitagawa
decomposition, but it does **not** build the manuscript assets. After the
pipeline (or after `10_kitagawa_endpoints.R` alone, if only the decomposition
changed), run:

```sh
Rscript reanalysis/R/10_kitagawa_endpoints.R   # if not already run by run_pipeline.R
Rscript reanalysis/R/09_manuscript_assets.R
```

`09_manuscript_assets.R` reads only committed CSV outputs and writes the LaTeX
table fragments in `reanalysis/manuscript/tables/` (including
`tab_kitagawa.tex`) and the figures in `reanalysis/manuscript/figures/`:
`fig1_relative_change.*` for the letter, and `fig1_relative_change_ge7.pdf/.jpg`
for the full article (crude and age-standardised rates over the same completed
ages ≥7; black and white, JPEG at 300 dpi). It also writes
`reanalysis/data/crude_rate_ge7_series.csv` and stops if that series does not
match the standardised rate in 2014 or the Kitagawa 2014–2021 endpoint.

## Full article for submission (RRCP, Word)

The full article is maintained as versioned Markdown in
`reanalysis/manuscript/article/` (`manuscript.md`, `supplement.md`,
`title_page.md`). The Word files required by the journal are generated, never
edited by hand:

```sh
bash reanalysis/manuscript/article/build_docx.sh
```

The script converts the LaTeX table fragments written by `09_manuscript_assets.R`
into Word tables (inline math is turned into plain characters, so no equation
objects reach Word), sets table column widths (`table_widths.lua`) and a 9-pt
table style, and writes `build/title_page.docx`, `build/manuscript.docx`,
`build/supplementary_tables.docx` and `build/BUILD_REPORT.txt` (main-text and
abstract word counts). Figure 1 is uploaded separately as
`reanalysis/manuscript/figures/fig1_relative_change_ge7.jpg`.
`methods_results.tex` and `letter_to_editor.tex` are kept as earlier versions.
Bracketed `[AUTHOR ... REQUIRED]` markers in the article are deliberate and must
be completed by the authors.

## Post hoc demographic decomposition (Kitagawa)

The additional analysis uses only already-produced inputs:
`reanalysis/annual_aggregates.csv` and
`reanalysis/data/ibge_denominators_by_age.csv` (IBGE 2018).
Run it separately, without downloading or reprocessing SIM microdata:

```sh
Rscript reanalysis/R/10_kitagawa_endpoints.R
```

It is also invoked **after** the canonical outputs by
`Rscript reanalysis/R/run_pipeline.R`. The script checks that the
2014-standardised series agrees with the committed results and that
the decomposition identity is satisfied for every endpoint pair.

- Output: `reanalysis/data/kitagawa_endpoint_sensitivity.csv` (six endpoint
  pairs: 2014–2021, 2014–2019, 2014–2020, 2015–2021, 2016–2021,
  2014–2018).
- Detailed age contributions:
  `reanalysis/data/kitagawa_age_contributions.csv` (ages 7–90+, one row
  per age and endpoint pair).
- Formula (symmetric midpoint Kitagawa, rates per 100,000):
  `composition = sum((w_end - w_start) * (r_start + r_end) / 2)`;
  `age_specific_rates = sum((r_end - r_start) * (w_start + w_end) / 2)`.
  Here `w` are population shares normalised over completed ages **7+**
  and `r` are age-specific mortality rates. Their sum is the crude-rate
  difference within that same age domain.
- Population age 90 represents the **90+ open interval**, matching the
  standardisation pipeline.
- **Age-domain boundary:** 18,543 deaths (2014–2021) in the completed
  age-7+ domain used for standardisation and Kitagawa, versus 18,582
  at continuous age >6, the domain used for the comparison with Brum
  (39 records' difference; both with the U07.1-corrected selection rule;
  18,544 and 18,583 with the original rule). Do not mix these denominators.
- **Interpretation:** population ageing is a consistently positive
  compositional component in the six checked endpoint pairs. Its share
  of the total increase is endpoint-dependent (about 62–194%; 62–193%
  with the original selection rule);
  the age-specific-rate component changes sign with the endpoint.
  For 2014–2021 only, composition exceeds the net increase because
  changes in age-specific rates partly offset it.
  About 94–95% of composition in these pairs arises at ages 60+.
- This is a **post hoc accounting decomposition**, not evidence that
  demographic ageing causally produces a particular death, nor a
  replacement for the primary eight-year age-standardised trend.
  The calculations use the 2018 IBGE population projection only.
- The outputs were independently recomputed from the committed input
  CSVs. The standalone script was subsequently executed successfully with
  R 4.3.3, passing its internal checks, and its two generated CSVs were
  committed in native R write.csv format (commit dd3c0d5).
- The full run_pipeline.R workflow, which downloads SIM microdata, was not
  re-executed as part of this validation. It was later re-executed end to
  end with the U07.1-corrected selection rule (branch analysis/u071-rerun;
  see reanalysis/audit/u071_rerun_diff.md).


## Word review copy with all three figures

The submission manuscript remains `reanalysis/manuscript/article/build/manuscript.docx`;
journal figure files are maintained separately. Editorial selection:

- Main article: Table 1 (trend estimates), Figure 1
  (`fig1_relative_change_ge7.jpg`) and Figure 2
  (`fig2_kitagawa_sensitivity.jpg`), uploaded as separate JPEG files.
- Supplement (`supplementary_tables.docx`): Supplementary Tables S1–S6
  (S6 = Kitagawa decomposition, exact values behind Figure 2) and
  Supplementary Figure S1 (`figS1_age_5_34_mortality.jpg`, ages 5–34),
  embedded.

Build order (Figure 2 and Supplementary Figure S1 are generated by the Python
script; the supplement embeds S1):

```sh
python3 -m pip install python-docx matplotlib numpy
python3 reanalysis/manuscript/article/build_review_figures.py   # figures
bash reanalysis/manuscript/article/build_docx.sh                 # submission .docx
python3 reanalysis/manuscript/article/build_review_figures.py   # review copy from the new manuscript.docx
```

Inputs are the frozen `primary_results.csv` and
`data/kitagawa_endpoint_sensitivity.csv`; no models are re-estimated.
`build/manuscript_with_3_figures_REVIEW.docx` embeds Figure 1, Figure 2 and
Supplementary Figure S1 for internal author review only; it is not a
submission file.

`build/Asthma_Mortality_Brazil_COMPLETE_AUTHOR_REVIEW.docx` (commit 8a6d5a5) is
an externally produced reading copy. It is not a source: its figures were
redrawn outside the pipeline and its legends are shortened. Accepted wording
changes from it are applied to `manuscript.md`; never regenerate tables,
figures or submission files from it.
