/********************************************
Purpose:  2 case study of ischemic stroke/ischemic heart disease (see description)
DATA SETS: tmp1.h_nhi_enrol*, tmp1.h_nhi_opdte*, tmp1.h_nhi_ipdte*, h_nhi_ipdte*, h_ost_death*, H_nhi_medfa*, and merged datasets
PROGRAMMER: Gloria Xiang 
********************************************/

/*****Case 1*****/
/*define age>=65*/
proc sort data=tmp1.h_nhi_enrol19 out=enrol19 nodupkey;
by id; run;
data age65; set enrol19;
birthyear=substr(ID_BIRTH_YM,1,4)*1;
age=2019-birthyear; 
if age>=65; /* age>=65*/
keep ID ID_s age;
if ID_S=9 then delete;
run;
/**********************OPD*****************************/ 
/*sort data by ID*/ 
data opdte19; set tmp1.h_nhi_opdte19;
keep ID func_type func_date icd9cm_1 icd9cm_2  icd9cm_3;
run;

proc sort data=opdte19; by ID; run;
data opd;
merge age65(in=A) opdte19;
by id; if A=1;
run;

/* filter Congestive heart failure */
data CHF_1; set opd;
if substr( icd9cm_1,1,3) in ('398', '402' , '404' , '425' , '428') or
substr( icd9cm_2,1,3) in ('398','402' , '404',  '425' ,'428') or
substr( icd9cm_3,1,3) in ('398' ,'402',  '404'  '425', '428') ; run;

proc sort data=CHF_1 out=CHF_2 nodupkey;
by  ID func_type func_date;
run;

/*count the number of CHF*/
data CHF_3; set chf_2;
by id; 
if first.ID then count=0;
count+1; 
if last.ID;
keep ID count;
run;

data chf_4; set chf_3;
if count>=2 then chf_opd=1; /*more than two counts of diagnosis*/
if chf_opd=1; drop count;
run;

/*hypertension*/
data htn1;
set opd;
if substr( icd9cm_1,1,3) in ('401',  '402', '403', '404', '405') or
substr( icd9cm_2,1,3) in ('401',  '402', '403', '404', '405') or
substr( icd9cm_3,1,3) in ('401',  '402', '403', '404', '405') ; run;


proc sort data=htn1 out=htn2 nodupkey;
by  ID func_type func_date;
run;

/*count number of hypertension*/
data htn3; set htn2;
by id; 
if first.ID then count=0;
count+1; 
if last.ID;
keep ID count;
run;

data htn_4; set htn3;
if count>=2 then htn_opd=1; /*more than two counts of diagnosis*/
if htn_opd=1; drop count;
run;


/*diabetes*/
data dm1;
set opd;
if substr( icd9cm_1,1,3) in ('250') or
substr( icd9cm_2,1,3) in ('250') or
substr( icd9cm_3,1,3) in ('250') ; 
run;

proc sort data=dm1 out=dm2 nodupkey;
by  ID func_type func_date;
run;

/*count number of diabetes*/
data dm3; set dm2;
by id; 
if first.ID then count=0;
count+1; 
if last.ID;
keep ID count;
run;

data dm_4; set dm3;
if count>=2 then dm_opd=1;  /*more than two counts of diagnosis*/
/*if dm_opd=1; drop count;*/
run;


/*stroke*/
data stroke1;
set opd;
if substr( icd9cm_1,1,3) in ('433' , '434', '435', '436', '437') or
substr( icd9cm_2,1,3) in ('433' , '434', '435', '436', '437') or
substr( icd9cm_3,1,3) in ('433' , '434', '435', '436', '437') ; run;


proc sort data=stroke1 out=stroke2 nodupkey;
by  ID func_type func_date;
run;

/*count number of stroke*/
data stroke3; set stroke2;
by id; 
if first.ID then count=0;
count+1; 
if last.ID;
keep ID count;
run;

