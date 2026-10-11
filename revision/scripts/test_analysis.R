source('revision/scripts/analysis.R')
stopifnot(is.na(parse_sim_date('31022020')),is.na(parse_sim_date('29022019')),is.na(parse_sim_date('010120200')),as.character(parse_sim_date('1012020'))=='2020-01-01')
b<-as.Date(c('2000-02-29','2000-02-29','2000-02-29','2000-02-29','2014-10-11','2014-10-11','2014-10-11'));d<-as.Date(c('2007-02-28','2007-03-01','2008-02-28','2008-02-29','2021-10-10','2021-10-11','2014-10-10'));stopifnot(identical(calendar_age(b,d),c(6L,7L,7L,8L,6L,7L,-1L)))
stopifnot(identical(as.character(band9(c(7,14,15,24,25,34,35,44,45,54,55,64,65,74,75,84,85,90))),rep(c('7-14','15-24','25-34','35-44','45-54','55-64','65-74','75-84','85+'),each=2)))
for(n in names(domains)){r<-domains[[n]];stopifnot(!(r[1]-1>=r[1]),r[1]>=r[1],r[2]<=r[2],!(r[2]+1<=r[2]))}
stopifnot(identical(band5(c(89,90,114)),c('85-89','90+','90+')))
cat('Date, birthday, leap-day, group and open-age tests passed\n')
