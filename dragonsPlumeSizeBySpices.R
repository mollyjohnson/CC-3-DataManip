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
# for when using Rstudio desktop version only (not cloud version, for cloud, leave as default)
# setwd("C:/Users/mljoh/github/ecologyDataScienceCourses/CC-3-DataManip")

# check where current working directory now is
getwd()

# import plume size data from .csv
plume_size <- read.csv("dragons.csv", header = TRUE)

# check import and preview data
head(plume_size)  # first few observations
str(plume_size)  # types of variables

# get object info
plume_size$dragon.ID  # prints all id codes in dataset
length(unique(plume_size$dragon.ID))  # num of distinct dragons
length(unique(plume_size$species))  # num of distinct species

# 1. fix: ----
# rename 4th treatment (paprika column) to turmeric
# format: rename(dataframe, newname = oldname)
plume_size <- rename(plume_size, turmeric = paprika)

# confirm that the 4th treatment col name is now turmeric instead of paprika
summary(plume_size)
str(plume_size)
class(plume_size)

# 2. fix: ----
# hungarian horntail measurements for tabasco trial only should be 30cm lower than they are

# look at current hungarian horntail tabasco values
head(filter(plume_size, species == "hungarian_horntail"))
tail(filter(plume_size, species == "hungarian_horntail"))

# add 30 cm to hungarian horntail tabasco trial measurements
plume_size[plume_size$species == "hungarian_horntail", ]$tabasco = 
  plume_size[plume_size$species == "hungarian_horntail", ]$tabasco - 30

# check to make sure each hungarian horntail tabasco trial plume measurement had 30 cm added
head(filter(plume_size, species == "hungarian_horntail"))
tail(filter(plume_size, species == "hungarian_horntail"))

# make sure tabasco measurement for other species remains unaffected
head(filter(plume_size, species != "hungarian_horntail"))
tail(filter(plume_size, species != "hungarian_horntail"))

# 3. fix: ----
# lengths are in cm for all species/treatments. change to meters.
# conversion rate: 100 cm == 1 m
# thus all measurements need to be multiplied by 100 to get their length in meters

# look at current head and tail values for all
head(plume_size)  # first few observations
tail(plume_size)  # last few observations

# divide all plume sizes by 100 to get their length in meters
cm_to_m_conversion_factor = 100
plume_size$tabasco = plume_size$tabasco / cm_to_m_conversion_factor
plume_size$jalapeno = plume_size$jalapeno / cm_to_m_conversion_factor 
plume_size$wasabi = plume_size$wasabi / cm_to_m_conversion_factor
plume_size$turmeric = plume_size$turmeric / cm_to_m_conversion_factor

# look at new head and tail values for all to ensure they were converted to meters properly
head(plume_size)  # first few observations
tail(plume_size)  # last few observations
str(plume_size)
class(plume_size)

# save the fixed data to a new csv prior to converting to long form to have a copy if needed later
write.csv(plume_size, file = "dragons_w_data_mistake_fixes.csv")

# convert dataframe to long format
plume_size_long = gather(plume_size, spice, plume_size.meters,
                         c(tabasco, jalapeno, wasabi, turmeric))

# check that it was converted to long form correctly
head(plume_size_long)
tail(plume_size_long)

# create 3 boxplots (1 for each species) to show the effects of the spices on plume size
par(mfrow = c(1, 3))  # splits plotting device into 3 cols where the plots will all appear side by side

# welsh green boxplot
plume_size_long_welsh_green <- filter(plume_size_long, species == "welsh_green")
boxplot(plume_size.meters ~ spice, data = plume_size_long_welsh_green,
        xlab = "Spice",
        ylab = "Plume Size (m)",
        main = "Plume Size of Welsh Green Dragons",
        ylim = c(0, 2.0))

# hungarian horntail boxplot
plume_size_long_hungarian_horntail <- filter(plume_size_long, species == "hungarian_horntail")
boxplot(plume_size.meters ~ spice, data = plume_size_long_hungarian_horntail,
        xlab = "Spice",
        ylab = "Plume Size (m)",
        main = "Plume Size of Hungarian Horntail Dragons",
        ylim = c(0, 2.0))

# swedish shortsnout boxplot
plume_size_long_swedish_shortsnout <- filter(plume_size_long, species == "swedish_shortsnout")
boxplot(plume_size.meters ~ spice, data = plume_size_long_swedish_shortsnout,
        xlab = "Spice",
        ylab = "Plume Size (m)",
        main = "Plume Size of Swedish Shortsnout Dragons",
        ylim = c(0, 2.0))