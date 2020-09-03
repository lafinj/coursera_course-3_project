## Goals:

## 1: Merge train and test dataset
## 2: Extract only mean and std dev for each measurement
## 3: Use descriptive activity names to name the activities in the data set
## 4: Appropriately label the data set with descriptive variable names
## 5: Create a second tidy data set with the average of each variable 
##    for each activity and subject

## Load required libraries
library(dplyr)

## Read in the test and training data as well as subject numbers
y_test <- readLines("data/test/y_test.txt")
y_train <- readLines("data/train/y_train.txt")
X_test <- read.delim("data/test/X_test.txt", sep = "", header = FALSE)
X_train <- read.delim("data/train/X_train.txt", sep = "", header = FALSE)
subject_train <- readLines("./data/train/subject_train.txt")
subject_test <- readLines("./data/test/subject_test.txt")

## Rename the columns with descriptive names
cols <- readLines("data/features.txt")
colnames(X_test) <- cols
colnames(X_train) <- cols

## Add activity and subject information
X_test['activity'] <- y_test
X_train['activity'] <- y_train
X_test['subject'] <- subject_test
X_train['subject'] <- subject_train

## Merge test and train datasets
total <- rbind(X_train, X_test)

## Extract means and standard deviation
means_std <- select(total, matches("mean\\(\\)|std\\(\\)|activity|subject"))

## Name the activities with a descriptive name
labs <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                 "SITTING","STANDING","LAYING")
names(labs) <- c('1','2','3','4','5','6')
means_std[,'activity'] <- recode(means_std[,'activity'], !!!labs)

## Create a second tidy dataset with 
## the average of each variable for each activity and subject

final <- means_std %>% group_by(subject, activity) %>% summarize(across(everything(), mean))
write.table(final, file = 'output.txt', row.names = FALSE)