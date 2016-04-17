## Getting and Cleaning Data
## Final Course Project

## The following steps will take you through how to Merge the training
## and test data from the accelerometers from the Samsung Galaxy Smartphone.
## Then it will explain how to extract only the measurements and Standard
## Deviation for each measurement. It will use descriptive activity to name
## the activities in the data set, and then appropriately label the data 
## set with descriptive variable names. Finally it will create a second 
## independent tidy data set with the average of each variable for each
## activity and subject.

## 1 Merge the training datasets into one data set.
## 1a. Download the data

> if(!file.exists("./data")){dir.create("./data")}
> fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> download.file(fileUrl,destfile="./data/Dataset.zip", method="curl")

## 1b. Unzip the files and then you will see the list of file names. 
> unzip(zipfile="./data/Dataset.zip",exdir="./data")
> path_rf <- file.path("./data" , "UCI HAR Dataset")
> files <- list.files(path_rf, recursive=TRUE)
> files

## 1c. Read the data from the Activity, Subject, and Features files
> ActivityTestData <- read.table(file.path(path_rf, "test" , "Y_test.txt"), header = FALSE)
> ActivityTrainData <- read.table(file.path(path_rf, "train", "Y_train.txt"), header = FALSE)
> SubjectTrainData <- read.table(file.path(path_rf, "train", "subject_train.txt"), header = FALSE)
> SubjectTestData <- read.table(file.path(path_rf, "test", "subject_test.txt"), header = FALSE)
> FeaturesTestData <- read.table(file.path(path_rf, "test", "X_test.txt"), header = FALSE)
> FeaturesTrainData <- read.table(file.path(path_rf, "train", "X_train.txt"), header = FALSE)

## 1d. Merge the training data sets to create one data set
> SubjectData <- rbind(SubjectTrainData, SubjectTestData)
> ActivityData <- rbind(ActivityTrainData, ActivityTestData)
> FeaturesData <- rbind(FeaturesTrainData, FeaturesTestData)

## 2e. Set names to the variables
> names(SubjectData) <- c("subject")
> names(ActivityData) <- c("activity")
> FeaturesNamesData <- read.table(file.path(path_rf, "features.txt"), head=FALSE)
> names(FeaturesData) <- FeaturesNamesData$V2

## 2f. Merge the columns to get the data frame for all of the data.
> CombineData <- cbind(SubjectData, ActivityData)
> Data <- cbind(FeaturesData, CombineData)

## 2a. Extract the measurements on the mean and standard deviation for each measurement
> FeaturesNamesSubdata <- FeaturesNamesData$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNamesData$V2)]
> selectedNames <- c(as.character(FeaturesNamesSubdata), "subject", "activity")
> Data <- subset(Data, select=selectedNames)

## 2b. You can use the following to preview the data:
> str(Data)

## 3a. Create activity labels
> activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"), header = FALSE)
> head(Data$activity,30)

## 4a. Use descriptive names to name the activities in the dataset
> names(Data) <- gsub("^t", "time", names(Data))
> names(Data) <- gsub("^f", "frequency", names(Data))
> names(Data) <- gsub("Acc", "Accelerometer", names(Data))
> names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
> names(Data) <- gsub("Mag", "Magnitued", names(Data))
> names(Data) <- gsub("BodyBody", "Body", names(Data))

## 4b. You can use the following to preview the new labels: 
> names(Data)

## 5a. Create a separate, second tidy data set with the average of each variable for each activity and subject.
> library(plyr);
> Data2 <- aggregate(. ~subject + activity, Data, mean)
> Data2 <- Data2[order(Data2$subject, Data2$activity),]
> write.table(Data2, file = "tidydata.txt", row.name = FALSE)
