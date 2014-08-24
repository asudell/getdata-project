#
# Generic filehandling funciton
# These are convenience functions to keep run_analysis.R
# a bit neat.  But they are intended to be generic and reusable.
#

fetchData <- function(url, fileName="data.txt", dataDir="./data") {
  #
  # Download data from url into a scratch directory
  # Args:
  #  url      : url to download data from
  #  fileName : name to give the file
  #  dataDir  : scratch directory to store data in
  # Returns: full path to the data file
  
  mkdir(dataDir)

  # download the data file, if not present
  dest <- file.path(dataDir, fileName)
  if (! file.exists(dest)) {
    download.file(url, dest, method="curl")
  }
  dest
}

mkdir <- function(dirName) {
  #
  # create a directory if needed
  #
  # Args:
  #  dirName : path to directory
  # Return:
  #   None
  
  if (! file.exists(dirName)){
    dir.create(dirName)
  }
}

zipDir <- function(zipfile) {
  #
  # Get a list of files in a zip archive
  #
  # Args:
  #  zipfile : path to archive
  # Returns:
  #  data frame containing name, length, and date of each file in the archive

  unzip(zipfile, list=TRUE)
}

