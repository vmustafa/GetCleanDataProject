## PART 1
## download the zipped data file
url_ds_zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url_ds_zip,"Dataset.zip")

## PART 2
## unzip the data file
unzip("Dataset.zip",junkpaths=TRUE,overwrite = TRUE, exdir = "data/.")

## PART 3
## 1 - Merge the X data - training first, test next
## 1.1 - Read X training data
X <- read.table("data/X_train.txt",header=FALSE)

## 1.2 - Read X test data into temporary data frame
Xtest <- read.table("data/X_test.txt",header=FALSE)

## 1.3 - merge the 2 frames
X <- rbind(X,Xtest)
remove(Xtest)

## 2 - get the features as column headings 
featureNames <- read.table("data/features.txt",header=FALSE)
featureNames$V2 <- as.character(featureNames$V2)
colnames(X) <- featureNames[,2]

## 3 - keep only means & std deviation columns
featuresToKeep <- character()
for (i in 1:nrow(featureNames)) {
        if ( (grepl("mean()", featureNames[i,2], fixed=TRUE)) | 
             (grepl("std()", featureNames[i,2],fixed=TRUE)) ) {
                
                featuresToKeep <- c(featuresToKeep,featureNames[i,2])
        }
} 
X <- X[,featuresToKeep]

## 4 - attach subject info into the dataset
subjectID <- read.table("data/subject_train.txt",header=FALSE)
sIDtest <- read.table("data/subject_test.txt",header=FALSE)
subjectID <- rbind(subjectID,sIDtest)
X$subjectID <- subjectID$V1
remove(sIDtest)
remove(subjectID)

## 5 - attach activity info into the dataset
activity <- read.table("data/y_train.txt",header=FALSE)
atest <- read.table("data/y_test.txt",header=FALSE)
activity <- rbind(activity,atest)
X$activity <- activity$V1
remove(atest)
remove(activity)

## 6 - make subjectID & activity as the first 2 columns
order_of_cols <- c("subjectID","activity",featuresToKeep)
X <- X[,order_of_cols]

## 7 - put descriptive activity names
X$activity <- factor(X$activity)
levels(X$activity) <- c("Walking","WalkingUpstairs","WalkingDownstairs",
                        "Sitting","Standing","Laying")

## 8 - renaming the features
## current naming by experts seems adequate & is having a naming convention as 
## follows:-
## a - the physical value is from time (t) or frequency (f) domain
## b - brief name of physical value being measured:-
##     [BodyAcc,GravityAcc,BodyAccJerk,BodyGyro,BodyGyroJerk,
##      BodyAccMag,GravityAccMag,BodyAccJerkMag,BodyAccJerkMag,BodyGyroMag,
##      BodyGyroJerkMag]
## c - further classification of the physical value (if any):- axis (X,Y,Z)
## d - statistical measure of the physical value:- mean(), std()
## changes I am suggesting:-
## 1 - assuming mean() to be the default measure, no need to mention it
## 2 - the measure std() replaced by sd
## 3 - statistical measures are last part of the name
colnames(X) <- 
c("subjectID","activity", "tBodyAccX", "tBodyAccY", "tBodyAccZ", 
  "tBodyAccX_sd", "tBodyAccY_sd", "tBodyAccZ_sd", "tGravityAccX", 
  "tGravityAccY", "tGravityAccZ", "tGravityAccX_sd", "tGravityAccY_sd", 
  "tGravityAccZ_sd", "tBodyAccJerkX", "tBodyAccJerkY", "tBodyAccJerkZ", 
  "tBodyAccJerkX_sd", "tBodyAccJerkY_sd", "tBodyAccJerkZ_sd", "tBodyGyroX", 
  "tBodyGyroY", "tBodyGyroZ", "tBodyGyroX_sd", "tBodyGyroY_sd", "tBodyGyroZ_sd", 
  "tBodyGyroJerkX", "tBodyGyroJerkY", "tBodyGyroJerkZ", "tBodyGyroJerkX_sd", 
  "tBodyGyroJerkY_sd", "tBodyGyroJerkZ_sd", "tBodyAccMag", "tBodyAccMag_sd", 
  "tGravityAccMag", "tGravityAccMag_sd", "tBodyAccJerkMag", "tBodyAccJerkMag_sd", 
  "tBodyGyroMag", "tBodyGyroMag_sd", "tBodyGyroJerkMag", "tBodyGyroJerkMag_sd", 
  "fBodyAccX", "fBodyAccY", "fBodyAccZ", "fBodyAccX_sd", "fBodyAccY_sd", 
  "fBodyAccZ_sd", "fBodyAccJerkX", "fBodyAccJerkY", "fBodyAccJerkZ", 
  "fBodyAccJerkX_sd", "fBodyAccJerkY_sd", "fBodyAccJerkZ_sd", "fBodyGyroX", 
  "fBodyGyroY", "fBodyGyroZ", "fBodyGyroX_sd", "fBodyGyroY_sd", "fBodyGyroZ_sd", 
  "fBodyAccMag", "fBodyAccMag_sd", "fBodyAccJerkMag", "fBodyAccJerkMag_sd", 
  "fBodyGyroMag", "fBodyGyroMag_sd", "fBodyGyroJerkMag", 
  "fBodyGyroJerkMag_sd") 

## 8.1 Write the tidy data into a file
write.table(X, file = "Tidy.txt", row.name = FALSE, sep=",")

