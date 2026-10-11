# Independent IRLS and matrix OLS, not glm/lm or MASS::glm.nb.
source('revision/scripts/analysis.R')
folders<-list.dirs('revision/results',recursive=TRUE);folders<-folders[file.exists(file.path(folders,'count_models.csv'))];checks<-list()
for(folder in folders){models<-read.csv(file.path(folder,'count_models.csv'));fits<-readRDS(file.path(folder,'count_fits.rds'));inputs<-readRDS(file.path(folder,'count_inputs.rds'));series<-read.csv(file.path(folder,'rates_by_year.csv'));trends<-read.csv(file.path(folder,'rate_trends.csv'))
 for(n in unique(series$series)){d<-series[series$series==n,];x<-d$year-mean(d$year);slope<-sum(x*(d$rate-mean(d$rate)))/sum(x*x);e<-d$rate-mean(d$rate)-slope*x;se<-sqrt(sum(e*e)/(nrow(d)-2)/sum(x*x));ref<-trends[trends$series==n,];stopifnot(abs(slope-ref$slope)<1e-10,abs(se-ref$se)<1e-10)}
 for(i in seq_len(nrow(models))){row<-models[i,];if(row$status=='failed')stop('Failed model in ',folder);d<-inputs[[row$series]];d$yc<-d$year-mean(d$year);x<-model.matrix(if(row$series=='age_adjusted_ge7')~band+yc else ~yc,d);y<-d$n_deaths;off<-log(d$population);b<-rep(0,ncol(x));b[1]<-log(sum(y)/sum(d$population));theta<-if(row$model=='negbin')row$nb_theta else Inf
  for(j in 1:100){mu<-exp(drop(x%*%b)+off);w<-mu/(1+mu/theta);z<-drop(x%*%b)+(y-mu)/mu;bn<-solve(crossprod(x,w*x),crossprod(x,w*z));if(max(abs(bn-b))<1e-11){b<-bn;break};b<-bn}
  mu<-exp(drop(x%*%b)+off);w<-mu/(1+mu/theta);vc<-solve(crossprod(x,w*x));disp<-sum((y-mu)^2/mu)/(nrow(x)-ncol(x));se<-sqrt(vc[ncol(x),ncol(x)]*if(row$model=='quasipoisson')disp else 1);err<-abs(tail(b,1)-row$beta);seerr<-abs(se-row$se);stopifnot(err<1e-6,seerr<1e-6);critical<-if(row$model=='quasipoisson')qt(.975,nrow(x)-ncol(x)) else qnorm(.975);p<-if(row$model=='quasipoisson')2*pt(-abs(tail(b,1)/se),nrow(x)-ncol(x)) else 2*pnorm(-abs(tail(b,1)/se));stopifnot(abs(p-row$p_value)<1e-4,abs(100*expm1(tail(b,1)-critical*se)-row$ci_low)<1e-4,abs(100*expm1(tail(b,1)+critical*se)-row$ci_high)<1e-4)
  checks[[length(checks)+1]]<-data.frame(folder=folder,series=row$series,model=row$model,beta_error=err,se_error=seerr,p_error=abs(p-row$p_value),irls_iterations=j,status=row$status)
 }
}
write.csv(do.call(rbind,checks),'revision/qa/independent_model_checks.csv',row.names=FALSE);cat('Independent OLS and IRLS checked',length(checks),'count models across',length(folders),'runs\n')
