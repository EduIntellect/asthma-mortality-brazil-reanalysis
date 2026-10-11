# Amaury revision — scientific and editorial package

Prepared from commit `3884c868a07164710a2e358180b3034f9cdcf642` on branch `revision/amaury-review`. The old checkout is preserved. The branch was published following the user's explicit instruction. No email or journal submission was performed.

## Read the delivery

- `deliverables/Manuscript_CLEAN.docx` and `.pdf`: corrected manuscript.
- `deliverables/Manuscript_MARKED_COMPARISON.docx`: visible red deletions/green insertions against the sent PDF's concordant Word text, including supplementary table rows. It is a marked comparison, **not native Word Track Changes**.
- `deliverables/Supplement.docx` and `.pdf`: selection, annual series, historical comparison, all count families, standards, both denominator revisions, six Kitagawa pairs, pandemic influence and one-condition sensitivities.
- `deliverables/Response_to_Amaury.docx`: prepared response to all six comments.
- `deliverables/figures/`: three result-derived figures in PNG, vector PDF and SVG.
- `editorial/request_resolution_matrix.csv`: 27 scientific subrequests with locations and evidence.
- `editorial/author_confirmations.md`: confirmed author facts, recovered metadata and the remaining documentary ethics item.

The primary corrected ≥7 sample is 18,544. Its equality to the historical total is coincidental: one retained 2018 record and one additional excluded 2021 U071 event cancel in the total. Calendar age changes 23 single-year bins. The corrected within-5–34 Brazil-standardised endpoint increase is 0.032773 per 100,000 (+18.0304%). The principal slope interval excludes zero without 2020, but not in 2014–2019; WHO with 2018 denominators without 2020 also includes zero. These qualifications are incorporated in the manuscript.

## Inputs and immutable provenance

`inputs_manifest.json`, `locked_inputs.csv`, `evidence/csv_manifest.json` and `results/historical/input_manifest.json` record hashes and source files. The reference PDF is preserved as `evidence/reference_sent.pdf` (SHA-256 `fc552ab83d5254549fa4f1dfe880ab631a26c50bc8d861bfdc433331544e71fe`). `reference_concordant.docx` matches its content; this does not prove historical binary provenance. `editorial/reference_manifest.json` fixes that distinction. Read `editorial/reference_reconciliation.md` for differences between repository Markdown and the sent PDF.

The input directory used here is `/Users/fede/.codex/visualizations/2026/10/11/01a129b2-a305-7931-bd9d-3252bf1f7bcc/B0`, with `raw/` and `evidence/` below it. Recovered official ZIPs and their inner CSVs were independently rehashed. SIM 2020–2021 hashes match the available historical audit. Historical execution hashes for SIM 2014–2019 are absent; no claim of byte identity is made. This limitation does not prevent analysis of verified available files.

`revision/inputs/` contains the locally pinned IBGE 2024 workbook and archived official SIM dictionary. These and IBGE 2018 are included in the delivery archive; large SIM ZIPs are referenced by hash/URL, not committed. Public record-level candidate caches are local, derived from the full ZIPs, verified against inner CSV hashes and excluded from Git.

## Run the analysis

Run from the repository root. R 4.6.1 was used; historical R was reported as 4.3.3. Exact recorded package versions are in each run's `package_versions.csv` / historical `session_info.txt`. The environment is documented, not asserted identical to the historical stack.

```sh
Rscript revision/scripts/install.R
# Only when the preserved input directory is unavailable:
python3 revision/scripts/fetch_inputs.py --data-dir /absolute/path/to/input_directory
python3 revision/scripts/extract_verified_candidates.py --data-dir /absolute/path/to/input_directory
```

The downloader accepts only the locked hashes. If the official source changes, it stops instead of silently replacing an input. On an existing B0 directory, `prepare_inputs.py` verifies ZIP/workbook hashes and the extractor verifies complete inner CSV hashes and exact raw/candidate counts. The extractor regenerates every candidate from all 11,169,644 raw records, retaining every original field and a one-based data-row index. `lock_inputs.py` is a development utility: do not rerun it to accept changed source bytes without an explicit new provenance review.

