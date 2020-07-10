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

# experiment w rep() to create repetitions of elements 
rep(c(1, 2), 3)  # will give repetition of the first two elements as many times as third element, i.e.
# 1 2 1 2 1 2 (so 1 2, 3 times)

# Changing variable names and value in a data frame ----

# let's create a working copy of our object
elong2 <- elongation

# now suppose you want to change the name of a column: you can use the names() function
# used on its own, it returns a vector of the names of the columns. Used on the left side
# of the assign arrow, it overwrites all or some of the names to value(s) of your choice
names(elong2)  # returns the names of the columns

names(elong2)[1] <- "zone" # changing "Zone" to "zone": we call the 1st element of the names vector
# using brackets, and assign it a new value

names(elong2)[2] <- "ID" # changing "Indiv" to "ID": we call the 2nd element and assign it the desired value

# now suppose there's a mistake in the data, and the value 5.1 for individual 373 in year 2008 should
# really be 5.7

# option 1: you can use row and column number
elong2[1,4] <- 5.7

# option 2: you can use logical conditions for more control
elong2[elong2$ID == 373, ]$X2008 <- 5.7  # completely equivalent to option 1

# CREATING A FACTOR ----

# let's check the classes
str(elong2)

# the zone column shows as int data (whole nums), but it's really a grouping factor (the zones could've
# been called A, B, C, etc.). Let's turn it into a factor:
elong2$zone <- as.factor(elong2$zone)  # converting and overwriting original class
str(elong2)  # now zone is a factor w 6 levels

# CHANGING A FACTOR'S LEVELS ----
levels(elong2$zone) # shows the different factor levels

levels(elong2$zone) <- c("A", "B", "C", "D", "E", "F")  # you can overwrite the orig. levels w new names

levels(elong2$zone) # shows the different factor levels now that they've been changed

# remember, you must make sure that you have a vector the same length as the number of factors,
# and pay attention to the order in which they appear!

# TIDYING DATA ----

###### tidy datasets are arranged so that each ROW represents an OBSERVATION and
###### each COLUMN represents a variable
elongation_long <- gather(elongation, Year, Length,
# in this order: data frame, key, value
                          c(X2007, X2008, X2009, X2010, X2011, X2012))
                          # we need to specify which cols to gather

# here we want the lengths (value) to be gathered by year (key)

# let's reverse! spread() is the inverse function, allowing you to go from long to wide format
elongation_wide <- spread(elongation_long, Year, Length)

# we gave col names previously to tell gather() which cols to reshape. this works if you
# only have a few. but if you have many cols, you might be better off specifying the col nums
elongation_long <- gather(elongation, Year, Length, c(3:8))

# quick boxplot to find out if there is inter-annual variation in the growth of
# Empetrum hermaphroditum
#boxplot(Length ~ Year, data = elongation_long,
#        xlab = "Year", ylab = "Elongation (cm)",
#        main = "Annual growth of Empetrum hermaphroditum")

# DIPLYR LIBRARY FUNCTIONS ----
# using the dplyr library, their functions take the dataframe as the first arg,
# so you can avoid having to refer to the full object when referring to cols (no $ needed!)

# rename() variables ----
# changes the name of the columns (getting rid of the capital letters) and overwriting our data frame.
# first arg is data frame, second/third etc takes the form of New name = Old name.
elongation_long <- rename(elongation_long,
                          zone = Zone,
                          indiv = Indiv,
                          year = Year,
                          length = Length)


# as we saw earlier, the base R equivalent to the dplyr rename() function would've been:
# names(elongation_long) <- c("zone", "indiv", "year", "length")

# filter() rows and select() columns ----
# helps you reduce your data frame to just the rows and columns you need
# NOTE: the select() function often clashes w/ functions of the same name
# in other packages, and for that reason it's recommended to always use the
# notation dplyr::select() when calling it

# FILTER OBSERVATIONS ----

# let's keep observations from zones 2 and 3 only, and from years 2009 to 2011
# you can use multiple diff conditions, separated by commas
elong_subset <- filter(elongation_long,
                       zone %in% c(2, 3),
                       year %in% c("X2009", "X2010", "X2011"))  

