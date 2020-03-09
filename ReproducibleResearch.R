# Elements of reproducinility ----
# Analytic data
# Analytic code
# Documentation
# Distribution

# Literate Statistical Programming - The text is readable by people and the code is readable by computers
library(knitr) # is a package that builds on the work of Sweave and provides much more powerful functionality, including the ability to write in Markdown and create a variety of output formats.

# Golden rule -  script everything

# Structure of data analysis ----
# • Defining the question - defining a question is the most powerful dimension reduction tool you can ever employ.
# • Defining the ideal dataset
# • Determining what data you can access
# • Obtaining the data
# • Cleaning the data
# • Exploratory data analysis
# • Statistical prediction/modeling
# • Interpretation of results
# • Challenging of results
# • Synthesis and write up
# • Creating reproducible code

# Organizing data files ----

# Raw and processed data
# Exploratory figures - serve the role of giving you a quick look at various aspects of your data.
# Final figures
# Scripts - raw and final
# R markdown files - review on report-writing-in-R.pdf
# Readme files - if you dont use R markdown
# Final report

# Coding standards for R ----
# 1.- Always write your code using a text editor and save as a text file
# 2.- Indent your code
# 3.- Limit the with of your code to 80 columns
# 4.- Limit the lenght of a function, keep it simple

# Markdown ----
# is a text-to-HTML conversion tool for web writers. Markdown allows you to write using an easy-to-read, easy-to-write plain text format, then convert it to structurally valid XHTML (or HTML)
# For syntax review Report-writing-in-R.pdf

# R Markdown - a mixture of markdown and live R code
# knitr package transforms R markdown into standar Markdown, 
# Markdown can subsequently be converted to HTML using the markdown package in R
# The slidify package converts the content into slides

# Knitr ----
# Literate statistical programming - text explanation and code (weaved and tangled)

# documentation languages -> Markdown, LaTeX, or HTML

# Mardown is an specific version of Markup language

# My general feeling is that knitr is ideal for
# • Manuals
# • Short/medium-length technical documents
# • Tutorials
# • Reports, especially if they will be generated periodically with updated data
# • Data preprocessing documents and summaries
#I feel that knitr is NOT particularly well-suited for the following:
# • Very long research articles
# • Documenting very complex and time-consuming computations
# • Documents that require precise formatting (although this is more an issue with using 
# Markdown than it is with using knitr)

# easiest way just using Rstudio R Markdown file editor
# more complex way
library(knitr)
knit2html("markdown_demo.Rmd") # knit into an HTML
browseURL("markdown_demo.html") # open in web browser

# Steps Rmarkdown -> Markdown -> html
# DO NOT EDIT the secondary files ONLY the original Rmd
install.packages("xtable") # this package will allow better table printing in the final doc
# Review knitr Rmd doc

# Project Week 2 ----
getwd()
setwd("/Users/alejandrosolis/Desktop/Data_Sc/R/Reproducible-Research/RepData_PeerAssessment1")

# Reading file
data <- read.csv("activity.csv")
str(data)
summary(data)
head(data)
# Transforming column date to Date type
data$date <- as.Date(as.character(data$date))

# Histogram of steps per day
stepsDay <- with(data,tapply(steps,date,sum,na.rm=TRUE))
hist(stepsDay, main = "Histogram activity",xlab = "Steps per Day", col = "red")

# Mean and Median steps per day
mean(stepsDay)
median(stepsDay)

# Time series plot for average steps taken
meanSteps <- with(data,tapply(steps,interval,mean,na.rm=TRUE))
plot(meanSteps,main = "Daily average number of steps",type = "l",col="blue",
     ylab = "Average number of steps",xlab = "5 min interval")

# 5 min interval with the max number of steps
maxInterval <- data$interval[grep(max(meanSteps),meanSteps)]

# Imputing missing data - by replacing mean values for each 5 min intervals
library(dplyr)
meanInt <- function(x){replace(x, is.na(x), mean(x, na.rm = TRUE))}
newData <- data %>% 
  group_by(interval) %>%
  mutate(steps = meanInt(steps))
head(newData)
# New Histogram
stepsDayNew <- with(newData,tapply(steps,date,sum,na.rm=TRUE))
hist(stepsDayNew, main = "Histogram activity",xlab = "Steps per Day", col = "red")
# New Mean and Median steps per day
mean(stepsDayNew)
median(stepsDayNew)
# Do these values differ from the estimates from the first part of the assignment? 
# YES
# What is the impact of imputing missing data on the estimates of the total daily number of steps?
# The new histogram shows a normal distribution, new mena and new median have the same value

# Are there differences in activity patterns between weekdays and weekends?
newData$weekday <- weekdays(data$date)
newData$weekcat <- ifelse(newData$weekday %in% c("Saturday","Sunday"),"Weekend","Weekday")

# Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends
stepsMean <- aggregate(newData$steps,by=list(newData$interval,newData$weekcat),mean)
colnames(stepsMean) <- c("Interval","Weekcat","Stepsmean")
str(stepsMean)
library(ggplot2)
ggplot(stepsMean,aes(Interval,Stepsmean,color=Weekcat)) +
  geom_line() +
  facet_grid(Weekcat~.) + 
  labs(y="Average number of steps", x="5-minute interval") + 
  theme(legend.position = "none")

# Basic reproducibility check list: ----
#  • Are we doing good science?
#  • Was any part of this analysis done by hand?If so, are those parts 
# precisely document? Does the documentation match reality?
#  • Have we taught a computer to do as much as possible (i.e. coded)?
#  • Are we using a version control system?
#  • Have we documented our software environment? sessionInfo()
#  • Have we saved any output that we cannot reconstruct from original 
# data + code?
#  • How far back in the analysis pipeline can we go before our results 
# are no longer (automatically) reproducible?

# Evidence-based Data Analysis ----





