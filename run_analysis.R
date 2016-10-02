# install and load dependent packages
requiredPackages = c('plyr','dplyr')
for(p in requiredPackages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  library(p,character.only = TRUE)
}

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
write.table(data_new, file = "new_dataset.txt")