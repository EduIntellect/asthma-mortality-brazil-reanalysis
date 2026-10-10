#!/usr/bin/env bash
# Build the RRCP submission files (.docx) from the versioned Markdown sources.
# Tables are converted from the LaTeX fragments written by 09_manuscript_assets.R,
# so numbers are never typed by hand. Do not edit the generated .docx files.
#
# Usage: bash reanalysis/manuscript/article/build_docx.sh   (from any directory)
# Requires: pandoc (tested with 3.1.3), python3, zip, unzip.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tables="$here/../tables"
out="$here/build"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
mkdir -p "$out"

# LaTeX table fragment -> Markdown table. Inline math in the fragments is limited to
# signs, comparison symbols, footnote superscripts and an italic p; convert it to
# plain text first so that Word receives characters, not equation objects.
tex2md() {
  sed -e 's/\$-\$/−/g' \
      -e 's/\$<\$/</g' \
      -e 's/\$>\$/>/g' \
      -e 's/\$\\geq\$/≥/g' \
      -e 's/\$\^{\([a-z]\)}\$/\\textsuperscript{\1}/g' \
      -e 's/\$p\$/\\emph{p}/g' \
      "$1" | pandoc -f latex -t markdown-simple_tables-multiline_tables-grid_tables --columns=1000
  # Fail loudly if any math survived the substitutions.
  if grep -q '\$' "$1" && sed -e 's/\$-\$//g; s/\$<\$//g; s/\$>\$//g; s/\$\\geq\$//g; s/\$\^{[a-z]}\$//g; s/\$p\$//g' "$1" | grep -q '\$'; then
    echo "Unhandled inline math in $1" >&2; exit 1
  fi
}

# Replace each {{TABLE:name}} line with the converted table.
expand_tables() {
  local src="$1" dst="$2"
  : > "$dst"
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^\{\{TABLE:([a-z_0-9]+)\}\}$ ]]; then
      local name="${BASH_REMATCH[1]}"
      [[ -f "$tables/$name.tex" ]] || { echo "Missing table $name.tex" >&2; exit 1; }
      tex2md "$tables/$name.tex" >> "$dst"
    else
      printf '%s\n' "$line" >> "$dst"
    fi
  done < "$src"
}

# Reference document: pandoc's default styles, with 9-pt text inside tables only
# (the "Table" style), so wide tables fit a portrait page without breaking numbers.
# Built at each run from pandoc's own default; no binary template is versioned.
make_reference_doc() {
  local ref="$work/reference.docx" dir="$work/ref"
  pandoc -o "$ref" --print-default-data-file reference.docx
  mkdir -p "$dir" && (cd "$dir" && unzip -q "$ref")
  python3 - "$dir/word/styles.xml" <<'PY'
import re, sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
m = re.search(r'(<w:style [^>]*w:styleId="Table"[^>]*>.*?)(<w:tblPr>)', s, re.S)
if not m:
    sys.exit("Table style not found in pandoc reference.docx")
rpr = '<w:rPr><w:sz w:val="18" /><w:szCs w:val="18" /></w:rPr>'
s = s[:m.start(2)] + rpr + s[m.start(2):]
open(p, "w", encoding="utf-8").write(s)
PY
  rm -f "$ref" && (cd "$dir" && zip -q -r -X "$ref" '[Content_Types].xml' _rels docProps word)
  echo "$ref"
}
reference_doc="$(make_reference_doc)"

expand_tables "$here/manuscript.md" "$work/manuscript.md"
expand_tables "$here/supplement.md" "$work/supplement.md"

# Main-text word count (Introduction to the end of the Discussion), as RRCP counts it:
# abstract, references, tables and figure legends excluded.
main_words=$(awk '/<!-- BEGIN MAIN TEXT -->/{f=1;next} /<!-- END MAIN TEXT -->/{f=0} f' "$here/manuscript.md" \
  | pandoc -f markdown -t plain --wrap=none | wc -w)
abstract_words=$(awk '/^# Abstract/{f=1;next} /^\*\*Keywords/{f=0} f' "$here/manuscript.md" \
  | pandoc -f markdown -t plain --wrap=none | wc -w)

sed "s/\[filled from the build report\]/${main_words}/" "$here/title_page.md" > "$work/title_page.md"

pandoc "$work/title_page.md" --reference-doc "$reference_doc" -o "$out/title_page.docx"
pandoc "$work/manuscript.md" --lua-filter "$here/table_widths.lua" --reference-doc "$reference_doc" -o "$out/manuscript.docx"
pandoc "$work/supplement.md" --lua-filter "$here/table_widths.lua" --reference-doc "$reference_doc" -o "$out/supplementary_tables.docx"

{
  echo "Build report"
  echo "pandoc: $(pandoc --version | head -1)"
  echo "main text words (Introduction-Discussion): $main_words (RRCP limit 3000)"
  echo "abstract words (including headings): $abstract_words (RRCP limit 250)"
  echo "outputs: title_page.docx, manuscript.docx, supplementary_tables.docx"
  echo "figure (separate upload): ../figures/fig1_relative_change_ge7.jpg"
} > "$out/BUILD_REPORT.txt"
cat "$out/BUILD_REPORT.txt"
