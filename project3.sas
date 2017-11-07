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






