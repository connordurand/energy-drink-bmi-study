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

***Import data****
use "$dta\master_data", clear





********************************
* Construct Summary Statistics *
********************************



************************************
* Construct Summary Statistic Table*
************************************

eststo clear 
estpost su BMXBMI MissingEducation male somecollege smoker HSorLess military hispanic white black asian other_race age eightyplus married formerly_married never_married married_missing [aw=finalweight] 
eststo all


estpost su BMXBMI MissingEducation somecollege smoker HSorLess military hispanic white black asian other_race age married formerly_married never_married married_missing [aw=finalweight] if flag_energydrinks==0 
eststo noenergy

estpost su BMXBMI MissingEducation somecollege smoker HSorLess military hispanic white black asian other_race age married formerly_married never_married married_missing [aw=finalweight] if flag_energydrinks==1
eststo energy
describe 
label var somecollege "Some College"
label var MissingEducation "Missing Education Data"
label var smoker "Smoker"
label var HSorLess "HS Education or Less"
label var military "Military Service"
label var hispanic "Hispanic"
label var white "White"
label var black "Black"
label var asian "Asian"
label var other_race "Other Races"
label var age "Age in Years"
label var married "Married"
label var formerly_married "Formerly Married"
label var never_married "Never Married"
label var married_missing "Missing Married"
label var BMXBMI "Body Mass Index (BMI)"
label var male "Male"
label var flag_energydrinks "Consumed Energy Drinks"
label define energylbl 0 "No" 1 "Yes"
label values flag_energydrinks energylbl

 dtable BMXBMI age smoker HSorLess somecollege MissingEducation military white black asian hispanic other_race  married formerly_married never_married married_missing [aw=finalweight] , by(flag_energydrinks) export(table1.tex, replace)

*THis is the one i got working the best somehow??
dtable BMXBMI male age smoker HSorLess somecollege MissingEducation military ///
    white black asian hispanic other_race ///
    married formerly_married never_married married_missing [aw=finalweight] , ///
    by(flag_energydrinks, tests) /// Enables statistical tests
    export(table1.tex, replace)

	*New One
** Install estout if needed

* Define variables of interest
local vars BMXBMI age smoker HSorLess somecollege MissingEducation military ///
    white black asian hispanic other_race ///
    married formerly_married never_married married_missing

* Step 1: Run t-tests and save group-wise stats
estpost ttest `vars', by(flag_energydrinks)
matrix g1 = e(mu_1)
matrix g2 = e(mu_2)
cap matrix sd1 = e(sd_1)
cap matrix sd2 = e(sd_2)
matrix diff = e(b_diff)
matrix se_diff = e(se_diff)

* Step 2: Pooled stats
estpost summarize `vars' [aw=finalweight]
matrix tot = e(mean)
matrix tot_sd = e(sd)

* Step 3: Open LaTeX file
file close _all
file open f1 using "table_energy_summary.tex", write replace

file write f1 "\begin{table}[htbp]" _n
file write f1 "\centering" _n
file write f1 "\caption{Summary Statistics and Differences by Energy Drink Use}" _n
file write f1 "\begin{tabular}{lcccc}" _n
file write f1 "\toprule" _n
file write f1 "\textbf{Variable} & \textbf{Not Energy Drinker} & \textbf{Energy Drinker} & \textbf{Total} & \textbf{Difference (SE)} \\\\" _n
file write f1 "\midrule" _n

* Step 4: Write rows
local i = 1
foreach var of local vars {
    scalar g1m = g1[1,`i']
    scalar g2m = g2[1,`i']
    cap scalar sdg1 = sd1[1,`i']
    if _rc scalar sdg1 = .
    cap scalar sdg2 = sd2[1,`i']
    if _rc scalar sdg2 = .
    scalar tm = tot[1,`i']
    scalar tsd = tot_sd[1,`i']
    scalar d = diff[1,`i']
    scalar se = se_diff[1,`i']

    local g1m_f = string(g1m, "%4.2f")
    local g2m_f = string(g2m, "%4.2f")
    local sdg1_f = cond(missing(sdg1), "--", string(sdg1, "%4.2f"))
    local sdg2_f = cond(missing(sdg2), "--", string(sdg2, "%4.2f"))
    local tm_f = string(tm, "%4.2f")
    local tsd_f = string(tsd, "%4.2f")
    local d_f = string(d, "%4.2f")
    local se_f = string(se, "%4.2f")

    file write f1 "`var' & " ///
        "\begin{tabular}{@{}c@{}}`g1m_f'\\\\[`sdg1_f']\end{tabular} & " ///
        "\begin{tabular}{@{}c@{}}`g2m_f'\\\\[`sdg2_f']\end{tabular} & " ///
        "\begin{tabular}{@{}c@{}}`tm_f'\\\\[`tsd_f']\end{tabular} & " ///
        "\begin{tabular}{@{}c@{}}`d_f'\\\\(`se_f')\end{tabular} \\\\" _n

    local ++i
}

* Step 5: Close LaTeX table
file write f1 "\bottomrule" _n
file write f1 "\end{tabular}" _n
file write f1 "\label{tab:summary_energy}" _n
file write f1 "\end{table}" _n
file close f1

	*END NEW ONE
	
	
	
esttab all noenergy energy , cells(mean se ) mtitles("All" "No energy" "Energy") collabels(none) label par 
*For latex esttab all noenergy energy using "$output\sumstats_table.tex", cells(mean) mtitles("All" "No energy" "Energy") collabels(none) label tex

*For word: esttab all noenergy energy using "$output\sumstats_table.csv", cells(mean) mtitles("All" "No energy" "Energy") collabels(none) label csv



esttab all noenergy energy , cells(mean se ) mtitles("All" "No energy" "Energy") collabels(none) label par 
*For latex esttab all noenergy energy using "$output\sumstats_table.tex", cells(mean) mtitles("All" "No energy" "Energy") collabels(none) label tex

*For word: esttab all noenergy energy using "$output\sumstats_table.csv", cells(mean) mtitles("All" "No energy" "Energy") collabels(none) label csv


