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
- **Weather data:** historical temperature and precipitation data for **Chicago O’Hare International Airport** (NOAA station `USW00094846`) from the [National Weather Service climate portal](https://www.weather.gov/wrh/climate?wfo=lot), covering the same period. The workbook is included as `data/weather.xlsx` and prepared by `r_scripts/weather.R`. The station was identified by comparing all 365 daily records against [NOAA daily summaries](https://www.ncei.noaa.gov/access/services/data/v1?dataset=daily-summaries&stations=USW00094846&startDate=2021-04-01&endDate=2022-03-31&format=json&units=standard&dataTypes=TMAX,TMIN,PRCP). Temperatures match the mean of the daily maximum and minimum in °F; precipitation matches in inches, treating trace amounts (`T`) as zero as the script does.

CSV and R data files in this repository use **Git LFS**. Install Git LFS before cloning to retrieve their contents rather than small pointer files:

```sh
git lfs install
git clone https://github.com/alexgreif/Cyclistic_Case_Study.git
cd Cyclistic_Case_Study
git lfs pull
```

The LFS data totals approximately 1.43 GB.

## Running the analysis

The original analysis used R 4.2.1. The project now uses `renv` to record and restore its R package versions. Both reports have been regenerated in an isolated Linux environment using **R 4.6.1** and **Pandoc 3.9**. The regenerated cleaned dataset matches the existing dataset in all 22 columns and 5,316,182 rows.

Install R and Pandoc (or RStudio, which includes Pandoc), then restore the packages from the repository root:

```sh
Rscript -e 'renv::restore()'
```

`renv.lock` records the direct and transitive dependencies. Installed packages are kept in an ignored local library rather than committed to Git. Linux installations may also require system libraries for individual R packages.

Run the analysis from the repository root. Its workflow is:

1. Import the monthly CSV files with `r_scripts/load.R`.
2. Prepare the weather data with `r_scripts/weather.R`.
3. Render `01_data_processing.Rmd`, which saves the cleaned dataset.
4. Render `02_data_analysis.Rmd` using the cleaned data and weather data.

The saved datasets are currently included via Git LFS, so steps 1 and 2 can be skipped when using those files. To regenerate the reports:

```sh
Rscript -e 'rmarkdown::render("01_data_processing.Rmd")'
Rscript -e 'rmarkdown::render("02_data_analysis.Rmd")'
```

These commands overwrite the local HTML reports; the first report also saves the cleaned dataset. The unchanged import script has also been validated against all 12 original monthly CSV files from Divvy, which match the repository copies byte-for-byte. The imported dataset reproduces the existing 5,723,532 rows and 13 columns within floating-point precision. The weather dataset was regenerated and matches the original. Future changes to data distribution are tracked in [TODO.md](TODO.md).

## Maintenance note

In 2026, this repository was reorganized, a README was added and the R package environment was updated with assistance from generative AI. The analysis code and interpretation are unchanged, and the original reports and presentation files are retained. Presentation links in the report sources and HTML files were adjusted to the new file locations. This is a maintained version rather than an exact snapshot of the original capstone submission.
