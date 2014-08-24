## CodeBook

### Synopsis

This file explains the datasets created,
as well as the sorce of the data,
and any transformations along the way.
To the degree practical,
it also explains some of the dataanalysis 
and choices that drove the data cleanup strategy.

### Origional Data

#### Source

The origional source of the data is 
the [Human Activity Recognitin Using Smartphones Data Set][HAR]
from the [University of California Irvine Machine Learning Repository][UCIML].
However for the purposes of this assignment,
a fixed snapshot of the data was provided as
[HAR Dataset.zip][data] on the class site.

#### Analysis of the raw data

The data is for the most part explained in `README.txt`.
At the top level
* `README.txt` is an overall explanation of the data.
* `features.txt` is a list of the data values, or features, colected.
  There are a total of 561 features
* `features_info.txt` is explanitory information about those features.
* `activity_labels.txt` is a list of activities the subjects were
  doing at the time of the measurement.
  There are only 6 activities.

The data was intended for machine learning,
and the subjects were randomly assigned into two data sets:
`train` and `test`, which are located in their own subdirectories.
For our purposes they really consitute a single data set.
Each directory is similar, though the file names differ.

The training data consists of 7352 data samples
* `train/X_train.txt` is a 7352 x 561 matrix of floating point values,
  where each row is the i<sup>th</sup> sample and each column is the value
  of the n<sup>th</sup> feature collected as part of that sample.
* `train/Y_train.txt` is a 7352 x 1 collection of activity values.
* `train/subject_train.txt` is a 7352 x 1 collection of subject ids,
  where each row is the id of the subject contributing the i<sup>th</sup>
  sample.
  There are 21 unique subjects in the traning data.

The test data is similar to the traning data, except
* everything is in a directory `test`.
* the files are `X_test.txt`, `Y_test.txt`, and `subject_test.txt`.
* there are only 2947 samples in the test set.
* there are only 9 subjects in the test data,
  who consititue a disjoint set from the training data.

Both the training and test data also include additional data in
the `Internal signals` directory.
For our purposes, that data is uninteresting, and may be ignored.

### Memory estimate

Given the large number of features in the data,
and given that we are only intrested in the means and standard deviations,
it is woth cosidering memory usage.
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

### Processing Strategy

Given the above memory estimate,
and given the nature of this project 
as course work, to be peer graded,
the processing strategy was to follow the assignment directions
pretty much in order.
There would be some preformance gain from having skipped unused columns
as mentioned in the memory section above.
Not doing that, there would be a gain by extracting the colums
we care about before merging the data.
It might also be simpler append activities to the main data before the merge.
However, for clarity, none of these optimizations were used.

### Transforming the data

#### Merging the datasets.

Since we are interested in the whole, 
we can merge the training and test data sets 
into one master dataset, by simply concatinating the data frames.






[data]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (UCI Human Activity Recognition Data Set)
[UCIML]: http://archive.ics.uci.edu/ml/index.html (UCI Machine Learning Repository)
[HAR]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones (Human Activity Recognition Using Smartphones)
