"""Verify preserved inputs, stage symlinks and make historical scripts portable."""
import argparse, pathlib, json, hashlib, shutil
p=argparse.ArgumentParser(); p.add_argument('--data-dir',required=True); p.add_argument('--output-dir',required=True); a=p.parse_args()
repo=pathlib.Path(__file__).resolve().parents[2]; data=pathlib.Path(a.data_dir).resolve(); out=pathlib.Path(a.output_dir).resolve(); out.mkdir(parents=True,exist_ok=True)
def sha(p):
 h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1048576),b''):h.update(b)
 return h.hexdigest()
manifest=json.loads((data/'evidence/download_manifest.json').read_text()); verified=[]
for s in manifest['sources']:
 path=data/'raw'/pathlib.Path(s['path']).name
 assert sha(path)==s['sha256'],str(path)
 verified.append(dict(path=str(path),sha256=s['sha256'],bytes=path.stat().st_size,url=s['url']))
raw=out/'data_raw'; (raw/'ibge').mkdir(parents=True,exist_ok=True)
for path in (data/'raw').glob('*.zip'):
 dest=raw/path.name
 if not dest.exists():dest.symlink_to(path)
for src,name in [(data/'raw/projecoes_2018_populacao_idade_simples_2010_2060_20201209.xls','projecoes_2018_populacao_idade_simples.xls'),(repo/'revision/inputs/projecoes_2024_tab1_idade_simples.xlsx','projecoes_2024_tab1_idade_simples.xlsx')]:
 digest=sha(src)
 if '2018' in name:assert digest=='69e4e6a7171bf1bbf02e5ee413f7d6a31114344711ef123277cad6de1595fc28'
 verified.append(dict(path=str(src),sha256=digest,bytes=src.stat().st_size))
 dest=raw/'ibge'/name
 if not dest.exists():dest.symlink_to(src)
shutil.copytree(repo/'reanalysis/R',out/'R',dirs_exist_ok=True)
for script in (out/'R').glob('*.R'):
 text=script.read_text().replace('"/home/user/asthma-mortality-brazil-reanalysis/reanalysis"','Sys.getenv("ASTHMA_REANALYSIS_ROOT")')
 if script.name=='00_provenance.R':text=text.replace('as.character(utils::packageVersion(p))','if (requireNamespace(p, quietly=TRUE)) as.character(utils::packageVersion(p)) else "not installed (unused by pipeline)"')
 script.write_text(text)
(out/'input_manifest.json').write_text(json.dumps({'base_commit':'3884c868a07164710a2e358180b3034f9cdcf642','inputs':verified,'csv_manifest':json.loads((data/'evidence/csv_manifest.json').read_text())},indent=2))
print('Verified',len(verified),'inputs; historical runtime prepared:',out)
