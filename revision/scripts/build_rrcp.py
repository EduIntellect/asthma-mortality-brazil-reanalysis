"""Build RRCP submission files from the single editorial source; never infer author declarations."""
from pathlib import Path
import re,json,sys,shutil,hashlib
from PIL import Image
root=Path(__file__).resolve().parents[2];ed=root/'revision/editorial';out=root/'revision/deliverables';dest=out/'RRCP';dest.mkdir(exist_ok=True)
sys.argv=['build_documents.py','--documents','Manuscript_CLEAN,Supplement,Author_confirmations']
import build_documents as doc
source=(ed/'manuscript.md').read_text(); title=source.splitlines()[0][2:]
blind='# '+title+'\n\n## Abstract'+source.split('## Abstract',1)[1]
blind=blind.replace('Code and revision outputs are available at https://github.com/EduIntellect/asthma-mortality-brazil-reanalysis/tree/revision/amaury-review .','Code and revision outputs are supplied in the accompanying reproducibility materials. The repository address is provided separately to the editors.')
# Funding, interests and contributions belong in the identifying title page in the identifying document.
a=blind.index('## Funding');b=blind.index('## References');blind=blind[:a]+blind[b:]
(ed/'rrcp_manuscript_blinded.md').write_text(blind)
abstract=blind.split('## Abstract')[1].split('Keywords.')[0]
body=blind.split('## Introduction')[1].split('## References')[0]
words=lambda s:len(re.sub(r'^#+ .*$', '',s,flags=re.M).split())
counts={'abstract_words_including_labels':words(abstract),'body_words_including_acknowledgements':words(body),'body_words_including_headings':len(body.replace('#','').split()),'references':12,'main_tables':1,'main_figures':2}
assert counts['abstract_words_including_labels']<=250,counts
assert counts['body_words_including_headings']<=3000,counts
page=f'''# {title}

Running title. Age-standardised asthma mortality in Brazil

Article type. Original article. Ecological study of national mortality records.

## Authors and affiliations

Francisco Federico García Crespi¹; Amaury de Souza².

¹ Department of Computer Engineering, Universidad Miguel Hernández, Elche, Alicante, Spain. PhD. ORCID 0000-0002-7129-7791.

² Institute of Physics, Federal University of Mato Grosso do Sul, Campo Grande, MS, Brazil. PhD in Environmental Technologies. ORCID 0000-0001-8168-1482.

Corresponding author. Francisco Federico García Crespi. Email fedeg@umh.es. Postal address. Department of Computer Engineering, Alcudia Building, office E14P1017, Avenida de la Universidad, s/n, 03202 Elche, Alicante, Spain. Telephone (UMH switchboard) +34 96 665 8500. Amaury de Souza's email amaury.souza@ufms.br.

## Counts

Abstract {counts['abstract_words_including_labels']} words including labels. Main body {counts['body_words_including_acknowledgements']} words including Acknowledgements, excluding headings, references and legends ({counts['body_words_including_headings']} including body headings). Twelve references, one main table, two main figures. Supplement supplied separately.

## Author declarations

No funding was received for this study. The authors declare no conflicts of interest. Both authors reviewed and approved the final manuscript and take responsibility for its content.

CRediT contributions. Francisco Federico García Crespi contributed conceptualisation, methodology, software, formal analysis, data curation, visualisation and writing the original draft. Amaury de Souza contributed validation of epidemiological and scientific interpretation, and writing, review and editing.

Ethics. The study used publicly accessible SIM mortality data and aggregated population projections without direct contact with participants. No identifying personal information was included in the reported results.

AI assistance. Claude Code and GitHub Copilot supported the historical workflow. Codex assisted code revision, analysis checking and editorial drafting. Figures were generated directly from analytical outputs. The manuscript discloses the assistance in Methods and Acknowledgements; both authors accept responsibility for the final manuscript.

## Data and code

https://github.com/EduIntellect/asthma-mortality-brazil-reanalysis/tree/revision/amaury-review

'''
letter=f'''# Cover letter for Respiratory Research & Clinical Practice

Dear Editors,

We present “{title}” for consideration as an Original Article. The study examines Brazilian asthma mortality during 2014–2021 using public SIM records and IBGE population projections. It reproduces the earlier analysis and assesses whether crude increases persist after standardisation within national and younger age domains.

The work addresses respiratory surveillance in Brazil. It distinguishes changes between endpoints from trends across years, and age composition from age-specific mortality. The national standardised estimate is compatible with trends in either direction. The increase within ages 5–34 over 2014–2021 is interpreted alongside uncertainty in the shorter prepandemic series and sensitivity to modelling assumptions.

We provide an anonymised manuscript, supplementary selection and sensitivity tables, figures, a reporting checklist and reproducible code and outputs. The ambiguous 2018 pair is retained in the principal analysis because available identifiers do not establish a shared death. Numerical results and model warnings remain available for review.

The study used publicly accessible SIM mortality data and aggregated population projections without direct contact with participants. No identifying personal information was included in the reported results.

Claude Code and GitHub Copilot assisted the historical workflow. Codex assisted code revision, analysis checking and editorial drafting. Figures were generated directly from results. Both authors reviewed and approved the final manuscript and take responsibility for its content. No funding was received for this study, and the authors declare no conflicts of interest.

Francisco Federico García Crespi and Amaury de Souza

Correspondence. fedeg@umh.es

'''
(ed/'rrcp_title_page.md').write_text(page);(ed/'rrcp_cover_letter.md').write_text(letter)
items=[
('1a–b','Design and balanced abstract','Abstract explicitly identifies ecological design and distinguishes national uncertainty from young-domain findings.'),
('2','Rationale','Introduction, paragraphs 1–3.'),('3','Objectives','Introduction, final paragraph; sensitivity analyses explicitly post hoc.'),
('4','Design','Methods, Study design and reference reproduction.'),('5','Setting and dates','Brazil, 2014–2021; Methods and supplementary provenance.'),
('6a','Eligibility and selection','Methods, Selection and Calendar ages; Supplementary Table S1. Population records rather than recruited participants.'),
('7','Variables','Underlying-cause J45/J46, age domains, calendar year and mortality rates defined in Methods; denominator and standard weights specified.'),
('8','Sources and measurement','SIM, IBGE revisions, date algorithm and public dictionary; Methods and supplementary provenance.'),
('9','Bias','Selection sensitivities, ambiguity of duplicates and denominator revisions; Methods and Discussion limitations.'),
('10','Study size','All eligible national underlying-cause records within the period; no sampled recruitment or prospective power calculation.'),
('11','Quantitative variables','Completed calendar age and single-year/90+ bins; nine count-model bands and continuous year covariate in Methods.'),
('12a','Statistical methods','Direct standardisation, rate GLMs/OLS, count families, offsets and intervals; Methods.'),
('12b','Subgroups','5–34, nested 7–34, 35–59 and ≥60; Methods, Results and Supplementary Tables S2, S5, S7, S8. No interaction testing reported.'),
('12c','Missing data','Invalid/missing dates excluded and separately logged; missing count cells assigned zero and positive complete populations required. Table S1.'),
('12d','Sampling strategy','Not applicable to this national registry enumeration; no sampling weights. Standardisation weights are defined separately.'),
('12e','Sensitivities','One-condition selection and period scenarios, both revisions/standards and all count families; Methods and S4–S8.'),
('13a–c','Flow and exclusions','Results, Historical reproduction and corrected selection; Table S1 and preserved selection logs. No individual recruitment or follow-up.'),
('14a','Descriptive characteristics','Age-specific national counts and rates in S2. Analyses pool sexes; no sex-specific associations are claimed.'),
('14b','Missingness','Table S1 reports exclusions for invalid dates/negative ages. Other registry-field missingness is not used as an exclusion criterion.'),
('15','Outcome data','Annual deaths and aligned denominators in S2 and full-precision CSV outputs.'),
('16a–c','Main results','Table 1, Results and S4–S8 show estimates, intervals and endpoint changes; adjustment/age-band rules described in Methods. Absolute rate change is reported, not individual risk.'),
('17','Other analyses','Kitagawa six endpoint pairs and prespecified execution scenarios; post hoc status acknowledged; S6–S8.'),
('18','Key results','Discussion opening and young-domain interpretation match study objectives.'),
('19','Limitations','Ecological design, short series, certification, record ambiguity, historical hashes, multiple comparisons and theta warnings; Discussion.'),
('20','Interpretation','Discussion distinguishes trend uncertainty, endpoints and descriptive decomposition; no causal attribution.'),
('21','Generalisability','National Brazilian registry analysis; ecological results do not establish individual associations or historical reversal.'),
('22','Funding','Title page states no funding was received, as confirmed during revision preparation. No sponsor role is reported.')]
check='# STROBE reporting checklist\n\nAdapted cross-sectional checklist for an ecological national registry time series. STROBE is a reporting aid, not evidence of design validity or author approval. Locations refer to section headings, which remain stable across Word/PDF pagination.\n\nSource. https://www.strobe-statement.org/checklists/\n\n| Item | Reporting topic | Location or applicability |\n| --- | --- | --- |\n'+'\n'.join('| '+' | '.join(x)+' |'for x in items)+'\n'
(ed/'rrcp_strobe.md').write_text(check)
for name,src,anonymous in [('Manuscript_BLINDED','rrcp_manuscript_blinded.md',True),('Title_page','rrcp_title_page.md',False),('Cover_letter','rrcp_cover_letter.md',False),('STROBE_checklist','rrcp_strobe.md',True)]:
 d=doc.read_md(ed/src)
 if anonymous:
  for attr in ['author','last_modified_by','comments','subject','keywords']:setattr(d.core_properties,attr,'')
 d.core_properties.title=name;d.save(dest/(name+'.docx'))
