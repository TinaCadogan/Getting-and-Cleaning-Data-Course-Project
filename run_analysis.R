#Read and Create the Data Sets


dataActivityTest  <- read.table("./test/Y_test.txt",header = FALSE)
dataActivityTrain <- read.table("./train/Y_train.txt",header = FALSE)

dataSubjectTest  <- read.table("test/subject_test.txt",header = FALSE)
dataSubjectTrain <- read.table("train/subject_train.txt",header = FALSE)


dataFeaturesTest  <- read.table("test/X_test.txt",header = FALSE)
dataFeaturesTrain <- read.table("train/X_train.txt",header = FALSE)

#Check the datasets
str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTest)
str(dataSubjectTrain)
str(dataFeaturesTest)
str(dataFeaturesTrain)

#Step 1: Merges the training and the test sets to create one data set.
#bind the datasets by rows
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#Set names to the variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table("features.txt",header=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2


#bind the datasets by columns
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)


#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Check the extracted dataframe
str(Data)

#Step 3: Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("activity_labels.txt",header = FALSE)
Data$activity<-factor(Data$activity,labels=activityLabels[,2])
head(Data$activity,30)

#Step 4: Appropriately labels the data set with descriptive variable names. 
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)


#Step 5: creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)



library(knitr)
knit2html("codebook.Rmd");


