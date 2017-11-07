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
	means Time/ tukey;
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
	*means Time/lines tukey;
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
