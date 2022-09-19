# Attach packages
library("tidyverse")

# Load data
load("data/r_data/data_cleaned.rda")

# Stations ---------------------------------------------------------------------

# Find top 10 after 4pm  <-  in casuals
stations <- data %>%
  group_by(weekend) %>% 
  mutate(n_days = n_distinct(date)) %>%
  pivot_longer(cols = c("start_station_id", "end_station_id"),
               names_to = c("type", ".value"),
               names_pattern = '(^[^_]+(?=_))_(.*)') %>%
  filter(!is.na(station_id)) %>% 
  group_by(member_casual, weekend, station_id) %>% 
  summarize(total_rides = n_distinct(ride_id),
            mean_rides = total_rides/mean(n_days),
            total_visits = n(),
            mean_visits = total_visits/mean(n_days)) %>%
  arrange(desc(total_rides)) %>% 
  mutate(number = row_number())

# Factor ordered by traffic in casuals overall
stations <- stations %>%
  ungroup() %>% 
  filter(member_casual == "casual") %>%
  mutate(id_ordered = reorder(station_id, desc(total_rides))) %>%
  select(station_id, id_ordered, weekend) %>% 
  right_join(stations, by = c("station_id", "weekend"))

# Reorder weekday ID
stations <- stations %>%
  ungroup() %>% 
  filter(member_casual == "casual" & weekend == "weekday") %>%
  mutate(id_weekday = reorder(station_id, number)) %>%
  select(station_id, id_weekday, weekend) %>% 
  right_join(stations, by = c("station_id", "weekend"))

# Reorder weekend ID
stations <- stations %>%
  ungroup() %>% 
  filter(member_casual == "casual" & weekend == "weekend") %>%
  mutate(id_weekend = reorder(station_id, number)) %>%
  select(station_id, id_weekend, weekend) %>% 
  right_join(stations, by = c("station_id", "weekend"))

# Top 10 stations
top10 <- stations %>%
  filter(number <= 10) %>% 
  ungroup() %>% 
  mutate(group = interaction(member_casual, weekend),
         n = 1) %>%
  select(station_id, group, n) %>%
  pivot_wider(names_from = "group", values_from = "n", values_fill = list(n = 0))

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

# Stations
stations_regular <- c("LF-005", "TA1308000050", "KA1504000135", "TA1307000039",
                      "TA1308000001", "13179", "13146")
stations_tourist <- c("13022", "13008", "13042", "13300")

# Combine all stations
stations_all <- c(stations_regular, stations_tourist)

# Station list
station_list <- list("Regular" = stations_regular, "Touristic" = stations_tourist)


# Load weather data ------------------------------------------------------------
load("data/r_data/weather.rda")


# Tables -----------------------------------------------------------------------

# Day of the week
data %>%
  group_by(day_of_week) %>% 
  mutate(n_days = n_distinct(date)) %>% 
  group_by(member_casual, day_of_week, weekend) %>% 
  summarize(n = n()/mean(n_days))

# Time of the day
data %>% 
  group_by(weekend) %>% 
  mutate(n_days = n_distinct(date)) %>% 
  group_by(weekend, member_casual, hour) %>% 
  summarize(n = n()/mean(n_days)) %>% 
  view()

# Month
data %>% 
  group_by(month) %>% 
  mutate(n_days = n_distinct(date)) %>% 
  group_by(member_casual, month) %>% 
  summarize(n = n()/mean(n_days)) %>% 
  view()

# Month weekend
data %>% 
  group_by(month, weekend) %>% 
  mutate(n_days = n_distinct(date)) %>% 
  group_by(weekend, member_casual, month) %>% 
  summarize(n = n()/mean(n_days)) %>% 
  view()

# Stations
stations %>%
  ungroup() %>% 
  filter(station_id %in% top10$station_id) %>% 
  select(member_casual, weekend, station_id, mean_rides) %>% 
  arrange(weekend, member_casual, station_id) %>% 
  view()

# Time of the day by station
relevant_stations <- c("13022", "LF-005", "TA1307000039")

data %>% 
  group_by(weekend) %>% 
  mutate(n_days = n_distinct(date)) %>% 
  pivot_longer(cols = c("start_station_id", "end_station_id"),
               names_to = c("type", ".value"),
               names_pattern = '(^[^_]+(?=_))_(.*)') %>%
  filter(station_id %in% relevant_stations) %>% 
  group_by(station_id, weekend, member_casual, hour) %>% 
  summarize(n = n()/mean(n_days)) %>%
  left_join(select(stations_list, station_id, station_name),
            by = "station_id") %>% 
  view()

# Station names top 10
stations_list %>%
  filter(station_id %in% top10$station_id) %>%
  select(station_id, station_name) %>% 
  view()

