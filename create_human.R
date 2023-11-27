# Minna Maunula
# Date: [27th of November 2023]
# File Description: This file contains R script for data wrangling of assignment 4.
# Data Source (Human development): "https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv"
# Data Source (Gender inequality): "https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv"

## Data wrangling 4

# Load readr package
library(readr)

# Read in the “Human development” and “Gender inequality” data sets 
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Explore the datasets

# See the structure of the data.
str(hd)
str(gii)

# See the dimension of the data.
dim(hd)
dim(gii)

# Create summaries of the variables
summary(hd)
summary(gii)

# Look at the meta files and rename the variables with (shorter) descriptive names

# Check the column names before changing them
colnames(hd)
colnames(gii)

# Rename columns for the Human Development data set
colnames(hd) <- c("HDI.Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Minus.Rank")

# Rename columns for the Gender Inequality data set
colnames(gii) <- c("GII.Rank", "Country", "GII", "Mat.Mor", 
                   "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", 
                   "Labo.F", "Labo.M")

# Check the column names again
colnames(hd)
colnames(gii)

# Mutate the “Gender inequality” data and create two new variables. 

# Load the dplyr library
library(dplyr)

# Create new variables
gii <- gii %>%
  mutate(Edu_Ratio = Edu2.F / Edu2.M,
         LF_Ratio = Labo.F / Labo.M)

# Join together the two datasets
human <- inner_join(hd, gii, by = "Country")

# Check the dimensions of the resulting data frame
dim(human)

# Save the joined data to a CSV file
write_csv(human, "/Users/minmaunu/IODS-project/data/human.csv")

# Done! 
