## Getting and Cleaning Data Programming Assignment

###Introduction

This repository holds my programming assignment for the Getting and Cleaning Data Coursera course. 

The task for the assignment is to create a summary data set that holds the means of the mean() and std() columns by subject and activity from the Human Activity Recognition using Smartphones Dataset hosted by the UCI Data Repository: [https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

###Repository Contents

- CodeBook.md: markdown file describing the columns in the summary data set
- HAR_MEANS.csv: tidy data set with the average of each variable for each activity and each subject
- README.md: Summary of this repo
- run_analysis.R: R script file containing all the code to import and process the UCI data sets

###Data Preparation

1. The source data was downloaded from the UCI repository linked above. 
2. The training and test sets were appended together
3. Columns identified with a "mean()" or "std()" were selected from the entire data set.
4. Activity labels and subject information was appended to the data subset.
5. The data was partitioned by subject and activity. Means for each data column are calculated.

Note: see the CodeBook.md file for further details on the data.





