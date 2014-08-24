## README.md

This repository is my course project for
[Getting and Cleaning Data][getdata].
This project uses data from the 
[University of California Irvine Machine Learning Repository][UCIML],
specifically the
[Human Activity Recognition Using Smartphones Data Set][HAR]
as an example of generating Tidy data from a raw, untidy, data source.
While the raw data originates from UCI,
for the purposes of this project,
a fixed snapshot [data set][data] is shared from the course site.


### Files

The following files in the repository are used for data transform
and/or documentation.

* [README.md](README.md) This file
* [CodeBook.md](CodeBook.md) 
* [run_analysis.R](run_analysis.R) Main data processing script.
* [fileUtils.R](fileUtils.R) Generic file processing functions
  used by `run_analysis.R`
* [dataTransforms.R](dataTransforms.R) utility functions 
  used by `run_analysis.R` which are peculiar to the dataset
  and the problem at hand.

### Output files

Running the transform creates the following output files:

* `output/observations.txt`  A tidy data file containing the 
   mean and standard deviation features for each observation
   in the dataset.  It corresponds to step 4 in the project
   directions.
* `output/averages.txt` A second tidy data file containing
   the average over each subject, over each activity, over
   each feature of the data values in `observations.txt`.
   This corresponds to step 5 in the project directions.

### Running the process

The project can be run simply by executing `run_analysis.R`, 
which will handle sourcing the utility files `fileUtils.R`
and `dataTranforms.R`.

Output will be created in the directory `./output`.
Temporary files will be created in a directory `./data`,
but will be cleaned up as the end of the execution.
To keep data files cached, you may set `cleanupData` to `FALSE`
in `run_analysis.R`.

#### Execution Flow

The processing runs in stages:

* The dataset archive is fetched, if needed, from the class site.
* Individual data files are then extracted from the archive.
* The individual data files are loaded using `read.table()`,
  though helper functions, `loadLookup()`, `loadJoin()` and `loadData()`,
  are  used for each type of file to consolidate the logic by file type.
* The training and test data sets are merged creating the 
  data frames `values`, `activities`, and `subjects`.
  This maps to step 1 of the project instructions.
* The mean and standard deviation features are extracted,
  filtering the columns to those matching the regular expression
  set in `filterFeatures()`.
  This selects only those features with names that include
  `-mean()` or `-std()` and maps to step 2 in the instructions.
  To simplify this a bit, the feature clumsy are first named
  after the feature names in `features.txt`, which is technically
  part of step 4 makes the logic more clear.
* The activity values are then column bound and joined (merged)
  with the activity names form `activity_labels.txt`.
  This maps to step 3 of the instructions.
* In addition, the subject ids are column bound to the data set,
  which while not explicit required is in the spirit of step 4.
* Finally the data is converted to a "tall thin" data set.
  * a sequence, called "observation" is prepended, since each 
    row is a unique observation and not natural key exists,
    so a synthetic key is needed.
  * the data is melted using `melt()`, 
    with observation, subject and activity as the keys
    and all of the mean() and std() features as measures.
* The result is output as `observations.txt`.
  See [CodeBook.md](CodeBook.md) for details on the file.

The processing then continues with step 5 to summarize average the data.
Because the data was already in a 'thin/tall' shape with each row
an observation of a single feature or value, for a single subject 
taking part in a single activity, the summarization is fairly trivial:

* The data summarized using `ddply` setting `subject`, `activity`,
  and `variable` as the key and applying the `mean()` function to
  compute an average or arithmetic mean.
* The resulting table is output as `averages.txt`.
  See [CodeBook.md](CodeBook.md) for details on the file.

[getdata]: https://www.coursera.org/course/getdata (Getting and Cleaning Data)
[data]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (UCI Human Activity Recognition Data Set)
[UCIML]: http://archive.ics.uci.edu/ml/index.html (UCI Machine Learning Repository)
[HAR]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones (Human Activity Recognition Using Smartphones)
