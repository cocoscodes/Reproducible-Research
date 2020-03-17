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

# RepResearch Course project 2 ----
getwd()
setwd("/Users/alejandrosolis/Desktop/Data_Sc/R/Reproducible-Research/RepResearchCourseProject")

stormData <- read.csv("repdata_data_StormData.csv.bz2")
head(stormData)
str(stormData)
summary(stormData)
unique(stormData$EVTYPE)
# Across the United States, which types of events (as indicated in the 
# EVTYPE variable) are most harmful with respect to population health?
library(dplyr)
library(ggplot2)
stormData$BGN_DATE <- as.Date(as.character(stormData$BGN_DATE),"%m/%d/%Y %H:%M:%S")
popHealth <- stormData %>%
  group_by(EVTYPE) %>%
  summarise(fatalities = sum(FATALITIES),
            injuries = sum(INJURIES)) %>% 
  arrange(desc(fatalities))

top10Fat <- popHealth[1:10,c(1,2)]
top10inj <- popHealth[,c(1,3)]
top10inj$injuries <- sort(top10inj$injuries,decreasing = TRUE)
top10inj <- top10inj[1:10,]

require(gridExtra)
plot1 <- ggplot(top10Fat,aes(top10Fat$EVTYPE,top10Fat$fatalities, 
                  fill = top10Fat$fatalities)) + geom_bar(stat="identity") + 
  xlab("Type of event")+ylab("# of fatalities")+coord_flip()+ 
  theme(legend.position = "none")
  
plot2 <- ggplot(top10inj,aes(top10inj$EVTYPE,top10inj$injuries, 
                    fill = top10inj$injuries)) + geom_bar(stat="identity") + 
  xlab("Type of event")+ylab("# of injuries")+coord_flip()+ 
  theme(legend.position = "none")
grid.arrange(plot1,plot2,nrow=2)
# Tornados

names(stormData)

# Across the United States, which types of events have the greatest economic 
# consequences?

econDmg <- stormData %>%
  group_by(EVTYPE) %>%
  select(event= EVTYPE, property = PROPDMG, propertyExp = PROPDMGEXP,
         crops=CROPDMG,cropsExp = CROPDMGEXP)

unique(stormData$PROPDMGEXP)
unique(stormData$CROPDMGEXP)

econDmg$propertyExp <- as.character(econDmg$propertyExp)
econDmg$cropsExp <- as.character(econDmg$cropsExp)

econDmg$propertyExp[econDmg$propertyExp=="-"] <- 0
econDmg$propertyExp[econDmg$propertyExp=="?"] <- 0
econDmg$propertyExp[econDmg$propertyExp=="+"] <- 0
econDmg$propertyExp[econDmg$propertyExp==""] <- 1
econDmg$propertyExp[econDmg$propertyExp=="1"] <- 10
econDmg$propertyExp[econDmg$propertyExp=="2"] <- 100
econDmg$propertyExp[econDmg$propertyExp=="3"] <- 1000
econDmg$propertyExp[econDmg$propertyExp=="4"] <- 10000
econDmg$propertyExp[econDmg$propertyExp=="5"] <- 100000
econDmg$propertyExp[econDmg$propertyExp=="6"] <- 1000000
econDmg$propertyExp[econDmg$propertyExp=="7"] <- 10000000
econDmg$propertyExp[econDmg$propertyExp=="8"] <- 100000000
econDmg$propertyExp[econDmg$propertyExp=="H"] <- 100
econDmg$propertyExp[econDmg$propertyExp=="h"] <- 100
econDmg$propertyExp[econDmg$propertyExp=="K"] <- 1000
econDmg$propertyExp[econDmg$propertyExp=="M"] <- 1000000
econDmg$propertyExp[econDmg$propertyExp=="m"] <- 1000000
econDmg$propertyExp[econDmg$propertyExp=="B"] <- 1000000000

econDmg$propertyExp <- as.numeric(econDmg$propertyExp)

econDmg$cropsExp[econDmg$cropsExp=="?"] <- 0
econDmg$cropsExp[econDmg$cropsExp=="0"] <- 1
econDmg$cropsExp[econDmg$cropsExp==""] <- 1
econDmg$cropsExp[econDmg$cropsExp=="2"] <- 100
econDmg$cropsExp[econDmg$cropsExp=="k"] <- 1000
econDmg$cropsExp[econDmg$cropsExp=="K"] <- 1000
econDmg$cropsExp[econDmg$cropsExp=="M"] <- 1000000
econDmg$cropsExp[econDmg$cropsExp=="m"] <- 1000000
econDmg$cropsExp[econDmg$cropsExp=="B"] <- 1000000000

econDmg$cropsExp <- as.numeric(econDmg$cropsExp)

econDmg$propcost <- econDmg$property*econDmg$propertyExp
econDmg$cropcost <- econDmg$crops*econDmg$cropsExp

top10prop <- econDmg %>%
  group_by(event) %>%
  summarise(cost=sum(propcost)) %>%
  arrange(desc(cost))
top10prop <- top10prop[1:10,]

top10crop <- econDmg %>%
  group_by(event) %>%
  summarise(cost=sum(cropcost)) %>%
  arrange(desc(cost))
top10crop <- top10crop[1:10,]

require(gridExtra)
plot3 <- ggplot(top10prop,aes(top10prop$event,top10prop$cost,fill=top10prop$cost))+
  geom_bar(stat="identity") + 
  xlab("Type of event")+ylab("Property costs")+coord_flip()+ 
  theme(legend.position = "none")

plot4 <- ggplot(top10crop,aes(top10crop$event,top10crop$cost,fill=top10crop$cost))+
  geom_bar(stat="identity") + 
  xlab("Type of event")+ylab("Crop costs")+coord_flip()+ 
  theme(legend.position = "none")

grid.arrange(plot3,plot4,nrow=2)

top10crop[1,2]>top10prop[1,2]