# Supply separate editable table and 300-dpi JPEGs, plus editable SVG originals.
tabletext='# Table 1\n\n'+source.split('## Table 1.',1)[1].split('## Figure 1.',1)[0]
p=ed/'rrcp_table1.md';p.write_text(tabletext);d=doc.read_md(p);d.core_properties.author='';d.core_properties.last_modified_by='';d.save(dest/'Table1.docx')
for stem in ['Figure1','Figure2','FigureS1']:
 image=Image.open(out/'figures'/f'{stem}.png').convert('RGB');image.save(dest/f'{stem}.jpg',quality=95,dpi=(300,300));shutil.copyfile(out/'figures'/f'{stem}.svg',dest/f'{stem}.svg')
supplement=(ed/'supplement.md').read_text().replace('Code and revision outputs are available at https://github.com/EduIntellect/asthma-mortality-brazil-reanalysis/tree/revision/amaury-review .','The repository address is supplied separately to the editors.')
(ed/'rrcp_supplement_blinded.md').write_text(supplement)
d=doc.read_md(ed/'rrcp_supplement_blinded.md')
for attr in ['author','last_modified_by','comments','subject','keywords']:setattr(d.core_properties,attr,'')
d.save(dest/'Supplement.docx')
counts['blinded_metadata_cleared']=True;counts['jpeg_dpi']=300
(root/'revision/qa/rrcp_counts.json').write_text(json.dumps(counts,indent=2))
(dest/'README.md').write_text('''# RRCP submission files

Upload Manuscript_BLINDED.docx as the main manuscript, Title_page.docx separately, Cover_letter.docx as the letter, STROBE_checklist.docx as the reporting checklist, Supplement.docx as supplementary material, Table1.docx as an editable table and Figure1.jpg/Figure2.jpg as main figures. FigureS1.jpg belongs to the supplement. SVG files supply editable originals; PDF previews are for author inspection.

Author approval, authorship metadata, contributions, funding and conflicts were confirmed during preparation on 11 October 2026. The authors describe this as an ecological analysis of public records without direct contact with participants. The original manuscript ethics declaration is reproduced in Methods, the title page and the cover letter. No committee approval number is supplied because no formal determination is documented. Exclusive-submission and publication-history questions must be answered by the submitting author at dispatch.

No email or journal submission has been sent. Code and the larger scientific revision package remain in the repository alongside the submission materials.

Instructions checked 11 October 2026: https://rrcpjournal.org/instructions-for-authors/
''')
print(json.dumps(counts,indent=2))
