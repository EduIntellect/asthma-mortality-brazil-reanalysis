from pathlib import Path
from PIL import Image,ImageDraw
from pypdf import PdfReader
import json
root=Path(__file__).resolve().parents[1]/'qa';dest=root/'contact_final';dest.mkdir(exist_ok=True);counts={}
for folder in sorted(root.glob('render_final_*')):
 if not folder.is_dir():continue
 pdf=next(folder.glob('*.pdf'));n=len(PdfReader(pdf).pages);counts[pdf.stem]=n
 for i in range(1,n+1,2):
  sheet=Image.new('RGB',(1800,1350),'#bcbcbc');draw=ImageDraw.Draw(sheet)
  for j,num in enumerate(range(i,min(i+2,n+1))):
   im=Image.open(folder/f'page-{num}.png');im.thumbnail((880,1300));sheet.paste(im,(j*900+10,35));draw.text((j*900+10,8),f'{pdf.stem} page {num}',fill='black')
  sheet.save(dest/f'{pdf.stem}_{(i+1)//2:02}.jpg')
(root/'render_final_page_counts.json').write_text(json.dumps(counts,indent=2))
print(counts)
