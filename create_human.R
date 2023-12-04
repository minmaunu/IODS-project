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
write_csv(human, "/my_file_path/IODS-project/data/human.csv")

# Done! 


# Data Wrangling 5 continues from here 
# Date: [4th of December 2023]
# This data set is originated from the last data wrangling excercise, but the metadata can be also found from here: https://github.com/KimmoVehkalahti/Helsinki-Open-Data-Science/blob/master/datasets/human_meta.txt

# Load readr package
library(readr)

# Specify the file path into CSV file
file_path <- "/my_file_path/IODS-project/data/human.csv"

# Read the CSV file into a data frame
human <- read_csv(file_path)

# Explore the datasets

# See the structure of the data.
str(human)

# See the dimension of the data.
dim(human)

# Human data set has in total 195 observations (rows) and 19 variables (columns) of which 18 are numeric variables and one ("Country") is character variable. 
# Variable names are as follows: 
colnames(human)

# "HDI.Rank"       "Country"        "HDI"            "Life.Exp"       "Edu.Exp"       #
# "Edu.Mean"       "GNI"            "GNI.Minus.Rank" "GII.Rank"       "GII"           #
# "Mat.Mor"        "Ado.Birth"      "Parli.F"        "Edu2.F"         "Edu2.M"        #
# "Labo.F"         "Labo.M"         "Edu_Ratio"      "LF_Ratio"                       #

# Description of data set and variables 

# "Country" = Country name

# "GNI" = Gross National Income per capita
# "Life.Exp" = Life expectancy at birth
# "Edu.Exp" = Expected years of schooling 
# "Mat.Mor" = Maternal mortality ratio
# "Ado.Birth" = Adolescent birth rate
# "Parli.F" = Percetange of female representatives in parliament
# "Edu2.F" = Proportion of females with at least secondary education
# "Edu2.M" = Proportion of males with at least secondary education
# "Labo.F" = Proportion of females in the labour force
# "Labo.M" " Proportion of males in the labour force
# "Edu_Ratio" = Edu2.F / Edu2.M
# "LF_Ratio" = Labo2.F / Labo2.M

# Create summaries of the variables
summary(human)

# Load dplyr package
library(dplyr)

# Specify the columns to keep
columns_to_keep <- c("Country", "Edu_Ratio", "LF_Ratio", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# Select only the specified columns
human_selected <- select(human, columns_to_keep)

# View the structure and dimensions of the updated data set
str(human_selected)
dim(human_selected)

# Now the data has 195 observations and only 9 variables (columns)

# Remove rows with missing values
human_no_na <- na.omit(human_selected)

# Check the structure and dimensions of the updated data set
str(human_no_na)
dim(human_no_na)

# After flitering the data has 162 observations (rows) and 9 variables (columns)

# Filter out observations related to regions
human_countries <- human_no_na %>% 
  filter(!grepl("Region", Country, ignore.case = FALSE))

# View the structure and dimensions of the updated data set
str(human_countries)
dim(human_countries)

# remove the observations which relate to regions instead of countries
human_countries$Country # seven last observations are regions
human_countries <- head(human_countries, -7)

# Check the dimension of the updated data set 
dim(human_countries)

# Data has now 155 observations and 9 variables 

# overwrite the old 'human' data with human_countries
human <- human_countries

# Save the human data in the data folder
write_csv(human, "/Users/minmaunu/IODS-project/data/human.csv")
