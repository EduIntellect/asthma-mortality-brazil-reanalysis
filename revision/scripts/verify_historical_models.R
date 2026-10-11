.libPaths(c('revision/.Rlib',.libPaths()));source('revision/scripts/analysis.R')
a<-read.csv('revision/results/historical/annual_aggregates.csv');c<-read.csv('revision/results/historical/data/fase2_year_counts.csv');ref<-read.csv('revision/results/historical/data/robustness_count_models.csv');p18<-read.csv('revision/results/historical/data/ibge_denominators_by_age.csv');p24<-read2024('revision/inputs/projecoes_2024_tab1_idade_simples.xlsx');results<-list()
for(rev in c('rev2018','rev2024')){p<-if(rev=='rev2018')p18 else p24;series<-list()
 for(label in c('brum_crude_national_total_pop','brum_crude_national_gt6_pop','age_5_34','age_7_34_control','age_35_59','legacy_18_59','legacy_gte60')){
  range<-switch(label,brum_crude_national_total_pop=c(0,90),brum_crude_national_gt6_pop=c(7,90),age_5_34=c(5,34),age_7_34_control=c(7,34),age_35_59=c(35,59),legacy_18_59=c(18,59),legacy_gte60=c(60,90));grid<-complete_grid(a,p,2014:2021,range[1],range[2]);d<-aggregate(cbind(n_deaths,population)~year,grid,sum);if(grepl('^brum',label))d$n_deaths<-c$N_gt6_valid_age[match(d$year,c$year)];series[[label]]<-d
 }
 grid<-complete_grid(a,p,2014:2021,7,90);grid$band<-band9(grid$age);series[['age_adjusted_poisson_ge7']]<-aggregate(cbind(n_deaths,population)~year+band,grid,sum)
 for(label in names(series)){d<-series[[label]];d$yc<-d$year-mean(d$year);x<-model.matrix(if(label=='age_adjusted_poisson_ge7')~band+yc else ~yc,d);y<-d$n_deaths;off<-log(d$population)
  for(mod in c('poisson','quasipoisson','negbin')){row<-ref[ref$denominator_revision==rev&ref$series==label&ref$model==mod,];stopifnot(nrow(row)==1);theta<-if(mod=='negbin')row$nb_theta else Inf;b<-rep(0,ncol(x));b[1]<-log(sum(y)/sum(d$population))
   for(j in 1:100){mu<-exp(drop(x%*%b)+off);w<-mu/(1+mu/theta);z<-drop(x%*%b)+(y-mu)/mu;bn<-solve(crossprod(x,w*x),crossprod(x,w*z));if(max(abs(bn-b))<1e-11){b<-bn;break};b<-bn}
   mu<-exp(drop(x%*%b)+off);vc<-solve(crossprod(x,mu/(1+mu/theta)*x));disp<-sum((y-mu)^2/mu)/(nrow(x)-ncol(x));se<-sqrt(tail(diag(vc),1)*if(mod=='quasipoisson')disp else 1);q<-if(mod=='quasipoisson')qt(.975,nrow(x)-ncol(x)) else qnorm(.975);apc<-100*expm1(tail(b,1));lo<-100*expm1(tail(b,1)-q*se);hi<-100*expm1(tail(b,1)+q*se);stopifnot(abs(apc-row$annual_pct_change)<1e-4,abs(lo-row$ci_low)<1e-4,abs(hi-row$ci_high)<1e-4);results[[length(results)+1]]<-data.frame(revision=rev,series=label,model=mod,apc_error=abs(apc-row$annual_pct_change),ci_low_error=abs(lo-row$ci_low),ci_high_error=abs(hi-row$ci_high))
  }
 }
}
stopifnot(length(results)==48);write.csv(do.call(rbind,results),'revision/qa/independent_historical_model_checks.csv',row.names=FALSE);cat('Independently checked all 48 historical count models, conditional on reported theta\n')
