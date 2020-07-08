/* STA 5856 HW3 */
/* Yuyu Fan */

/* P1 */
/*(a)*/
data HW5p1;
infile "/courses/d452b5e5ba27fe300/HW5p1.dat" firstobs=2;
input Level Salin Rain River;
if _n_ <=375 then Salin1=Salin;
else Salin2=Salin;
Rainfall = sqrt(Rain);
Riverflow= log(River);
id = _n_;
Run;

/*(b)*/
proc arima data=HW5p1;
identify var=Salin(1) nlag=50; 
*estimate p=2 method=ml;
estimate p=1 q=2 method=ml; /*final model*/
forecast out= res1 back=0 lead=20 ;
run; 

/*(c)*/
title 'Regression-TS Model';
proc arima data=HW5p1;
identify var=Salin1(1) cross=(Level(1) Rainfall(1) Riverflow(1));
*estimate p=1 q=2 input=(Level Rainfall Riverflow) method=ml;
*estimate p=2  input=(Level  Riverflow) method=ml;
estimate p=2  input=(Level) method=ml; /*final model*/
forecast out=res2 back=0 lead=20 ;
run;

/*(e)*/
data fore;
set res1;
FY = FORECAST;
LY = L95;
UY = U95;
 set res2;
FReg = FORECAST;
LReg = L95;
UReg = U95;
set HW5p1;
TrueY = Salin;
id = _n_;
 keep FY FReg TrueY id LY UY LReg UReg;
*proc print data=fore (firstobs=376 obs=395);
run;

data fore1;
set fore;
if _n_ >= 370;
run;

title 'Forecast Plot';
proc sgplot data=fore1;
series x=id y=TrueY;
series x=id y=FY;
series x=id y=FReg;
run;


/* P2 */
/*(a)*/
options missing='M';
data HW5p2;
infile "/courses/d452b5e5ba27fe300/HW5p2.txt" firstobs=2;
input xt yt @@; 
if _n_ <= 500 then yt1=yt; * training set;
if _n_ > 500 then yt2=yt;
Run;

/*(b)*/
proc arima data=HW5p2;
identify var=xt nlag=50; 
estimate method=ml;
forecast out= resX back=0 lead=0;
run; 

proc arima data=HW5p2;
identify var=yt1 nlag=50; 
estimate p=1 method=ml; /*final model*/
*estimate q=3 method=ml;
forecast out= resY back=0 lead=20 ;
run; 

/*(c,d)*/
proc arima data=HW5p2;
identify var=yt1 crosscorr=xt nlag=50;
estimate p=1 input=((1,2,3,4,5,6,7,8,9,10,11,12,13,14,15) Xt) method=ml outest= est1;
run;

/*(e)*/
proc transpose data=est1 out=est2;
proc print data=est2;
run;

data ltf;
set est2;
if _n_ <20 and _n_ >3;
Weight=COL1;
LB=-2*COL2;
UB=2*COL2;
Lag=COL4;
keep Weight Lag LB UB;
if _n_ > 4 then Weight=-Weight;
run;

title 'v-Weights plot';
proc sgplot data=ltf;
vbar Lag /response=Weight;
vline Lag /response = LB;
vline Lag /response = UB;
run;

/*(f,g)*/
proc arima data=HW5p2;
identify var=yt1 crosscorr=xt nlag=50;
*estimate input=(3$ /(1) xt) method=ml;
*estimate p=4 q=1 input=(3$ /(1) xt) noint method=ml;
estimate p=1 q=1 input=(3$ /(1) xt) noint method=ml;/*final model*/
forecast out= resRDL back=0 lead=20 ;
run;


/*(h)*/
data res0;
set resX;
r1 = RESIDUAL;
set resRDL;
r2 = RESIDUAL;
keep r1 r2;
run;

title 'Check the CCF between Residuals';
proc arima data=res0;
identify var=r2 cross=(r1);
run;

title 'Refit RDL Model 2,h=1';
proc arima data=HW5p2;
identify var=yt1 crosscorr=xt nlag=50;
estimate p=1 q=1 input=(3 $ (1) /(1) xt) noint method=ml;
forecast out= resRDL2 back=0 lead=20;
run;

data res1;
set resX;
r1 = RESIDUAL;
set resRDL2;
r2 = RESIDUAL;
keep r1 r2;
run;

title 'Check the CCF between Residuals again';
proc arima data=res1;
identify var=r2 cross=(r1);
run;


/*(i)*/
data fore;
set resY;
FY = FORECAST;
LY = L95;
UY = U95;
set resRDL2;
FRDL = FORECAST;
LRDL = L95;
URDL = U95;
set HW5p2;
TrueY = yt;
id = _n_;
keep FY FRDL TrueY id LY UY LRDL URDL;


data fore1;
set fore;
if _n_ >= 495;
run;

title 'Forecast Plot';
proc sgplot data=fore1;
series x=id y=TrueY;
series x=id y=FY;
series x=id y=FRDL;
run;


proc sgplot data=fore1;
band x=id lower=LRDL upper=URDL;
series x=id y=TrueY;
series x=id y=FRDL;
run;


/* P3 */
/*(a)*/
options missing='M';
data HW5p3;
infile "/courses/d452b5e5ba27fe300/HW5p3.txt";
input sales;
id = _n_;
run;

title 'Time Series Plot for Milk Sales';
proc sgplot data=HW5p3;
series x=id y=sales;
run;


/*(b)*/
title 'Created Intervention';
data HW5p3;
set HW5p3;
if id = 63 then x1=1;
else x1=0;
proc print data=HW5p3 (firstobs=60 obs=70);
run;

data extra;
input sales id x1;
cards;
'M' 79 0
'M' 80 0
'M' 81 0
'M' 82 0
'M' 83 0;
run;
title 'Created Extra Five Rows';
proc append base=HW5p3 data=extra;
proc print data=HW5p3 (firstobs=75);
run;

title 'Intervention Analysis';
proc arima data=HW5p3;
identify var=sales cross=x1;
estimate p=1 input = ( (1,2,3,4,5,6,7,8,9,10) x1) method=ml outest=est1;
run;


/*(c)*/
proc transpose data=est1 out=est2;
run;


data ltf;
set est2;
if _n_ > 3;
Weight=COL1;
LB=-2*COL2;
UB=2*COL2;
Lag=COL4;
keep Weight Lag LB UB;
if _n_ > 4 then Weight=-Weight;
run;

title 'v-Weights plot';
proc sgplot data=ltf;
vbar Lag /response=Weight;
vline Lag /response = LB;
vline Lag /response = UB;
run;
* b = 0, r = 1, u = 1, h = 1;

title 'Intervention Analysis';
proc arima data=HW5p3;
identify var=sales cross=x1 noprint nlag=40;
estimate p=(1)(12) q=2 input = ( (1)/(1) x1) method=ml;
forecast back=0 lead=5 out=res;
run;

/*(d)*/
data res;
set res;
set HW5p3;
run;

title 'Forecast Results';
proc sgplot data=res;
band x=id lower=L95 upper=U95;
series x=id y=sales;
series x=id y=forecast;
run;






