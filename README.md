##### README
### Averages of the Means and Standard Deviations by Activity and Subject

The following describes the script which produces the tidy data set of the averages of the features that are means or standard deviations for each activity and each subject using the data of both test and training.

<br>

##### The Raw Data
The raw data can be found under the folder */UCI HAR Dataset/*. The following is a description of the different raw files used.

Filename|Description|Relative Path
---|---|---
activity_labels.txt|Contains the activity master data. This data was used to have the names of the activities|/
features.txt|Contains the index of the features and their names. This data was used to identify only the features that are means or standard deviations, and to properly name the variable in the tidy data|/
subject_test.txt|Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.|/test
X_test.txt|Each row contains the data of each feature|/test
y_test.txt|Each row identifies the activity that was performed. Its range is from 1 to 6|/test
subject_train.txt|Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.|/train
X_train.txt|Each row contains the data of each feature|/train
y_train.txt|Each row identifies the activity that was performed. Its range is from 1 to 6|/train

<br>

##### The Script
The function returning the tidy data is: **getTheAveragesOfTheTrainingAndTestDataByActivityAndSubject**

The following is a top-down functional breakdown of the script starting from this main function.

<br>

###### Function: getTheAveragesOfTheTrainingAndTestDataByActivityAndSubject

1. Gets the merged training and test data containing properly named columns with only the means and standard deviations
    * See <a href=#getTheTrainingAndTestData>getTheTrainingAndTestData</a>
2. Builds an SQL statement to perform an average of every feature that is a mean or standard deviation and then does a simple SELECT and GROUP BY ActivityId, ActivityName, SubjectId
    * An SQL statement is built in order to avoid hard coding any columns
3. Returns the result of the SQL statement

<br id=getTheTrainingAndTestData>

###### Function: getTheTrainingAndTestData

1. Gets the training data
    * See <a href=#getTheMeansAndStandardDeviationsOfTheSpecifiedData>getTheMeansAndStandardDeviationsOfTheSpecifiedData</a>
2. Gets the test data
    * See <a href=#getTheMeansAndStandardDeviationsOfTheSpecifiedData>getTheMeansAndStandardDeviationsOfTheSpecifiedData</a>
3. Unions the two data frames using a simple `rbind`
4. Returns the resulting data frame

<br id=getTheMeansAndStandardDeviationsOfTheSpecifiedData>

###### Function: getTheMeansAndStandardDeviationsOfTheSpecifiedData

The following function is used to retrieve both the "test" and "train" data as their structures are the same.

Inputs: the name of the data, which is either "train", or "test"

1. Gets the subjects
    * See <a href=#getTheSubjectsOfTheSpecifiedData>getTheSubjectsOfTheSpecifiedData</a>
2. Gets the activities
    * See <a href=#getTheActivitiesOfTheSpecifiedData>getTheActivitiesOfTheSpecifiedData</a>
3. Gets the observations of the features
    * See <a href=#getTheSpecifiedData>getTheSpecifiedData</a>
4. Prepend the activities to the data. Done using `cbind`
5. Prepend the subjects to the data. Done using `cbind`
6. Gets the indexes of the features that are means and standard deviations
    * See <a href=#getTheIndexesOfTheFeaturesRegardingMeansAndStandardDeviations>getTheIndexesOfTheFeaturesRegardingMeansAndStandardDeviations</a>
7. Creates a new data frame with only the subject info, activity info and the variables regarding means and standard deviations.
8. Returns the new data

<br id=getTheSubjectsOfTheSpecifiedData>

###### Function: getTheSubjectsOfTheSpecifiedData

The following function is used to retrieve both the "test" and "train" data as their structures are the same.

Inputs: the name of the data, which is either "train", or "test"

1. Reads the subject raw data file of each observation
2. Returns the data of subjects

<br id=getTheActivitiesOfTheSpecifiedData>

###### Function: getTheActivitiesOfTheSpecifiedData

The following function is used to retrieve both the "test" and "train" data as their structures are the same.

Inputs: the name of the data, which is either "train", or "test"

1. Gets the activities from the raw data
    * See <a href=#getTheActivityIdsOfTheSpecifiedData>getTheActivityIdsOfTheSpecifiedData</a>
2. Gets the activity master data
    * See <a href=#getTheActivityMasterData>getTheActivityMasterData</a>
2. Merges the raw data and master data in order to have the proper names of each activity
3. Returns the merged data

<br id=getTheActivityIdsOfTheSpecifiedData>

###### Function: getTheActivityIdsOfTheSpecifiedData

The following function is used to retrieve both the "test" and "train" data as their structures are the same.

Inputs: the name of the data, which is either "train", or "test"

1. Reads the activity raw data file of each observation
2. Returns the data of activities

<br id=getTheActivityMasterData>

###### Function: getTheActivityMasterData

1. Reads the activity master data file
2. Returns the data of activity master data

<br id=getTheSpecifiedData>

###### Function: getTheSpecifiedData

The following function is used to retrieve both the "test" and "train" data as their structures are the same.

Inputs: the name of the data, which is either "train", or "test"

1. Gets the indexes and names of the features
    * See <a href=#getTheFeatureIndexesAndNames>getTheFeatureIndexesAndNames</a>
2. Reads the raw data file of each observation of every feature, and names the columns appropriately
3. Returns the data

<br id=getTheIndexesOfTheFeaturesRegardingMeansAndStandardDeviations>

###### Function: getTheIndexesOfTheFeaturesRegardingMeansAndStandardDeviations

1. Gets the indexes and names of the features
    * See <a href=#getTheFeatureIndexesAndNames>getTheFeatureIndexesAndNames</a>
2. Subsets the indexes to only features that contain either "mean" or "std"
3. Returns the subset of indexes that are means of standard deviations

<br id=getTheFeatureIndexesAndNames>

###### Function: getTheFeatureIndexesAndNames

1. Reads the features raw data file
2. Returns the data of indexes and feature names