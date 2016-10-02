# download file
assignment_file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
assignment_dest_file <- "assignment.zip"
download.file(assignment_file, destfile = assignment_dest_file, method = "curl")

# Unzip files
unzip(assignment_dest_file, exdir = ".")