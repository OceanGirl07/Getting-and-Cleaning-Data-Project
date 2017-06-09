# Code book
## Getting and Cleaning Data Course Project ##

## Introduction 
One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The overarching goal of this project is to write one R script called run_analysis.R which does the following:

  - Merges the training and the test sets to create one data set.
  - Extracts only the measurements on the mean and standard deviation for each measurement.
 - Uses descriptive activity names to name the activities in the data set
 -  Appropriately labels the data set with descriptive variable names. 
 -  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

 
## Description of the data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, experimentalists captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

Each record includes:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables (prepended with a "t" or an "f" respectively. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The relevant files are:
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
## Description of abbreviations of measurements

- a prepended "t" or "f" indicates time or frequency, respectively
- Body relates to body movement
- Gravity is acceleration due to gravity
- Acc is accelerometer measurement 
- Gyro is gyroscopic measurement 
- Jerk is sudden movement or acceleration
- Mag is magnitude of movement
- The -XYZ denotes movement in 3D. 
- units are rad/sec for gyroscope, g's for accelerometer, g/sec or rad/sec^2 for the corresponding jerks.


The signals were used to estimate variables of each features vector.  They were preprocessed by applying noise filers and then sampled in fixed-width sliding windows.  From these signals, the mean and standard deviation were calculated, denoted in the data as
- mean()
- std()

This project will specifically focus on variables that include mean() and std().

## Description of Data Transformation Performed in Script "run_analysis.R"

### Variables in the Code ###
- features: a data frame with columns "activityID" and "featuresName"  It has 561 observations (rows) and describes what was measured in the experiments.
- ActivityLabels: a data frame with columns "activityId" and "activityName".  It associates each of 6 numbers (1-6) to an activity ("WALKING" etc.)
- Xtrain and Xtest: data frames of the training and test data features.  The column names come from the names in the "featuresName" column of features.
- These are combined into variable dataFeatures.
- Ytrain and Ytest: data frames with observations of 1 variable, the column name is "activityID."
- These are combined into variable dataActivity.
- SubjectTrain/SubjectTest: data frames with one variable, the column name is "subjectId."
- These are combined into variable dataSubject.
- Data: a data frame that binds the three frames above by columns.  This is the data set required in Step 1 of the assignment prompt.
- Data2: this is a data frame that extracted only measurements on the mean and standard deviation from the data frame Data.  This is the data set required in Step 2 of the assignment prompt.
- DataB: a data frame where descriptive activity names (i.e., "WALKING" have replaced the labels (numbers 1-6).  This is the data set required in Step 3 of the assignment prompt.  We overwrite it with appropriate labels for the variables, as required in Step 4 of the prompt.
- TidySet: this is a data frame with the average of each variable for each activity and each subject.  It follows the principles of Tidy Data as outlined by Hadley Wickham's paper.  This data set is written to the file "tidy.text," and satisfies Step 5 of the assignment prompt.

### Download and Unzip the Data.
**load packages.**
        

        library(data.table)
        library(reshape2) 

**set working directory.**
    
    setwd("~/Desktop")

**download data and put it in data folder.**

    if(!file.exists("./data")){dir.create("./data")}
    fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile="./data/Dataset.zip", method="curl")

**unzip file in directory "data."**

            unzip(zipfile = "./data/Dataset.zip", exdir = "./data") 

**get list of files.**

    list.files(path = "./data") #we see the folder "UCI HAR Dataset" contains the files required
    files<- list.files(path = "./data/UCI HAR Dataset", recursive = TRUE) 

The files we need are
* Subject Files - test/subject_test.txt, train/subject_train.txt
* Activity Files - test/X_test.txt, train/X_train.txt
* Data Files - test/y_test.txt, train/y_train.txt
* Features File - features.txt
* Activity File - activity_labels.txt

### Create Datatables and Merge.
**Read the required files and create data tables, assigning column names where appropriate.**

    features <- fread("./data/UCI HAR Dataset/features.txt", col.names = c("activityId", "featuresName"))
    ActivityLabels <- data.table::fread("./data/UCI HAR Dataset/activity_labels.txt", col.names = c("activityId", "activityName"))

    Xtrain <- data.table::fread("./data/UCI HAR Dataset/train/X_train.txt")
    Ytrain <- data.table::fread("./data/UCI HAR Dataset/train/y_train.txt")
    SubjectTrain <- data.table::fread("./data/UCI HAR Dataset/train/subject_train.txt")
    colnames(Xtrain) <- features$featuresName
    colnames(Ytrain) <-"activityId"
    colnames(SubjectTrain) <-"subjectId"

    Xtest <- data.table::fread("./data/UCI HAR Dataset/test/X_test.txt")
    Ytest <- data.table::fread("./data/UCI HAR Dataset/test/y_test.txt")
    SubjectTest <- data.table::fread("./data/UCI HAR Dataset/test/subject_test.txt")
    colnames(Xtest) <- features$featuresName
    colnames(Ytest) <-"activityId"
    colnames(SubjectTest) <-"subjectId"

**Merge the data sets.** 
Concatenate data tables for training and testing sets by row, set names to variables, then bind by column.

        dataSubject <- rbind(SubjectTrain,SubjectTest) 
        dataActivity <- rbind(Ytrain,Ytest) 
        dataFeatures <- rbind(Xtrain, Xtest)
        names(dataSubject) <- "subjectId" 
        names(dataActivity) <- "activityId"
        names(dataFeatures) <- features$featuresName 
        Data <- cbind(dataFeatures, dataSubject, dataActivity)

### Extract only the measurements on the mean and standard deviation for each measurement.
        subfeatures <- features$featuresName[grep("mean\\(\\)|std\\(\\)", features$featuresName)] 
        selectedNames <- c(subfeatures, "subjectId", "activityId") 
        Data2 <- subset(Data, select = selectedNames) 
        
### Use descriptive activity names to name the activities in the data set.
        DataB <- merge(Data2, ActivityLabels, by = "activityId", all.x = TRUE) 
        
### Appropriately label the data set with descriptive variable names.
       
        names(DataB) <-gsub("^t", "time", names(DataB))
        names(DataB) <-gsub("^f", "frequency", names(DataB))
        names(DataB) <-gsub("Mag", "Magnitude", names(DataB))
        names(DataB) <-gsub("Acc", "Acceleration", names(DataB))
        names(DataB) <-gsub("Gyro", "Gyroscope", names(DataB))
        names(DataB) <-gsub("[Bb]ody[Bb]ody","Body", names(DataB))
        names(DataB) <-gsub("\\()", "", names(DataB))
        names(DataB) <-gsub("-mean", "Mean", names(DataB))
        names(DataB) <-gsub("-std", "StandardDeviation", names(DataB))
        
### From the data set in the step above, create a second, independent tidy data set with the average of each variable for each activity and each subject.
        TidySet <- aggregate(DataB, by=list(DataB$subjectId, DataB$activityName), FUN = mean, na.rm = TRUE)
        drops = c("activityId", "activityName","subjectId")
        TidySet <- TidySet[, !names(TidySet) %in% drops] 
         write.table(TidySet, "tidy.txt", row.names = FALSE, quote = FALSE)

The tidy data set is saved to the file "tidy.tex."




 