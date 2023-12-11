# Minna Maunula
# Date: [11th of December 2023]
# File Description: This file contains R script for data wrangling 6.
# Data Source (BPRS): "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt"
# Data Source (RATS): "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt"

## Data wrangling 6

# Load tidyverse package
library(tidyverse)

# Read in the “BPRS” and “RATS” data sets 
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header=TRUE, sep=" ")
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header=TRUE, sep="\t")

# Explore the datasets

# See the names of the data.
names(BPRS)
names(RATS)

# See the structure of the data.
str(BPRS)
str(RATS)

# See the dimension of the data.
dim(BPRS)
dim(RATS)

# Create summaries of the variables
summary(BPRS)
summary(RATS)

# Change the categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Convert the data to long form and add variables for time 
BPRSL <- BPRS %>% gather(key=weeks, value=bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5, 5)))
RATSL <- RATS %>% gather(key=WD, value=Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3,4))) 

# Check the differences between the long and wide forms
names(BPRS)
names(BPRSL)
str(BPRS)
str(BPRSL)
dim(BPRS)
dim(BPRSL)
summary(BPRS)
summary(BPRSL)

names(RATS)
names(RATSL)
str(RATS)
str(RATSL)
dim(RATS)
dim(RATSL)
summary(RATS)
summary(RATSL)

# In wide data: the observations made in each time point are as separate variables. 
# In longitudinal data: the data in different time points is gathered under one variable.
# Transforming wide data to longitudinal is a requirement for certain analyses.

# write out the data
write.table(BPRSL, "/Users/minmaunu/IODS-project/data/BPRSL.txt", sep="\t", col.names = TRUE)
write.table(RATSL, "/Users/minmaunu/IODS-project/data/RATSL.txt", sep="\t", col.names = TRUE)
