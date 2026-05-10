*******************************************************************
* Name:   Cadet Connor Durand       						            
* Date: 
* Purpose: Emperical Course Project: Caffeine on BMI
*******************************************************************

*** This next line is the path to this .do file, you can cut and paste this path into stata to run the .do file

* do c:\ss368\do\filename.do

**Set Globals**
global root "C:\ss368"
global do "$root\do"
global dta "$root\dta"
global log "$root\log"
global output "$root\output"

********************************
* Standard Stata Configuration
********************************
clear all
set more off
cap log close
clear 


log using "C:\ss368\log\filename.log", replace

use "C:\ss368\dta\BMX_L.dta", clear

** can now type $dta\namedata.dta, clear 

merge 1:1 SEQN using "C:\ss368\dta\SMQ_L.dta"
drop _merge

merge 1:1 SEQN using "C:\ss368\dta\DEMO_L.dta"
drop _merge

merge 1:m SEQN using "C:\ss368\dta\DR1IFF_L.dta"
drop _merge


save "C:\ss368\dta\merged.dta", replace


keep SEQN BMXBMI SMQ020 RIAGENDR DMDEDUC2 DR1IFDCD DMQMILIZ RIDRETH3 RIDAGEYR DMDMARTZ WTINT2YR WTMEC2YR 


*************************
* Prepare the variables *
*************************
gen finalweight=WTINT2YR*WTMEC2YR

*If HS grad or less, DMDEDUC2=0
gen HSorLess= DMDEDUC2<=3 

*If refused to answer , DMDEDUC2=null
gen MissingEducation= DMDEDUC2>=7

*If Some college or more, DMDEDUC2=1
gen somecollege= inrange(DMDEDUC2,4,5)

*If Male, RIAGENDR=1,female=0
gen female=  RIAGENDR==2


*If Smoker, 1, nonsmoker=2, refused/dont know=null
gen smoker=. 
replace smoker=1 if SMQ020==1
replace smoker=0 if SMQ020==2

*If Military, 1, Nonmilatary=2, refused/dont know=null
gen military=.
replace military=1 if DMQMILIZ==1
replace military=0 if DMQMILIZ==2


*If energy drink drinker=1, 0 if not
gen energydrink= inlist(DR1IFDCD, 95310200, 95310400, 95310500, 95310550, 95310555, 95310560, 95310600, 95310700, 95310750, 95310800, 95311000, 95312400, 95312410, 95312500, 95312550, 95312E555, 95312560, 95312600, 95312700, 95312800, 95312900, 95312905, 95313200)


*Hispanic= Mex American plus other hispanic
gen hispanic =RIDRETH3==inrange(RIDRETH3,1,2)

gen white =RIDRETH3==3
gen black =RIDRETH3==4
gen asian =RIDRETH3==6
gen other_race=RIDRETH3==7


summarize RIDAGEYR
*Age*
gen age=RIDAGEYR if inrange(RIDAGEYR,18,64)
drop if (RIDAGEYR<18)
drop if (RIDAGEYR>64)

*Maritial Status
gen married =DMDMARTZ==1
gen formerly_married =DMDMARTZ==2
gen never_married =DMDMARTZ==3
gen married_missing =DMDMARTZ>3


drop if missing(BMXBMI)

collapse (max) MissingEducation somecollege smoker HSorLess military hispanic white black asian other_race age married formerly_married never_married married_missing flag_energydrinks1=energydrink male WTINT2YR WTMEC2YR finalweight (mean) BMXBMI (sum) num_energydrinks1=energydrink, by(SEQN)
 

merge 1:m SEQN using "C:\ss368\dta\DR2IFF_L.dta"
drop _merge

keep SEQN-num_energydrinks1 DR2IFDCD 


gen energydrinks2 = inlist(DR2IFDCD, 95310200, 95310400, 95310500, 95310550, 95310555, 95310560, 95310600, 95310700, 95310750, 95310800, 95311000, 95312400, 95312410, 95312500, 95312550, 95312E555, 95312560, 95312600, 95312700, 95312800, 95312900, 95312905, 95313200)


collapse (max) age MissingEducation somecollege smoker HSorLess military hispanic white black asian other_race  married formerly_married never_married married_missing  flag_energydrinks1 male flag_energydrinks2=energydrinks2 WTINT2YR WTMEC2YR finalweight (mean) BMXBMI (sum)num_energydrinks1 num_energydrinks2=energydrinks2, by(SEQN)

gen num_energydrinks=num_energydrinks1+num_energydrinks2
egen flag_energydrinks=rowmax(flag_energydrinks1 flag_energydrinks2)

drop num_energydrinks1 num_energydrinks2 flag_energydrinks1 flag_energydrinks2
save "$dta\master_data", replace




stop





