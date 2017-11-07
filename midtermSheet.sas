/*
>First day notes - 1:108
   -Input data into sas

>sas import data, summaries box plot, univariate  - 108:185

>Convert wide to long, anova test - 185:301

>Import sas dataset (JUST POINT w/ file blue star)  - 301:388
  -reference nameofsetgiven.file !!

>Long to wide, students T test - 388:464

>sql, predicitive analytics - 464:538

>sql join data, alias, regression - 538:610

>sql join data, alias, scatter plots - 610:655

>Project 1 - 655:737

>Project 2 - 737:890

>Project 3 - 890: 


*This program will input data into SAS;
* The "data step" creates a new SAS dataset named cars1;
*http://www.ats.ucla.edu/stat/sas/modules/input.htm;
DATA cars1;
*input tells sas the column/variable names;
*the $ means the preceding variable is a character string;
*Here both mDake and model are strings;
*if no $ then it is numeric;

INPUT make $ model $ mpg weight price;
*the cards or dataLines statement tells SAS where the data begins;
CARDS;

AMC Concord 22 2930 4099
AMC Pacer   17 3350 4749
AMC Spirit  22 2640 3799
Buick Century 20 3250 4816
Buick Electra 15 4080 7827
; *semicolon ends data;

RUN; *run tells sas to run previous lines of code;

title "cars1 data"; *adds title string; 
PROC PRINT DATA=cars1(obs=5); *PROC means procedure such as print statement 
*data = cars1 tells it which dataset to print;
*(obs =5) tells sas to limit the output to the first 5 rows;
RUN; 

*Create a new dataset named amc1;
DATA amc1; *no equal sign;

SET cars1; *subset preexsting data set;
WHERE make = "AMC";
PROC PRINT DATA=amc1; *remember = sign when use PROC;
RUN;

proc summary data = cars1  print; *summary of data set cars1 with print!;
VAR mpg weight; *focus on certain variables;
Run;

*This program will input data into SAS;
* The "data step" creates a new SAS dataset named cars1;
*http://www.ats.ucla.edu/stat/sas/modules/input.htm;
DATA impulse;
*input tells sas the column/variable names;
*the $ means the preceding variable is a character string;
*Here both control vs. repoxin and gender are strings;
*if no $ then it is numeric;

INPUT repoxin$ subjNum gender$ t1 t2 t3 t4; *intialze variables;
*the cards or dataLines statement tells SAS where the data begins;
CARDS;

R 24 F 44 44 48 47
R 25 M 42 44 41 44
R 26 F 34 44 44 47
; *semicolon ends data;

run; *run tells sas to run previous lines of code;

title "Impulse data"; *adds title string; 
PROC PRINT DATA=impulse(obs=5); *PROC means procedure such as print statement 
*data = cars1 tells it which dataset to print;
*(obs =5) tells sas to limit the output to the first 5 rows;


DATA repoxin1; *no equal sign;

SET impulse; *subset preexsting data set;
WHERE repoxin = "R"; *looks for repoxin patients only for subset data;
title"Repoxin positive"; *give table a title for readers;
PROC PRINT DATA= repoxin1 ; *remember = sign when use PROC;


data control; *create a control subset of data;
set impulse; *looks at previous impulse data;
where repoxin = "C"; *focus on control of data set;
title "Control";*gives table a title for reader;
proc print data = control;*prints the subset of data;

data male; *create male subset;
set impulse;*uses original impulse data;
where gender = "M";*looks at males specifically;
title "males";*gives table title;
proc print data= male;*prints subset table;

data female; *create a femal subset of data;
set impulse;*looks at original impulse data;
where gender="F";*focus on females;
title "Females";*gives table title;
proc print data = female;*print femal subset data table;


proc summary data = impulse  print; *summary of data set cars1 with print!;
*VAR repoxin ; *focus on certain variables;
run; *run tells sas to run previous lines of code;
##############################################################################
##############################################################################
IMPORT DATA AND SUMMARIES

*PROC IMPORT reads in files that are not sas datasets;
* OUT = <library.datasetname>;
* DATA = <filename with path;
* DBMS file format, replace means if file is alredy there write over it;
PROC IMPORT OUT= WORK.postal 
            DATAFILE= "C:\Users\livingstonmm\Desktop\Postal.csv" 
            DBMS=CSV REPLACE;
	*is the first row column names;
     GETNAMES=YES;
	 *what is the first row with data;
     DATAROW=2; 
RUN;

*file import data;
*go through progression;
*then "open" the import data file;

*regular summary;
PROC SUMMARY data = postal print;
	VAR time;
run;

*univariate summary;
PROC univariate data = postal; *gives you alot of data output, NO print needed;
	var time;
run;

PROC univariate data = postal; *gives you alot of data output, NO print needed;
	var time;
	HISTOGRAM; *gives you histogram;
run;

*data plot MUST be CLOSED before sorting like always;
proc sort data = postal; *this is the general data;
	by city; *this is what sorting to, second arg;
run;

PROC BOXPLOT data = postal; *have to SORT data before boxplot;
	plot time*city;
run;

data dc;
	set postal;
	where city = "WDC";*string is case sensitive;
run;

*makes a new copy of data set, bad for space;
PROC univariate data = dc; * NO print needed;
	var time;
	histogram;
run;

*Doesn't make another copy of data, which reduces space;
PROC univariate data = postal; *NO print needed;
	var time;
	histogram;
	where city = "WDC";
run;

PROC univariate data = postal; *NO print needed;
	var time;
	histogram;
	by city;
run;

proc summary data = postal print;
	var time;
	by city;
run;
##############################################################################
##############################################################################
*PROC IMPORT reads in files that are not sas datasets;
* OUT = <library.datasetname>;
* DATA = <filename with path;
* DBMS file format, replace means if file is alredy there write over it;

*Change OUT =  AND DATAFILE = path to file;
*this data reads across;
*how to change from wide file to long;
PROC IMPORT OUT= CPK 
            DATAFILE= "C:\Users\livingstonmm\Desktop\CyclerCPK.csv" 
            DBMS=CSV REPLACE;
	*is the first row column names;
     GETNAMES=YES;
	 *what is the first row with data;
     DATAROW=2; 
RUN;

*change cpk into a long file;
data cpk1;
	set cpk;
	CPK = CPK1; *creates a new variable; 
	Time = 1; *creates a new variable with value 1 in every row;
	keep Subject Age Gender TRT Time CPK; *what sections we want to keep in new data set, may take acouple iterations;

run;

data cpk2;
	set cpk;
	CPK = CPK2; *creates a new variable; 
	Time = 2; *creates a new variable with value 1 in every row;
	keep Subject Age Gender TRT Time CPK; *what sections we want to keep in new data set, may take acouple iterations;

run;

data cpk3;
	set cpk;
	CPK = CPK3; *creates a new variable; 
	Time = 3; *creates a new variable with value 1 in every row;
	keep Subject Age Gender TRT Time CPK; *what sections we want to keep in new data set, may take acouple iterations;

run;

data cpk4;
	set cpk;
	CPK = CPK4; *creates a new variable; 
	Time = 4; *creates a new variable with value 1 in every row;
	keep Subject Age Gender TRT Time CPK; *what sections we want to keep in new data set, may take acouple iterations;

run;

*creating long file;
data cpkLong;
	set cpk1 cpk2 cpk3 cpk4; *it will stack on IFONLY have same column name;
	run;

proc boxplot data = cpkLong; *dont have to sort data, but usually have to;
	plot cpk*time; *variables againts each other;
run; 

proc sort data = cpkLong;
	by trt;
run;

proc boxplot data= cpkLong;
	plot cpk*trt;
run;

*ANOVA = Analysis of variance;
*numeric outcome;
*categorical groups;
*the goal is to determine if there are differences in the;
*population means across the groups;

*mu1 = population mean for group1;
*mu2 = pop mean for group2;
*mu3= pop mean for group3;
*mu4= pop mean for group4;

*hypothesis:
*H0 (null hyp): mu1 = mu2= mu3=mu4;
*HA: at least two pop means differ;

*this is a test which is about the data, summary is about population;
proc glm data = cpkLong;
	*glm = general linear model;
	class trt; *catergorical variable;
	model CPK = trt;
run;
quit; *quits b/c glm runs in backround (source of problems cause cant edit data when open;

*p-value is what peopl are affter;
*p-value = measure of how rare or common your data is;
*if the data was found by random chance;
*if p-value is small then either we have freak data
*or the null hypothesis is FALSE;

*a common rule is "if p-value < alpha then reject HO";

*alpha = signficance level;
*alpha = how often we are willing to be wrong;
*typical value alpha =0.05..OFF LIMITS!  NO;
*depends on study, pilot...;

*So far...
*ANOVA tells us "if" a difference exists;
*if a difference exists which groups differ?;

proc glm data = cpkLong;
	*glm = general linear model;
	class trt; *catergorical variable;
	model CPK = trt;
	means trt /lines tukey; *change alpha = 0.05, google how to;
run;
quit;
##############################################################################
##############################################################################

*Bring a sas data set into SAS:;
*dont have to import, have to point at its directory;

libname bat 'C:\Users\livingstonmm\Desktop'; *identifies specific data set;

proc sort data = bat.battery1; *must sort data before create box plot;
	by item; *sort by second variable;
run;

proc boxplot data = bat.battery1; *references to library, specific syntax;
	plot amount*item;
run; 

proc glm data = bat.battery1;
	class item;
	model amount =item;
run;
quit;

data battery2;
	set bat.battery1;
	wkday = weekday(date);
run;

proc sort data = battery2; *must sort data before create box plot;
	by wkday; *sort by second variable;
run;

*p-value result = 0.0032, rare data;
proc glm data = battery2; *sort;
	class wkday;
	model amount =wkday;
	means wkday tukey; <<<multiple comparisons (TUKEY)
run;
quit;

data bat.battery; *not in work, in desktop;
	SET battery2;
run;

*<<switching topic ######;

*Now switching to sydhob.txt data file;
PROC IMPORT OUT= WORK.Boat 
            DATAFILE= "C:\Users\livingstonmm\Desktop\sydhob.txt" 
            DBMS= tab REPLACE;
	*is the first row column names;
     GETNAMES=YES;
	 *what is the first row with data;
     DATAROW=2; 
RUN;

*look at direction, shape, strength;

TITLE 'Scatterplot - Boat data';
PROC GPLOT DATA=Boat;
     PLOT time*year;
RUN; 
quit;

*R^2 = porportion of the variance y by x;
*The equation of the line of "best fit" is..;
*time =144708-70.59413*year;

*The intercept of 144708 can be interpreted as;
*in the year 0 if the race were run we would expect it to take 144708 minutes;
*doesnt make sense, b/c of extrapolation is predicting outside the bounds of data;

*the slope = each year inc. we expect the race to take 70.59413 minutes less (negative);
*how good is the line?;
proc reg data =boat;
	model time = year;
run;
quit;
##############################################################################
##############################################################################
>Long to wide, students T test - 388:464

*uses testing1.csv data set
*first we want change long dataset into wide;
PROC IMPORT OUT= WORK.testing
            DATAFILE= "C:\Users\livingstonmm\Desktop\testing1.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

*create seperate data sets for each column;
data test1;
	set testing;
	test1 = score;
	where test = 1; *collect test 1 data;
run;

data test2;
	set testing;
	test2 = score;
	where test = 2; *collect test 1 data;
run;

data test3;
	set testing;
	test3 = score;
	if test = 3; *can use if = where;
run;

proc sort data = test1;
	by student;
proc sort data = test2;
	by student;
proc sort data = test3;
	by student;
run;

DATA testWide; *have to sort data before;
  MERGE test1 test2 test3; 
  BY Student; 
  drop test score;
  *can also use keep;
RUN; 

*super usefull to see changes in scores;
data changeWide;
	set testWide;
	change12 = test2-test1;
	change13 = test3 -test1;
	change23 = test3 - test2;
run;

*Use info to do hypothesis test;
*specifically a "paired t test";
proc univariate data=  changeWide;
	var change12;
	histogram;
run;

*H0: mu0 =0;
*HA: mu0 !=0;
*mu0 = 0 means no change;
*This means the intervention between time 1 and time 2 had no effect;

*look at: Test for location mu0=0;
*This gives 3 tests, Student's t is most popular and requires assumptions;
*                                      -normality (probmatically), if symmetric n>15, havily skewed n>40;

*sign test and signed rank test are also given (non-parametric test, no assumptions);

*dont test normality;

proc univariate data=changeWide normal;
	qqplot;
run;

proc sort data = testing;
	by Student;
run;

*elegent way to transform to wide;
proc transpose data=testing out=testingOut prefix=test;
    by student;
    id test;
    var score;
run;
##############################################################################
##############################################################################
*to "import sas file type click on file with blue star;
*using battery1 data set
we are shfting gears into SQL;

*SQL= structured query language
pull data with sql and do something with data with sas;
*sql language is similar to speaking;

*seperate select by comma different from sas;
*no semi colon after select var;
*"AS" shows up a lot;
proc sql;
	create table battery2 AS
	select store, item  
	from batman.battery1;
quit;

*what if want to creat SUMMARY?;
*as can create var;
proc sql;
	select store, item, sum(amount) as SumOfAmount
	from batman.battery1
	group by store, item; 
quit;

proc sql;
	create table battery3 as 
	select store, item, sum(amount) as SumOfAmount
	from batman.battery1
	group by store, item; 
quit;


*proc sql;
*	create table battery3 as 
        *>>>>>variables below must show up in the group by statement;
*	select store, item, sum(amount) as SumOfAmount
*	from batman.battery1
*	group by store, item; 
*quit;

*whatever is before the first summary must be in the group by statemnt;

*adding OTHER USEFUL summaries;
proc sql;
	create table battery4 as 
	select store, item, 
		sum(amount) as SumOfAmount,
		mean(amount) as MeanAmount,
		count(amount) as nCount,
		std(amount) as StDev
	from batman.battery1
	group by store, item; 
quit;

*generate confidence interval on hte mean amount sold;
*statement about meann;
data CI;
	set battery4;
	LB = MeanAmount-1.96*StDev/sqrt(nCount); *lowerbound;
	UB = MeanAmount+1.96*StDev/sqrt(nCount);*upperbound;
run;

*>>>predictive interval;
data CI;
	set battery4;
	*LB = MeanAmount-1.96*StDev*sqrt(1 + 1/nCount); *lowerbound, not worrying about selling least amount;
	UB = MeanAmount+1.96*StDev*sqrt(1 + 1/nCount);*upperbound;
	stock = CEIL(UB);
run;
##############################################################################
##############################################################################
*Code uses 
batterySpace.xls
storeTraffic.xls
storeSize.csv;

*attaching files or joining data;

*hardest thing, just think ahead lol;

*try to put storeTraffic and storeSize in same table;

proc sql;
	create table TrafficTotal as
	select store, sum(Traffic) as sumOfTraffic
	from Storetraffic
	group by store;
*start alias in sas, make table with store, sqft, traffic;
	select a.store, a.sqft, b.sumOfTraffic
	from StoreSize as a, TrafficTotal as b
	where a.store = b.store; 


quit;


proc sql;
	create table TrafficTotal as
	select store, sum(Traffic) as sumOfTraffic
	from Storetraffic
	group by store;


*>>>start alias in sas, make table with store, sqft, traffic;
	select a.store, a.sqft, b.sumOfTraffic

	from StoreSize as a, TrafficTotal as b
               |||||||||       ||||||||
	where a.store       =    b.store; 
 >>join

quit;

sql is used for rational database <<<
   - as set of tables that cen be connected via joins.;

*relate space to amount;
*need store, item, space, total amount;

proc sql;
	create table BatteryTotal as
	select store, item, sum(amount) as sumOfAmount
	from bunny.battery1
	group by store, item;
 *   ^^put everything from select BEFORE add/sum fucniton ;
create table batterySpace as
	select a.store, a.sqft, a.sumOfAmount, b.space
	from batterytotal  as a, batteryspace as b
	where a.store = b.store
	AND a.item = b.item;
quit;


proc reg data = batterySpace;
	model  sumOfAmount= batteryspace; *outcome; dependent= independent 
run;

proc sgplot data=sashelp.class;
   title "Regression Line with Slope and Intercept";
   reg y=weight x=height;

##############################################################################
##############################################################################

*Goal is to find the total profit each day for batteries

1st get the profit for each battery;

data batteryProfit;
	set batterymoney1;
	profit = price -cost;
run;

*combine data sets using SQL;
*join (where, and statements) on midterm;
proc sql;
	create table BatteryProfit2 as 
	select store, item, price - cost as profit
	from batterymoney1;

	create table combined as 
	select a.store, b.item, a.date, a.amount, b.profit
	from bat1.battery1 as a , BatteryProfit2 as b
	where a.store = b.store
	and a.item = b.item;

	create table combined2 as 
	select date, amount*profit as itemProfit
	from combined;

	create table combined 3 as 
	select date, sum(itemProfit) as totalProfit
	from combined2
	group by date;
quit; 

*get a picture from data made above;

proc sgplot data = combined3;
	title "total profit by day";
	series x = date y = totalProfit;
	yaxis label = "profit in dollars";
	xaxis label = "Time (days)";
run;
quit;
##############################################################################
##############################################################################
>>PROJECT 1

*This program will input data into SAS;
* The "data step" creates a new SAS dataset named cars1;
*http://www.ats.ucla.edu/stat/sas/modules/input.htm;
DATA impulse;
*input tells sas the column/variable names;
*the $ means the preceding variable is a character string;
*Here both mDake and model are strings;
*if no $ then it is numeric;

INPUT repoxin$ subjNum gender$ t1 t2 t3 t4; *intialize variables;
*the cards or dataLines statement tells SAS where the data begins;
CARDS;


R 24 F 44 44 48 47
R 25 M 42 44 41 44
R 26 F 34 44 44 47
R 27 M 45 42 35 44

; *semicolon ends data;

RUN; *run tells sas to run previous lines of code;

title "Impulse data"; *adds title string; 
PROC PRINT DATA=impulse(obs=5); *PROC means procedure such as print statement 

*Create a new dataset named repoxin1;
DATA repoxin1; *no equal sign;

SET impulse; *subset preexsting data set;
WHERE repoxin = "R"; *looks for repoxin patients only for subset data;
title "Repoxodin data"; *give data table title;
PROC PRINT DATA= repoxin1 ; *remember = sign when use PROC;
*RUN;

data control; *create a control subset of data;
set impulse; *looks at previous impulse data;
where repoxin = "C"; *focus on control of data set;
title "Control";*gives table a title for reader;
proc print data = control;*prints the subset of data;

data male; *create male subset;
set impulse;*uses original impulse data;
where gender = "M";*looks at males specifically;
title "males";*gives table title;
proc print data= male;*prints subset table;

data female; *create a femal subset of data;
set impulse;*looks at original impulse data;
where gender="F";*focus on females;
title "Females";*gives table title;
proc print data = female;*print femal subset data table;


proc summary data = impulse  print; *summary of data set cars1 with print!;
title "impulse summary"; *title;
VAR   subjNum t1 t2 t3 t4; *focus on certain variables, --> cannont use string variables!;

proc summary data = male print; *create summary of male subset;
title "Male summary"; *tiltle;
var subjNum t1 t2 t3 t4; *focus on certain variables, --> cannont use string variables!;


proc summary data = female print; *create summary for females ;
title "Female summary"; *title;
var subjNum t1 t2 t3 t4; *focus on certain variables, --> cannont use string variables!;

proc summary data=control print; *create summary for control data;
title"Control summary"; *title;
var subjNum t1 t2 t3 t4; *focus on certain variables, --> cannont use string variables!;

proc summary data=repoxin1 print; *create summary repoxodin postitive;
title "Repoxodin positive summary"; *title;
var subjNum t1 t2 t3 t4; *focus on certain variables, --> cannont use string variables!;

run; *run previous code above;
##############################################################################
##############################################################################
PROJECT 2

PROC IMPORT OUT= WORK.burst 
            DATAFILE= "C:\Users\Debbie\Desktop\SAS\Burst.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

data burst1;
	set burst;
	ev = Ev1; *creates a new variable; 
	Time = 1; *creates a new variable with value 1 in every row;
	keep Subject Treatment ev Time; *what sections we want to keep in new data set, may take acouple iterations;

run;

data burst2;
	set burst;
	ev = Ev2; *creates a new variable; 
	Time = 2; *creates a new variable with value 1 in every row;
	keep Subject Treatment ev Time; *what sections we want to keep in new data set, may take acouple iterations;

run;

data burst3;
	set burst;
	ev = Ev3; *creates a new variable; 
	Time = 3; *creates a new variable with value 1 in every row;
	keep Subject Treatment ev Time; *what sections we want to keep in new data set, may take acouple iterations;

run;

data burst4;
	set burst;
	ev = Ev4; *creates a new variable; 
	Time = 4; *creates a new variable with value 1 in every row;
	keep Subject Treatment ev Time; *what sections we want to keep in new data set, may take acouple iterations;

run;

data burst5;
	set burst;
	ev = Ev5; *creates a new variable; 
	Time = 5; *creates a new variable with value 1 in every row;
	keep Subject Treatment ev Time; *what sections we want to keep in new data set, may take acouple iterations;

run;

*creates long file of events stacked on top of each other;
data burstLong;
	set burst1 burst2 burst3 burst4 burst5; *it will stack on IFONLY have same column name;
run;


*CHANGE SIGNIFCANCE LEVEL to something  |= 0.05;
proc glm ALPHA = 0.1 data = burstLong;
	*glm = general linear model;
    
	class Time; *numeric measurements;
	model ev = Time ;
	*means ev/lines tukey;
run;
quit; *quits b/c glm runs in backround (source of problems cause cant edit data when open;

proc sort data = burstLong;
	by ev;
run;

proc sort data = burstLong;
	by Time;
run;

proc boxplot data = burstLong;
	plot ev*Time;
run;


*
I transformed the data into a long file with Event measurements stacked 
in one column.

I then performed a general linear model test (similar to ANOVA) on the Event measuremnts 
over time (the event numbers) to see if theres variance across the various 
events

This test produced a P-value <.0001
This means that we have unique data.
The graph produced shows theres varaiance in Ev3 comparedt to rest
this is confrimed by the box plot as well
;

proc glm ALPHA = 0.1 data = burstLong;
	class Treatment; *catergorical variable;
	model ev = Treatment;
	*means Treatment/ tukey;
run;
quit; 

proc boxplot data = burstLong;
	plot ev*Treatment;
run;


*This test produced a P-value <.0001
This means that we have unique data.
The boxplot produced shows that the control has a lower event reaction measurment compared to tthe treatements
this may show that the treatements are or are not working depending on the situation
;

*start to break up long file into seperate columns to reformat to wide file;
data burst_1;
	set burstLong;
	Control = ev; *store the event response into a variable which can be displayed and so we dont loose any info;
	if Treatment = 'Control'; *search for control;
run;

data burst_2;
	set burstLong;
	SRX1 = ev;
	if Treatment = 'SRX1';
run;

data burst_3;
	set burstLong;
	SRX2 = ev;
	if Treatment = 'SRX2';
run;

data burst_4;
	set burstLong;
	SRX3 = ev;
	if Treatment = 'SRX3';
run;

*sort all data frames by treatement;
proc sort data = burst_1;
	by Treatment;
proc sort data = burst_2;
	by Treatment;
proc sort data = burst_3;
	by Treatment;
proc sort data = burst_4;
	by Treatment;

*merge all the data sets to make a wide file;
DATA testWide; *have to sort data before;
  MERGE burst_1 burst_2 burst_3 burst_4; 
  BY Treatment; 
  keep Subject Control SRX1 SRX2 SRX3;
RUN; 

##############################################################################
##############################################################################

/*
*CHANGE location of file!!!!!!!;
PROC IMPORT OUT= WORK.managers 
            DATAFILE= "C:\Users\Debbie\Desktop\SAS\ManagerStore.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= WORK.sales 
            DATAFILE= "C:\Users\Debbie\Desktop\SAS\StoreSales.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
*/
*import data from specificied location;
PROC IMPORT OUT= WORK.managers 
            DATAFILE= "C:\TempData\ManagerStore.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= WORK.sales 
            DATAFILE= "C:\TempData\StoreSales.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

