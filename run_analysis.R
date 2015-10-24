# 
# Coursera Getting and Cleaning Data
# Course Project
#
# For details about this project::
# - README.md   : Contains the description.
# - CodeBook.md : Describes the variables, the data, and details of how is performed clean up the data.
#

# Verify that exists the required libraries

installed_pack<-rownames(installed.packages())

if ( "dplyr" %in% installed_pack == TRUE) {
   library(dplyr)
  } else  {
   stop("Please, install library dplyr")
  }

if ( "tidyr" %in% installed_pack == TRUE) {
   library(tidyr)
  } else  {
   stop ("Please, install library tidyr")
   return()
  }

# Download the required data if not present
if (file.exists("UCI HAR Dataset") == FALSE) { 
   print ("The data file is not present. Download... please wait")
   fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   download.file(fileUrl, destfile="./ProjectData.zip", method="curl")
   unzip("./ProjectData.zip", exdir=".")
  }
# Verify if the data is present
if (file.exists("UCI HAR Dataset") == FALSE) {
   stop("The data is not present. You can try download it manually. Please refer to CodeBook.md")
  }

#
# 1. Merges the training and the test sets to create one data set.
# 

## 1.a Import trainig data
print ("Import training data...")
data_x_train       <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE )
data_y_train       <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE, col.names=c("Activity") )
data_subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, col.names=c("Subject") )

data_train<-cbind( data_x_train, data_subject_train ,data_y_train)

## 1.b Import test data
print ("Import test data...")
data_x_test       <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE )
data_y_test       <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE, col.names=c("Activity") )
data_subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, col.names=c("Subject") )

data_test<-cbind( data_x_test, data_subject_test, data_y_test)

## 1.c Merge training and test data
data_merge<-rbind(data_train,data_test)

#
# 1. Result. data_merge contains the training and test data
#

## ----------------------------------------------------------------------------------------

#
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#

measurements_names_file <- read.table("./UCI HAR Dataset/features.txt", header=FALSE, col.names=c("Id","Measurement.Name") )
measurements_names      <- c(as.vector(measurements_names_file[,"Measurement.Name"]), "Subject", "Activity")

filtered_measurements_ids  <- grepl("mean|std|Subject|Activity",measurements_names) & !grepl("meanFreq",measurements_names)
data_filtered_measurements <- data_merge[, filtered_measurements_ids]

# data_filtered_measurements contains the measurements on the mean and standard deviation for each measurement

## -----------------------------------------------------------------------------------------

#
# 3. Uses descriptive activity names to name the activities in the data set
#

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, col.names=c("Id","Activity.Name") )
data_filtered_activity_labels<-merge(data_filtered_measurements,activity_labels,by.x="Activity",by.y="Id", all.x=TRUE)
data_filtered_activity_labels<-data_filtered_activity_labels[-1]

# data_filtered_activity_labels contains descriptive activity names in Activity.Name column


## -----------------------------------------------------------------------------------------


#
# 4. Appropriately labels the data set with descriptive variable names. 
#


names(data_merge)<-measurements_names

# To assing labels to filtered data
measurements_names_filtered          <- measurements_names[filtered_measurements_ids]
measurements_names_filtered          <-gsub("\\()","",measurements_names_filtered)
names(data_filtered_activity_labels) <- measurements_names_filtered

# the labels of data_filtered_activity_labels have the descriptive variable names


#
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#

tidy_data_filtered <- tbl_df(data_filtered_activity_labels) 
tidy_data_group    <- group_by(tidy_data_filtered,Activity,Subject)
tidy_data_result   <- summarise_each(tidy_data_group,funs(mean))

write.table(tidy_data_result,file="tidy_data_result.txt",row.name=FALSE)

