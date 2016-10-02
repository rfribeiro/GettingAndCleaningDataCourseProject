# Peer-graded Assignment: Getting and Cleaning Data Course Project
      
These are the basic steps that describe the files 
and how to execute scripts to accomplish Getting and Cleaning Data course project.

Files:
 * Readme.md
 * Codebook.md
 * run_analysis.R

### Readme.md
The file that contains description of how to execute the scripts and others useful data.
    
### CodeBook.md
File that contains a description of all variables, the data, and any transformations or work that were performed to clean up the data

### run_analysis.R
The script that executes all the steps to download, clean up and transformations on the dataset to produce the correctly exit file

### Script Execution
In order to execute and get correctly data from the current script you have to follow the steps:

1. Download files from github repository:
```
git clone https://github.com/rfribeiro/GettingAndCleaningDataCourseProject.git
```
2. Open RStudio
3. Load run_analysis.R file on RStudio
```
source('C:/GettingAndCleaningDataCourseProject/run_analysis.R')
```
4. Execute function run_analysis
```
> run_analysis()
```
5. The exit will be a file called "new_dataset.txt" on same folder of git repository
6. To read new dataset type:
```
new_data <- read.table("new_dataset.txt", header = TRUE)
```