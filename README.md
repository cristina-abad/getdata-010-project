# README
# getdata-010-project

This repository is the submission for Coursera's Getting and Cleaning Data [course project](https://class.coursera.org/getdata-010/human_grading/view/courses/973497/assessments/3/submissions).

Here is a description of all the files included in this repo:

1. `CodeBook.md`: The codebook that describes the dataset (`mean_and_std.txt` and `averages.txt`).
2. `README.md`: This file.
3. `mean_and_std.txt`: Tidy dataset 1. Full description in the [CodeBook](./CodeBook.md).
4. `averages.txt`: Tidy dataset 2. Full description in the [CodeBook](./CodeBook.md).
5. `run_analysis.R`: R script that reads the input dataset and produces the datasets described in the [CodeBook](./CodeBook.md).

## Usage
By default, the script assumes that the original UCI dataset (see [CodeBook](./CodeBook.md) for details) has been downloaded and extracted in the current working directory. If you have not done this, you can uncomment the following two lines in the [run_analysis.R](./run_analysis.R) script to perform this step for you.

```
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "HAR_dataset.zip")
#unzip("HAR_dataset.zip")
```

To run the analysis script from the command line:

```
R -f run_analysis.R
```

The result will be the two datasets also included in this repository.

## Notes
* This script has only been tested on CentOS 6.5
