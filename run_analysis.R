run_analysis <- function() {
        
        # Create folder, download assignment data and unzip.
        if(!file.exists("./data")) {
                dir.create("./data")
                url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                file_dest <- "./data/assignment_data.zip"
                message("downloading files...")
                download.file(url, file_dest)
                message("unzipping contents...")
                unzip("./data/assignment_data.zip", exdir = "./data")
        }
        else {
                message("datasets found...")
        }

        
        # Read the various txt files into R, with appropriate column names.
        # X_test/train column names are taken from the features.txt
        require(data.table)
        message("reading .txt files into R...")
        y_test <- fread(paste0(getwd(), "/data/UCI HAR Dataset/test/y_test.txt"), header = FALSE, col.names = c("activity_id"))
        y_train <- fread(paste0(getwd(), "/data/UCI HAR Dataset/train/y_train.txt"), header = FALSE, col.names = c("activity_id"))
        subject_test <- fread(paste0(getwd(), "/data/UCI HAR Dataset/test/subject_test.txt"), header = FALSE, col.names = c("subject_id"))
        subject_train <- fread(paste0(getwd(), "/data/UCI HAR Dataset/train/subject_train.txt"), header = FALSE, col.names = c("subject_id"))
        features <- fread(paste0(getwd(),"/data/UCI HAR Dataset/features.txt"), header = FALSE, col.names = c("feature_id", "feature"))
        X_test <- fread(paste0(getwd(), "/data/UCI HAR Dataset/test/X_test.txt"), header = FALSE, col.names = features$feature)
        X_train <- fread(paste0(getwd(), "/data/UCI HAR Dataset/train/X_train.txt"), header = FALSE, col.names = features$feature)
        act_lbl <- fread(paste0(getwd(), "/data/UCI HAR Dataset/activity_labels.txt"), col.names = c("activity_id", "activity"))
        

        require(dplyr)
        message("shaping and merging data...")
        
        # make column names unique
        names(X_test) <- make.unique(names(X_test))
        names(X_train) <- make.unique(names(X_train))
        
        # select only variables with mean or std in the name.
        X_test_sub <- select(X_test, matches(".*-mean\\(\\)|.*-std\\(\\)"))
        X_train_sub <- select(X_train, matches(".*-mean\\(\\)|.*-std\\(\\)"))
        
        # merge columns of train/test with subject and activities
        data_train <- cbind(subject_train, y_train, X_train_sub)
        data_test <- cbind(subject_test, y_test, X_test_sub)
        
        # merge full test with full train tables
        data_full <- rbind(data_train, data_test) 
        
        # set activies and subjects as factors and give activities labels
        data_full$activity_id <- factor(data_full$activity_id, levels = act_lbl$activity_id, labels = act_lbl$activity)
        data_full$subject_id <- as.factor(data_full$subject_id)
        
        # set final column names for full dataset
        colnames(data_full) <- c("subject", "activity", colnames(X_train_sub))
        
        # melt data
        data_full_melt <- melt(data_full, id = c("subject", "activity"))
        
        # recast data
        data_full_means <- dcast(data_full_melt, subject + activity ~ variable, mean)

        # write tidy data set into txt file
        write.table(data_full_means, "tidy.txt", row.names = FALSE)
}


