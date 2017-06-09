# Getting and Cleaning Data - Course Project

The tidy data set *tidy.txt* is produced as the output of the function 
*run_analysis*. The function can be sourced from the *run_analysis.R* file. 
All the required data shaping and analysis is performed within the function.

**How the run_analysis function works:**

1. Downloads and unzips the required files inside the working directory (if needed).

2. Reads the various files into R.

3. Makes variable names unique, as there are duplicates in the original.

4. Subsets both train and test datasets to include only mean and st. deviation
measurements

5. Merges train and test datasets into one dataset. The id of the subject 
and the activity are also added.

6. Replaces activity ids with descriptive activity labels.

7. Outputs "tidy.txt" which contains the average of each veriable for each activity and each subject


