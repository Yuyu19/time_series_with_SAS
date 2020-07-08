/* STA 5856 HW2 */
/* Yuyu Fan */

data ARFour;
infile "/courses/d452b5e5ba27fe300/HW2p3.txt";
input x1 x2 x3 x4;
Run;


/*(a)*/
Proc arima data= arfour;
identify var= x1;
identify var= x2;
identify var= x3;
identify var= x4;
run;


/*(c)*/

proc arima data=ARfour; 
identify var=x4; 
estimate p=2 method=ml;
run;



/*(d)*/
proc arima data=ARfour; 
identify var=x4; 
estimate p=2 method=ml noint;
forecast out=res1 back=0 lead=5;
run;

proc arima data=ARfour; 
identify var=x4; 
estimate p=2 method=ml noint;
forecast out=res1 back=3 lead=5;
run;

proc arima data=ARfour; 
identify var=x4; 
estimate p=2 method=ml noint;
forecast out=res1 back=3 lead=10;
run;


proc univariate data=res1 plot normal; 
var residual;
run;











