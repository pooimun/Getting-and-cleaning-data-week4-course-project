library(dplyr)
setwd('UCI HAR Dataset')

#Read Data
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
sub_train <- read.table("./train/subject_train.txt")

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
sub_test <- read.table("./test/subject_test.txt")

features <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")

# merge of training and test sets
x_total   <- rbind(x_train, x_test)
y_total   <- rbind(y_train, y_test) 
sub_total <- rbind(sub_train, sub_test) 

# select mean and std
sel_features <- features[grep("mean|std",features[,2]),]
x_total <- x_total[,sel_features[,1]]

#naming
colnames(x_total)   <- sel_features[,2]
colnames(y_total)   <- "activity"
colnames(sub_total) <- "subject"

#merge dataset
total <- cbind(sub_total,y_total,x_total)

# create a summary independent tidy dataset from final dataset with the average of each variable for each activity and each subject. 
total$activity <- factor(total$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
total$subject  <- as.factor(total$subject) 

final <- group_by(total,activity,subject)
final2 <- summarize_all(temp,funs(mean))

#export data
write.table(final2, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 

