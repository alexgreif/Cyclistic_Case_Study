# Attach packages
library("tidyverse")

# Import sheets
temperature <- readxl::read_xlsx("data/weather.xlsx", sheet = "temperature")
precipitation <- readxl::read_xlsx("data/weather.xlsx", sheet = "precipitation") %>% 
  mutate(across(-day, ~as.numeric(ifelse(. == "T", 0, .)))) # T = trace precip

# Join
weather <- full_join(temperature, precipitation, by = "day")

# Transform
weather <- weather %>% 
  pivot_longer(cols = -"day", names_sep = "\\.",
               names_to = c("month", ".value")) %>% 
  rename(temp = x, precip = y) %>% 
  mutate(year = ifelse(month %in% c("Jan", "Feb", "Mar"), 2022, 2021),
         date = lubridate::dmy(paste(day, month, year)),
         week = lubridate::isoweek(date),
         day_of_week = lubridate::wday(date, label = T, week_start = 1),
         weekend = as.factor(ifelse(day_of_week %in% c("Sat", "Sun"),
                                    "weekend",
                                    "weekday"))) %>% 
  filter(!is.na(date)) %>% 
  arrange(date)

# Save
save(weather, file = "data/r_data/weather.rda")