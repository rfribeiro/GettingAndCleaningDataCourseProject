# get current directory to script folder
script.directory <- dirname(sys.frame(1)$ofile)

download_dataset <- function() {
  # download file
  assignment_file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  assignment_dest_file <- "assignment.zip"
  
  # downloading file
  print(paste("Downloading dataset from :", assignment_file))
  download.file(assignment_file, destfile = assignment_dest_file, method = "curl")
  
  # Unzip files
  print("Extracting dataset files!")
  unzip(assignment_dest_file, exdir = ".")
  
  if (!file.exists("UCI HAR Dataset")) return (FALSE) else return (TRUE)
}

# install and load dependent packages
install_dependences <- function() {
  requiredPackages = c('plyr','dplyr')
  for(p in requiredPackages){
    if(!require(p,character.only = TRUE)) install.packages(p)
    library(p,character.only = TRUE)
  }
}

set_working_folder <- function() {
  if (getwd() != script.directory)
  {
    print(paste("Current directory NOT set correctly : ", getwd()))
    setwd(script.directory)
    if (getwd() != script.directory) answer <- FALSE else answer <- TRUE
    print(paste("Setting current directory to correct", answer, ":", getwd()))
  }
  else
  {
    print(paste("Current directory set correctly : ", getwd()))
  }
}

run_analysis <- function() {
  # load dependent libraries
  install_dependences()
  
  # set working directory
  set_working_folder()
  
  # check if dataset folder exist
  if (!file.exists("UCI HAR Dataset"))
  {
    ans <- readline(prompt="Dataset NOT exist, do you like to download it?")
    if (ans != "y" && ans != "Y") 
    {
      stop("Dataset NOT exist, exiting!!!")
    }
    
    # download and unzip dataset
    if (download_dataset() == TRUE) 
    {
      print("Dataset downloaded and extracted correctly")  
    }
    else
    {
      stop("Problem occurred when downloading and extracting dataset!")
    }
  }

  print("Dataset exist, starting to analyse it!")
  
  # files path
  activity_labels_file <- ".\\UCI HAR Dataset\\activity_labels.txt"
  features_labels_file <- ".\\UCI HAR Dataset\\features.txt"
  
  x_train_file <- ".\\UCI HAR Dataset\\train\\X_train.txt"
  y_train_file <- ".\\UCI HAR Dataset\\train\\Y_train.txt"
  sub_train_file <- ".\\UCI HAR Dataset\\train\\subject_train.txt"
  train_files <- c(sub_train_file, x_train_file, y_train_file)
  
  x_test_file <- ".\\UCI HAR Dataset\\test\\X_test.txt"
  y_test_file <- ".\\UCI HAR Dataset\\test\\Y_test.txt"
  sub_test_file <- ".\\UCI HAR Dataset\\test\\subject_test.txt"
  test_files <- c(sub_test_file, x_test_file, y_test_file)
  
  #constants
  activity_label <- c("activity")
  subject_label <- c("subject")
  
  
  # load files
  print("Loading dataset files!")
  activity_labels <- read.table(activity_labels_file)
  names(activity_labels) <- c("activity_index", "activity_label")
  
  features_labels <- read.table(features_labels_file)
  names(features_labels) <- c("feature_index", "feature_label")
  
  data_train_x <- read.table(x_train_file, col.names = features_labels$feature_label, check.names = FALSE)
  data_train_y <- read.table(y_train_file, col.names = activity_label)
  data_train_subjects <- read.table(sub_train_file, col.names = subject_label)
  
  data_test_x <- read.table(x_test_file, col.names = features_labels$feature_label, check.names = FALSE)
  data_test_y <- read.table(y_test_file, col.names = activity_label)
  data_test_subjects <- read.table(sub_test_file, col.names = subject_label)
  
  # select only columns that have mean and std values
  mean_features_idx <- grep("mean()", features_labels$feature_label)
  std_features_idx <- grep("std()", features_labels$feature_label)
  
  # extract only mean and std columns (sorted) from measurements 
  data_train_x <- data_train_x[,sort(c(mean_features_idx, std_features_idx))]
  data_test_x <- data_test_x[,sort(c(mean_features_idx, std_features_idx))]
  
  # merge train and test column
  print("Merging data")
  data_train <- cbind(data_train_subjects, data_train_y, data_train_x)
  data_test <- cbind(data_test_subjects, data_test_y, data_test_x)
  
  # join train and test data
  data_total <- rbind(data_train, data_test)
  
  # descriptive names of the activities
  data_total$activity <- factor(data_total$activity, labels = activity_labels$activity_label)
  data_total$subject <- as.factor(data_total$subject)
  
  # delete unused data to clean memory
  rm(list = c("data_train", "data_test", "data_train_x", "data_test_x", "data_train_y", "data_test_y", "data_train_subjects", "data_test_subjects"))
  
  # calculate mean for each column grouped by activity and subject
  data_new <- ddply(data_total, .(activity, subject), colwise(mean))
  
  # save new dataset in files
  print("Writing new dataset!")
  write.table(data_new, file = "new_dataset.txt", row.names = FALSE)
  if (file.exists("new_dataset.txt"))
  {
    print("Everything finished correctly!")
  }
  else
  {
    stop("Problem occurred when saving new dataset!")
  }
}