
# Minna Maunula
# Date: [21th of November 2023]
# File Description: This file contains R script for data wrangling of assignment 3.
# Data Source: http://www.archive.ics.uci.edu/dataset/320/student+performance

## Data wrangling

# Aim of this analysis is to interpret (student-mat.csv) and (student-por.csv), combine these two data sets, remove duplicates and save the results into a new csv file.

# Data was downloaded from the webpage and csv files were transferred into the project folder I'm currently working at ("/Users/minmaunu/IODS-project/data/".

library(readr)

# Read the file path for student-mat.csv 
file_path <- "/Users/minmaunu/IODS-project/data/student-mat.csv"

# Read the CSV file into R using read_csv2
stud_math <- read_csv2(file_path)

# Display the first few rows of the data
head(stud_math)

# Look at the structure of the data
str(stud_math)

# Look at the dimensions of the data
dim(stud_math)

# stud_math has 395 rows (observations) and 33 columns (variables)

# Read the file path for student-por.csv
file_path <- "/Users/minmaunu/IODS-project/data/student-por.csv"

# Read the CSV file into R using read_csv2
stud_por <- read_csv2(file_path)

# Display the first few rows of the data
head(stud_por)

# Look at the structure of the data
str(stud_por)

# Look at the dimensions of the data
dim(stud_por)

# stud_por has 649 rows (observations) and 33 columns (variables)

# Look at the column names of both data sets
colnames(stud_math); colnames(stud_por)

# Join the two data sets using all other variables than "failures", "paid", "absences", "G1", "G2", "G3" as (student) identifiers. 
# Keep only the students present in both data sets. Explore the structure and dimensions of the joined data.

# access the dplyr package
library(dplyr)

# Identify columns to use as identifiers
identifiers <- setdiff(names(stud_math), c("failures", "paid", "absences", "G1", "G2", "G3"))

# Inner join the datasets using identifiers
merged_data <- inner_join(stud_math, stud_por, by = identifiers)

# Explore the structure and dimensions of the joined data
str(merged_data)
dim(merged_data)

# merged_data has 370 rows and 39 columns 

# Get rid of the duplicate records in the joined data set with the if-else structure. 

# give the columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(stud_por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(stud_math, stud_por, by = join_cols)

# look at the column names of the joined data set
colnames(math_por)

# glimpse at the joined data set
glimpse(math_por)

# add suffix to column names during the join
math_por <- inner_join(stud_math, stud_por, by = join_cols, suffix = c(".math", ".por"))

# create a new data frame with only the joined columns
combined_math_por <- select(math_por, all_of(join_cols))

# for every column name not used for joining...
for (col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if (is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    combined_math_por[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    combined_math_por[col_name] <- first_col
  }
}

# glimpse at the new combined data
glimpse(combined_math_por)

# data has 370 rows and 28 columns

# Calculate the average of weekday and weekend alcohol consumption
combined_math_por$alc_use <- rowMeans(select(combined_math_por, ends_with(".Walc"), ends_with(".Dalc")), na.rm = TRUE)

# Create a new logical column 'high_use'
combined_math_por$high_use <- combined_math_por$alc_use > 2

# Print the first few rows of the updated dataset
head(combined_math_por)

# take a glimpse of the data
glimpse(combined_math_por)

# data has 370 rows and 30 columns

# Specify the file path where you want to save the CSV file
file_path <- "/Users/minmaunu/IODS-project/data/combined_math_por.csv"

# Use write_csv to save the dataset to the specified file path
write_csv(combined_math_por, file_path)

# Print a message indicating that the file has been saved
cat("Dataset saved to:", file_path, "\n")

# Done!