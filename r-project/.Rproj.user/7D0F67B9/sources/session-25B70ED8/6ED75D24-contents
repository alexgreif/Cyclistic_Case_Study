# Load packages
library("tidyverse")

# Load data
load("data/r_data/data_cleaned.rda")

# Stations ---------------------------------------------------------------------

# Stations
stations_list <- data %>%
  filter(rideable_type == "classic_bike") %>% 
  select(matches("start_|end_"), started_at) %>% 
  pivot_longer(cols = -"started_at",
               names_to = c("type", ".value"),
               names_pattern = '(^[^_]+(?=_))_(.*)') %>% 
  group_by(station_id) %>% 
  filter(started_at == max(started_at)) %>%
  select(-c(type, started_at)) %>%
  distinct() %>% 
  arrange(station_id)

# Stations with visits
stations <- data %>%
  filter(!is.na(start_station_id) | !is.na(end_station_id)) %>%
  select(rideable_type, member_casual,
         start_station_id, end_station_id,
         weekend, month, hour) %>% 
  pivot_longer(cols = matches("start_|end_"),
               names_to = c("type", ".value"),
               names_pattern = '(^[^_]+(?=_))_(.*)') %>%
  filter(!is.na(station_id)) %>%
  mutate(type = as.factor(type)) %>%
  group_by(across(everything())) %>% 
  summarize(n = n()) %>%
  left_join(stations_list, by = "station_id")

# Save
save(stations, file = "data/tableau_data/stations.rda")

# Top stations -----------------------------------------------------------------

# Choose stations
stations_regular <- c("LF-005", "TA1308000050", "KA1504000135", "TA1307000039",
                      "TA1308000001", "13179", "13146")
stations_tourist <- c("13022", "13008", "13042", "13300")

# Retrieve and categorize stations
top_stations <- stations_list %>% 
  filter(station_id %in% c(stations_regular, stations_tourist)) %>% 
  mutate(type = ifelse(station_id %in% stations_regular,
                       "Regular", "Touristic"))

# Save
save(top_stations, file = "data/tableau_data/top_stations.rda")

# Trips ------------------------------------------------------------------------

# List of trips with IDs and n
trips_list <- data %>%
  filter(!is.na(start_station_id) & !is.na(end_station_id)) %>%
  group_by(start_station_id, end_station_id) %>%
  summarize(n = n()) %>% 
  ungroup() %>% 
  arrange(desc(n)) %>% 
  mutate(trip_id = row_number())

# Add trip_id to data and delete trips with n <= 100
trips <- data %>%
  filter(!is.na(start_station_id) & !is.na(end_station_id)) %>%
  inner_join(trips_list %>% filter(n > 300) %>% select(-n),
             by = c("start_station_id", "end_station_id"))

# Trip frequency by categories
trips <- trips %>%
  group_by(trip_id, member_casual, weekend, month, hour) %>%
  summarize(n = n()) %>% 
  ungroup()

# Add start and end_station_id
trips <- trips %>%
  left_join(select(trips_list, -n),
            by = c("trip_id")) 

# Add start and end station name, lat and lng
trips <- trips %>%
  left_join(stations_list %>% rename_with(~paste0("start_",.)),
            by = "start_station_id") %>%
  left_join(stations_list %>% rename_with(~paste0("end_",.)),
            by = "end_station_id") 

# Check for roundtrips
trips <- trips %>%
  mutate(round_trip = ifelse(start_station_id == end_station_id, TRUE, FALSE))

# Long format
trips_long <- trips %>%
  pivot_longer(cols = matches("start_|end_"),
               names_to = c("type", ".value"),
               names_pattern = '(^[^_]+(?=_))_(.*)')

# Save
save(trips, file = "data/tableau_data/trips.rda")
save(trips_long, file = "data/tableau_data/trips_long.rda")