
# Minna Maunula
# Date: [12th of November 2023]
# File Description: This file contains script for both data wrangling and analysis of assignment 2.
# Data Source: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt

## Data wrangling

# Step 1: Set up the project folder and data folder
if (!file.exists("data")) {
  dir.create("data")
}

# Step 2: read the data into memory
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Look at the dimensions of the data
dim(learning2014)
# Data has 183 rows (observations) and 60 columns (variables)

# Look at the structures of the data
str(learning2014)
# Each variable is a type integer (int) that indicates numerical values and only gender is a type character (chr).
# This data set is missing variables deep,stra and surf so I assume they will be in the other data set. 

#Step 3: Create and analysis dataset with spesific variables, scale variables to the original scale and exclude observations where the exam points variable is zero

# Access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning 
deep_columns <- select(learning2014, one_of(deep_questions))
# and create column 'deep' by averaging
learning2014$deep <- rowMeans(deep_columns)

# select the columns related to surface learning 
surface_columns <- select(learning2014, one_of(surface_questions))
# and create column 'surf' by averaging
learning2014$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning 
strategic_columns <- select(learning2014, one_of(strategic_questions))
# and create column 'stra' by averaging
learning2014$stra <- rowMeans(strategic_columns)

# choose a handful of columns to keep
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# Select the 'keep_columns' to create a new dataset
learning2014_final <- select(learning2014, one_of(keep_columns))

# View the structure of the new dataset
str(learning2014_final)

# Exclude observations where the exam points variable is zero 
learning2014_final <- learning2014_final %>% filter(Points != 0)

# Display the first few rows of the selected columns
head(learning2014_final)

# Check the structure of the final dataset
str(learning2014_final)
# The data has 166 observations and 7 variables. Yes!


# Step 4: Set the working directory to the IODS Project folder
setwd("/Users/minmaunu/IODS-project")

# Save the analysis dataset to the 'data' folder
library(tidyverse)
write_csv(learning2014_final, "data/learning2014.csv")

# Read the data again using read_csv to read the data and then use str() and head() to check the structure
read_data <- read_csv("data/learning2014.csv")
str(read_data)
head(read_data)

# Done! 
