#README#
##Getting and Cleaning Data - Course Project ##

This is the course project for the Getting and Cleaning Data course offered by Coursera/Johns Hopkins University. 

The R script, run_analysis.R, does the following:

- Creates a directory called "data" if it does not already exist in the working directory.
- Downloads and unzips the data files provided to this directory.  (The files for the assignment are found here:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.)
- Loads the activity and feature information.
- Loads both the training and test datasets.
- Merges the datasets.
- Keeps only those variables which reflect a mean or standard deviation.
- Uses descriptive activity names to name the activities in the data set.
- Labels the dataset with descriptive variable names.
- Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
- The end result is shown in the file "tidy.txt."
### Execution ###
Install the data.table package.

The script run_analyisis.R creates a relative ./data directory in which it downloads the zip file, unzips files, tidies the data as described, and writes the resulting file (tidy_data.txt).

Please see the associated Code Book for details on the data set, the script, and the variables.
