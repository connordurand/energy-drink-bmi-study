# Analysis Scripts

This directory contains Stata .do files used for data preparation and analysis.

## Files

- **Course_Project.do** -- Main data preparation script. Merges NHANES datasets (BMX_L, SMQ_L, DEMO_L, DR1IFF_L, DR2IFF_L), constructs all variables (energy drink flag, demographics, education, race, marital status, smoking, military service), restricts the sample to ages 18-64 with non-missing BMI, and saves the master dataset.

- **Course_Project_Sum_Stats.do** -- Summary statistics and table generation script. Loads the master dataset, computes weighted summary statistics by energy drink consumption group, runs t-tests for differences in means, and exports LaTeX tables.

## How to Run

1. Set the global root path in each .do file to match your local directory structure (default: `C:\ss368`).
2. Place the raw NHANES .dta files in the `dta` subdirectory.
3. Run `Course_Project.do` first to build the master dataset.
4. Run `Course_Project_Sum_Stats.do` to generate summary statistics and tables.

Both scripts require Stata with the `estout` package installed (`ssc install estout`).
