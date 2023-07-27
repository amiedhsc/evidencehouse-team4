mp_data <- read.csv("LegislationMPs_sampledata.csv")
amend_data <- read.csv("Legislation_sampledata.csv")


list_mps <- mp_data %>%
  distinct(Name) %>%
  arrange() %>%
  pull()

list_themes <- amend_data %>%
  distinct(Themes) %>%
  arrange() %>%
  pull()
