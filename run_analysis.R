# read and combine test files
subject_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
test <- cbind(subject_test, X_test, y_test)
# read and combine train files
subject_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
train <- cbind(subject_train, X_train, y_train)
# combine test and train data
test_train <- rbind(test, train)
# Find mean and deviation columns and extract
features <- read.table("features.txt")
mean_var <- grep("mean", features[,2])
std_var <- grep("std", features[,2])
mean_std <- c(mean_var, std_var)
DT <- test_train[,c(1, mean_std+1, ncol(test_train))]
# Use descriptive activity names
library(dplyr)
DT <- mutate(DT, V1.2 = gsub("1", "WALKING", DT$V1.2))
DT <- mutate(DT, V1.2 = gsub("2", "WALKING_UPSTAIRS", DT$V1.2))
DT <- mutate(DT, V1.2 = gsub("3", "WALKING_DOWNSTAIRS", DT$V1.2))
DT <- mutate(DT, V1.2 = gsub("4", "SITTING", DT$V1.2))
DT <- mutate(DT, V1.2 = gsub("5", "STANDING", DT$V1.2))
DT <- mutate(DT, V1.2 = gsub("6", "LAYING", DT$V1.2))
# Use descriptive variable names
ori_names <- mutate(features, V2 = gsub("tBody", "TimeBody", features[,2]))
ori_names <- mutate(ori_names, V2 = gsub("fBody", "FreqBody", ori_names[,2]))
ori_names <- mutate(ori_names, V2 = gsub("tGravity", "TimeGravity", ori_names[,2]))
ori_names <- mutate(ori_names, V2 = gsub("BodyBody", "Body", ori_names[,2]))
ori_names <- mutate(ori_names, V2 = gsub("Freq", "", ori_names[,2]))
ori_names <- mutate(ori_names, V2 = gsub("-mean", "", ori_names[,2]))
ori_names <- mutate(ori_names, V2 = gsub("-std", "", ori_names[,2]))
ori_names <- mutate(ori_names, V2 = gsub("\\()", "", ori_names[,2]))
ori_names <- mutate(ori_names, V2 = gsub("-X", "X", ori_names[,2]))
ori_names <- mutate(ori_names, V2 = gsub("-Y", "Y", ori_names[,2]))
ori_names <- mutate(ori_names, V2 = gsub("-Z", "Z", ori_names[,2]))
ori_names[mean_var,] <- mutate(ori_names[mean_var,], V2 = paste0("MeanOf", ori_names[mean_var,2]))
ori_names[std_var,] <- mutate(ori_names[std_var,], V2 = paste0("StdOf", ori_names[std_var,2]))
var_names <- ori_names[mean_std,2]
col_names <- c("subject", var_names, "activity")
colnames(DT) <- col_names
# create data set with average of each variable for each activity and each subject
DT_avg <- aggregate(.~subject + activity, data = DT, FUN = "mean")




