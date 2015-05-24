#Load column names
column_names<-read.table("features.txt")
#Filter columns (only mean and std measurements)
column_indexes<-grep("mean|std", column_names[,2])

#Load activity labels (for y datasets)
activity_labels<-read.table("activity_labels.txt")

#Load files (subject)
subject_test<-read.table("test/subject_test.txt")
subject_train<-read.table("train/subject_train.txt")
#Set labels for subject datasets
names(subject_test)<-c("subjectnumber")
names(subject_train)<-c("subjectnumber")

#Load files (x)
x_test<-read.table("test/X_test.txt")
x_train<-read.table("train/X_train.txt")
#Get only columns with mean and std
x_test<-x_test[,column_indexes]
x_train<-x_train[,column_indexes]
#Set labels for x datasets
names(x_test)<-column_names[column_indexes,2]
names(x_train)<-column_names[column_indexes,2]

#Load files (y)
y_test<-read.table("test/y_test.txt")
y_train<-read.table("train/y_train.txt")

#Merge y datasets (train and test) with activity labels
y_test<-merge(activity_labels, y_test)
y_train<-merge(activity_labels, y_train)

#Set labels for y datasets
names(y_test)<-c("activitycode", "activitydescription")
names(y_train)<-c("activitycode", "activitydescription")

#Create data frame from test data
test_df<-data.frame(subject_test, y_test, x_test)
#Create data frame from train data
train_df<-data.frame(subject_train, y_train, x_train)

#Combine test and train data frame
dataset<-rbind(test_df, train_df)

#Split dataset by subject and acvitity
splitdatasets<-split(dataset, list(dataset$subjectnumber, dataset$activitycode), drop=TRUE)

#Calculate column means (only to certain columns) and transpose
colmeans<-data.frame(t(sapply(splitdatasets, function(x) colMeans(x[, 4:82], na.rm=TRUE))))
#Get row.names
subject.activity<-row.names(colmeans)
#Delete row.names column
row.names(colmeans)<-NULL
#Create new subject.activity column
colmeans<-cbind(subject.activity, colmeans)

#Save the two tidy datasets
write.csv(dataset, file="peer_task1.csv")
write.csv(colmeans, file="peer_task2.csv")
