#!/usr/bin/env python3
"""Compare every committed analytical output between a base ref (main) and
the working tree, cell by cell, for the U07.1 re-run.

Writes reanalysis/audit/u071_rerun_cells.csv (every changed numeric cell)
and prints Markdown sections used in u071_rerun_diff.md. Standard library
only; run from the repository root:

    python3 reanalysis/audit/u071_compare.py [base_ref]
"""
import csv
import io
import subprocess
import sys
from pathlib import Path

BASE = sys.argv[1] if len(sys.argv) > 1 else "main"
ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "reanalysis" / "audit" / "u071_rerun_cells.csv"
TOL = 1e-12

def git_show(path):
    return subprocess.run(["git", "-C", str(ROOT), "show", f"{BASE}:{path}"],
                          check=True, capture_output=True, text=True).stdout

def tracked_csvs():
    out = subprocess.run(["git", "-C", str(ROOT), "ls-tree", "-r", "--name-only", BASE,
                          "reanalysis/"], check=True, capture_output=True, text=True).stdout
    return [p for p in out.split() if p.endswith(".csv") and "/audit/" not in p]

def num(x):
    try:
        return float(x)
    except ValueError:
        return None

def rows(text):
    return list(csv.reader(io.StringIO(text)))

changed = []
summary = []
for path in tracked_csvs():
    old = rows(git_show(path))
    new = rows((ROOT / path).read_text(encoding="utf-8"))
    if old[0] != new[0] or len(old) != len(new):
        summary.append((path, "STRUCTURE CHANGED", len(old), len(new)))
        continue
    header = old[0]
    n = 0
    for i, (a, b) in enumerate(zip(old[1:], new[1:]), start=1):
        for j, (x, y) in enumerate(zip(a, b)):
            nx, ny = num(x), num(y)
            if nx is None or ny is None:
                if x != y:
                    raise SystemExit(f"{path} row {i} col {header[j]}: text differs ({x!r} -> {y!r})")
                continue
            if abs(nx - ny) > TOL:
                n += 1
                key = {h: v for h, v in zip(header, a) if num(v) is None or h in ("year", "start_year", "end_year", "age", "age_floor")}
                changed.append({"file": path, "row": i, "key": "; ".join(f"{k}={v}" for k, v in key.items()),
                                "column": header[j], "main": x, "u071": y, "diff": ny - nx})
    summary.append((path, n, len(old) - 1, len(header)))

with OUT.open("w", newline="", encoding="utf-8") as fd:
    w = csv.DictWriter(fd, fieldnames=["file", "row", "key", "column", "main", "u071", "diff"])
    w.writeheader()
    w.writerows(changed)

print("| File | Changed numeric cells | Rows |")
print("|---|---|---|")
for path, n, r, *_ in summary:
    print(f"| `{path.removeprefix('reanalysis/')}` | {n} | {r} |")
print(f"\nTotal changed numeric cells: {len(changed)} (tolerance {TOL}). Detail: audit/u071_rerun_cells.csv")


# ---- Estimate-level comparison with inferential flags -------------------
# One row per estimate (rows repeated per year are collapsed). An estimate is
# flagged INFERENTIAL when, between main and the re-run, the sign of the point
# estimate changes, p crosses 0.05, or the 95% CI changes whether it contains 0.
EST_FILES = {
    "reanalysis/primary_results.csv": ("slope", ["series"]),
    "reanalysis/data/sensitivity_denominators_summary.csv": ("slope", ["denominator_revision", "series"]),
    "reanalysis/data/robustness_who_standard_summary.csv": ("slope", ["denominator_revision", "series"]),
    "reanalysis/data/robustness_count_models.csv": ("annual_pct_change", ["denominator_revision", "series", "model"]),
    "reanalysis/data/fase1_legacy_reconciliation.csv": ("slope", ["series"]),
}

def dicts(text):
    return list(csv.DictReader(io.StringIO(text)))

def flag(o, n, est):
    f = []
    eo, en = num(o[est]), num(n[est])
    if eo is not None and en is not None and (eo > 0) != (en > 0):
        f.append("sign")
    po, pn = num(o.get("p_value", "")), num(n.get("p_value", ""))
    if po is not None and pn is not None and (po < 0.05) != (pn < 0.05):
        f.append("p crosses 0.05")
    lo, hi = num(o.get("ci_low", "")), num(o.get("ci_high", ""))
    ln, hn = num(n.get("ci_low", "")), num(n.get("ci_high", ""))
    if None not in (lo, hi, ln, hn) and (lo <= 0 <= hi) != (ln <= 0 <= hn):
        f.append("CI vs 0")
    return ", ".join(f) or "-"

def g(x, d=4):
    v = num(x)
    return "NA" if v is None else (f"{v:.2e}" if v != 0 and abs(v) < 1e-3 else f"{v:.{d}f}")

flags = []
for path, (est, keys) in EST_FILES.items():
    old = dicts(git_show(path)); new = dicts((ROOT / path).read_text(encoding="utf-8"))
    seen = set()
    print(f"\n#### `{path.removeprefix('reanalysis/')}`\n")
    print(f"| {' / '.join(keys)} | {est} main | {est} U07.1 | 95% CI main | 95% CI U07.1 | p main | p U07.1 | Flag |")
    print("|---|---|---|---|---|---|---|---|")
    for o, n in zip(old, new):
        k = tuple(o[c] for c in keys)
        if k in seen:
            continue
        seen.add(k)
        fl = flag(o, n, est)
        if fl != "-":
            flags.append((path, k, fl))
        print(f"| {' / '.join(k)} | {g(o[est])} | {g(n[est])} | {g(o.get('ci_low',''))} to {g(o.get('ci_high',''))} | "
              f"{g(n.get('ci_low',''))} to {g(n.get('ci_high',''))} | {g(o.get('p_value',''))} | {g(n.get('p_value',''))} | {fl} |")
print("\nInferential flags:", flags if flags else "none")
