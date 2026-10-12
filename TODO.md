# Follow-ups

- Validate `r_scripts/load.R` against the original monthly CSV files, comparing its output with the existing raw R dataset. The renv validation so far starts from the saved raw dataset.
- Review the empty-subset summary in `01_data_processing.Rmd` (`warehouse`): it produces `Inf` / `-Inf` and an existing min/max warning when no rows are selected.
- Adjust the unconditional manual color and fill scales in `my_ggplot()` so newer ggplot2 versions do not warn for plots without mapped membership colors. Verify the resulting plots before updating the archived HTML reports.
- Decide whether to replace the large LFS datasets with downloads from Divvy and locally generated intermediate files once the complete import workflow is verified.
