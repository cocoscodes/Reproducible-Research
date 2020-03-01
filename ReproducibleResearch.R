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