data stroke_4; set stroke3;
if count>=2 then stroke_opd=1;  /*more than two counts of diagnosis*/
/*if stroke_opd=1; drop count;*/
run;



/**************************IPD**************************/
data ipdte19; set tmp1.h_nhi_ipdte19;
keep ID icd9cm_1 icd9cm_2  icd9cm_3 icd9cm_4 icd9cm_5;
run;

proc sort data=ipdte19; by ID; run;
data ipd;
merge age65(in=A) ipdte19;
by id; if A=1;
run;

/*CHF*/
data CHF_a; set ipd;
if substr( icd9cm_1,1,3) in ('398', '402' , '404',  '425' ,'428') or 
substr( icd9cm_2,1,3) in ('398' ,'402' , '404',  '425', '428') or
substr( icd9cm_3,1,3) in ('398', '402' , '404' , '425', '428') or
substr( icd9cm_4,1,3) in ('398' ,'402',  '404' , '425' ,'428') or
substr( icd9cm_5,1,3) in ('398' ,'402' , '404',  '425' ,'428') ; run;

proc sort data=CHF_a out=CHF_b nodupkey;
by  ID;
run;

data CHF_c; set chf_b;
chf_ipd=1;
keep chf_ipd id;
run;

/*hypertension*/
data htn_a; set ipd;
if substr( icd9cm_1,1,3) in ('401' , '402', '403', '404', '405') or 
substr( icd9cm_2,1,3) in '401' , '402', '403', '404', '405') or
substr( icd9cm_3,1,3) in ('401' , '402', '403', '404', '405') or
substr( icd9cm_4,1,3) in ('401' , '402', '403', '404', '405') or
substr( icd9cm_5,1,3) in ('401' , '402', '403', '404', '405') ; run;

proc sort data=htn_a out=htn_b nodupkey;
by  ID;
run;

data htn_c; set htn_b;
htn_ipd=1;
keep htn_ipd id;
run;

/*diabetes*/
data dma; set ipd;
if substr( icd9cm_1,1,3) in ('250') or 
substr( icd9cm_2,1,3) in ('250') or
substr( icd9cm_3,1,3) in ('250') or
substr( icd9cm_4,1,3) in ('250') or
substr( icd9cm_5,1,3) in ('250') ; 
run;

proc sort data=dma out=dmb nodupkey;
by  ID;
run;

data dm_c; set dmb;
dm_ipd=1;
keep dm_ipd id;
run;

/*stroke*/
data strokea; set ipd;
if substr( icd9cm_1,1,3) in ('433' , '434', '435', '436', '437') or 
substr( icd9cm_2,1,3) in ('433' , '434', '435', '436', '437') or
substr( icd9cm_3,1,3) in ('433' , '434', '435', '436', '437') or
substr( icd9cm_4,1,3) in ('433' , '434', '435', '436', '437') or
substr( icd9cm_5,1,3) in ('433' , '434', '435', '436', '437') ; run;

proc sort data= strokea out= strokeb nodupkey;
by  ID;
run;

data  stroke_c; set  strokeb;
 stroke_ipd=1;
keep  stroke_ipd id;
run;

/*****************link IPD and opd**********/
data chf; 
merge chf_4 chf_c;
by id;
chf=1;
run;

data htn; 
merge htn_4 htn_c;
by id;
htn=1;
run;

data dm; 
merge dm_4 dm_c;
by id;
dm=1;
run;

data stroke; 
merge stroke_4 stroke_c;
by id;
stroke=1;
run;

data total_1;
merge age65 chf  htn dm stroke;
by id;
run;

data total_2; set total_1;
if chf=. then chf=0;
if htn=. then htn=0;
if dm=. then dm=0;
if stroke=. then stroke=0;
keep ID ID_S age chf htn dm stroke;
run;

data total_3; set total_2; /*final dataset*/
if age>75 then age75=1;
else age75=0;
CHADS=age75+CHF+htn+dm+stroke*2;
run;

