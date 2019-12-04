
# coding: utf-8

# In[1]:


# import packages
import pandas as pd
import numpy as np


# In[2]:


# read data
client = pd.read_csv('https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/CLIENT_191102.tsv',sep ='\t')
detail = pd.read_csv('https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/EE_UDES_191102.tsv',sep ='\t')
exit = pd.read_csv('https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/ENTRY_EXIT_191102.tsv',sep ='\t')
income = pd.read_csv('https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/INCOME_ENTRY_191102.tsv',sep ='\t')


# In[3]:


# data cleaning for clients, select only data which will be analyzed
cl_client = client[["Client ID","Client Age at Entry","Client Gender","Client Primary Race","Client Ethnicity","Client Veteran Status"]].dropna()
cl_client.columns = ["ID","Age","Gender","Race","Ethnicity","Veteran"]
# remove (HUD) at the end
cl_client = cl_client.replace(to_replace = "American Indian or Alaska Native (HUD)", value = "American Indian or Alaska Native")
cl_client = cl_client.replace(to_replace = "Asian (HUD)", value = "Asian")
cl_client = cl_client.replace(to_replace = "Black or African American (HUD)", value = "Black/African American")
cl_client = cl_client.replace(to_replace = "Native Hawaiian or Other Pacific Islander (HUD)", value = "Native Hawaiian/Pacific Islander") 
cl_client = cl_client.replace(to_replace = "White (HUD)", value = "White")
cl_client = cl_client.replace(to_replace = "Hispanic/Latino (HUD)", value = "Hispanic/Latino") 
cl_client = cl_client.replace(to_replace = "Non-Hispanic/Non-Latino (HUD)", value = "Non-Hispanic/Non-Latino") 
cl_client = cl_client.replace(to_replace = "Data not collected (HUD)", value = "Unknown") 
cl_client = cl_client.replace(to_replace = "Client refused (HUD)", value = "Unknown") 
cl_client = cl_client.replace(to_replace = "Client doesn't Know (HUD)", value = "Unknown")
cl_client = cl_client.replace(to_replace = "Client doesn't know (HUD)", value = "Unknown") 
cl_client = cl_client.replace(to_replace = "Yes (HUD)", value = "Yes") 
cl_client = cl_client.replace(to_replace = "No (HUD)", value = "No") 

final_client = cl_client.drop_duplicates()


# In[4]:


final_client.head()


# In[5]:


# data cleaning for detailed information, select only data which will be analyzed
cl_detail = detail[["Client ID","Does the client have a disabling condition?(1935)","Covered by Health Insurance(4376)", "Domestic violence victim/survivor(341)"]].dropna()
cl_detail.columns = ["ID","Disability","Health_Insurance","Domestic violence victim"]
cl_detail = cl_detail.replace(to_replace = "Yes (HUD)", value = "Yes") 
cl_detail = cl_detail.replace(to_replace = "No (HUD)", value = "No")
cl_detail = cl_detail.replace(to_replace = "Client doesn't Know (HUD)", value = "Unknown") 
cl_detail = cl_detail.replace(to_replace = "Client doesn't know (HUD)", value = "Unknown")
cl_detail = cl_detail.replace(to_replace = "Data not collected (HUD)", value = "Unknown") 
cl_detail = cl_detail.replace(to_replace = "Client refused (HUD)", value = "Unknown") 
final_detail = cl_detail.drop_duplicates()


# In[6]:


final_detail.head()


# In[7]:


# data cleaning for income information, select only data which will be analyzed
cl_income = income[["Client ID","Monthly Amount (Entry)"]]
cl_income.columns=["ID","Income"]
cl_income = cl_income.fillna(0)
final_income = cl_income.drop_duplicates()


# In[8]:


final_income.head()


# In[9]:


Master_df1 = pd.merge(final_client, final_detail)
Master_df = pd.merge(Master_df1, final_income)


# In[10]:


Master_df.head()


# In[11]:


Master_df.to_csv("Final_data_for_analysis.csv", index=False)

