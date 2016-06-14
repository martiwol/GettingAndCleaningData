==================================================================
Tidied Data Set of Averaged Human Activity Recognition Features
==================================================================
The analysis is based on the "Human Activity Recognition Using Smartphones Dataset" (Version 1.0) available from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
(downloaded June 13th, 2016)
This data set contains measured signals and extracted features from the smartphone of 30 subjects each performing 6 activities. Details on the performed experiment can be found in the "Readme.txt" document which accompanies the data set.

The added processing function "run_analysis()" reads and combines the feature data sets for both, training as well as test data, and outputs a tidy data set containing averaged observations/features per subject-activity-pair.  The set has 180 rows (30 subjects performing 6 activities each, one row per subject/activity pair) and 69 variables.

These variables include 3 identification columns:
"subjectId" 	... a number identifying a subject that participated in the experiment [integer]
"activity" 		... the activity performed by the subject during the measurement/observation [string]
"classType" 	... the suggested use of the data during classification (train/test data) [string]

The remaining 66 columns describe mean values per given variable and subject-activity-pair. The exact meaning of the (non-averaged) values can be found in the file "features_info.txt" which is located  in the original data set. The unit of these (normalized) features is standard gravity unit 'g'.