# (for comparison, the base R equivalent would be not assigned to an object here.)
# base R equiv:
# elongation_long[elongation_long$zone %in% c(2, 3) & elongation_long$year %in%
# c("X2009", "X2010", "X2011"), ]

# Note: we can use the %in% logical operator here because we're looking to match a list
# of exact character values. if you want to keep observations within a range of NUMERIC values,
# you either need two logical statements in your filter function (i.e. length > 4 & length <= 6.5),
# or you can use the between() function, i.e. between(length, 4, 6.5)

# SELECT OBSERVATIONS ----

# let's ditch the zone column just as an example
elong_no.zone <- dplyr::select(elongation_long, indiv, year, length)  # select all but zone, or alternatively
elong_no.zone <- dplyr::select(elongation_long, -zone)  # the minus sign removes the column

# for comparison, the base R equivalent would be (not assigned to an object here)
# elongation_long[ , -1]  # removes the first column

# a nice hack! select() lets you rename and reorder columns on the fly
elong_no.zone <- dplyr::select(elongation_long, Year = year, Shrub.ID = indiv, Growth = length)

# mutate() your dataset by creating new columns! ----
# create a new column representing total growth for the period of 2007 - 2012
elong_total <- mutate(elongation, total.growth = X2007 + X2008 + X2009 + X2010 + X2011)

# group_by certain factors to perform operations on chunks of data ----
# you won't see any visible change to your data frame. it creates an internal grouping structure,
# which means that every subsequent function you run on it will use these groups, and not the whole
# dataset, as an input. it's very useful when you want to compute summary statistics for different
# sites, treatments, species, etc.
elong_grouped <- group_by(elongation_long, indiv)  # grouping our dataset by individual

# if you now compare elong_grouped and elongation_long, they should look exactly the same. but now,
# let's use summarise() to calculate the total growth of each individual over the years
# summarise() data with a range of summary statistics ----
# the summarise function will always aggregate your original data frame, i.e. the output data frame
# will be shorter than the input. Here, let's contrast summing growth increments over the study period
# on the original dataset vs our new GROUPED dataset

# corresponds to the sum of all growth increments in the dataset(all individuals and years)
summary1 <- summarise(elongation_long, total.growth = sum(length))

# gives us a breakdown of total growth per INDIVIDUAL, as that was our grouping variable
summary2 <- summarise(elong_grouped, total.growth = sum(length))

# we can also compute other summary statistics, like the mean or
# standard deviation of growth across years
summary3 <- summarise(elong_grouped, total.growth = sum(length),
                      mean.growth = mean(length),
                      sd.growth = sd(length))

# but w grouping, we lose all other cols not specified at the grouping stage or in a summary operation
# for instance, we lost the column year because there are 5 yrs for each individual, and we're
# summarising to get one single growth value per individual. ALWAYS CREATE A NEW OBJECT FOR
# SUMMARISED DATA, SO THAT YOUR FULL DATASET DOESN'T GO AWAY! you can always merge back some info later

# ..._join() datasets based on shared attributes ----
# sometimes you may have multiple data files for the same project. you can join these 
# datasets into one table. joins are similar to those in SQL

# in this example, we want to keep all the information in elong_long and have the
# treatment code repeated for five occurrences of every individual, so we will use left_join()

# load the treatments associated w each individual
treatments <- read.csv("EmpetrumTreatments.csv", header = TRUE, sep = ";")
head(treatments)

# join the two data frames by ID code. the column names are spelled differently though,
# so we need to tell the function which columns represent a match. we have 2 columns
# that contain the same info in both datasets: zone and individual ID
experiment <- left_join(elongation_long, treatments, by = c("indiv" = "Indiv", "zone" = "Zone"))

# we see that the new object has the same length as our first data frame, which is what we want.
# and the treatments corresponding to each plant have been added

# equivalent base r function using merge()
# experiment2 <- merge(elongation_long, treatments, by.x = c("zone, indiv"),
#                    by.y = c("Zone", "Indiv"))


# now that we have gone to the trouble of adding treatments to our data, let's check
# if they affect growth by drawing another boxplot
boxplot(length ~ Treatment, data = experiment)





