# Explicit scenario analysis. Input candidates retain every raw SIM field and source row.
parse_sim_date <- function(x, strict=TRUE) {
 x <- ifelse(!is.na(x) & nchar(x)==7,paste0('0',x),x)
 d <- as.Date(x,format='%d%m%Y')
 if(strict) d[is.na(x)|!grepl('^[0-9]{8}$',x)|is.na(d)|format(d,'%d%m%Y')!=x] <- NA
 d
}
calendar_age <- function(b,d) {
 by<-as.integer(format(b,'%Y')); dy<-as.integer(format(d,'%Y'))
 anniversary<-format(b,'%m%d'); leap<-dy%%4==0 & (dy%%100!=0|dy%%400==0)
 anniversary[!is.na(anniversary)&anniversary=='0229'&!is.na(leap)&!leap]<-'0301'
 dy-by-as.integer(format(d,'%m%d')<anniversary)
}
domains<-list(ge7=c(7,90),age_5_34=c(5,34),age_7_34=c(7,34),age_35_59=c(35,59),age_ge60=c(60,90))
scenario_config<-function(s) {
 stopifnot(s%in%c('corrected','age_days','covid_original','covid_retained','historical_dedup','without_2020','prepandemic','historical'))
 list(scenario=s,age=if(s%in%c('age_days','historical'))'days365.25' else 'calendar', covid=if(s%in%c('covid_original','historical'))'original' else if(s=='covid_retained')'retain' else 'U071',dedup=if(s%in%c('historical_dedup','historical'))'historical_key' else 'retain_ambiguous',years=if(s=='without_2020')c(2014:2019,2021) else if(s=='prepandemic')2014:2019 else 2014:2021)
}
select_records<-function(d,y,cfg,n_raw) {
 fields<-c('LINHAA','LINHAB','LINHAC','LINHAD','LINHAII'); codes<-c('B342','U072','U071','COVID-19')
 flags<-sapply(codes,function(code) Reduce(`|`,lapply(fields,function(f)grepl(code,d[[f]],fixed=TRUE))))
 b<-parse_sim_date(d$DTNASC,cfg$scenario!='historical'); death<-parse_sim_date(d$DTOBITO,cfg$scenario!='historical')
 continuous<-as.numeric(death-b)/365.25; completed<-calendar_age(b,death)
 age<-if(cfg$age=='calendar')completed else continuous
 covid<-if(cfg$covid=='retain')rep(FALSE,nrow(d)) else rowSums(flags[,if(cfg$covid=='original')c(1,2,4) else 1:4,drop=FALSE])>0
 key<-data.frame(death,continuous,d[,c('CAUSABAS',fields)])
 dup<-rep(FALSE,nrow(d)); if(cfg$dedup=='historical_key')dup[!covid]<-duplicated(key[!covid,])
 invalid<-is.na(b)|is.na(death)|is.na(age); negative<-!invalid & b>death
 keep<-!covid & !dup & !invalid & !negative
 if(cfg$scenario=='historical')keep<-!covid & !dup & !invalid
 a<-pmin(floor(age[keep]),90L)
 agg<-aggregate(rep(1,length(a)),list(age_floor=a),sum);names(agg)[2]<-'n_deaths';agg$year<-y
 log<-data.frame(year=y,N_raw=n_raw,N_J45_J46=nrow(d),N_COVID=sum(covid),N_duplicates=sum(dup),N_post_exclusions=sum(!covid&!dup),N_invalid_dates=sum(!covid&!dup&invalid),N_negative_age=sum(!covid&!dup&negative),N_valid_age=sum(keep),N_continuous_gt6=sum(keep & continuous>6,na.rm=TRUE),N_ge7=sum(keep&floor(age)>=7,na.rm=TRUE))
 for(n in names(domains)){range<-domains[[n]];log[[paste0('N_',n)]]<-sum(keep&pmin(floor(age),90)>=range[1]&pmin(floor(age),90)<=range[2],na.rm=TRUE)}
 overlap<-data.frame(year=y,pattern=apply(flags,1,function(z)paste(codes[z],collapse='+')))
 overlap<-aggregate(rep(1,nrow(overlap)),overlap,sum);names(overlap)[3]<-'records'
 transitions<-data.frame(year=y,source_row=d$source_row,age_continuous=continuous,age_calendar=completed,retained=keep,covid=covid,historical_key_duplicate=duplicated(key),invalid_date=invalid,negative_age=negative)
 for(n in names(domains)){r<-domains[[n]];transitions[[paste0(n,'_days')]]<-pmin(floor(continuous),90)>=r[1]&pmin(floor(continuous),90)<=r[2];transitions[[paste0(n,'_calendar')]]<-pmin(completed,90)>=r[1]&pmin(completed,90)<=r[2]}
 list(agg=agg,counts=log,overlap=overlap,records=transitions)
}
read2024<-function(path){d<-suppressMessages(readxl::read_excel(path,sheet=1,skip=5,col_types='text'));names(d)[1]<-'IDADE';b<-d[d$SEXO=='Ambos'&d$SIGLA=='BR',];a<-as.integer(b$IDADE);stopifnot(identical(sort(a),0:90));do.call(rbind,lapply(2014:2021,function(y)data.frame(year=y,age=a,population=as.numeric(b[[as.character(y)]]))))}
complete_grid<-function(agg,pop,years,lo,hi){g<-pop[pop$year%in%years&pop$age>=lo&pop$age<=hi,c('year','age','population')];names(agg)[1]<-'age';m<-merge(g,agg,by=c('year','age'),all.x=TRUE);m$n_deaths[is.na(m$n_deaths)]<-0;stopifnot(nrow(m)==length(years)*(hi-lo+1),!anyDuplicated(m[c('year','age')]),all(m$population>0));m}
who_weights<-c('5-9'=8.69,'10-14'=8.60,'15-19'=8.47,'20-24'=8.22,'25-29'=7.93,'30-34'=7.61,'35-39'=7.15,'40-44'=6.59,'45-49'=6.04,'50-54'=5.37,'55-59'=4.55,'60-64'=3.72,'65-69'=2.96,'70-74'=2.21,'75-79'=1.52,'80-84'=.91,'85-89'=.44,'90+'=.195)
band5<-function(a)ifelse(a>=90,'90+',paste0(a%/%5*5,'-',a%/%5*5+4))
make_rates<-function(agg,pop,years){series<-list();weights<-list();count_data<-list()
 for(n in names(domains)){r<-domains[[n]];m<-complete_grid(agg,pop,years,r[1],r[2]);m$rate<-m$n_deaths/m$population*1e5
  raw<-aggregate(cbind(n_deaths,population)~year,m,sum);raw$rate<-raw$n_deaths/raw$population*1e5;raw$series<-paste0('crude_',n);series[[raw$series[1]]]<-raw;count_data[[raw$series[1]]]<-raw
  w<-pop[pop$year==2014&pop$age>=r[1]&pop$age<=r[2],c('age','population')];w$weight<-w$population/sum(w$population);w$population<-NULL;stopifnot(abs(sum(w$weight)-1)<1e-14)
  b<-merge(m,w,by='age');std<-aggregate(rate*weight~year,b,sum);names(std)[2]<-'rate';std$n_deaths<-raw$n_deaths[match(std$year,raw$year)];std$population<-raw$population[match(std$year,raw$year)];std$series<-paste0('brazil2014_',n);series[[std$series[1]]]<-std
  if(2014%in%years)stopifnot(abs(std$rate[std$year==2014]-raw$rate[raw$year==2014])<1e-12)
  weights[[paste0('brazil2014_',n)]]<-data.frame(standard='Brazil2014',domain=n,age_band=as.character(w$age),weight=w$weight)
  m$band<-band5(m$age);bm<-aggregate(cbind(n_deaths,population)~year+band,m,sum);bm$rate<-bm$n_deaths/bm$population*1e5
  covered<-table(band5(r[1]:r[2]));fraction<-pmin(as.numeric(covered)/ifelse(names(covered)=='90+',1,5),1);ww<-who_weights[names(covered)]*fraction;ww<-ww/sum(ww);stopifnot(!anyNA(ww),abs(sum(ww)-1)<1e-14)
  bm$weight<-ww[match(bm$band,names(covered))];ws<-aggregate(rate*weight~year,bm,sum);names(ws)[2]<-'rate';ws$n_deaths<-raw$n_deaths[match(ws$year,raw$year)];ws$population<-raw$population[match(ws$year,raw$year)];ws$series<-paste0('who_',n);series[[ws$series[1]]]<-ws;weights[[paste0('who_',n)]]<-data.frame(standard='WHO',domain=n,age_band=names(covered),weight=as.numeric(ww))
 }
 list(series=do.call(rbind,series),weights=do.call(rbind,weights),count_data=count_data)
}
trend_summary<-function(s){do.call(rbind,lapply(split(s,s$series),function(d){d<-d[order(d$year),];fit<-if(d$series[1]%in%c('crude_ge7','brazil2014_ge7'))glm(rate~year,gaussian(),d) else lm(rate~year,d);co<-coef(summary(fit))['year',];q<-qt(.975,df.residual(fit));data.frame(series=d$series[1],n_years=nrow(d),first_year=d$year[1],last_year=tail(d$year,1),total_deaths=sum(d$n_deaths),first_rate=d$rate[1],last_rate=tail(d$rate,1),absolute_change=tail(d$rate,1)-d$rate[1],relative_change=(tail(d$rate,1)/d$rate[1]-1)*100,slope=co[1],se=co[2],ci_low=co[1]-q*co[2],ci_high=co[1]+q*co[2],p_value=tail(co,1),df_residual=df.residual(fit))}))}
band9<-function(a)cut(a,c(6,14,24,34,44,54,64,74,84,Inf),labels=c('7-14','15-24','25-34','35-44','45-54','55-64','65-74','75-84','85+'))
fit_counts<-function(agg,pop,years,count_data){m<-complete_grid(agg,pop,years,7,90);m$band<-band9(m$age);adj<-aggregate(cbind(n_deaths,population)~year+band,m,sum);count_data[['age_adjusted_ge7']]<-adj;results<-list();fitted<-list();coefficients<-list();inputs<-list()
 for(n in names(count_data)){d<-count_data[[n]];form<-if(n=='age_adjusted_ge7')n_deaths~band+year+offset(log(population)) else n_deaths~year+offset(log(population));inputs[[n]]<-d
  for(model in c('poisson','quasipoisson','negbin')){warnings<-character();error<-'';fit<-tryCatch(withCallingHandlers(if(model=='negbin')MASS::glm.nb(form,data=d) else glm(form,family=get(model)(),data=d),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')}),error=function(e){error<<-conditionMessage(e);NULL})
   row<-data.frame(series=n,model=model,beta=NA_real_,se=NA_real_,annual_pct_change=NA_real_,ci_low=NA_real_,ci_high=NA_real_,p_value=NA_real_,df_residual=NA_real_,pearson_dispersion=NA_real_,nb_theta=NA_real_,converged=FALSE,iterations=NA_integer_,warnings=paste(unique(warnings),collapse=' | '),error=error,status='failed')
   if(!is.null(fit)){co<-coef(summary(fit))['year',];q<-if(model=='quasipoisson')qt(.975,df.residual(fit)) else qnorm(.975);row$beta<-co[1];row$se<-co[2];row$annual_pct_change<-100*expm1(co[1]);row$ci_low<-100*expm1(co[1]-q*co[2]);row$ci_high<-100*expm1(co[1]+q*co[2]);row$p_value<-tail(co,1);row$df_residual<-df.residual(fit);row$pearson_dispersion<-sum(residuals(fit,'pearson')^2)/df.residual(fit);row$converged<-isTRUE(fit$converged);row$iterations<-fit$iter;if(model=='negbin')row$nb_theta<-fit$theta;row$status<-if(!row$converged)'not_converged' else if(length(warnings))'warning' else 'ok';tag<-paste(n,model,sep='/');fitted[[tag]]<-fit;coefficients[[tag]]<-data.frame(series=n,model=model,term=names(coef(fit)),coefficient=unname(coef(fit)));}
   results[[paste(n,model)]]<-row
  }
 }
 list(summary=do.call(rbind,results),fits=fitted,coefficients=do.call(rbind,coefficients),inputs=inputs)
}
kitagawa<-function(agg,pop,years){pairs<-rbind(c(2014,2021),c(2014,2019),c(2014,2020),c(2015,2021),c(2016,2021),c(2014,2018));m<-complete_grid(agg,pop,years,7,90);m$r<-m$n_deaths/m$population*1e5;m$w<-m$population/ave(m$population,m$year,FUN=sum);out<-list();details<-list()
 for(i in seq_len(nrow(pairs))){a<-pairs[i,1];b<-pairs[i,2];if(!all(c(a,b)%in%years))next;x<-m[m$year==a,];z<-m[m$year==b,];z<-z[match(x$age,z$age),];cpt<-(z$w-x$w)*(x$r+z$r)/2;rate<-(z$r-x$r)*(x$w+z$w)/2;delta<-sum(z$w*z$r)-sum(x$w*x$r);stopifnot(abs(delta-sum(cpt)-sum(rate))<1e-12);out[[i]]<-data.frame(start=a,end=b,crude_start=sum(x$w*x$r),crude_end=sum(z$w*z$r),net_change=delta,composition=sum(cpt),rate_component=sum(rate),composition_percent=100*sum(cpt)/delta,composition_ge60_percent=100*sum(cpt[x$age>=60])/sum(cpt),identity_error=delta-sum(cpt)-sum(rate));details[[i]]<-data.frame(start=a,end=b,age=x$age,composition=cpt,rate_component=rate)}
 list(summary=do.call(rbind,out),details=do.call(rbind,details))
}
