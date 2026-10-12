# Follow-ups

- Validate `r_scripts/load.R` against the original monthly CSV files, comparing its output with the existing raw R dataset. The renv validation so far starts from the saved raw dataset.
- Decide whether to replace the large LFS datasets with downloads from Divvy and locally generated intermediate files once the complete import workflow is verified.

## Reviewed warnings

The analysis code is retained rather than rewritten solely to remove warnings. Both reports render successfully with the recorded renv environment.

- Manual color/fill scales: `my_ggplot()` adds membership scales even when the plot does not map those aesthetics. Newer ggplot2 versions warn about unused scales; the inspected plots render correctly.
- Empty warehouse search: the processing report computes min/max on an empty selection. The table has headers and no data rows; this warning is also present in the original HTML report.
- Many-to-many joins: station ordering lookups contain repeated labels. In the checked station-traffic plot, 48 distinct plot rows become 96 identical copies after the join. The final plot's 11 selected stations have 44 lookup rows but only 11 distinct label assignments, with no missing labels. These joins add plotting annotations after counts have been calculated; their redundancy merits attention if the code is extended, but is not corrected in this historical analysis.
- Vectorized `element_text()`: used to bold weekend axis labels. It is not officially supported; the current plots show the intended formatting.
- Removed `geom_text()` rows: precipitation labels are explicitly set to `NA` on dry days, so these labels are omitted intentionally.
- Weather dates: seven invalid calendar cells in the monthly workbook produce parse warnings and are filtered out. The regenerated 365-day weather dataset matches the original.

All 26 table contents match the original reports; two processing tables differ only in row order. The reports contain the same number of embedded PNG images as before. These checks do not replace a full methodological review.
