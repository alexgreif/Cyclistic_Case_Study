# Attach packages
library("tidyverse")
library("data.table")

# Load data using data.table
data_raw <- list.files("data/divvy_data", pattern="*.csv", full.names = TRUE) %>%
  map_df(~fread(., stringsAsFactors = TRUE, na.strings = "")) %>%
  as_tibble() %>%
  mutate(across(ride_id, as.character))

# Save data
save(data_raw, file = "data/r_data/data_raw.rda")