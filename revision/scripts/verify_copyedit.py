"""Verify that language editing preserves the frozen scientific delivery."""
from pathlib import Path
import json,hashlib,re,subprocess
root=Path(__file__).resolve().parents[2]
freeze=json.loads((root/'revision/qa/editorial_freeze.json').read_text())
for item in freeze['protected_files']:
 assert hashlib.sha256((root/item['path']).read_bytes()).hexdigest()==item['sha256'],item['path']
claims=json.loads((root/'revision/editorial/claim_trace.json').read_text())
assert claims==freeze['claim_trace']
new=(root/'revision/editorial/manuscript.md').read_text()
old=freeze['manuscript_before']
assert hashlib.sha256(old.encode()).hexdigest()==freeze['manuscript_before_sha256']
def refs(s):return sorted(re.sub(r'^\d+\. ', '',line)for line in s.split('## References\n')[1].split('## Table 1.')[0].splitlines()if line.strip())
assert refs(new)==refs(old), 'Reference content changed'
assert new.split('## Table 1.')[1]==old.split('## Table 1.')[1], 'Tables and captions changed'
equations=[s for s in old.splitlines()if s.startswith(('ASR(t,D)','w(a,D)','C = Σ','R = Σ','Crude(1)'))]
assert all(s in new for s in equations)
for value in ['7–14 (reference), 15–24, 25–34, 35–44, 45–54, 55–64, 65–74, 75–84 and 85+.','μ + μ²/θ','29 February','1 March','LINHAA, LINHAB, LINHAC, LINHAD and LINHAII','B342, U072, U071 or literal COVID-19','log E[Y(t)] = α + β × year(t) + log population(t).','log E[Y(b,t)] = α + γ(b) + β × year(t) + log population(b,t).']:
 assert value in new,value
body=new.split('## References')[0]
assert ':' not in re.sub(r'https?://\S+','',body)
assert '—'not in body
assert not re.search(r'(?<!\*)\*[^*\n]+\*(?!\*)',body)
metrics={'status':'passed','baseline_commit':freeze['baseline_commit'],'scientific_files_unchanged':len(freeze['protected_files']),'identical_traced_values':len(claims),'equations_preserved':len(equations),'references_preserved':True,'table_and_captions_preserved':True,'colon_free_manuscript_prose':True,'em_dash_and_italic_free_prose':True,'definitions_and_model_formulas_preserved':True,'words_before':len(old.split()),'words_after':len(new.split())}
(root/'revision/qa/copyedit_checks.json').write_text(json.dumps(metrics,indent=2))
print(json.dumps(metrics,indent=2))
