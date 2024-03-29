library(tidyverse)
library(ggplot2)

# Data cleaning. I will use only non-character columns for analysis.

UMD_data <- read_tsv("https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project1_2019/UMD_Services_Provided_20190719.tsv") %>%
  mutate(N_Date = as.Date(Date, "%m/%d/%Y")) %>%
  select_if(~!is.character(.)) %>%
  select_if(~!is.logical(.)) %>%
  arrange(N_Date)

ggplot(data = UMD_data, aes(x=N_Date)) +
  geom_histogram(alpha = 0.4) +
  theme_classic() +
  xlab("Date of Service Provided") +
  ylab("Count") +
  ggtitle("Date when services were provided")

# UMD was estabblished in 1983, so it is possible that data provided before this date might be not relevant or mistaken.
# We can also see that almost no information provided for the dates before year 2000.
# Filter the data to start at Jan, 2000.

UMD_cld <- UMD_data %>%
  filter(between(N_Date, as.Date("2000-01-01"), as.Date("2019-06-30"))) %>%
  mutate(Year = as.numeric(format(N_Date, "%Y"))) 

# Find the total clients supported by year.

clients = UMD_cld %>%
  group_by('Client file number', Year) %>%
  summarize(N_Client=n())

# Print the result

ggplot(clients, aes(Year, N_Client)) + 
  geom_col(alpha = 0.4) +
  geom_smooth(color='red')+
  theme_classic()+
  xlab("Year of Service Provided") +
  ylab("Number of Clients") +
  ggtitle("Increase in number of clients by year")

# Food pounds provided per year

food_df <- UMD_cld %>%
  drop_na(`Food Pounds`) %>%
  group_by(Year) %>%
  summarise(count = n(),food = sum(`Food Pounds`))

ggplot(food_df,aes(x = Year, y = food)) +
  geom_col(alpha = 0.4) +
  geom_smooth(color='red', se=FALSE) +
  theme_classic() +
  labs(title = 'Food (pounds) per Year',
       y = 'Food Pounds')

# Predict the ammount of food provided in 2019-2023.

food_model=lm(food ~ Year, food_df)
pred_years <- c(2019, 2020, 2021, 2022, 2023)

food_pred <- data.frame(Year=pred_years)
prd=predict(food_model, food_pred)

names(prd)[] <- c('2019','2020', '2021', '2022', '2023')

prd

# Find the distribution of diapers by year.
UMD_cld %>%
  drop_na('Diapers') %>%
  group_by(Year) %>%
  summarise(count = n(),diapers=sum(Diapers)) %>%
  ggplot(aes(x = Year, y = diapers)) +
  geom_point(size = 1.5, alpha = 0.4) +
  geom_smooth(color='red', se=FALSE) +
  theme_classic() +
  labs(title = 'Diapers help by Year',
       y = 'Number of diapers')

# Find the distribution of clothing items by year.
UMD_cld %>%
  drop_na(`Clothing Items`) %>%
  group_by(Year) %>%
  summarise(count = n(),cloth=sum(`Clothing Items`)) %>%
  ggplot(aes(x = Year, y = cloth)) +
  geom_point(size = 1.5, alpha = 0.4) +
  geom_smooth(color='red', se=FALSE) +
  theme_classic() +
  labs(title = 'Clothing Items distribution by Year',
       y = 'Number of Clothing Items')

# Find the distribution of School kits by year.
UMD_cld %>%
  drop_na(`School Kits`) %>%
  group_by(Year) %>%
  summarise(count = n(), school=sum(`School Kits`)) %>%
  ggplot(aes(x = Year, y = school)) +
  geom_col(alpha = 0.4) +
  theme_classic() +
  labs(title = 'School Kits distribution by Year',
       y = 'Number of School Kits')

# Find the distribution of Hygiene kits by year.
UMD_cld %>%
  drop_na(`Hygiene Kits`) %>%
  group_by(Year) %>%
  summarise(count = n(), kit = sum(`Hygiene Kits`)) %>%
  ggplot(aes(x = Year, y = kit)) +
  geom_col(alpha = 0.4) +
  theme_classic() +
  labs(title = 'Hygiene Kits distribution by Year',
       y = 'Number of Hygiene Kits')

# Average family size (by column food provided for)
family_size <- UMD_cld %>%
  select(`Food Provided for`) %>%
  filter(`Food Provided for`>0) %>%
  drop_na(`Food Provided for`) %>%
  rename(food=`Food Provided for`)

mean(family_size$food)

