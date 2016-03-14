#Getting-CleaningData
The data is read in using read.table functions, separate variables are created containing the data. 
The names of the original variables are coinciding with the names of the original data files to avoid confusion.
Trainig and test sets data are read in separately along with labels, feature vector and activity labels.
Variable names are assigned using feature names from the feature vector, activity label names are assigned. 
The train and test sets are merged using rbind() function, since we have 561 columns with the same variables.
Test labels sets are combined respectively, column name for labels added. 
Activity Codes, identifying activity are added. Subject ids from train and test sets are merged.
Activity labels are added using dplyr leftjoin function. Dataset is combined with labels.
Columns containig data on mean and standard deviation are selected based on the column names using regular expressions
looking for mean and std in column names, columns containig activity and SubjectID are also kept.
ActivityCode column is then dropped and subjectID converted to factors.
The dataset is grouped by Activity and subjectID using dplyr grpoup_by function.
Finally the final set is produced using summarise_each function and funs_ functions.
The data is then exported with write.table function.