/**********statistical test : chi square ***********/
proc freq data=total_3;
table chf*dm/chisq;
run;

proc freq data=total_3;
table htn*dm/chisq;
run;

proc freq data=total_3;
table stroke*dm/chisq;
run;

/*age*/
proc univariate data= total_3 plot normal;
var age;
class dm;
run;

proc npar1way data= total_3 wilcoxon;
var age;
class dm;
run;

/*test CHADS score among dm patients*/
proc univariate data= total_3 plot normal;
var CHADS;
class dm;
run;

proc npar1way data= total_3 wilcoxon;
var CHADS;
class dm;
run;

/*****Case 2*****/
%Macro case_2;

/*sort hospital type*/
%Do i=16 %to 19;
data ipdte&i.;
set tmp1.H_nhi_ipdte&i;
proc sort;
by hosp_id;
run;

/*filter hospital type*/
data medfa&i.;
set  tmp1.H_nhi_medfa&i.; 
Keep Hosp_ID Hosp_Cont_Type Type_E_date;
Proc sort;
By Hosp_ID Type_E_date;
run;

data medfa&i._2;
set medfa&i.;
by hosp_id;
if last.hosp_id;
run;
/*merge inpatient data and medfa by hosp_ID*/
data ipdte&i._2;
merge ipdte&i. (in=x) medfa&i._2 (in=y);
by hosp_id; if x=1;

/*death data only keeps ID and death date*/
Data Death&i.;
 Set NHI.h_ost_death&i.;
 Keep ID D_Date;
 run;
%End;

/*keep no duplicate death*/
Data Death_all;
 Set
 %Do i=16 %to 19;
 Death&i.
 %End;
 Proc sort nodupkey;
 by id;
 run;

/*sort inpatient data*/
Data ipdte_all;
 Set
 %Do i=16 %to 19;
 ipdte&i._2
 %End;
;
 Proc sort;
 by id;
 run;

/*merge inpatient and death data*/
Data ipdte_death;
Format Age 3.0;
Merge ipdte_all(in=x) Death_all;
By id;
If x=1;
If substr(In_date,1,4) in ('2016'  '2017' '2018' '2019');
If substr(out_date,1,4) in ('2016'  '2017' '2018' '2019');
IF ID_S in ('1', '2');
if Hosp_Cont_Type in ('1', '2', '3');
Age=Substr(In_Date,1,4)- Substr(Birth_YM,1,4);
If substr(ICD9CM_1,1,3) in ('410' , '411' , '412' , '413' , '414');

/*define hypertension and diabetes*/
Array ICD$9CM_2-ICD9CM_5;
Do over ICD;
if substr(ICD,1,3) in ('410' , '411' , '412' , '413' , '414') then ht='1'; /*ht=hypertension*/ 
End;
do over ICD;
if substr(ICD,1,3) in ('250') then dm='1';
end;
if ht=. then ht=0;
if dm=. then dm=0;

/*define death due to ischemic heart disease*/
If (MDY(Substr(D_Date,5,2), Substr(D_Date,7,2),
Substr(D_Date,1,4)) <=
(MDY(Substr(Out_Date, 5,2), Substr(Out_Date, 7,2),
Substr(Out_Date, 1,4)) + 3) ) and
(MDY(Substr(D_Date, 5,2), Substr(D_Date, 7,2),
Substr(D_Date, 1,4)) >= MDY(Substr(In_Date, 5,2),
Substr(In_Date,7,2),Substr(In_Date, 1,4)) )
then Death=1;
Else Death=0;

/*logistic model calculate OR of death among with/without ht*/

Proc Logistic;
Class ID_S (ref='2') HT(ref='0') DM(ref='0')
Hosp_Cont_type (ref='3') /param=ref;
Model Death (event='1')=ID_S Age HT DM  
Hosp_Cont_Type; /*adjust variables*/
run;

%MEnd;
%case_2;
quit;

