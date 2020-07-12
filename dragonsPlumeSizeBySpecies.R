####################################################################
# Title: Coding Club Workshop: Basic data manipulation challenge
# Description: This dataset gives the length (cm) of fire plumes
# breathed by dragons of different species when fed different
# spices. Need to make the data tidy (long format) and to create a
# boxplot for each species showing the effect of the spices on plume size
# such that you can answer the questions:
# 1. Which spice triggers the most fiery reaction? 
# 2. And the least?
# HOWEVER, you find out that your field assistant was a bit careless during
# data collection, and let slip some mistakes that need correcting.
# 1. The 4th treatment wasn't paprika at all, it was turmeric.
# 2. There was a calibration error with the measuring device for the tabasco
# trial, but only for the Hungarian Horntail species. All measurements are
# 30cm higher than they should be.
# 3. The lengths are given in centimeters, but really it would make sense
# to convert them to meters
# Author: Molly Johnson, Bradley University/Oregon State University
# Date: 7/12/20
####################################################################

# Libraries ----
library(dplyr)
library(tidyr)

# Functions ----


# Set working directory ----
setwd(":/Users/mljoh/github/ecologyDataScienceCourses/CC-3-DataManip")