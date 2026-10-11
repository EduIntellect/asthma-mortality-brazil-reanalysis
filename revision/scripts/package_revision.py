"""Freeze a file manifest, then package exactly those verified files without raw SIM ZIPs."""
from pathlib import Path
import argparse,subprocess,json,hashlib,zipfile
root=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser();p.add_argument('--manifest-only',action='store_true');p.add_argument('--output');a=p.parse_args()
manifest=root/'revision/artifact_manifest.json'
def sha(path):
 h=hashlib.sha256()
 with path.open('rb')as f:
  for chunk in iter(lambda:f.read(1048576),b''):h.update(chunk)
 return h.hexdigest()
if a.manifest_only:
 names=set(subprocess.check_output(['git','ls-files','--cached','--others','--exclude-standard','-z'],cwd=root).decode().split('\0'))
 names.discard('');names.discard(str(manifest.relative_to(root)))
 names.update(str(x.relative_to(root))for x in (root/'revision/inputs').iterdir()if x.is_file())
 files=[{'path':name,'bytes':(root/name).stat().st_size,'sha256':sha(root/name)}for name in sorted(names)if(root/name).is_file()]
 manifest.write_text(json.dumps({'base_commit':'3884c868a07164710a2e358180b3034f9cdcf642','branch':'revision/amaury-review','files':files,'raw_SIM':'Not embedded: public download URLs and immutable ZIP/CSV hashes are provided; fetch_inputs.py and extract_verified_candidates.py reconstruct the inputs.','historical_limitation':'No historical execution hashes for SIM 2014–2019. Verified available files were used.','scope':'Scientific and editorial review package. The branch was published following user authorisation; no email or journal submission.'},indent=2))
 print('Manifest fixed:',len(files),'files');raise SystemExit
if not a.output:p.error('--output is required when building an archive')
payload=json.loads(manifest.read_text());target=Path(a.output).resolve();target.parent.mkdir(parents=True,exist_ok=True)
for row in payload['files']:assert sha(root/row['path'])==row['sha256'],row['path']
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=6)as z:
 for row in payload['files']:z.write(root/row['path'],row['path'])
 z.write(manifest,'revision/artifact_manifest.json')
with zipfile.ZipFile(target)as z:
 assert z.testzip()is None
 for row in payload['files']:assert hashlib.sha256(z.read(row['path'])).hexdigest()==row['sha256'],row['path']
checksum=sha(target);target.with_suffix(target.suffix+'.sha256').write_text(f'{checksum}  {target.name}\n')
print('Archive verified:',target,'files:',len(payload['files'])+1,'bytes:',target.stat().st_size,'SHA-256:',checksum)
