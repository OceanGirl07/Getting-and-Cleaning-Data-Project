# Project for Getting and Cleaning Data
# June 9, 2017
## run_analysis.R 


## load packages
library(data.table)

## set working directory
setwd("~/Desktop")

## download data and put it in data folder
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip", method="curl")

## unzip file in directory "data"
unzip(zipfile = "./data/Dataset.zip", exdir = "./data") 

#get list of files
list.files(path = "./data") #we see the folder "UCI HAR Dataset" contains the files required
files<- list.files(path = "./data/UCI HAR Dataset", recursive = TRUE) #recursive = TRUE lets us look in the subdirectories.
files


#1. Merge the training and the test sets to create one data set.

## load features and activity labels

#read features.txt, set column names.  
features <- fread("./data/UCI HAR Dataset/features.txt", col.names = c("activityId", "featuresName"))

#read activity labels, set column names
ActivityLabels <- data.table::fread("./data/UCI HAR Dataset/activity_labels.txt", col.names = c("activityId", "activityName"))

#read training tables 
Xtrain <- data.table::fread("./data/UCI HAR Dataset/train/X_train.txt")
Ytrain <- data.table::fread("./data/UCI HAR Dataset/train/y_train.txt")
SubjectTrain <- data.table::fread("./data/UCI HAR Dataset/train/subject_train.txt")

#assign consistent column names for future merge
colnames(Xtrain) <- features$featuresName
colnames(Ytrain) <-"activityId"
colnames(SubjectTrain) <-"subjectId"

#read testing tables
Xtest <- data.table::fread("./data/UCI HAR Dataset/test/X_test.txt")
Ytest <- data.table::fread("./data/UCI HAR Dataset/test/y_test.txt")
SubjectTest <- data.table::fread("./data/UCI HAR Dataset/test/subject_test.txt")

#assign column consistent names for future merge
colnames(Xtest) <- features$featuresName
colnames(Ytest) <-"activityId"
colnames(SubjectTest) <-"subjectId"
       
#Merge data into one set.  We do this in 2 steps, first with rbind to form 3 data frames (of combined train/test data for subjects, activity, features, respectively),
#then cbind to put these three togehter into one data frame, "Data."
        
        #concatenate data tables for training and testing sets by row.
        dataSubject <- rbind(SubjectTrain,SubjectTest)
        dataActivity <- rbind(Ytrain,Ytest)
        dataFeatures <- rbind(Xtrain, Xtest) 
        
        
        #set names to variables
        names(dataSubject) <- "subjectId" 
        names(dataActivity) <- "activityId"
        names(dataFeatures) <- features$featuresName #take second column "featuresName" from features for descriptive names.  Prior to this, the column names were "V1" through "V561."
        
        #cbind to put all in one data frame called Data
        Data <- cbind(dataFeatures, dataSubject, dataActivity)
        
        #note: Data is a data frame with [train subject, train activity, train features; test subject, test activity, test features]. This is the required data set for part 1.


# 2. Extract only the measurements on the mean and standard deviation for each measurement.

        # subset by taking featuresNames that are either mean() or std()
        subfeatures <- features$featuresName[grep("mean\\(\\)|std\\(\\)", features$featuresName)] #keep only data with mean() or std()
        
        # subset Data by selected names in features, assign to data table "Data2"
        selectedNames <- c(subfeatures, "subjectId", "activityId")  
        Data2 <- subset(Data, select = selectedNames) 
        
        #note: Data2 is a data frame that satisfies part 2.
        
# 3. Use descriptive activity names to name the activities in the data set
        
        # need to replace Data2$activity "activityId" (1-6) wth "activityName" ("WALKING", etc.)  from the ActivityLabels
        DataB <- merge(Data2, ActivityLabels, by = "activityId", all.x = TRUE) 
        
        #note: DataB is a data frame that satisfies part 3.
        
# 4. Appropriately label the data set with descriptive variable names.
        # replace prefix t with time
        names(DataB) <-gsub("^t", "time", names(DataB))
        # replace prefix f with frequency
        names(DataB) <-gsub("^f", "frequency", names(DataB))
        #r eplace Mag by Magnitude
        names(DataB) <-gsub("Mag", "Magnitude", names(DataB))
        # replace Acc by Acceleration
        names(DataB) <-gsub("Acc", "Acceleration", names(DataB))
        # replace Gyro by Gyroscope
        names(DataB) <-gsub("Gyro", "Gyroscope", names(DataB))
        # replace BodyBody by Body, also make cases consistent
        names(DataB) <-gsub("[Bb]ody[Bb]ody","Body", names(DataB))
        # eliminnate parentheses for mean and standard deviation
        names(DataB) <-gsub("\\()", "", names(DataB))
        # eliminate hyphen and change case
        names(DataB) <-gsub("-mean", "Mean", names(DataB))
        # eliminate hyphen, change case, make more readable
        names(DataB) <-gsub("-std", "StandardDeviation", names(DataB))
 
       #note: DataB is a data frame that now satisfies part 4.
        
# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
        
        TidySet <- aggregate(DataB, by=list(DataB$subjectId, DataB$activityName), FUN = mean, na.rm = TRUE)
        #drop the columns where averages don't make sense.
        drops = c("activityId", "activityName","subjectId")
        TidySet <- TidySet[, !names(TidySet) %in% drops] 
        
        #write data set to txt file.
        write.table(TidySet, "tidy.txt", row.names = FALSE, quote = FALSE) #eliminate quotes from characters and factors
        
        # note: TidySet is a data fram that satisfies part 5.  We wrote the data frame to the text file "tidy.txt."
        
        
        
