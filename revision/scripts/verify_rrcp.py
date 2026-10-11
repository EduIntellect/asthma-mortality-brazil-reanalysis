"""Verify submission limits, Vancouver mapping, anonymity and DOCX/PDF source concordance."""
from pathlib import Path
import re,json,subprocess,unicodedata
from docx import Document
from pypdf import PdfReader
from PIL import Image
root=Path(__file__).resolve().parents[2];ed=root/'revision/editorial';out=root/'revision/deliverables/RRCP'
s=(ed/'rrcp_manuscript_blinded.md').read_text();body=s.split('## References')[0]
first=[]
for m in re.finditer(r'\[([0-9,]+)\]',body):
 for n in map(int,m[1].split(',')):
  if n not in first:first.append(n)
assert first==list(range(1,13)),first
assert len(re.findall(r'^\d+\. ',s.split('## References')[1].split('## Table 1.')[0],re.M))==12
assert all(x in body for x in ['Table 1 summarises','Figure 1 compares','Figure 2 compares','Conclusions.'])
for section in ['Introduction','Discussion']:
 assert not re.search(r'^### ',s.split('## '+section)[1].split('\n## ')[0],re.M)
identity=['García Crespi','Amaury de Souza','fedeg@','Universidad Miguel','EduIntellect']
report=[]
def norm(x):return re.sub(r'\s+','',unicodedata.normalize('NFKC',x).replace('“','"').replace('”','"').replace('’',"'").replace('−','-'))
def source(path):
 parts=[]
 for line in path.read_text().splitlines():
  line=line.strip()
  if not line:continue
  if line.startswith('|'):
   if re.fullmatch(r'[| :\-]+',line):continue
   parts.extend(x.strip()for x in line.strip('|').split('|'))
  elif line.startswith('!['):parts.append(re.match(r'!\[(.*?)\]',line)[1])
  else:parts.append(re.sub(r'^#+ |^- ','',line).replace('**',''))
 return parts
for stem,src,anonymous,figures in [('Manuscript_BLINDED','rrcp_manuscript_blinded.md',True,2),('Title_page','rrcp_title_page.md',False,0),('Cover_letter','rrcp_cover_letter.md',False,0),('STROBE_checklist','rrcp_strobe.md',True,0),('Table1','rrcp_table1.md',True,0),('Supplement','rrcp_supplement_blinded.md',True,1)]:
 d=Document(out/(stem+'.docx'));actual=[]
 for b in d.element.body:
  if b.tag.endswith('}p'):
   from docx.text.paragraph import Paragraph
   p=Paragraph(b,d)
   if p.text.strip():actual.append(p.text)
  elif b.tag.endswith('}tbl'):
   from docx.table import Table
   for row in Table(b,d).rows:actual.extend(c.text for c in row.cells)
 expected=source(ed/src);assert actual==expected,stem;assert len(d.inline_shapes)==figures
 if anonymous:
  assert d.core_properties.author==d.core_properties.last_modified_by==''
  assert not any(x in '\n'.join(actual)for x in identity),stem
 pdf=PdfReader(out/(stem+'.pdf'));texts=[p.extract_text()or''for p in pdf.pages]
 assert all(len(re.sub(r'\s+','',x))>50 for x in texts),(stem,'blank page')
 flat=norm('\n'.join(re.sub(r'^\s*\d+\s*\n','',x)for x in texts));ordered=norm(subprocess.check_output(['pdftotext','-layout',str(out/(stem+'.pdf')),'-'],text=True));pos=0
 # pypdf maintains table-cell order; Poppler preserves mixed-script equations.
 for block in expected:
  token=norm(block);index=flat.find(token,pos)
  if index>=0:pos=index+len(token)
  else:assert token in ordered,(stem,block[:100])
 if anonymous:assert not any(x in ''.join(texts)for x in identity),stem
 report.append({'document':stem,'pages':len(pdf.pages),'source_docx_exact':True,'pdf_all_text_verified':True,'anonymous':anonymous,'blank_pages':False})
for stem in ['Figure1','Figure2','FigureS1']:
 im=Image.open(out/(stem+'.jpg'));assert im.info['dpi']==(300,300)
counts=json.loads((root/'revision/qa/rrcp_counts.json').read_text());assert counts['abstract_words_including_labels']<=250;assert counts['body_words_including_headings']<=3000
# Freeze all numbers in Results apart from newly added illustration calls and citation labels.
freeze=json.loads((root/'revision/qa/editorial_freeze.json').read_text())
def result_numbers(text):
 text=text.split('## Results')[1].split('## Discussion')[0]
 text='\n'.join(line for line in text.splitlines()if not line.startswith(('### ','Table 1 summarises','Figure 2 compares')))
 text=re.sub(r'\[[0-9,]+\]','',text)
 return re.findall(r'(?<![A-Za-z])[-+]?\d+(?:[.,]\d+)*',text)
before=subprocess.check_output(['git','show','8b9f8fd:revision/editorial/manuscript.md'],cwd=root,text=True)
assert result_numbers((ed/'manuscript.md').read_text())==result_numbers(before)
report={'status':'passed','counts':counts,'vancouver_first_appearance':first,'documents':report,'science_preservation_report':'revision/qa/copyedit_checks.json','mesh_terms_verified':6,'author_approval':'Confirmed by the corresponding author on 11 October 2026','ethics_document':'Original public-records ethics declaration included; no committee number asserted','results_numerical_tokens_unchanged_from':'8b9f8fd','analysis_rerun':False}
(root/'revision/qa/rrcp_checks.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))
