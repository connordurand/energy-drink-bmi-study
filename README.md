# Energy Drinks and Body Mass Index

**Aggregated Effects of Energy Drink Consumption on Physical Health**

## Abstract

Energy drink consumption is on the rise, along with media reporting associated with health risks. By controlling various demographic and lifestyle factors, the effect of energy drinks on BMI can be isolated. Findings demonstrate a statistically and economically significant positive association between energy drinks and BMI after controlling for both factors known to affect BMI (age, gender, etc.), and those with unstudied impacts. However, without physical activity controls, the effects are unable to prove causality.

## Repository Structure

```
energy-drink-bmi-study/
├── paper/
│   ├── main.tex            # Main LaTeX document
│   ├── references.bib      # BibTeX bibliography
│   ├── figures/             # Figures (image1-4.png)
│   └── tables/              # LaTeX table files
├── analysis/                # Stata .do files
├── data/                    # Data documentation (raw data not included)
├── output/                  # Generated output
└── README.md
```

## Compiling the Paper

```bash
cd paper
pdflatex main
bibtex main
pdflatex main
pdflatex main
```

Or with latexmk:

```bash
cd paper
latexmk -pdf main.tex
```

## Running the Analysis

1. Download NHANES 2021-2023 datasets (BMX_L, SMQ_L, DEMO_L, DR1IFF_L, DR2IFF_L) from https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?Cycle=2021-2023
2. Convert .XPT files to Stata .dta format.
3. Update the global root path in the .do files.
4. Run `analysis/Course_Project.do` to build the master dataset.
5. Run `analysis/Course_Project_Sum_Stats.do` to generate summary statistics.

Requires Stata with the `estout` package.

## Data Sources

- **NHANES 2021-2023** -- National Health and Nutrition Examination Survey (CDC/NCHS)
- **USDA WWEIA Food Categories** -- Used for energy drink product classification

## Author

Connor Durand -- connor.durand@westpoint.edu
