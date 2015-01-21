# getdata-010 Coursera course
# Course Project

# Source data
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Note: This script assumes you have downloaded the file and extracted it in the current directory
# If you haven't, the script can do it for you. Just uncomment the following lines:
#
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "HAR_dataset.zip")
#unzip("HAR_dataset.zip")
#

library(plyr)

# 1) Merge the training and the test sets to create one data set.
mergeDataSet <- function(id) {
  train <- read.table(paste("./UCI HAR Dataset/train/", id, "_train.txt", sep=""), header = FALSE)
  test <- read.table(paste("./UCI HAR Dataset/test/", id, "_test.txt", sep=""), header = FALSE)
  merged <- rbind(train, test)

  # free memory
  rm(train, test)

  # return the merged dataset
  merged
}

x <- mergeDataSet("X")
y <- mergeDataSet("y")
subject <- mergeDataSet("subject")

# Add column (variable) names to dataset
names(subject)<-c("subject")
names(y)<- c("activity")

# add the feature names to the dataset
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
names(features) <- c("id" , "name")
names(x) <- features$name

# merge all three datasets into one, and free the memory of the original datasets
data <- cbind(x, subject, y)
rm(x, subject, y, features)

# 2) Extract only the measurements on the mean and standard deviation for each measurement. 
selectedColumns <- names(data)[grep("mean\\(\\)|std\\(\\)|subject|activity", names(data))]
data <- data[ , selectedColumns]
rm(selectedColumns)

# 3) Use descriptive activity names to name the activities in the data set.
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, col.names = c("activity", "activity_name"))

# Activity names are all in upper case. This looks ugly. Fix:
activityLabels$activity_name <- tolower(activityLabels$activity_name)

# Now, join (merge would work too) the descriptive activity names with the data set
# Should also remove the duplicated column (activity id, as it repeats info in activity_name),
# and free unnneeded memory; finally, rename the activity_names column
data <- join(data, activityLabels, by = "activity")
data <- data[, !(names(data) %in% c("activity"))]
names(data)[names(data) == 'activity_name'] <- 'activity'
rm(activityLabels)

# 4) Appropriately label the data set with descriptive variable names. 

# 4.1) Remove parentheses
names(data) <- gsub("\\(|\\)", "", names(data))

# 4.2) Replace dashes with underscores
names(data) <- gsub('-', "_", names(data))

# 4.3) Expand names to make them clearer
names(data) <- gsub("^t", "time_", names(data))
names(data) <- gsub("^f", "frequency_", names(data))
names(data) <- gsub("std", "standard_deviation", names(data))
names(data) <- gsub("Acc", "_accelerometer", names(data))
names(data) <- gsub("GyroJerk", "_gyroscope_jerk", names(data))
names(data) <- gsub("Gyro", "_gyroscope", names(data))
names(data) <- gsub("Mag", "_magnitude", names(data))
names(data) <- gsub("BodyBody", "body", names(data))
names(data) <- gsub("Body", "body", names(data))
names(data) <- gsub("Jerk", "_jerk", names(data))
names(data) <- gsub("Gravity", "gravity", names(data))

# Store this dataset
write.table(data, "mean_and_std.txt")

# 5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
averages <- aggregate(. ~subject + activity, data, mean)
write.table(averages, "averages.txt")
