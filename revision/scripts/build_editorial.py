"""Fill the single editorial Markdown template from identified CSV results."""
from pathlib import Path
import json,hashlib,re,datetime
import pandas as pd,numpy as np
import sys,os
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'.vendor'))
os.environ['XDG_CACHE_HOME']=str(Path(__file__).resolve().parents[1]/'.cache')
os.environ['MPLCONFIGDIR']=str(Path(__file__).resolve().parents[1]/'.cache/matplotlib')
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from docx import Document
root=Path(__file__).resolve().parents[2];ed=root/'revision/editorial';delivery=root/'revision/deliverables';ed.mkdir(exist_ok=True);delivery.mkdir(exist_ok=True);fig=delivery/'figures';fig.mkdir(exist_ok=True);claims=[]
def frame(file,scenario='corrected',rev=2018):return pd.read_csv(root/f'revision/results/{scenario}/ibge{rev}/{file}.csv')
def stat(series,key,scenario='corrected',rev=2018):
 p=f'revision/results/{scenario}/ibge{rev}/rate_trends.csv';row=pd.read_csv(root/p).set_index('series').loc[series];v=float(row[key]);claims.append(dict(source=p,series=series,field=key,value=v));return v
f=lambda x,n=3:f'{x:.{n}f}'
pval=lambda x:'<0.001' if x<.001 else f(x,3)
signed=lambda x,n=3:f'{x:+.{n}f}'
T=frame('rate_trends').set_index('series');C=frame('selection_counts');K=frame('kitagawa_endpoints');K24=frame('kitagawa_endpoints',rev=2024);M=frame('count_models');M24=frame('count_models',rev=2024)
def rate_sentence(s):
 return f"{f(stat(s,'first_rate'))} to {f(stat(s,'last_rate'))} per 100,000 ({signed(stat(s,'relative_change'),1)}%; absolute change {signed(stat(s,'absolute_change'),4)}), with slope {f(stat(s,'slope'),4)} per year (95% CI {f(stat(s,'ci_low'),4)} to {f(stat(s,'ci_high'),4)}; p = {pval(stat(s,'p_value'))})"
def model_text(df,series,model):
 r=df[(df.series==series)&(df.model==model)].iloc[0];return f"{signed(r.annual_pct_change,2)}% per year (95% CI {f(r.ci_low,2)} to {f(r.ci_high,2)}; p = {pval(r.p_value)})"
def pretty(x):
 labels={'ge7':'≥7','age_5_34':'5–34','age_7_34':'7–34','age_35_59':'35–59','age_ge60':'≥60','age_adjusted_ge7':'Age-adjusted ≥7','corrected':'Principal','without_2020':'Without 2020','prepandemic':'2014–2019','age_days':'Days/365.25','covid_original':'Original COVID','covid_retained':'Retain COVID','historical_dedup':'Historical key','poisson':'Poisson','quasipoisson':'Quasi-Poisson','negbin':'Negative binomial'}
 for pre,title in [('crude','Crude'),('brazil2014','Brazil ASR'),('who','WHO ASR')]:
  for dom,label in list(labels.items())[:5]:labels[pre+'_'+dom]=title+' '+label
 return labels.get(str(x),str(x))
def mdtable(headers,rows):return '\n'.join(['| '+' | '.join(map(str,headers))+' |','| '+' | '.join(['---']*len(headers))+' |']+['| '+' | '.join(pretty(x)for x in row)+' |'for row in rows])
# Concordant Word is evidence of PDF content, not an assertion of historical binary provenance.
ref=root/'revision/evidence/reference_concordant.docx';d=Document(ref);reference=[]
for b in d.element.body:
 if b.tag.endswith('}p'):
  from docx.text.paragraph import Paragraph
  p=Paragraph(b,d);t=p.text
  if t.strip():reference.append(t)
 elif b.tag.endswith('}tbl'):
  from docx.table import Table
  for row in Table(b,d).rows:
   for c in row.cells:
    for p in c.paragraphs:
     if p.text.strip():reference.append(p.text)
