# Getting & Cleaning Data Course Project README  
  
  
The deliverables are:-  
1 - the R script [run_analysis.R]  
2 - the Code book [CodeBook.txt]  
3 - the tidy data [Tidy.txt]  
4 - the tidy means data [TidyMeans.txt]  
5 - the README file [README.md]  

These are explained individually below:-  
  
  
## 1 - the R script [run_analysis.R]  

This script contains the complete R script for the project from download of raw data  
from a url to producing the tidy dataset.  

However, due to factors like connectivity & download speed it is better to run this in  
three parts as marked in the script & also explained here  
  
### PART 1
This will download the data zip file from the url into the local machine  

### PART 2  
This will unzip the data files from the downloaded zip file in Part 1  
The datafiles will be stored in a folder 'data/'  

### PART 3  
This forms rest of the script  
There are a number of steps performed here, properly marked in the script.    
It collates the data from various data files into one Data Frame (X), filtering out  
the data not required further. It renames variables, labels activities & stores it  
in X. This tidy data is then written into a file "Tidy.txt" stored in workspace.  
Subsequently it creates a separate tidy data table (XTidyMeans) which averages out  
the data in X to have one row for each subject, each activity. This separate tidy  
data is now ordered by subject, activity.  
This separate data is then stored in a file "TidyMeans.txt" in workspace.    


## 2 - the Code book [CodeBook.txt]

The code book contains the following details about this project:-  
  
- Experimental Study Design  
- Naming Conventions  
- Code Book (variables & descriptions)  
- Summary Info  
  
  
## 3 - the tidy data [Tidy.txt]  
  
This is the clean, collated data from the project without filtering any observations  
One can view this data by following commands:-  
  
data <- read.csv("Tidy.txt")  
View(data)  
  
  
## 4 - the tidy means data [TidyMeans.txt]   
  
This is the separate tidy data that averages out the variable values showing one info  
for each subject, each activity.  

One can view this data by following commands:-  
  
data <- read.csv("TidyMeans.txt")    
View(data)   
  
  
## 5 - the README file [README.md]  
  
This document.  

