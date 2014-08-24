#
# Data transformations and tricks that have specific
# understanding of the UCIML Cell Phone data set.
# Like fileutils.R, these are just convenience functions
# to keep code clean.  But by contrast they have implicit
# knowledge of the dataset and/or the problem at hand,
# and are thus not very reusable.

limitFiles <- function(fileNames) {
  #
  # Limit file names to "interesting" files we want to extract
  # clearly just an optimization to slog fewer files on and off disk
  #
  # Args:
  #  fileNames : initial list of files in the archive
  #
  # Return:
  #  character vector of files we want to extract

  # exclude everything in the Inerial Signals directories
  f <- grep("Inertial Signals", fileNames, value=TRUE, invert=TRUE)
  # and just grab the txt files
  grep("*.txt", f, value=TRUE)
}


loadLookup <- function(fileName, dataDir="./data") {
  #
  # Load any of the two column lookup tables
  #
  # Args:
  #  fileName : name of the data file t load
  #  dataDir  : path of directory holding the file
  #
  # Return:
  #  data frame with two columns, id and name
  file <- file.path(dataDir, fileName)
  read.table(file, col.names=c("id", "name"),
             colClasses=c("numeric", "character"))
}

loadJoin <- function(fileName, dataDir="./data") {
  #
  # Load any of the single column join tables
  #
  # Args:
  #  fileName : name of the data file t load
  #  dataDir  : path of directory holding the file
  #
  # Return:
  #  data frame with column, id 
  file <- file.path(dataDir, fileName)
  read.table(file, col.names=c("id"),
             colClasses=c("numeric"))
}

loadData <- function(fileName, dataDir="./data", featureCount) {
  #
  # Load the main data tables
  #
  # Args:
  #  fileName    : name of the data file t load
  #  dataDir     : path of directory holding the file
  #  featurCount : number of features wide the data file is
  #
  # Return:
  #  data frame with one row per observation, and one column per feature
  #
  file <- file.path(dataDir, fileName)
  read.table(file, colClasses=rep("numeric", featureCount))
}

filterFeatures <- function(names) {
  #
  # filter feature names to just mean() and std() values
  #
  # Args:
  #   names : feature name list to filter
  # Return:
  #   list of features which calculate mean() or std()
  #
  grep("-mean\\(|-std\\(", names, value=TRUE)
}