(ed/'pdf_reference_text.md').write_text('\n\n'.join(reference))
pdf=root/'revision/evidence/reference_sent.pdf';assert hashlib.sha256(pdf.read_bytes()).hexdigest()=='fc552ab83d5254549fa4f1dfe880ab631a26c50bc8d861bfdc433331544e71fe'
(ed/'reference_manifest.json').write_text(json.dumps({'pdf_sha256':hashlib.sha256(pdf.read_bytes()).hexdigest(),'concordant_word_sha256':hashlib.sha256(ref.read_bytes()).hexdigest(),'reference_text_sha256':hashlib.sha256((ed/'pdf_reference_text.md').read_bytes()).hexdigest(),'qualification':'Word content concordance does not establish binary identity at email send time.'},indent=2))
original=(root/'reanalysis/manuscript/article/manuscript.md').read_text();intro=original.split('# Introduction\n',1)[1].split('# Methods\n',1)[0].strip();refs=original.split('# References\n',1)[1].split('# Tables',1)[0].strip().replace('2024. Available from: https://www.R-project.org/','2026. Available from: https://www.R-project.org/')
refs+='\n11. Kitagawa EM. Components of a difference between two rates. J Am Stat Assoc. 1955;50(272):1168–1194. doi:10.1080/01621459.1955.10501299\n12. Ministério da Saúde. Estrutura de Dados SIM. Secretaria de Vigilância em Saúde. Official data dictionary, archived by UFBA. https://ccvisat.ufba.br/wp-content/uploads/2019/10/Estrutura-do-SIM-para-o-CD-ROM.pdf (accessed 11 October 2026).'
cal=frame('record_selection_and_age_transitions');valid=cal.dropna(subset=['age_continuous','age_calendar']);shift=int(((valid.age_continuous//1)!=valid.age_calendar).sum());shiftret=int((((valid.age_continuous//1)!=valid.age_calendar)&valid.retained).sum());primarytotal=int(C.N_ge7.sum());youngtotal=int(C.N_age_5_34.sum());older=int(C.N_age_ge60.sum());warn=int((M.status=='warning').sum());k=K.iloc[0];k24=K24.iloc[0]
values={
'TITLE':'Reassessing asthma mortality in Brazil during 2014–2021 through reproduction and age-specific analysis',
'INTRODUCTION':intro,'REFERENCES':refs,
'ABSTRACT_RESULTS':f"Historical selection reproduced 18,583 deaths with continuous age >6; the published count was 18,584. The corrected national analysis of completed ages ≥7 included {primarytotal:,} deaths. Aligned crude mortality increased {stat('crude_ge7','relative_change'):.1f}%; Brazil-2014-standardised mortality changed {stat('brazil2014_ge7','relative_change'):.1f}% between endpoints (eight-year slope {stat('brazil2014_ge7','slope'):.4f}; 95% CI {stat('brazil2014_ge7','ci_low'):.4f} to {stat('brazil2014_ge7','ci_high'):.4f}; p = {pval(stat('brazil2014_ge7','p_value'))}). Within ages 5–34, Brazil-2014-standardised mortality increased {stat('brazil2014_age_5_34','relative_change'):.1f}% ({stat('brazil2014_age_5_34','absolute_change'):.4f} per 100,000; p = {pval(stat('brazil2014_age_5_34','p_value'))}). Its slope remained positive excluding 2020 (p = {pval(stat('brazil2014_age_5_34','p_value','without_2020'))}); the 2014–2019 interval included zero (p = {pval(stat('brazil2014_age_5_34','p_value','prepandemic'))}).",
'SELECTION_RESULTS':f"The eight official files contained {int(C.N_raw.sum()):,} records, including {int(C.N_J45_J46.sum()):,} underlying-cause asthma records. Corrected COVID exclusions removed {int(C.N_COVID.sum())} records, comprising 27 in 2020 and 30 in 2021. No record was removed as a proven duplicate; 15 had non-interpretable dates and none had birth after death, leaving {int(C.N_valid_age.sum()):,} age-valid records. The ≥7 domain contained {primarytotal:,} deaths, including {older:,} ({older/primarytotal*100:.1f}%) at ≥60. Calendar age changed the single-year bin of {shift} candidates ({shiftret} retained), but none crossed the ≥7, 5–34, 7–34, 35–59 or ≥60 domain boundaries relative to floor(days/365.25). Ages above 90 were retained in the 90+ interval. The corrected total ≥7 equals the historical total because retaining one 2018 record and excluding the additional 2021 U071 record cancel in the total.",
'NATIONAL_RESULTS':f"For completed ages ≥7, the aligned crude series rose from {rate_sentence('crude_ge7')}. Brazil-2014-standardised mortality changed from {rate_sentence('brazil2014_ge7')}. The endpoint comparison describes the difference between 2014 and 2021. The slope uses all eight annual observations, and its interval includes trends in both directions.",
'COUNT_RESULTS':f"With 2018 denominators, the age-adjusted national estimate was {model_text(M,'age_adjusted_ge7','quasipoisson')} under quasi-Poisson and {model_text(M,'age_adjusted_ge7','negbin')} under negative binomial regression. With 2024 denominators, the negative binomial estimate was {model_text(M24,'age_adjusted_ge7','negbin')}, the only one of the six corrected national age-adjusted specifications whose interval excluded zero. The national Poisson Pearson dispersion was {M[(M.series=='age_adjusted_ge7')&(M.model=='poisson')].iloc[0].pearson_dispersion:.2f}; different uncertainty and variance assumptions contribute to differences between families. All mean-model iterations converged. Some unadjusted age-group negative binomial fits reached the theta iteration limit. Supplementary Table S4 identifies these warnings; convergence of the mean model alone does not establish dispersion convergence.",
'KITAGAWA_RESULTS':f"Across six pairs, the composition component was positive under both revisions. With IBGE 2018 it accounted for {K.composition_percent.min():.1f}–{K.composition_percent.max():.1f}% of the net increase, compared with {K24.composition_percent.min():.1f}–{K24.composition_percent.max():.1f}% under IBGE 2024. For 2014–2021, the 2018 net change of {signed(k.net_change)} per 100,000 comprised composition {signed(k.composition)} and age-specific rates {signed(k.rate_component)}; {k.composition_ge60_percent:.1f}% of composition arose at ≥60. The corresponding 2024 terms were {signed(k24.net_change)}, {signed(k24.composition)} and {signed(k24.rate_component)}. Contributions above 100% mean that a negative rate component partly offset the positive composition component; these proportions describe the decomposition and do not estimate causal effects.",
'YOUNG_RESULTS':f"Ages 5–34 contributed {youngtotal:,} corrected deaths (172–236 annually). Their crude rate rose from {rate_sentence('crude_age_5_34')}. Standardising within 5–34 to Brazil 2014 yielded {rate_sentence('brazil2014_age_5_34')}; WHO standardisation yielded {rate_sentence('who_age_5_34')}. Thus the crude absolute increase was {stat('crude_age_5_34','absolute_change'):.4f}, and the within-group-standardised absolute increase was {stat('brazil2014_age_5_34','absolute_change'):.4f} per 100,000. The nested 7–34 comparison gave {rate_sentence('brazil2014_age_7_34')}; it tests sensitivity to including ages five and six. The crude 5–34 quasi-Poisson estimate was {model_text(M,'crude_age_5_34','quasipoisson')}.",
'PANDEMIC_RESULTS':f"Excluding 2020 while retaining calendar-year values, the within-5–34 Brazil-2014-standardised slope was {stat('brazil2014_age_5_34','slope','without_2020'):.4f} (95% CI {stat('brazil2014_age_5_34','ci_low','without_2020'):.4f} to {stat('brazil2014_age_5_34','ci_high','without_2020'):.4f}; p = {pval(stat('brazil2014_age_5_34','p_value','without_2020'))}). In 2014–2019 it was {stat('brazil2014_age_5_34','slope','prepandemic'):.4f} (95% CI {stat('brazil2014_age_5_34','ci_low','prepandemic'):.4f} to {stat('brazil2014_age_5_34','ci_high','prepandemic'):.4f}; p = {pval(stat('brazil2014_age_5_34','p_value','prepandemic'))}); the endpoint increase was {stat('brazil2014_age_5_34','relative_change','prepandemic'):.1f}%. For the 7–34 control, the respective standardised trend p values were {pval(stat('brazil2014_age_7_34','p_value','without_2020'))} and {pval(stat('brazil2014_age_7_34','p_value','prepandemic'))}. The primary standardised prepandemic interval therefore does not establish a positive annual trend.\n\nWith WHO standardisation and IBGE 2018, excluding 2020 gives p = {pval(stat('who_age_5_34','p_value','without_2020'))}, with an interval including zero. In 2014–2019, count-model inference also differs. The crude 5–34 Poisson and negative binomial Wald intervals exclude zero; the quasi-Poisson t interval includes it; negative-binomial theta has an iteration warning. Supplementary Table S7 reports results for both revisions, both standards and all three count families. These comparisons show that inference depends on the standard and variance assumptions.",
'COVID_RESULTS':f"The original COVID rule removes 56 records; adding U071 removes one further record in 2021, within both young domains. Of 18 U071 mentions in 2020, all were already excluded; of 19 in 2021, 18 overlapped the original rule. Retaining all COVID mentions raises the primary ≥7 numerator from {primarytotal:,} to {int(frame('selection_counts','covid_retained').N_ge7.sum()):,}. Calendar-age, original-COVID, all-COVID-retained and historical-key sensitivities change one condition at a time (Supplementary Table S8). At 35–59 the crude slope remained imprecise (p = {pval(stat('crude_age_35_59','p_value'))}); uncertainty is not evidence of stability.",
}
# Table 1 includes historical continuous >6 series distinctly from corrected domains.
rows=[]
for s,label in [('crude_ge7','Corrected crude ≥7'),('brazil2014_ge7','Brazil 2014 ASR ≥7'),('crude_age_5_34','Crude 5–34'),('brazil2014_age_5_34','Brazil 2014 ASR 5–34'),('crude_age_7_34','Crude 7–34'),('crude_age_35_59','Crude 35–59')]:
 r=T.loc[s];rows.append([label,f(r.first_rate),f(r.last_rate),signed(r.absolute_change),signed(r.relative_change,1),f'{f(r.slope,4)} ({f(r.ci_low,4)}, {f(r.ci_high,4)})',pval(r.p_value)])
hist=pd.read_csv(root/'revision/results/historical/primary_results.csv')
for s,label in [('brum_crude_national_total_pop','Historical >6 / all population'),('brum_crude_national_gt6_pop','Historical >6 / ≥7 population')]:
 r=hist[hist.series==s].sort_values('year');a=r.iloc[0];b=r.iloc[-1];rows.append([label,f(a.rate),f(b.rate),signed(b.rate-a.rate),signed(b['pct_change'],1),f'{f(a.slope,4)} ({f(a.ci_low,4)}, {f(a.ci_high,4)})',pval(a.p_value)])
values['TABLE1']=mdtable(['Series','2014','2021','Δ rate','Δ %','Slope (95% CI)','p'],rows)
template=ed/'manuscript_template.md'
if not template.exists():raise RuntimeError('Write the editorial template first')
text=template.read_text()
for key,value in values.items():text=text.replace('{{'+key+'}}',value)
assert not re.search(r'\{\{.*?\}\}',text)
(ed/'manuscript.md').write_text(text);(ed/'claim_trace.json').write_text(json.dumps(claims,indent=2))
# A prose-only edit must preserve the existing result-derived figure bytes.
if "--text-only" not in sys.argv:
 # Figures use the corrected rates and decompositions directly.
 plt.rcParams.update({'font.family':'DejaVu Sans','font.size':10,'axes.spines.top':False,'axes.spines.right':False})
 r=frame('rates_by_year');fig1,ax=plt.subplots(figsize=(7,4.5))
 for s,label,style in [('crude_ge7','Crude ≥7','o--'),('brazil2014_ge7','Brazil 2014 ASR ≥7','s-'),('brazil2014_age_5_34','Brazil 2014 ASR 5–34','^-.' )]:
  d=r[r.series==s].sort_values('year');ax.plot(d.year,(d.rate/d.iloc[0].rate-1)*100,style,label=label)
 ax.axhline(0,color='gray',lw=.7);ax.set(xlabel='Year',ylabel='Change from 2014 (%)');ax.legend(frameon=False);fig1.tight_layout()
 fig2,axs=plt.subplots(1,2,figsize=(8,4.6),sharey=True)
 for ax,k,label in zip(axs,[K,K24],['IBGE 2018','IBGE 2024']):
  x=np.arange(len(k));ax.bar(x-.18,k.composition,.36,label='Composition',color='#343434');ax.bar(x+.18,k.rate_component,.36,label='Age-specific rates',color='#bbbbbb',hatch='//');ax.plot(x,k.net_change,'o',color='#b44c00',label='Net change');ax.set_xticks(x,[f'{int(a)}–{int(b)}'for a,b in zip(k.start,k.end)],rotation=55,ha='right');ax.set_title(label);ax.axhline(0,color='gray',lw=.7)
 axs[0].set_ylabel('Change per 100,000 (≥7 years)');axs[1].legend(fontsize=8,frameon=False);fig2.tight_layout()
 figs,axs=plt.subplots(2,1,figsize=(7,6),sharex=True)
 for s,label,style in [('crude_age_5_34','Crude 5–34','o-'),('crude_age_7_34','Crude 7–34','s--'),('brazil2014_age_5_34','Brazil 2014 ASR 5–34','^-.' )]:
  d=r[r.series==s].sort_values('year');axs[0].plot(d.year,d.rate,style,label=label)
 axs[0].set_ylabel('Rate per 100,000');axs[0].legend(frameon=False,fontsize=9);d=r[r.series=='crude_age_5_34'];axs[1].bar(d.year,d.n_deaths,color='#666666');axs[1].set(xlabel='Year',ylabel='Deaths at ages 5–34');figs.tight_layout()
 for figure,name in [(fig1,'Figure1'),(fig2,'Figure2'),(figs,'FigureS1')]:
  for ext in ['png','pdf','svg']:figure.savefig(fig/f'{name}.{ext}',dpi=300,bbox_inches='tight')
# Supplement generated from all prespecified scenarios (CSV retains unrounded detail).
supp=['# Supplementary material', 'All analyses use corrected selection unless labelled historical. Rates and slope units are deaths per 100,000; APC is percent per year. Full-precision CSV results and model warnings are delivered with the code.']
def add(title,headers,rows,note=''):supp.extend(['## '+title,mdtable(headers,rows),note])
add('Table S1. Corrected selection by year',['Year','All SIM','J45/J46','COVID','Duplicates','Invalid dates','Negative age','Valid','≥7','5–34'],[[int(r.year),int(r.N_raw),int(r.N_J45_J46),int(r.N_COVID),int(r.N_duplicates),int(r.N_invalid_dates),int(r.N_negative_age),int(r.N_valid_age),int(r.N_ge7),int(r.N_age_5_34)]for _,r in C.iterrows()],'COVID = union across five cause lines. Invalid-date and negative-age counts follow COVID and deduplication. Both ambiguous 2018 records are retained. The historical selection, provided separately, removed 56 COVID records, one record under the reduced key and 15 records with invalid dates, leaving 18,583 deaths at continuous age >6.')
for s,label in [('crude_ge7','Aligned crude ≥7'),('brazil2014_ge7','Brazil 2014 ASR ≥7'),('crude_age_5_34','Crude 5–34'),('brazil2014_age_5_34','Brazil 2014 ASR 5–34'),('crude_age_7_34','Crude 7–34'),('crude_age_35_59','Crude 35–59'),('crude_age_ge60','Crude ≥60')]:
 d=rates=frame('rates_by_year');d=d[d.series==s];add('Table S2. Annual '+label,['Year','Deaths','Population','Rate'],[[int(x.year),int(x.n_deaths),f'{int(x.population):,}',f(x.rate,6)]for _,x in d.iterrows()])
legacy=pd.read_csv(root/'revision/results/historical/data/fase1_legacy_reconciliation.csv');add('Table S3. Historical age-group reproduction',list(legacy.columns),[[f(x,5)if isinstance(x,float)else x for x in row]for row in legacy.itertuples(index=False,name=None)],'Historical <18 numerator is floor ages 7–17 and denominator ages 0–17. These rows reproduce the historical construction and are not corrected primary domains.')
for rev in [2018,2024]:
 m=frame('count_models',rev=rev);add(f'Table S4. Count models, IBGE {rev}',['Series','Family','APC','95% CI','p','Dispersion','Theta','Status'],[[x.series,x.model,f(x.annual_pct_change,3),f'{f(x.ci_low,3)}, {f(x.ci_high,3)}',pval(x.p_value),f(x.pearson_dispersion,2),''if pd.isna(x.nb_theta)else f(x.nb_theta,1),x.status]for _,x in m.iterrows()], 'Rows marked as warnings reached the theta iteration limit; convergence of mean-model IRLS does not prove convergence of theta. Retain these estimates with caution. The recorded warning was “iteration limit reached”. All errors, warnings, iterations, coefficients and fitted objects are retained in CSV/RDS. Quasi-Poisson uses t intervals with residual degrees of freedom; Poisson and negative binomial use normal Wald intervals.')
for rev in [2018,2024]:
 t=frame('rate_trends',rev=rev);t=t[t.series.str.startswith(('brazil2014','who'))];add(f'Table S5. Standards and domains, IBGE {rev}',['Series','2014','2021','Δ rate','Δ %','Slope (95% CI)','p'],[[x.series,f(x.first_rate,5),f(x.last_rate,5),signed(x.absolute_change,5),signed(x.relative_change,2),f'{f(x.slope,5)} ({f(x.ci_low,5)}, {f(x.ci_high,5)})',pval(x.p_value)]for _,x in t.iterrows()])
for rev in [2018,2024]:
 k=frame('kitagawa_endpoints',rev=rev);add(f'Table S6. Kitagawa, IBGE {rev}',['Endpoints','Crude start','Crude end','Net Δ','Composition','Rate term','Composition %'],[[f'{int(x.start)}–{int(x.end)}',f(x.crude_start,6),f(x.crude_end,6),signed(x.net_change,6),signed(x.composition,6),signed(x.rate_component,6),f(x.composition_percent,2)]for _,x in k.iterrows()],'Each term is independently rounded. The unrounded identity is tested to 1e−12; rounded terms may differ in their last displayed digit. A share over 100% reflects a negative rate term, not a probability.')
for rev in [2018,2024]:
 for domain in ['age_5_34','age_7_34']:
  rows=[]
  for scen in ['corrected','without_2020','prepandemic']:
   t=frame('rate_trends',scen,rev);t=t[t.series.isin([p+'_'+domain for p in ['crude','brazil2014','who']])]
   for _,x in t.iterrows():rows.append([scen,x.series,int(x.n_years),signed(x.relative_change,2),f'{f(x.slope,5)} ({f(x.ci_low,5)}, {f(x.ci_high,5)})',pval(x.p_value)])
  add(f'Table S7. Pandemic-period influence, {domain}, IBGE {rev}',['Scenario','Series','Years','Δ %','Slope (95% CI)','p'],rows,'Without 2020 uses 2014–2019 and 2021 as calendar years (seven observations, 5 residual df); prepandemic uses 2014–2019 (six observations, 4 residual df). Endpoint contrasts are distinct from annual slopes. Count-model sensitivities for the same domains are supplied below.')
  rows=[]
  for scen in ['corrected','without_2020','prepandemic']:
   m=frame('count_models',scen,rev)
   for _,x in m[m.series=='crude_'+domain].iterrows():rows.append([scen,x.model,f(x.annual_pct_change,3),f'{f(x.ci_low,3)}, {f(x.ci_high,3)}',pval(x.p_value),int(x.df_residual),x.status])
  add(f'Table S7 continued. Count models, {domain}, IBGE {rev}',['Scenario','Family','APC','95% CI','p','df','Status'],rows)
for rev in [2018,2024]:
 for domain in ['ge7','age_5_34','age_7_34']:
  rows=[]
  for scen in ['corrected','age_days','covid_original','covid_retained','historical_dedup']:
   t=frame('rate_trends',scen,rev)
   for _,x in t[t.series=='brazil2014_'+domain].iterrows():rows.append([scen,int(x.total_deaths),f(x.first_rate,5),f(x.last_rate,5),signed(x.relative_change,2),f'{f(x.slope,5)} ({f(x.ci_low,5)}, {f(x.ci_high,5)})',pval(x.p_value)])
  add(f'Table S8. One-condition sensitivities, {domain}, IBGE {rev}',['Scenario','Deaths','2014','2021','Δ %','Slope (95% CI)','p'],rows,'Each scenario changes only the indicated condition from corrected selection. Calendar-boundary changes are recorded individually in record_selection_and_age_transitions.csv; COVID overlaps in covid_overlap_patterns.csv.')
supp+=['## Supplementary Figure S1','![Figure S1. Annual crude rates for ages 5–34 and 7–34, within-5–34 Brazil-2014-standardised rates, and 5–34 death counts; corrected selection and IBGE 2018.](figures/FigureS1.png)']
(ed/'supplement.md').write_text('\n\n'.join(supp))
print('Editorial sources and figures built; claims:',len(claims))
