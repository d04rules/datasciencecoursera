library(dplyr)
# This script does the following 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation 
#for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.

train_data<-"X_train.txt"
test_data<-"X_test.txt"
train_labels<-"Y_train.txt"
test_labels<-"Y_test.txt"
train_subjects<-"subject_train.txt"
test_subjects<-"subject_test.txt"
features_file<-"features.txt"
activity_labels_file<-"activity_labels.txt"

#Read and join observation data
data_train<-read.table(train_data)
data_test<-read.table(test_data)
total_data<-rbind(data_train,data_test)

#Read and join the labels
labels_train<-read.table(train_labels)
labels_test<-read.table(test_labels)
total_labels<-rbind(labels_train,labels_test)

#Read and join the subjects
subjects_train<-read.table(train_subjects)
subjects_test<-read.table(test_subjects)
total_subjects<-rbind(subjects_train,subjects_test)

#Read the features
features<-read.table(features_file)

#Read the activity names
activity_labels<-read.table(activity_labels_file)

#Figure out which columns correspond to features with mean or std
col_nums<-grep("mean|std",features[,2])
col_name<-grep("mean|std",features[,2],value = TRUE)

#Only keep columns identified above
total_data<- select(total_data,col_nums)

#Convert labels to activity names
total_labels<-activity_labels[match(total_labels[,1],activity_labels[,1]),2]

#Combine data, labels, and subjects
complete_data<-cbind(total_subjects, total_labels, total_data)

#Give the columns descriptive names
names(complete_data)<-c("subject","activity_label",col_name)

#Create dataset of averages
avg_dataset<-complete_data%>%group_by(subject,activity_label)%>%summarise_all(mean, na.rm=TRUE)


