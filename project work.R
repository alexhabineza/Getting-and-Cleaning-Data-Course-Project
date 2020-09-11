
# Create one R script called run_analysis.R that does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##Load required libraries
if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}
require("data.table")
require("reshape2")
# Download the Data
data_labels <- read.table("./UCI HAR Dataset/data_labels.txt")[,2]
# Load: data column names
mywork <- read.table("./UCI HAR Dataset/mywork.txt")[,2]
# Extract only the measurements on the mean and standard deviation for each measurement.
extract_mywork <- grepl("mean|std", mywork)
# Load and process X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(X_test) = mywork
# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_mywork]
# Load activity labels
y_test[,2] = data_labels[y_test[,1]]
names(y_test) = c("data_ID", "data_Label")
names(subject_test) = "subject"
# Bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
# Load and process X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(X_train) = features
# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_mywork]
# Load activity data
y_train[,2] = data_labels[y_train[,1]]
names(y_train) = c("data_ID", "data_Label")
names(subject_train) = "subject"
# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)
# Merge test and train data
data = rbind(test_data, train_data)
id_labels   = c("subject", "data_ID", "data_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)
# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt")

