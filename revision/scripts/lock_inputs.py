import argparse,json,pathlib,hashlib,csv
p=argparse.ArgumentParser();p.add_argument('--data-dir',required=True);a=p.parse_args();data=pathlib.Path(a.data_dir).resolve();root=pathlib.Path(__file__).resolve().parents[2]
def sha(p):
 h=hashlib.sha256()
 with p.open('rb')as f:
  for b in iter(lambda:f.read(1048576),b''):h.update(b)
 return h.hexdigest()
rows=[]
for s in json.loads((data/'evidence/download_manifest.json').read_text())['sources']:
 path=data/'raw'/pathlib.Path(s['path']).name;assert sha(path)==s['sha256'];rows.append(dict(location='data',relative_path=str(path.relative_to(data)),sha256=s['sha256'],kind='official input'))
for path in [data/'raw/projecoes_2018_populacao_idade_simples_2010_2060_20201209.xls',data/'evidence/gmail_original_attachment.pdf',root/'revision/inputs/projecoes_2024_tab1_idade_simples.xlsx',root/'revision/inputs/SIM_dictionary.pdf']:
 loc='data' if path.is_relative_to(data)else'repo';rows.append(dict(location=loc,relative_path=str(path.relative_to(data if loc=='data'else root)),sha256=sha(path),kind='official/reference input'))
for path in sorted((root/'revision/.cache').glob('*.csv')):rows.append(dict(location='repo',relative_path=str(path.relative_to(root)),sha256=sha(path),kind='verified extraction cache'))
with (root/'revision/locked_inputs.csv').open('w')as f:
 w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
(root/'revision/inputs_manifest.json').write_text(json.dumps({'base_commit':'3884c868a07164710a2e358180b3034f9cdcf642','inputs':rows,'csv_evidence':json.loads((data/'evidence/csv_manifest.json').read_text()),'limitation':'No execution-of-1-October hashes for SIM 2014–2019. Current verified official files reproduce committed counts and aggregates exactly.'},indent=2))
