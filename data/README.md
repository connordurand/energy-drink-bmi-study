# Data Sources

All data comes from the National Health and Nutrition Examination Survey (NHANES), 2021-2023 cycle.

**Source URL:** https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?Cycle=2021-2023

## Datasets Used

| Dataset   | Description                        |
|-----------|------------------------------------|
| BMX_L     | Body Measures (includes BMI)       |
| SMQ_L     | Smoking - Cigarette Use            |
| DEMO_L    | Demographics                       |
| DR1IFF_L  | Dietary Interview - Individual Foods, Day 1 |
| DR2IFF_L  | Dietary Interview - Individual Foods, Day 2 |

## Notes

- Raw .dta files are not included in this repository due to size and licensing.
- Download SAS transport files (.XPT) from the NHANES website and convert to Stata format (.dta) before running the analysis scripts.
- The sample is restricted to individuals aged 18-64 with non-missing BMI who completed the in-person examination component.
- Sample weights (WTINT2YR, WTMEC2YR) are used to account for the complex survey design.
