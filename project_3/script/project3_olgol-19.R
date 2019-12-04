library(tidyverse)
library(ggplot2)


# remove duplicates, means that data for the first entry to the program 
UMD_data <- read_csv("https://raw.githubusercontent.com/datasci611/bios611-projects-fall-2019-olgol-19/master/project_3/data/Final_data_for_analysis.csv") %>%
  distinct(ID, .keep_all = TRUE)
  
# Gender information

data <- UMD_data %>% 
  group_by(Gender) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(per=`n`/sum(`n`)) %>% 
  arrange(desc(Gender))

data$label <- scales::percent(data$per) # getting proportion


ggplot(data=data)+
  geom_bar(aes(x="", y=per, fill=Gender), stat="identity", width = 1)+
  coord_polar("y", start=0, direction = -1)+ # organize
  theme_void()+
  geom_text(aes(x=1, y = cumsum(per) - per/2, label=label)) +
  ggtitle("Gender Distribution")+
  theme(plot.title = element_text(hjust = 0.5)) # adjust title to center

# Race Distribution

ggplot(data = UMD_data, aes(x=Race)) +
  geom_bar(alpha = 0.5, color="black", fill="grey") +
  theme_classic() +
  ylab("Count") +
  ggtitle("Race distribution")+
  theme(plot.title = element_text(hjust = 0.5), axis.title.y=element_blank())+
  coord_flip() # Flipp x and y axis


# Ethnicity Distribution
data_e <- UMD_data %>% 
  group_by(Ethnicity) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(per=`n`/sum(`n`)) %>% 
  arrange(desc(Ethnicity))
data_e$label <- scales::percent(data_e$per)

library(ggrepel) #library to avoid labels overlapping
ggplot(data=data_e)+
  geom_bar(aes(x="", y=per, fill=Ethnicity), stat="identity", width = 1)+
  coord_polar("y", start=0, direction = -1)+
  theme_void()+
  geom_text_repel(aes(x=1, y = cumsum(per) - per/2, label=label)) +
  ggtitle("Ethnicity Distribution")+
  theme(plot.title = element_text(hjust = 0.5))

#Are there any Vetrans?
  
data_v <- UMD_data %>% 
  group_by(Veteran) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(per=`n`/sum(`n`)) %>% 
  arrange(desc(Veteran))
data_v$label <- scales::percent(data_v$per)

ggplot(data=data_v)+
  geom_bar(aes(x="", y=per, fill=Veteran), stat="identity", width = 1)+
  coord_polar("y", start=0, direction = -1)+
  theme_void()+
  geom_text_repel(aes(x=1, y = cumsum(per) - per/2, label=label)) +
  ggtitle("Veteran Status Distribution")+
  theme(plot.title = element_text(hjust = 0.5))

# People with Disability

data_d <- UMD_data %>% 
  group_by(Disability) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(per=`n`/sum(`n`)) %>% 
  arrange(desc(Disability))
data_d$label <- scales::percent(data_d$per)

ggplot(data=data_d)+
  geom_bar(aes(x="", y=per, fill=Disability), stat="identity", width = 1)+
  coord_polar("y", start=0, direction = -1)+
  theme_void()+
  geom_text_repel(aes(x=1, y = cumsum(per) - per/2, label=label)) +
  ggtitle("Disability Status Distribution")+
  theme(plot.title = element_text(hjust = 0.5))

## Homeless people covered with Health Insurance

data_i <- UMD_data %>% 
  group_by(Health_Insurance) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(per=`n`/sum(`n`)) %>% 
  arrange(desc(Health_Insurance))
data_i$label <- scales::percent(data_i$per)

ggplot(data=data_i)+
  geom_bar(aes(x="", y=per, fill=Health_Insurance), stat="identity", width = 1)+
  coord_polar("y", start=0, direction = -1)+
  theme_void()+
  geom_text_repel(aes(x=1, y = cumsum(per) - per/2, label=label)) +
  ggtitle("Health Insurance Coverage")+
  theme(plot.title = element_text(hjust = 0.5))

# Effect of Domestic Violence

data_dv <- UMD_data %>% 
  group_by(`Domestic violence victim`) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(per=`n`/sum(`n`)) %>% 
  arrange(desc(`Domestic violence victim`))
data_dv$label <- scales::percent(data_dv$per)

ggplot(data=data_dv)+
  geom_bar(aes(x="", y=per, fill=`Domestic violence victim`), stat="identity", width = 1)+
  coord_polar("y", start=0, direction = -1)+
  theme_void()+
  geom_text_repel(aes(x=1, y = cumsum(per) - per/2, label=label)) +
  ggtitle("Domestic Violence Victims/Survivals")+
  theme(plot.title = element_text(hjust = 0.5))


# Age Distribution

ggplot(data = UMD_data, aes(x=Age)) +
  geom_histogram(alpha = 0.4, color="black", fill="grey") +
  theme_classic() +
  xlab("Age distribution") +
  ylab("Count") +
  ggtitle("Age distribution")+
  theme(plot.title = element_text(hjust = 0.5))+
  geom_vline(aes(xintercept=mean(Age)),
             color="blue", linetype="dashed", size=1)


## Distribution by Age and Gender
library(plyr)
mu <- ddply(UMD_data, "Gender", summarise, grp.mean=mean(Age))

ggplot(data = UMD_data, aes(x=Age,fill=Gender ,color=Gender)) +
  geom_histogram(alpha=0.5)+
  theme_classic() +
  xlab("Age distribution") +
  ylab("Count") +
  ggtitle("Age distribution by Gender")+
  theme(plot.title = element_text(hjust = 0.5))+
  geom_vline(data=mu, aes(xintercept=grp.mean, color=Gender),
             linetype="dashed")
detach("package:plyr", unload=TRUE)

## Income Distribution

data_in <- UMD_data %>% 
  filter(Income>0)

data_in_n <- UMD_data %>% 
  filter(Income==0)

x <- data.frame("Count" = c(2219,79), "Income" = c("No Income", "Some Income"))

ggplot(data = x, aes(Income, Count)) +
  geom_col(alpha = 0.4, color="black", fill="grey") +
  theme_classic() +
  ylab("Count") +
  ggtitle("Income distribution")+
  theme(plot.title = element_text(hjust = 0.5))

ggplot(data = data_in, aes(x=Income)) +
  geom_histogram(alpha = 0.4, color="black", fill="grey") +
  theme_classic() +
  xlab("Amount") +
  ylab("Count") +
  ggtitle("Income distribution")+
  theme(plot.title = element_text(hjust = 0.5))