*1. Create a scatterplot of revenue against month with correct 
titles for all the data;

*use sql to create tables to make graphical representations;
proc sql;
	create table revenue as
	select month, revenue 
	from sales 
	group by month;

	create table storeRevenue as
	select store, month, revenue 
	from sales
	group by store;

	
quit;
run; 


*plot shows increase in revenue towards the end of the year;
proc gplot data = revenue;
 	title "Revenue againts month for all data";
	plot revenue*month;
	*yaxis label = "Revenue (Dollars)";
	*xaxis label = "Time (month)";

run; 

proc gplot data = storeRevenue;
 	title "Revenue againts month for stores";
	plot revenue*store;
	
run; 

*looks like NM0331 has largest revenue over month consistnely ;
proc sgscatter data = storeRevenue;
 	title "Revenue againts month for stores";
	plot revenue*month/
	group = store; 
	
run; 
quit;

 *Create a wide dataset with each row corresponding to a manager and the remaining columns are the monthly revenue values;

*Create a wide dataset that has one row containing the mean revenue for each month as the columns;

data revenue1;
	set sales;
	month1 = revenue;
	where month =1;
run;

data revenue2;
	set sales;
	month2 = revenue;
	where month =2;
run;

data revenue3;
	set sales;
	month3 = revenue;
	where month =3;
