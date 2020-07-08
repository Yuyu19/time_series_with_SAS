/* STA 5856 HW3 */
/* Yuyu Fan */


/* P3 */
data tobacco;
infile "/courses/d452b5e5ba27fe300/HW3p3.dat";
input year tobacco_production;
const=0;
Run;

/*(a)*/
PROC SGPLOT data= tobacco;
SERIES x= year y=tobacco_production;
run;

/*(b)*/
proc transreg data=tobacco; 
model boxcox(tobacco_production)=identity(const);
output out= tobacco_trans;
run;

/*(c)*/
Proc arima data= tobacco_trans;
identify var=Ttobacco_production nlag=40; 
identify var=Ttobacco_production(1) nlag=40; 
estimate q=1 method=ml;
run;



/* P4 */
data retail_sales;
infile "/courses/d452b5e5ba27fe300/HW3p4.dat";
input sales@@;
month= _n_;
const=0;
Run;

/*(a)*/
PROC SGPLOT data= retail_sales;
SERIES x= month y=sales;
run;

/*(b)*/
proc transreg data=retail_sales; 
model boxcox(sales)=identity(const);
output out= retail_trans;
run;

/*(c)*/
Proc arima data= retail_trans;
identify var=Tsales(1) nlag=50 ; 
identify var=Tsales(1,12) nlag=50 ; 
estimate p=(12) q=1 method=ml;
estimate p=(2)(12) q=2 method=ml;
estimate p=(2) q=2 method=ml;
estimate  q=2 method=ml;/*final model*/
run;



/*(d)*/
Proc arima data= retail_trans;
identify var=Tsales(1,12); 
estimate p=(2)(12) q=2 method=ml;
forecast out= foresales;
run;

data foresales;
merge foresales retail_sales;
run;

Proc sgplot data=foresales;
series x=month y=Tsales;
series x=month y=forecast;
run;

/* P5 */
data IOWA;
infile "/courses/d452b5e5ba27fe300/HW3B.txt";
input demands@@;
month= _n_;
const=0;
Run;

PROC SGPLOT data= IOWA;
SERIES x= month y=demands;
run;

proc transreg data=IOWA; 
model boxcox(demands)=identity(const);
output out= IOWA_trans;
run;

Proc arima data= IOWA_trans;
identify var=Tdemands(1) nlag=50 ; 
estimate p=1 q=1 method=ml;
estimate p=(12) q=1 method=ml;/*final model*/
estimate p=(12) q=(12) method=ml;
estimate p=(12) q=(12,24) method=ml;
run;




