#
# Class project for Getting and Cleaning Data.
#
source("fileUtils.R")
source("dataTransforms.R")
library(reshape2)
library(plyr)

# Local Constants that we may want to change
dataDir = "./data"
cleanUpData = TRUE
outputDir = "./output"

#
# Get the data (assuming it's not local and cached)
#

# Fetch the data if needed
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip"
archiveFile <- fetchData(dataUrl, "dataset.zip", dataDir)
# List the files in the archive
dataFiles <- zipDir(archiveFile)
# extract files, but skill the Internal Signals, and flatten things
fileNames <- limitFiles(dataFiles$Name)
unzip(archiveFile, files=fileNames, junkpaths=TRUE, exdir=dataDir)


#
# Load up the raw files
#
activityLabels <- loadLookup("activity_labels.txt", "./data")
featureNames <- loadLookup("features.txt", "./data")
subjectTrain <- loadJoin("subject_train.txt", "./data")
yTrain <- loadJoin("y_train.txt", "./data")
xTrain <- loadData("X_train.txt", "./data", nrow(featureNames))
subjectTest <- loadJoin("subject_test.txt", "./data")
yTest <- loadJoin("y_test.txt", "./data")
xTest <- loadData("X_test.txt", "./data", nrow(featureNames))

#
# Merge the data sets
#
values <- rbind(xTrain, xTest)
activities <- rbind(yTrain, yTest)
subjects <- rbind(subjectTrain, subjectTest)

#
# extract out just the colums for mean and std features
#
# first set the column names to match the features
names(values) <- featureNames$name
# select just the colums we want
values <- values[, filterFeatures(featureNames$name)]

#
# label the activities
#
# give the activity nicer names
names(activityLabels) <- c("activity_id", "activity")
names(activities) <- c("activity_id")
# append the activity id
values <- cbind(values, activities)
# cartesian join to the activity labels
values <- merge(values, activityLabels, by="activity_id")
# remove the activity id column
values <- values[, !(names(values) %in% c("activity_id"))]


#
# Add the subject as well
#
# give the subject a nicer label
names(subjects) <- c("subject")
# and prepend that to the data
dataPoints <- cbind(subjects, values)

#
# Convert to thin/tall data, to make the later summerization easier
#

# prepend a sequence for observation id, so we have a key
observations <- data.frame(observation = seq_len(nrow(dataPoints)))
dataPoints <- cbind(observations, dataPoints)
# then melt the data using observation, subject and activity as the key
# and treating all the origional values as measures
idAttrs = c("observation", "subject", "activity")
measures = setdiff(names(dataPoints), idAttrs)
# save a copy of the measures, to help with creating
# the Codebook.
mkdir(outputDir)
write.table(measures, file=file.path(outputDir, "measures.txt"),
            row.names=FALSE, column.names=FALSE, quote=FALSE)
tallData <- melt(dataPoints,id = idAttrs, measure.vars = measures) 
                           
# finally save out the data set
mkdir(outputDir)
write.table(tallData, file=file.path(outputDir, "observations.txt"),
            row.names=FALSE, quote=FALSE)

#
# Now Summarize up the data
#
averages <- ddply(tallData,
                  .(subject, activity, variable),
                  summarize,
                  average=mean(value))
write.table(averages, file=file.path(outputDir, "averages.txt"),
            row.names=FALSE, quote=FALSE)
                  
#
# clean up the temporary files
#
if (cleanupData) {
  unlink(dataDir, recursive=TRUE)
}





