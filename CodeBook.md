# CodeBook

The code is structured in the follows blocks

a) **Packages and data project**.
* Verification of required libraries
* Verification that the data project is presents in the local folder

b) **The requirements**
* 1. Merges the training and the test sets to create one data set.
* 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
* 3. Uses descriptive activity names to name the activities in the data set
* 4. Appropriately labels the data set with descriptive variable names. 
* 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Libraries and data project

### Verify required libraries
 First of all, I verifying that exits the required packages. The *installed.packages()* function will be used to obtain the packages that are installed. With *rownames()* i will obtain the package name. With *match()* function I will see if dplyr and tidyr libraries are presents in the system.


### Download the required data if not present
 If the folder not contain the data source, I proceed to download and unzip the data. I use the download.file() function that permit download the zip file in our local drive. The unzip() function extract the data from the zipped file.


## The requeriments

### 1. Merges the training and the test sets to create one data set.
 I import the data files to follow frames, using read.table() function:
* **data_x_train** from X_train.txt
* **data_y_train** from y_train.txt
* **data_subject_train** from subject_train.txt
I use use *cbind()* to combine the three tables to **data_train**

 Also, I import the test files:
* **data_x_test** from X_test.txt
* **data_y_test** from y_test.txt
* **data_subject_test** from subject_test.txt
Using *cbind()*, I assing to **data_test** those three files.

Finally, I merge the training and test data in one data set calling **data_merge** using *rbind()* which permit combine the data by rows.


### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
 To extract the required data, I use the grepl() function, which search for matches. According the requeriment, I will search by mean and std. As you can see, I include the "Subject" and "Activity" cols, than contains data that I will can need.


### 3. Uses descriptive activity names to name the activities in the data set
 I use the merge() function. This function permit merge two data frames by common columns or row names, and do other versions of database join operations. This join operation will permit assign the activity name instead of id. The result will saved in **data_filtered_activity_labels**. Note that merge() will create one column at begin. With *data_filtered_activity_labels[-1]* I remove such column.


### 4. Appropriately labels the data set with descriptive variable names.

 For this, I use the names() function, that permit relabel the labels of dataframe. Also I use gsub() to make the label a little more readable.


### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

 I used the dplyr librar to group by activity and subject, and to have the average of each variable. To save the data in a local file, I use the *write.table()* function
