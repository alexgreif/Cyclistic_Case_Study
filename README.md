# Cyclistic Case Study

An R-based analysis of Chicago bike-share trips, completed as a capstone project for the Google Data Analytics Professional Certificate. The case study examines differences between annual members and casual riders to inform recommendations for a fictional bike-share company.

The analysis uses Divvy trip data from April 2021 through March 2022, supplemented by historical weather data for Chicago.

## Results

- [Data processing report](https://alexgreif.github.io/cyclistic/01_data_processing.html)
- [Data analysis report](https://alexgreif.github.io/cyclistic/02_data_analysis.html)
- [Presentation (PDF)](presentation/cyclistic.pdf)
- [Presentation (PowerPoint)](presentation/cyclistic.pptx)

The HTML reports are also included in `r-project/` and can be opened locally in a browser.

## Repository structure

- `r-project/01_data_processing.Rmd`: data inspection, cleaning and preparation.
- `r-project/02_data_analysis.Rmd`: exploratory analysis and interpretation.
- `r-project/r_scripts/`: data import, weather preparation and supporting exports.
- `r-project/data/`: original data, saved R datasets and Tableau exports.
- `r-project/images/`: report images and Tableau visualizations.
- `presentation/`: the final presentation in PDF and PowerPoint formats.

## Data

The original monthly trip files are available from [Divvy System Data](https://divvybikes.com/system-data). Weather data is included in `r-project/data/weather.xlsx`; its source is described in the analysis report.

CSV and R data files in this repository use **Git LFS**. Install Git LFS before cloning to retrieve their contents rather than small pointer files:

```sh
git lfs install
git clone https://github.com/alexgreif/Cyclistic_Case_Study.git
cd Cyclistic_Case_Study
git lfs pull
```

The LFS data totals approximately 1.43 GB. Reading the finished reports does not require downloading these datasets.

## Running the analysis

The original environment used R 4.2.1. The project still includes its historical Packrat environment, which contains macOS-specific installed packages; its dependency setup has not yet been modernized or verified on a fresh installation.

The source files use `tidyverse`, `data.table`, `kableExtra`, `patchwork`, `geosphere`, `readxl`, `lubridate`, `scales`, `htmltools`, `knitr` and `rmarkdown`. Rendering the reports also requires Pandoc, which is included with RStudio.

Run the analysis from `r-project/`. Its workflow is:

1. Import the monthly CSV files with `r_scripts/load.R`.
2. Prepare the weather data with `r_scripts/weather.R`.
3. Render `01_data_processing.Rmd`, which saves the cleaned dataset.
4. Render `02_data_analysis.Rmd` using the cleaned data and weather data.

The saved datasets are currently included via Git LFS, so steps 1 and 2 can be skipped when using those files. A clean-environment reproduction check and dependency cleanup are planned separately.
