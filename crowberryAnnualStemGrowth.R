#####################################################################
# Title: Coding club Workshop: Basic data manipulation
# Description: This dataset represents annual increments in stem growth,
# measured on crowberry shrubs (Empetrum hermaphroditum) on a sand dune system.
# The Zone field corresponds to distinct zones going from closest (2) to
# farthest (7) from the sea.
# Author: Molly Johnson, Bradley University/Oregon State University
# Date: 7/10/2020
#####################################################################  

# Libraries ----
library(dplyr)
library(tidyr)

# Functions ----

# Set working directory ----
setwd("C:/Users/mljoh/github/ecologyDataScienceCourses/CC-3-DataManip")

# Import elongation data from .csv ----
elongation <- read.csv("EmpetrumElongation.csv", header = TRUE)

# Check import and preview data ----
head(elongation)  # first few observations
str(elongation)  # types of variables

# get object info
elongation$Indiv  # prints out all the ID codes in the dataset
length(unique(elongation$Indiv))  # returns the num of distinct shrubs in the data

# get second row, fifth column (example)
elongation[2,5]

# how to get all the info for row number six (example)
elongation[6, ]

# mix it all together (example)
elongation[6, ]$Indiv  # returns the value in the column Indiv for the sixth observation
# (much easier calling columns by their names than figuring out where they are)

# better to not hard code rows when looking at something tho, as that may change if you
# add or delete rows later. better to use logical operations to access specific parts of
# the data to match our specificationsj

# so let's access the values for Individual number 603 instead
elongation[elongation$Indiv == 603, ]


# Subsetting with one condition

elongation[elongation$Zone < 4, ]    # returns only the data for zones 2-3
elongation[elongation$Zone <= 4, ]   # returns only the data for zones 2-3-4


# This is completely equivalent to the last statement
elongation[!elongation$Zone >= 5, ]   # the ! means exclude


# Subsetting with two conditions
elongation[elongation$Zone == 2 | elongation$Zone == 7, ]    # returns only data for zones 2 and 7
elongation[elongation$Zone == 2 & elongation$Indiv %in% c(300:400), ]

# experiment w seq() to create a sequence
seq(300, 400, 10)  # creates sequence from start num (300) to end num (400) in increments of 3rd num (10)


