rm(list = ls(all = TRUE))


# Load Libraries ----------------------------------------------------------

library("tidyverse")
library("lubridate")
source("R/99_functions.R")

# Load data ---------------------------------------------------------------


covid_data <- tribble(
  ~Variable_name, ~File_path,
  "Confirmed",    "data/_raw/time_series_covid19_confirmed_global.csv",
  "Deaths",       "data/_raw/time_series_covid19_deaths_global.csv",
  "Recovered",    "data/_raw/time_series_covid19_recovered_global.csv"
)


covid_data <- covid_data %>% 
  mutate(Raw_data = purrr::map(File_path, ~read_csv(.)))


# Wrangle Data ------------------------------------------------------------


# Pivot the data and join the pivoted dataframes
covid_data <- covid_data %>% 
  mutate(Pivoted_data = map2(.x = Raw_data,
                             .y = Variable_name, 
                             ~pivot_longer(data = .x, 
                                           cols = matches("\\d+/\\d+/\\d+"),
                                           names_to = "Date",
                                           values_to = .y))) %>% 
  pluck("Pivoted_data") %>% 
  reduce(left_join, by = c("Province/State",
                           "Country/Region",
                           "Lat",
                           "Long",
                           "Date"))

# Sum up variable on country level and reformat date.
covid_data <- covid_data %>% 
  rename(Country = `Country/Region`) %>%
  group_by(Country, Date) %>%
  summarise(Confirmed = sum(Confirmed),
            Deaths = sum(Deaths),
            Recovered = sum(Recovered)) %>% 
  mutate(Date = mdy(Date))

# Write data --------------------------------------------------------------
covid_data %>%
  write_csv("data/01_timeseries_country.csv")

