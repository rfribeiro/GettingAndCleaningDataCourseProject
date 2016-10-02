# CodeBook
File that contains a description of all variables, the data, and any transformations or work that were performed to clean up the data
The details will be split on the following sections

- **Dataset download**
- **Dataset files**
- **Dataset variables**
- **Dataset cleanup and merge**
- **New dataset file description**
- **Script details: run_analysis.R**

### Dataset download
The dataset used for this assignment was provided from Coursera class.

It was available at the below link:
```
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
```
The dataset was collected from UCI dataset repository:
```
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
```
The original dataset has 10299 instances with 561 variables

The dataset was splitted into training and testing in the proportion of 70% to 30% sample randomly.

This way the training files have 7352 samples and test files have 2947 samples.

For more details visit the UCI repository link

### Dataset files
After extracted the dataset was devided on many folders and files

In main folder it has 4 files:
* **activity_labels.txt** - the labels of the activities in order
* **features.txt** - the variables names for all the 561 variables based on features_info.txt information
* **features_info.txt** - describe the how the features were generated and how the names
* **README.txt** - describe the dataset structure and other informations

And 2 folders:

It is important to clarify that the data from both folders have the same meaning, the only difference is the number of samples that have in each folder
* **test** - folder that contains the data of test samples, it has others files in it
	* subject_test.txt - it has all the ID of the persons that executed the test
	* X_test.txt - it has all the measurements collected from persons
	* y_test.txt - it has all the labels of the activities that persons executed
	* Inertial Signals - Not used - it has raw that from sensors
* **train** - folder that contains the data of train samples, it has others files in it
	* subject_train.txt - it has all the ID of the persons that executed the test
	* X_train.txt - it has all the measurements collected from persons
	* y_train.txt - it has all the labels of the activities that persons executed
	* Inertial Signals - Not used - it has raw that from sensors

### Dataset variables

The dataset have many variables that were described on features_info.txt, but we will insert some of the comments here for a better comprehension

and it is important to say that we included 2 other columns that are the activity and subject (person)

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value

std(): Standard deviation

mad(): Median absolute deviation 

max(): Largest value in array

min(): Smallest value in array

sma(): Signal magnitude area

energy(): Energy measure. Sum of the squares divided by the number of values. 

iqr(): Interquartile range 

entropy(): Signal entropy

arCoeff(): Autorregresion coefficients with Burg order equal to 4

correlation(): correlation coefficient between two signals

maxInds(): index of the frequency component with largest magnitude

meanFreq(): Weighted average of the frequency components to obtain a mean frequency

skewness(): skewness of the frequency domain signal 

kurtosis(): kurtosis of the frequency domain signal 

bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.

angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean

tBodyAccMean

tBodyAccJerkMean

tBodyGyroMean

tBodyGyroJerkMean

### Dataset cleanup and merge

For the assignment we follow the below steps:
1. Load test information (subject_test.txt, Y_test.txt. X_test.txt) with variables names loaded from features.txt and already set column name for subject and activity


2. Load train information (subject_train.txt, Y_train.txt. X_train.txt) with variables names loaded from features.txt and already set column name for subject and activity


3. Select and extract only the columns that have mean and std on its names from train and test data


4. Join subject_test.txt, Y_test.txt. X_test.txt files by column using cbind


5. Join subject_train.txt, Y_train.txt. X_train.txt files by column using cbind


6. Discretize the values of activity column


7. Merge train and test data by rows using rbind

The final merged data have 10299 rows and 81 columns where first is the subject and second is the activity, followed by 79 measurements variable with only mean and std data

### New dataset file description

Using the data cleaned and merged from previous step we generate a new dataset with the instruction that is: 

**Creates a second, independent tidy data set with the average of each variable for each activity and each subject.**

To accomplish this task we executed these steps:

we use ddapply function to group the data by activity and subject and after that we calculated the mean of each column bitwise
```
data_new <- ddply(data_total, .(activity, subject), colwise(mean))
```

after that we save new dataset on current git project folder with the name of "new_dataset.txt".

The new dataset was saved with HEADER information and without row information.

To read the new dataset please execute the command below:
```
new_data <- read.table("new_dataset.txt", header = TRUE)
```

The new dataset has 180 rows and 81 columns.

### Script details: run_analysis.R 

The run_analysis.R script has some functions inside it that I try to explain what each function is resposible for.

* download_dataset

	This function is in charge to download and unzip the dataset this assignment.
    
    
* install_dependences

	This function install the dependent packages to run the script
    
* set_working_folder

	This function set the current working directory to same directory of the git project repository
    
    
* run_analysis

	This is the main function of the assignment it is responsible to call the others functions, clean, merge the data and generate new dataset