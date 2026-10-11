import pathlib, json, argparse, io, csv, hashlib, zipfile
p=argparse.ArgumentParser();p.add_argument('--data-dir',required=True);a=p.parse_args();base=pathlib.Path(a.data_dir);out=pathlib.Path(__file__).resolve().parents[1]/'.cache';out.mkdir(exist_ok=True)
manifest=json.loads((base/'evidence/csv_manifest.json').read_text())
class HashReader(io.RawIOBase):
 def __init__(self,source):self.source=source;self.sha=hashlib.sha256()
 def readable(self):return True
 def readinto(self,b):
  data=self.source.read(len(b));self.sha.update(data);b[:len(data)]=data;return len(data)
with (out/'raw_counts.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=['year','N_raw','N_J45_J46','csv_sha256']);w.writeheader()
 for s in manifest:
  y=s['year']
  with zipfile.ZipFile(base/'raw'/f'Mortalidade_Geral_{y}_csv.zip') as z:
   h=HashReader(z.open(s['csv_member']));stream=io.TextIOWrapper(io.BufferedReader(h),encoding='latin1',newline='');reader=csv.reader(stream,delimiter=';');cols=next(reader);cause=cols.index('CAUSABAS');n_j=0
   with (out/f'asthma_{y}.csv').open('w',newline='') as dest:
    cw=csv.writer(dest);cw.writerow(['source_row']+cols)
    for n,row in enumerate(reader,1):
     assert len(row)==len(cols)
     if 'J45' in row[cause] or 'J46' in row[cause]:cw.writerow([n]+row);n_j+=1
   assert h.sha.hexdigest()==s['csv_sha256'];assert n==s['N_raw'] and n_j==s['N_J45_J46'];w.writerow(dict(year=y,N_raw=n,N_J45_J46=n_j,csv_sha256=h.sha.hexdigest()));f.flush();print('Verified CSV and regenerated candidates',y,flush=True)
