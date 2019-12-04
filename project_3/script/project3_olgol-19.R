library(tidyverse)
library(ggplot2)


# remove duplicates, means that data for the first entry to the program 
UMD_data <- read_csv("https://raw.githubusercontent.com/datasci611/bios611-projects-fall-2019-olgol-19/master/project_3/data/Final_data_for_analysis.csv") %>%
  distinct(ID, .keep_all = TRUE)
  