```sh
python3 revision/scripts/execute.py \
  --data-dir /absolute/path/to/input_directory \
  --output-dir /absolute/path/to/new/historical \
  --scenario historical --ibge-revision 2018
python3 revision/scripts/execute.py \
  --data-dir /absolute/path/to/input_directory \
  --output-dir /absolute/path/to/new/corrected/ibge2018 \
  --scenario corrected --ibge-revision 2018
```

The historical driver runs the real full-data vroom loader, denominators, trends, Kitagawa, denominator sensitivity, all historical count/WHO models and manuscript assets. It stages ZIP symlinks and unzips/removes only its own working CSVs. Original inputs and committed historical outputs remain intact. Root portability and reporting of unused packages are its only changes from the base analysis; the analytical operations remain reproducible from the base commit.

Corrected scenarios: `corrected`, `age_days`, `covid_original`, `covid_retained`, `historical_dedup`, `without_2020`, `prepandemic`. Each accepts `--ibge-revision 2018` or `2024`; use a new output directory each time. The corrected runner verifies every locked input/cache before reading it and saves configuration, input hashes, full R session, package versions, warning/error status, coefficients, fitted objects and source-row selection/age audits. The output tree records all eight years' selection even when a trend uses fewer years; `configuration.R` and the annual rate rows identify the years actually modelled.

Every sensitivity changes one condition from the calendar/U071/retain-ambiguous principal. Historical-key deduplication intentionally uses historical elapsed-days age in its key. No maximum-age exclusion or unsupported record-linkage rule is added.

## Numerical verification

```sh
Rscript revision/scripts/test_analysis.R
Rscript revision/scripts/test_selection.R
python3 revision/scripts/compare_historical.py
python3 revision/scripts/verify_outputs.py
Rscript revision/scripts/verify_models.R
Rscript revision/scripts/verify_historical_models.R
python3 revision/scripts/audit_duplicate.py
python3 revision/scripts/verify_documents.py
```

The verification scripts audit the included result tree. `compare_historical.py` compares the full historical run against the preserved base outputs. Counts, year-age aggregates and 728 primary population cells agree exactly. Other discrepancies are documented in `editorial/historical_reproduction.md`: rate and trend differences are numerical precision, and theta differs slightly in four very-large-theta models. No significance-class discrepancy was found. Direct outputs are compared before rounding.

Independent Python datetime, population/rate/weight and Kitagawa calculations check the outputs. Independent matrix OLS and IRLS check 252 corrected/sensitivity count-model coefficients and intervals, plus all 48 historical count models. For negative binomial, these coefficient/interval checks are **conditional on the reported fitted theta**; they do not resolve theta iteration-limit warnings. All such warnings remain in outputs and the supplement. Test logs and machine-readable checks are in `qa/`.

`verify_documents.py` additionally needs Poppler `pdftotext` on PATH. It checks 74 traced numerical values, exact Markdown-to-Word content, ordered PDF text and all 486 content blocks of the concordant reference. The portable historical CLI was rerun and matched all 25 output tables exactly (`qa/historical_cli_reproduction.json`). The final visual review covered 45 pages.

## Editorial source and document generation

The single editable editorial source is `editorial/manuscript_template.md`. Its result placeholders are resolved from identified CSVs by `scripts/build_editorial.py` into `editorial/manuscript.md`; do not maintain independently edited copies of that generated file. Introduction/reference content is reconciled to the sent PDF; declarations are carried forward with confirmation status explicit. `claim_trace.json` and the final artifact manifest link text, source outputs and hashes. The supplement and response are generated from the same scenario outputs; figures are programmatic plots.

The document build uses the Codex bundled Python runtime with python-docx, pandas, NumPy, Pillow and pypdf; matplotlib and its dependencies were installed in a project-only `.vendor` directory. Exact loaded module versions are recorded in `environment_python.json`. Install those recorded versions into a suitable Python environment outside Codex if necessary. No libraries or input files in the historical checkout were modified.