run;
data revenue4;
	set sales;
	month4 = revenue;
	where month =4;
run;
data revenue5;
	set sales;
	month5 = revenue;
	where month =5;
run;
data revenue6;
	set sales;
	month6 = revenue;
	where month =6;
run;
data revenue7;
	set sales;
	month7 = revenue;
	where month =7;
run;
data revenue8;
	set sales;
	month8 = revenue;
	where month =8;
run;
data revenue9;
	set sales;
	month9 = revenue;
	where month =9;
run;
data revenue10;
	set sales;
	month10 = revenue;
	where month =10;
run;
data revenue11;
	set sales;
	month11 = revenue;
	where month =11;
run;
data revenue12;
	set sales;
	month12 = revenue;
	where month =12;
run;

proc sort data =revenue1;
	by store;
run;
proc sort data =revenue2;
	by store;
run;
proc sort data =revenue3;
	by store;
run;
proc sort data =revenue4;
	by store;
run;
proc sort data =revenue5;
	by store;
run;
proc sort data =revenue6;
	by store;
run;
proc sort data =revenue7;
	by store;
run;
proc sort data =revenue8;
	by store;
run;
proc sort data =revenue9;
	by store;
run;
proc sort data =revenue10;
	by store;
run;
proc sort data =revenue11;
	by store;
run;
proc sort data =revenue12;
	by store;
run;
proc sort data =managers;
	by store;
run;

*invalid/missig data for month4 with manager #33495. 
In order to fix would have to input data or use sas to iterate and look for null data;
data wideRevenue;
	merge managers revenue1 revenue2 revenue3
	revenue4 revenue5 revenue6 revenue7
	revenue8 revenue9 revenue10 revenue11
	revenue12;
	by store;
	drop store month revenue;

run;

*Create a wide dataset that has one row containing the mean revenue for each month as the columns;


*http://stackoverflow.com/questions/21786945/how-to-find-the-mean-value-of-columns-in-sas;
proc means data=widerevenue noprint nway;
  var month1 month2 month3 month4 month5 month6 month7 month8
   month9 month10 month11 month12;
  output 
    out= monthRevenue(drop = _TYPE_ _FREQ_) 
    mean= month1 month2 month3 month4 month5 month6 month7 month8
   month9 month10 month11 month12;
   	
run;


/*

proc univariate data=Measures;
   var Length Width;
   qqplot;

*/










