## CodeBook

### Synopsis

This file explains the datasets created,
as well as the source of the data,
and any transformations along the way.
To the degree practical,
it also explains some of the data analysis 
and choices that drove the data cleanup strategy.

### Original Data

#### Source

The original source of the data is 
the [Human Activity Recognition Using Smartphones Data Set][HAR]
from the [University of California Irvine Machine Learning Repository][UCIML].
However for the purposes of this assignment,
a fixed snapshot of the data was provided as
[HAR Dataset.zip][data] on the class site.

#### Analysis of the raw data

The data is for the most part explained in `README.txt`.
At the top level
* `README.txt` is an overall explanation of the data.
* `features.txt` is a list of the data values, or features, collected.
  There are a total of 561 features
* `features_info.txt` is explanatory information about those features.
* `activity_labels.txt` is a list of activities the subjects were
  doing at the time of the measurement.
  There are only 6 activities.

The data was intended for machine learning,
and the subjects were randomly assigned into two data sets:
`train` and `test`, which are located in their own sub-directories.
For our purposes they really constitute a single data set.
Each directory is similar, though the file names differ.

The training data consists of 7352 data samples
* `train/X_train.txt` is a 7352 x 561 matrix of floating point values,
  where each row is the i<sup>th</sup> sample and each column is the value
  of the n<sup>th</sup> feature collected as part of that sample.
* `train/Y_train.txt` is a 7352 x 1 collection of activity values.
* `train/subject_train.txt` is a 7352 x 1 collection of subject ids,
  where each row is the id of the subject contributing the i<sup>th</sup>
  sample.
  There are 21 unique subjects in the training data.

The test data is similar to the training data, except
* everything is in a directory `test`.
* the files are `X_test.txt`, `Y_test.txt`, and `subject_test.txt`.
* there are only 2947 samples in the test set.
* there are only 9 subjects in the test data,
  who constitute a disjoint set from the training data.

Both the training and test data also include additional data in
the `Internal signals` directory.
For our purposes, that data is uninteresting, and may be ignored.

### Memory estimate

Given the large number of features in the data,
and given that we are only interested in the means and standard deviations,
it is worth considering memory usage.
There are 10299 data samples total, 
each is a floating point value that will 
occupy 8 bytes as a double.
So for 561 features, the raw data set is just over 44MB.
There are only 33 mean and 33 standard deviation features.
We could load just those,
by setting the other features to have a `colClasses` to `NULL`
in `read.table`.
In that case the raw data would be just over 5MB.
While this is a significant savings, 
unless required,
and in the spirit of transparency in the transformations,
such optimization was avoided.

### Data processing 

#### Processing Strategy

Given the above memory estimate,
and given the nature of this project 
as course work, to be peer graded,
the processing strategy was to follow the assignment directions
pretty much in order.
There would be some performance gain from having skipped unused columns
as mentioned in the memory section above.
Not doing that, there would be a gain by extracting the columns
we care about before merging the data.
It might also be simpler append activities to the main data before the merge.
However, for clarity, none of these optimizations were used.

#### Transformations

The data was transformed in three ways.

First, a very simple transform was applied to `features.txt`
to create `measures.txt`, which is a support file for creating
this CodeBook and not a part of the formal output.
In this case, those feature names which represented either
mean or standard deviation features were subsetted.
This subset was based on a regex match names which included
the function names `mean()` or `std()`.

Second, a file of individual observations, one per row,
was created as `observations.txt`.
The transform logic was to
 * load the individual data files.
 * concatenate the training and test data sets for the 
   values, features and subjects.
 * subset just those features selected above in `measures.txt`.
 * Cartesian join to the `activity_labels.txt` data .
 * fold the data into a tall thin data set with one row
   per observation, per feature,
   identified by subject id, activity name, and 
   and synthetic observation id.

Finally the observation data was summarized into `averages.txt`
by computing the arithmetic mean for each unique subject, activity,
feature grouping.

A more code oriented explanation of the processing is contained
in [README.md](README.md).

### Data Formats

####  General Format

The general format for all output files is ascii text,
with white space separated fields
and newline separated records.
With the exception of `measures.txt`,
each file contains a single header row before any data,
with white space separated column names.

#### measures.txt

The `measures.txt` file contains each of the measures 
used in the data below as a single column.
Measure names are those derived from the original data's
`features.text` file.


#### observations.text

The `observations.text` file contains one row per observation
per selected feature.
Since no data is missing any of the measures, 
there are exactly 66 rows per each of 10299 observations.

