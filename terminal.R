

library(ggplot2)
library(ggthemes)
library(scales)
library(dplyr)
library(randomForest)
library(mice)

train <- read.csv('C:/Users/SeaBur/Documents/GitProjects/titanic_risdal/train.csv',stringsAsFactors = F)
test <- read.csv('C:/Users/SeaBur/Documents/GitProjects/titanic_risdal/test.csv',stringsAsFactors = F)

full <- bind_rows(train,test)
str(full)
head(full)
