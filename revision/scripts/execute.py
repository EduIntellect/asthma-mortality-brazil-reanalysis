"""Portable entry point: immutable source files and isolated result directories."""
import argparse,pathlib,subprocess,os,sys
p=argparse.ArgumentParser();p.add_argument('--data-dir',required=True);p.add_argument('--output-dir',required=True);p.add_argument('--scenario',choices=['historical','corrected','age_days','covid_original','covid_retained','historical_dedup','without_2020','prepandemic'],required=True);p.add_argument('--ibge-revision',choices=['2018','2024'],default='2018');a=p.parse_args();repo=pathlib.Path(__file__).resolve().parents[2];out=pathlib.Path(a.output_dir).resolve();env=os.environ.copy();env['R_LIBS_USER']=str(repo/'revision/.Rlib')
def run(args):subprocess.run(args,check=True,cwd=repo,env=env)
if a.scenario=='historical':
 if a.ibge_revision!='2018':p.error('Historical pipeline uses both revisions internally; primary is 2018.')
 if (out/'annual_aggregates.csv').exists():p.error('Choose an empty output directory.')
 run([sys.executable,str(repo/'revision/scripts/prepare_inputs.py'),'--data-dir',a.data_dir,'--output-dir',str(out)])
 env['ASTHMA_REANALYSIS_ROOT']=str(out)
 with (out/'execution.log').open('w')as log:
  for script in ['run_pipeline.R','check_fase1_reconciliation.R','08_count_models_and_who_standard.R','09_manuscript_assets.R']:
   subprocess.run(['Rscript',str(out/'R'/script)],check=True,cwd=repo,env=env,stdout=log,stderr=subprocess.STDOUT)
else:
 run(['Rscript',str(repo/'revision/scripts/run.R'),'--data-dir',a.data_dir,'--output-dir',str(out),'--scenario',a.scenario,'--ibge-revision',a.ibge_revision])