The data elements are given as 

| Column | Name        |                                      Description |
|--------|-------------|--------------------------------------------------|
| 1      | observation | numeric sequence withing the original data set  |
| 2      | subject     | subject id in the range 1-30                     |
| 3      | activity    |one of the 6 activities listed below               |
| 4      | variable    | one of the 66 variables or features listed below |
| 5      | value       | decimal, normalized, measured value in the range -1 to 1|

#### averages.txt

The `averages.txt` file contains one row per unique
subject, activity, variable group.
The data elements are given as:

| Column | Name     | Description                                              |
|--------|----------|----------------------------------------------------------|
| 1      | subject  | numeric subject id in range 1 to 30                      |
| 2      | activity | activity name as listed below                            |
| 3      | variable | the variable or feature measured as listed below         |
| 4      | average  | the average over the observations dataset for this group |


#### Activity Names 

The following activity names appear in both data sets:

| activity           |
|--------------------|
| WALKING            |
| WALKING_UPSTAIRS   |
| WALKING_DOWNSTAIRS |
| SITTING            |
| STANDING           |
| LAYING             |

#### Variable Names

The following variable names are used in both data sets.
They are further defined and explained in `features_info.txt`
in the original data set.
No interpretation of the names was done in transforming the data,
other than the selection of mean and standard deviation features,
as noted above.

| variable |
|----------|
| tBodyAcc-mean()-X |
| tBodyAcc-mean()-Y |
| tBodyAcc-mean()-Z |
| tBodyAcc-std()-X |
| tBodyAcc-std()-Y |
| tBodyAcc-std()-Z |
| tGravityAcc-mean()-X |
| tGravityAcc-mean()-Y |
| tGravityAcc-mean()-Z |
| tGravityAcc-std()-X |
| tGravityAcc-std()-Y |
| tGravityAcc-std()-Z |
| tBodyAccJerk-mean()-X |
| tBodyAccJerk-mean()-Y |
| tBodyAccJerk-mean()-Z |
| tBodyAccJerk-std()-X |
| tBodyAccJerk-std()-Y |
| tBodyAccJerk-std()-Z |
| tBodyGyro-mean()-X |
| tBodyGyro-mean()-Y |
| tBodyGyro-mean()-Z |
| tBodyGyro-std()-X |
| tBodyGyro-std()-Y |
| tBodyGyro-std()-Z |
| tBodyGyroJerk-mean()-X |
| tBodyGyroJerk-mean()-Y |
| tBodyGyroJerk-mean()-Z |
| tBodyGyroJerk-std()-X |
| tBodyGyroJerk-std()-Y |
| tBodyGyroJerk-std()-Z |
| tBodyAccMag-mean() |
| tBodyAccMag-std() |
| tGravityAccMag-mean() |
| tGravityAccMag-std() |
| tBodyAccJerkMag-mean() |
| tBodyAccJerkMag-std() |
| tBodyGyroMag-mean() |
| tBodyGyroMag-std() |
| tBodyGyroJerkMag-mean() |
| tBodyGyroJerkMag-std() |
| fBodyAcc-mean()-X |
| fBodyAcc-mean()-Y |
| fBodyAcc-mean()-Z |
| fBodyAcc-std()-X |
| fBodyAcc-std()-Y |
| fBodyAcc-std()-Z |
| fBodyAccJerk-mean()-X |
| fBodyAccJerk-mean()-Y |
| fBodyAccJerk-mean()-Z |
| fBodyAccJerk-std()-X |
| fBodyAccJerk-std()-Y |
| fBodyAccJerk-std()-Z |
| fBodyGyro-mean()-X |
| fBodyGyro-mean()-Y |
| fBodyGyro-mean()-Z |
| fBodyGyro-std()-X |
| fBodyGyro-std()-Y |
| fBodyGyro-std()-Z |
| fBodyAccMag-mean() |
| fBodyAccMag-std() |
| fBodyBodyAccJerkMag-mean() |
| fBodyBodyAccJerkMag-std() |
| fBodyBodyGyroMag-mean() |
| fBodyBodyGyroMag-std() |
| fBodyBodyGyroJerkMag-mean() |
| fBodyBodyGyroJerkMag-std() |






[data]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (UCI Human Activity Recognition Data Set)
[UCIML]: http://archive.ics.uci.edu/ml/index.html (UCI Machine Learning Repository)
[HAR]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones (Human Activity Recognition Using Smartphones)
