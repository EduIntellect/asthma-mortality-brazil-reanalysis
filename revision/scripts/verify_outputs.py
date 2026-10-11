"""Independent calendar, rate, weighting and decomposition calculations."""
from pathlib import Path
from datetime import datetime
import csv,json,math
import numpy as np,pandas as pd
root=Path(__file__).resolve().parents[2];checks=[]
def date(s):
 if not isinstance(s,str):return None
 if len(s)==7:s='0'+s
 if len(s)!=8 or not s.isdigit():return None
 try:return datetime.strptime(s,'%d%m%Y').date()
 except ValueError:return None
for y in range(2014,2022):
 records=pd.read_csv(root/f'revision/results/corrected/ibge2018/record_selection_and_age_transitions.csv').query('year==@y').set_index('source_row')
 for d in csv.DictReader((root/f'revision/.cache/asthma_{y}.csv').open()):
  b=date(d['DTNASC']);death=date(d['DTOBITO']);row=records.loc[int(d['source_row'])]
  if b is None or death is None:assert pd.isna(row.age_calendar);continue
  anniversary=(b.month,b.day)
  if anniversary==(2,29) and not (death.year%4==0 and (death.year%100!=0 or death.year%400==0)):anniversary=(3,1)
  age=death.year-b.year-((death.month,death.day)<anniversary)
  assert age==row.age_calendar
  assert abs((death-b).days/365.25-row.age_continuous)<1e-10
 checks.append({'check':'calendar and continuous age','year':y,'status':'passed'})
for folder in sorted((root/'revision/results').glob('*/ibge*')):
 agg=pd.read_csv(folder/'annual_aggregates.csv');pop=pd.read_csv(folder/'population_by_age.csv');rates=pd.read_csv(folder/'rates_by_year.csv');trends=pd.read_csv(folder/'rate_trends.csv');weights=pd.read_csv(folder/'standard_weights.csv');counts=pd.read_csv(folder/'selection_counts.csv');models=pd.read_csv(folder/'count_models.csv')
 assert (counts.N_J45_J46-counts.N_COVID-counts.N_duplicates==counts.N_post_exclusions).all();assert (counts.N_post_exclusions-counts.N_invalid_dates-counts.N_negative_age==counts.N_valid_age).all();assert agg.n_deaths.sum()==counts.N_valid_age.sum();assert (counts.N_ge7==counts.N_age_7_34+counts.N_age_35_59+counts.N_age_ge60).all()
 for (standard,domain),g in weights.groupby(['standard','domain']):assert abs(g.weight.sum()-1)<1e-14
 domains={'ge7':(7,90),'age_5_34':(5,34),'age_7_34':(7,34),'age_35_59':(35,59),'age_ge60':(60,90)}
 for _,row in rates.iterrows():
  prefix,domain=next((pre,row.series[len(pre)+1:])for pre in ['crude','brazil2014','who']if row.series.startswith(pre+'_'));lo,hi=domains[domain];p=pop.query('year==@row.year and @lo<=age<=@hi').set_index('age').population;d=agg.query('year==@row.year').set_index('age_floor').n_deaths.reindex(p.index,fill_value=0);assert d.sum()==row.n_deaths;assert p.sum()==row.population
  if prefix=='crude':val=d.sum()/p.sum()*1e5
  elif prefix=='brazil2014':w=weights.query('standard=="Brazil2014" and domain==@domain').copy();w.age_band=w.age_band.astype(int);w=w.set_index('age_band').weight;val=(d/p*w*1e5).sum()
  else:
   bands={int(a):'90+'if a>=90 else f'{a//5*5}-{a//5*5+4}'for a in p.index};dw=d.groupby(d.index.map(bands)).sum();pw=p.groupby(p.index.map(bands)).sum();w=weights.query('standard=="WHO" and domain==@domain').set_index('age_band').weight;val=(dw/pw*w*1e5).sum()
  assert abs(val-row.rate)<1e-12
 for _,k in pd.read_csv(folder/'kitagawa_endpoints.csv').iterrows():
  ps=pop.query('year==@k.start and age>=7').set_index('age').population;pe=pop.query('year==@k.end and age>=7').set_index('age').population;ds=agg.query('year==@k.start').set_index('age_floor').n_deaths.reindex(ps.index,fill_value=0);de=agg.query('year==@k.end').set_index('age_floor').n_deaths.reindex(pe.index,fill_value=0);ws=ps/ps.sum();we=pe/pe.sum();rs=1e5*ds/ps;re=1e5*de/pe;composition=((we-ws)*(rs+re)/2).sum();component=((re-rs)*(ws+we)/2).sum();assert abs(composition-k.composition)<1e-12;assert abs(component-k.rate_component)<1e-12;assert abs(k.net_change-composition-component)<1e-12
 assert len(models)==18;assert not (models.status=='failed').any();assert models.converged.all()
 checks.append({'check':'flow, denominators, rates, weights, Kitagawa and model accounting','run':str(folder.relative_to(root)),'status':'passed','model_warnings':int((models.status=='warning').sum())})
(root/'revision/qa/independent_output_checks.json').write_text(json.dumps(checks,indent=2));print('Independent checks passed:',len(checks))
