################################################################
#Part 1: Merge the training and test sets to create one data set
################################################################

#declare the paths containing the files:

mainPath <- "T:/School/Coursera/Data Science Specialization/Course 3 - Getting and Cleaning Data/Week 4/Programming Assignment/UCI HAR Dataset/"
trainPath <- paste(mainPath, "train/", sep = "")
testPath <- paste(mainPath, "test/", sep = "")

#read in the training data:

X_train <- read.table(paste(trainPath,"X_train.txt", sep = ""), header = FALSE)
y_train <- read.table(paste(trainPath,"y_train.txt", sep = ""), header = FALSE)

#read in the test data:

X_test <- read.table(paste(testPath,"X_test.txt", sep = ""), header = FALSE)
y_test <- read.table(paste(testPath,"y_test.txt", sep = ""), header = FALSE)

#append the test data to the training data:

X <- rbind(X_train, X_test)
Y <- rbind(y_train, y_test)

##############################################################################################
#Part 2: Extract only the measurements on the mean and standard deviation for each measurement
##############################################################################################

#read in the features (column/variable names):

features <- read.table(paste(mainPath,"features.txt", sep = ""), header = FALSE)

#identify the mean and standard deviation features:

meanfeatures <- grep("-mean\\(", features$V2)
stdfeatures <- grep("-std\\(", features$V2)

#identify those with either a mean() or std() in their column names and preserve the order of the variables

features_mean_std <- features[sort(union(meanfeatures, stdfeatures)),]

#subselect only those that have a "mean()" or "std()" in the description, and preserve the ordering

X_mean_std <- X[, features_mean_std$V1]

##############################################################################
#Part 3: Use descriptive activity names to name the activities in the data set
##############################################################################

#read in the activity labels:
activity_labels <- read.table(paste(mainPath,"activity_labels.txt", sep = ""), header = FALSE)

#create an ID column because the merge function doesn't preserve ordering

Y_ID <- cbind(Y, ID = c(1:nrow(Y)))

#merge with the activity codes:

Y_activity_labels <- merge(Y_ID, activity_labels, by.x = "V1", by.y = "V1")

#order by original ID:

Y_activity_labels_sorted <- Y_activity_labels[order(Y_activity_labels$ID),]

#combine the activity label with the X_mean_std data:
YX <- cbind(Y_activity_labels_sorted[,3], X_mean_std)

#########################################################################
#Part 4: Appropriately label the data set with descriptive variable names
#########################################################################

names(YX) <- c("activity", as.character(features_mean_std$V2))

#########################################################################
#Part 5: From the data in step 4, create a second independent tidy data
#set with the average of each variable for each activity and each subject
#########################################################################

#read in the subject labels:

subject_train <- read.table(paste(trainPath,"subject_train.txt", sep = ""), header = FALSE)
subject_test <- read.table(paste(testPath,"subject_test.txt", sep = ""), header = FALSE)

#append the test data to the training data:

subject <- rbind(subject_train, subject_test)

#append the test data to the training data:

HAR_MEAN_SD <- cbind(subject, YX)

#rename the first column:

names(HAR_MEAN_SD)[1] <- "Subject"

#declare an empty data frame to hold the subject x activity x column mean:

HAR_MEANS <- as.data.frame(0, nrow = 180, ncol = 68)

#create a separate data set for the averages by var, activity, and subject:

splitdata <- split(HAR_MEAN_SD, interaction(HAR_MEAN_SD$Subject, HAR_MEAN_SD$activity))

#splitdata[[subject x activity]][[column]][[measurement]]
#subject = 1-30
#activity = 1-6
#measurement = 66 columns

#loop over each combination

for(i in 1:180)
{
	#identify the subject
	HAR_MEANS[i, 1] <- splitdata[[i]][[1]][1]

	#identify the activity
	HAR_MEANS[i, 2] <- splitdata[[i]][[2]][1]

	#calculate the means:
	for(j in 3:68)
	{
		HAR_MEANS[i, j] <- mean(splitdata[[i]][[j]])
	}
}

#give the data frame the column names

names(HAR_MEANS) <- names(HAR_MEAN_SD)

#export the data frame. Exclude the row names:

write.csv(HAR_MEANS, paste(mainPath, "HAR_MEANS.csv", sep = ""), row.names = F)