```sh
python3 revision/scripts/build_editorial.py
python3 revision/scripts/build_response.py
python3 revision/scripts/build_documents.py
```

For prose-only revisions, use `build_editorial.py --text-only` to preserve every existing figure byte. The academic copyedit applied `academic-editing`, structural C-C-C/PIER diagnosis, `research-problem-mechanism-evidence` and `compag-elsevier-paper-editing`. No dedicated humanisation skill was installed; natural phrasing was handled as clarity and fluency editing. Read `editorial/academic_style_review.md` and run `scripts/verify_copyedit.py` for the protected-output, numerical-trace, equation and punctuation checks. Diagnostic English and paragraph checks from Academic Writing Toolkit are recorded in `qa/academic_tool_checks.json`; these do not substitute for scientific verification.

For PDFs/page PNGs, the Codex bundled documents `render_docx.py` helper was used with LibreOffice, `--emit_pdf` and a unique output directory. Initial logs are `qa/render_final_*.log`; the academic copyedit uses `qa/render_copyedit_*.log` and the final small wording pass uses `qa/render_polished_*.log`. The latest page counts are in `qa/render_polished_page_counts.json`. In this installation the helper path is `/Users/fede/.cache/codex-runtimes/codex-primary-runtime/plugins/openai-primary-runtime/plugins/documents/skills/documents/render_docx.py`. The bundled Python executable is `/Users/fede/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3`. The managed `soffice` wrapper is `/Users/fede/.cache/codex-runtimes/codex-primary-runtime/dependencies/bin/override/soffice`. Standard LibreOffice PDF export is an alternative in another environment, with visual reinspection required because layout can differ.

All final pages and figure labels were inspected. Table headers repeat on continuation pages; rows do not split, formulas and age-domain symbols render, and no editorial placeholders remain. The final QA report records page counts and checks against Markdown/table/figure sources. Marked comparison is for author review, not submission.

## Review boundary

The scientific and editorial commits are reviewable on `revision/amaury-review`, published following the user's instruction. Sending the response and submitting to the selected journal remain outside this execution. Scientific implementation and author review are complete. The corresponding author confirmed author approval and declarations on 11 October 2026; `author_confirmations.md` records recovered metadata and the remaining documentary ethics item.

## Structural revision requested by the authors

The five C-C-C/PIER actions are implemented in `editorial/structural_actions_review.md`. Abstract methods and the Introduction now name the descriptive decomposition; Results separate period inference from standard/model sensitivities; Discussion separates the full-period finding from temporal/historical limits; provenance was moved verbatim to reproducibility. `qa/structural_checks.json` records preservation checks. Latest manuscript/comparison rendering logs and page counts use the `render_structure_` prefix. Their 32 pages were visually inspected; the remaining 13 delivery pages are unchanged.


## RRCP submission preparation (11 October 2026)

The upload files are in `deliverables/RRCP/`; its README maps each file to its submission role. The anonymised Word/PDF, separate title page, cover letter, adapted STROBE checklist, editable Table 1 and 300-dpi JPEG figures are generated by `scripts/build_rrcp.py`. The manuscript template remains the single editorial source. Supplementary operational/provenance details are stored in `editorial/supplementary_provenance.md`. References are renumbered by first appearance with a recorded permutation and unchanged reference content.

Run `python scripts/build_editorial.py --text-only`, then `python scripts/build_rrcp.py`. Render the generated Word files to PDFs with the document renderer before running `scripts/verify_documents.py` and `scripts/verify_rrcp.py`. `scripts/verify_copyedit.py` checks scientific hashes, identical traced values, equations, table/caption content and reference entries while permitting the documented Vancouver order. It does not claim the old ordered reference list remains unchanged.

The journal file contains 249 abstract words and 2,954 body words including section headings and acknowledgements. Author approval, metadata, contributions and funding/conflicts are incorporated. The original manuscript ethics declaration is reproduced in the submission documents; no formal institutional approval or exemption document has been located. The submitting author must resolve any ethics-document field and answer exclusive-submission/publication-history questions at dispatch. No submission has been made.
