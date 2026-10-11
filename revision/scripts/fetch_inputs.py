"""Download only pinned public data. Changed official bytes fail verification."""
import argparse,pathlib,json,hashlib,urllib.request,shutil
p=argparse.ArgumentParser();p.add_argument('--data-dir',required=True);a=p.parse_args();root=pathlib.Path(__file__).resolve().parents[2];data=pathlib.Path(a.data_dir).resolve();(data/'raw').mkdir(parents=True,exist_ok=True);(data/'evidence').mkdir(exist_ok=True)
def sha(p):
 h=hashlib.sha256()
 with p.open('rb')as f:
  for b in iter(lambda:f.read(1048576),b''):h.update(b)
 return h.hexdigest()
manifest=json.loads((root/'revision/evidence/download_manifest.json').read_text());locked=json.loads((root/'revision/inputs_manifest.json').read_text())['inputs']
def fetch(url,path,expected):
 if path.exists():
  if sha(path)!=expected:raise ValueError(f'Existing file differs from pinned input: {path}')
  return
 path.parent.mkdir(parents=True,exist_ok=True);tmp=path.with_suffix(path.suffix+'.partial')
 with urllib.request.urlopen(url,timeout=120)as src,tmp.open('wb')as dst:shutil.copyfileobj(src,dst,1048576)
 if sha(tmp)!=expected:raise ValueError(f'Official download differs from pinned input: {url}; retained {tmp} for inspection')
 tmp.rename(path);print('Verified',path,flush=True)
for s in manifest['sources']:
 name=pathlib.Path(s['path']).name;target=data/'raw'/name;packaged=root/'revision/inputs'/name
 if not target.exists()and packaged.exists():
  if sha(packaged)!=s['sha256']:raise ValueError(f'Packaged input differs from pinned hash: {packaged}')
  shutil.copy2(packaged,target)
 fetch(s['url'],target,s['sha256'])
for name,url in [('projecoes_2024_tab1_idade_simples.xlsx','https://ftp.ibge.gov.br/Projecao_da_Populacao/Projecao_da_Populacao_2024/projecoes_2024_tab1_idade_simples.xlsx'),('SIM_dictionary.pdf','https://ccvisat.ufba.br/wp-content/uploads/2019/10/Estrutura-do-SIM-para-o-CD-ROM.pdf')]:
 row=next(x for x in locked if x['relative_path']==f'revision/inputs/{name}');fetch(url,root/row['relative_path'],row['sha256'])
for name in ['csv_manifest.json','download_manifest.json']:shutil.copy2(root/'revision/evidence'/name,data/'evidence'/name)
shutil.copy2(root/'revision/evidence/reference_sent.pdf',data/'evidence/gmail_original_attachment.pdf')
