# Cyclistic Case Study

An R-based analysis of Chicago bike-share trips, completed as a capstone project for the Google Data Analytics Professional Certificate. The case study examines differences between annual members and casual riders to inform recommendations for a fictional bike-share company.

The analysis uses real trip data from Chicago-based bike-share company Divvy from April 2021 through March 2022, supplemented by historical weather data for Chicago.

## Results

- [Data processing report](https://alexgreif.github.io/cyclistic/01_data_processing.html)
- [Data analysis report](https://alexgreif.github.io/cyclistic/02_data_analysis.html)
- [Presentation (PDF)](presentation/cyclistic.pdf)
- [Presentation (PowerPoint)](presentation/cyclistic.pptx)

The HTML reports are also included in the repository root and can be opened locally in a browser.

## Repository structure

- `01_data_processing.Rmd`: data inspection, cleaning and preparation.
- `02_data_analysis.Rmd`: exploratory analysis and interpretation.
- `r_scripts/`: data import, weather preparation and supporting exports.
- `data/`: original data, saved R datasets and Tableau exports.
- `images/`: report images and Tableau visualizations.
- `presentation/`: the final presentation in PDF and PowerPoint formats.

## Data

- **Trip data:** monthly files from [Divvy System Data](https://divvybikes.com/system-data), covering April 2021 through March 2022.
- **Weather data:** historical temperature and precipitation data for the Chicago area from the [National Weather Service climate portal](https://www.weather.gov/wrh/climate?wfo=lot), covering the same period. The workbook is included as `data/weather.xlsx` and prepared by `r_scripts/weather.R`. The original workbook and script do not identify the specific weather station.

CSV and R data files in this repository use **Git LFS**. Install Git LFS before cloning to retrieve their contents rather than small pointer files:

```sh
git lfs install
git clone https://github.com/alexgreif/Cyclistic_Case_Study.git
cd Cyclistic_Case_Study
git lfs pull
```

The LFS data totals approximately 1.43 GB.

## Running the analysis

The original environment used R 4.2.1. The project still includes its historical Packrat environment, which contains macOS-specific installed packages; its dependency setup has not yet been modernized or verified on a fresh installation.

The source files use `tidyverse`, `data.table`, `kableExtra`, `patchwork`, `geosphere`, `readxl`, `lubridate`, `scales`, `htmltools`, `knitr` and `rmarkdown`. Rendering the reports also requires Pandoc, which is included with RStudio.

Run the analysis from ``. Its workflow is:

1. Import the monthly CSV files with `r_scripts/load.R`.
2. Prepare the weather data with `r_scripts/weather.R`.
3. Render `01_data_processing.Rmd`, which saves the cleaned dataset.
4. Render `02_data_analysis.Rmd` using the cleaned data and weather data.

The saved datasets are currently included via Git LFS, so steps 1 and 2 can be skipped when using those files. A clean-environment reproduction check and dependency cleanup are planned separately.