## 9 Create a separate tidy dataset giving average feature values for each 
##   (subject,activity)
## 9.1 Order the dataset on (subject, activity) & make datatable for further use
library(data.table)
XTidy <- data.table(X[order(X$subjectID,X$activity),])

## 9.2 set key on the datatable for speed  & perform the group by aggregate
setkey(XTidy,subjectID,activity)
XTidyMeans <- XTidy[,
        list(
                tBodyAccX           = mean(tBodyAccX),
                tBodyAccY          = mean(tBodyAccY),
                tBodyAccZ           = mean(tBodyAccZ),
                tBodyAccX_sd           = mean(tBodyAccX_sd),
                tBodyAccY_sd            = mean(tBodyAccY_sd),
                tBodyAccZ_sd           = mean(tBodyAccZ_sd),
                tGravityAccX        = mean(tGravityAccX),
                tGravityAccY       = mean(tGravityAccY),
                tGravityAccZ        = mean(tGravityAccZ),
                tGravityAccX_sd        = mean(tGravityAccX_sd),
                tGravityAccY_sd         = mean(tGravityAccY_sd),
                tGravityAccZ_sd        = mean(tGravityAccZ_sd),
                tBodyAccJerkX       = mean(tBodyAccJerkX),
                tBodyAccJerkY      = mean(tBodyAccJerkY),
                tBodyAccJerkZ       = mean(tBodyAccJerkZ),
                tBodyAccJerkX_sd       = mean(tBodyAccJerkX_sd),
                tBodyAccJerkY_sd        = mean(tBodyAccJerkY_sd),
                tBodyAccJerkZ_sd       = mean(tBodyAccJerkZ_sd),
                tBodyGyroX          = mean(tBodyGyroX),
                tBodyGyroY         = mean(tBodyGyroY),
                tBodyGyroZ          = mean(tBodyGyroZ),
                tBodyGyroX_sd          = mean(tBodyGyroX_sd),
                tBodyGyroY_sd           = mean(tBodyGyroY_sd),
                tBodyGyroZ_sd          = mean(tBodyGyroZ_sd),
                tBodyGyroJerkX      = mean(tBodyGyroJerkX),
                tBodyGyroJerkY     = mean(tBodyGyroJerkY),
                tBodyGyroJerkZ      = mean(tBodyGyroJerkZ),
                tBodyGyroJerkX_sd      = mean(tBodyGyroJerkX_sd),
                tBodyGyroJerkY_sd       = mean(tBodyGyroJerkY_sd),
                tBodyGyroJerkZ_sd      = mean(tBodyGyroJerkZ_sd),
                tBodyAccMag          = mean(tBodyAccMag),
                tBodyAccMag_sd          = mean(tBodyAccMag_sd),
                tGravityAccMag       = mean(tGravityAccMag),
                tGravityAccMag_sd       = mean(tGravityAccMag_sd),
                tBodyAccJerkMag      = mean(tBodyAccJerkMag),
                tBodyAccJerkMag_sd      = mean(tBodyAccJerkMag_sd),
                tBodyGyroMag         = mean(tBodyGyroMag),
                tBodyGyroMag_sd         = mean(tBodyGyroMag_sd),
                tBodyGyroJerkMag     = mean(tBodyGyroJerkMag),
                tBodyGyroJerkMag_sd     = mean(tBodyGyroJerkMag_sd),
                fBodyAccX           = mean(fBodyAccX),
                fBodyAccY          = mean(fBodyAccY),
                fBodyAccZ           = mean(fBodyAccZ),
                fBodyAccX_sd           = mean(fBodyAccX_sd),
                fBodyAccY_sd            = mean(fBodyAccY_sd),
                fBodyAccZ_sd           = mean(fBodyAccZ_sd),
                fBodyAccJerkX       = mean(fBodyAccJerkX),
                fBodyAccJerkY      = mean(fBodyAccJerkY),
                fBodyAccJerkZ       = mean(fBodyAccJerkZ),
                fBodyAccJerkX_sd       = mean(fBodyAccJerkX_sd),
                fBodyAccJerkY_sd        = mean(fBodyAccJerkY_sd),
                fBodyAccJerkZ_sd       = mean(fBodyAccJerkZ_sd),
                fBodyGyroX          = mean(fBodyGyroX),
                fBodyGyroY         = mean(fBodyGyroY),
                fBodyGyroZ          = mean(fBodyGyroZ),
                fBodyGyroX_sd          = mean(fBodyGyroX_sd),
                fBodyGyroY_sd           = mean(fBodyGyroY_sd),
                fBodyGyroZ_sd          = mean(fBodyGyroZ_sd),
                fBodyAccMag          = mean(fBodyAccMag),
                fBodyAccMag_sd          = mean(fBodyAccMag_sd),
                fBodyAccJerkMag  = mean(fBodyAccJerkMag),
                fBodyAccJerkMag_sd  = mean(fBodyAccJerkMag_sd),
                fBodyGyroMag     = mean(fBodyGyroMag),
                fBodyGyroMag_sd     = mean(fBodyGyroMag_sd),
                fBodyGyroJerkMag = mean(fBodyGyroJerkMag),
                fBodyGyroJerkMag_sd = mean(fBodyGyroJerkMag_sd)
        ),
        by=list(subjectID,activity)]

## 9.3 Write the tidy means data into a file
write.table(XTidyMeans, file = "TidyMeans.txt", row.name = FALSE, sep=",")

##ReadTidyData <- read.csv("TidyMeans.txt")
##View(ReadTidyData)
