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
R 28 M 42 39 44 44
R 29 F 37 44 45 38
R 30 F 41 46 46 41
R 31 M 42 47 42 41
R 32 M 44 41 38 37
R 33 F 43 41 44 49
R 34 F 38 45 46 43
R 35 F 42 43 46 39
R 36 M 42 43 41 46
R 37 M 48 42 42 41
R 38 F 40 37 41 41
R 39 M 41 44 43 44
R 40 M 47 42 45 40
C 01 F 59 57 62 65
C 02 F 58 56 49 51
C 03 M 59 66 64 56 
C 04 M 54 54 59 50 
C 05 F 60 57 58 64
C 06 M 62 58 64 58
C 07 F 59 56 58 63
C 08 M 53 51 52 57 
C 09 F 56 59 55 55 
C 10 M 57 64 61 60 
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
