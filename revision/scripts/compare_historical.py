import pathlib,json,numpy as np,pandas as pd
repo=pathlib.Path(__file__).resolve().parents[2];base=repo/'reanalysis';out=repo/'revision/results/historical';report=[]
for src in sorted(base.rglob('*.csv')):
 rel=src.relative_to(base);dst=out/rel
 if not dst.exists():continue
 a=pd.read_csv(src);b=pd.read_csv(dst);r={'file':str(rel),'shape_equal':a.shape==b.shape,'columns_equal':list(a)==list(b)}
 if r['shape_equal'] and r['columns_equal']:
  diffs={};eq=True
  for col in a:
   assert a[col].isna().equals(b[col].isna()),(rel,col,'missing-value mismatch')
   if pd.api.types.is_numeric_dtype(a[col]) and pd.api.types.is_numeric_dtype(b[col]) and not pd.api.types.is_bool_dtype(a[col]):
    same=np.array_equal(a[col],b[col],equal_nan=True);both=np.isfinite(a[col])&np.isfinite(b[col]);err=float(np.max(np.abs(a.loc[both,col]-b.loc[both,col]))) if both.any() else 0
    if not same:diffs[col]={'max_abs_error':err,'max_relative_error':float(np.max(np.abs((a.loc[both,col]-b.loc[both,col])/a.loc[both,col].replace(0,np.nan)))) if both.any() else 0};eq=False
   elif not a[col].fillna('').equals(b[col].fillna('')):raise AssertionError((rel,col,'text mismatch'))
  for col,diff in diffs.items():
   if col=='nb_theta':
    changed=~np.isclose(a[col],b[col],rtol=1e-8,atol=1e-8,equal_nan=True)
    assert (a.loc[changed,col]>1e5).all()and(b.loc[changed,col]>1e5).all()
    assert diff['max_relative_error']<0.001,(rel,col,diff)
   else:assert diff['max_abs_error']<1e-8,(rel,col,diff)
  if 'p_value'in a:assert (a.p_value<0.05).equals(b.p_value<0.05),rel
  if 'ci_low'in a:assert ((a.ci_low>0)|(a.ci_high<0)).equals((b.ci_low>0)|(b.ci_high<0)),rel
  r['exact_equal']=eq;r['differences']=diffs
 report.append(r)
(out/'historical_comparison.json').write_text(json.dumps(report,indent=2));print(json.dumps([r for r in report if not r.get('exact_equal')],indent=2));print('Compared',len(report),'tables')
assert all(r['shape_equal'] and r['columns_equal'] for r in report)
for r in report:
 if 'annual' in r['file'] or 'fase2' in r['file'] or 'ibge_denominators' in r['file']:assert r['exact_equal'],r
