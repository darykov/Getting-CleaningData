# Load libraries
library(dplyr)
#Remove all existing variables
rm(list = ls())

# Read in the test and train datasets
#Train dataset
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", sep="")
#Test_dataset
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", sep="")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="")
# Check in any values are NA
sum(is.na(Y_train))
sum(is.na(Y_test))
sum(colSums(is.na(X_train)))
sum(colSums(is.na(Y_train)))

# Read in the feature vector
features <- read.table("./UCI HAR Dataset/features.txt", sep="")

#Assign Variable names using feature names from the feature vector
names(X_test) <- features$V2
names(X_train) <- features$V2

#Read in activity labels 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep="")
#Assign column names to activity_labels
names(activity_labels)<-c("ActivityCode", "Activity")

# Join the train and test sets
#since we have 561 columns with the same variables in each - rbind() function is used
combined_set <-rbind(X_test, X_train)
# Combining test labels respectively
combined_labels <-rbind(Y_test, Y_train)
names(combined_labels)<-c("ActivityCode")
#Combine subject ids from train and test sets
combined_subject <-rbind(subject_test, subject_train)
names(combined_subject)<-c("subjectID")
#Labelling activities
combined_activity_labels <- left_join(combined_labels, activity_labels, by="ActivityCode")
#Join combined_set with combined_activity_labels set 
combined_set_labelled <- cbind(combined_set, combined_activity_labels)
combined_set_labelled_subjID<-cbind(combined_set_labelled, combined_subject)
#select column indecies containig standard deviation and mean
extract_mean_std<-combined_set_labelled_subjID[,grep('std|mean|Activity|subjectID', names(combined_set_labelled_subjID))]
#Drop ActivityCode column
extract_mean_std<-select(extract_mean_std, -ActivityCode)
#convert subjectID to factor
extract_mean_std$subjectID<-as.factor(extract_mean_std$subjectID)
#Group the set by by Activity and subjectID
final_set<-group_by(extract_mean_std, Activity, subjectID)%>%
#Summarise using dplyr summarise and funs_ fuction accepting function calls for mean and sd  
summarise_each(funs_(c("mean", "sd")))
#Export table
write.table(final_set, file = "final_data.txt", row.names = F)