# Station names top 11
stations_list %>%
  filter(station_id %in% stations_all) %>%
  select(station_id, station_name) %>% 
  view()

# By day touristic
data %>%
  filter(month %in% c("Jun", "Jul", "August", "September")) %>%
  group_by(day_of_week) %>% 
  mutate(n_days = n_distinct(date)) %>%
  filter((start_station_id %in% stations_tourist |
            end_station_id %in% stations_tourist) &
           (between(hour, 12, 18) & weekend == "weekday") |
           (between(hour, 11, 17) & weekend == "weekend")) %>%
  pivot_longer(cols = c("start_station_id", "end_station_id"),
               names_to = c("type", ".value"),
               names_pattern = '(^[^_]+(?=_))_(.*)') %>% 
  filter(station_id %in% stations_tourist) %>%
  group_by(station_id, day_of_week, member_casual) %>%
  summarize(n = n()/mean(n_days)) %>%
  left_join(select(stations_list, station_id, station_name),
            by = "station_id") %>% 
  pivot_wider(names_from = "member_casual", values_from = "n") %>% 
  view() %>% 
  select(station_name, day_of_week, member, casual)

# By weekend non-touristic
data %>%
  filter(month %in% c("Jun", "Jul", "August", "September")) %>%
  group_by(weekend) %>% 
  mutate(n_days = n_distinct(date)) %>%
  filter((start_station_id %in% stations_regular |
            end_station_id %in% stations_regular) &
           (between(hour, 16, 22) & weekend == "weekday") |
           (between(hour, 11, 17) & weekend == "weekend")) %>%
  pivot_longer(cols = c("start_station_id", "end_station_id"),
               names_to = c("type", ".value"),
               names_pattern = '(^[^_]+(?=_))_(.*)') %>% 
  filter(station_id %in% stations_regular) %>%
  group_by(weekend, member_casual, station_id) %>%
  summarize(n = n()/mean(n_days)) %>%
  left_join(select(stations_list, station_id, station_name),
            by = "station_id") %>% 
  pivot_wider(names_from = "weekend", values_from = "n") %>% 
  ungroup() %>% 
  select(member_casual, station_name, weekday, weekend) %>% 
  view()

# By weekend touristic
data %>%
  filter(month %in% c("Jun", "Jul", "August", "September")) %>%
  group_by(weekend) %>% 
  mutate(n_days = n_distinct(date)) %>%
  filter((start_station_id %in% stations_tourist |
            end_station_id %in% stations_tourist) &
           (between(hour, 16, 22) & weekend == "weekday") |
           (between(hour, 11, 17) & weekend == "weekend")) %>%
  pivot_longer(cols = c("start_station_id", "end_station_id"),
               names_to = c("type", ".value"),
               names_pattern = '(^[^_]+(?=_))_(.*)') %>% 
  filter(station_id %in% stations_tourist) %>%
  group_by(weekend, member_casual, station_id) %>%
  summarize(n = n()/mean(n_days)) %>%
  left_join(select(stations_list, station_id, station_name),
            by = "station_id") %>% 
  pivot_wider(names_from = "weekend", values_from = "n") %>% 
  ungroup() %>% 
  select(member_casual, station_name, weekday, weekend) %>% 
  view()

# Rain
data %>%
  filter(month %in% c("Jun", "Jul", "August", "September")) %>%
  left_join(weather %>%
              select(date, precip) %>%
              mutate(precip = as.factor(ifelse(precip > 0, "rainy", "dry"))),
            by = "date") %>%
  group_by(weekend, precip) %>% 
  mutate(n_days = n_distinct(date)) %>%
  filter((start_station_id %in% stations_all |
            end_station_id %in% stations_all) &
           (between(hour, 12, 22) & weekend == "weekday") |
           (between(hour, 11, 17) & weekend == "weekend")) %>%
  pivot_longer(cols = c("start_station_id", "end_station_id"),
               names_to = c("type", ".value"),
               names_pattern = '(^[^_]+(?=_))_(.*)') %>% 
  filter((station_id %in% stations_all & weekend == "weekend") |
           (station_id %in% stations_regular & between(hour, 16, 22)) |
           (station_id %in% stations_tourist & between(hour, 12, 18))) %>% 
  group_by(weekend, member_casual, precip) %>%
  summarize(n = n()/mean(n_days)) %>%
  pivot_wider(names_from = "precip", values_from = "n") %>% 
  ungroup() %>% 
  select(member_casual, weekend, rainy, dry) %>%
  view()

# Tableau
tableau_stations <- stations %>%
  filter(station_id %in% top10$station_id) %>% 
  select(station_id, member_casual, weekend,
         total_rides, total_visits, number) %>% 
  left_join(select(stations_list, station_id, station_name, lat, lng),
            by = "station_id")

# Save
save(tableau_stations, file = "tableau_ppt.rda")