

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

full$Title <- gsub('(.*, )|(\\..*)', '',full$Name)
table(full$Sex,full$Title)

rare_title <- c('Dona','Lady','the Countess','Capt','Col','Don','Dr','Major','Rev','Sir','Jonkheer')

full$Title[full$Title == 'Mlle'] <- 'Miss'
full$Title[full$Title == 'Ms'] <- 'Miss'
full$Title[full$Title == 'Mme'] <- 'Mrs'
full$Title[full$Title %in% rare_title] <- 'Rare Title'

table(full$Sex,full$Title)
help("sapply")
help("fun")
full$Surname <- sapply(full$Name,function(x) strsplit(x,split = '[,.]')[[1]][1])
full$Surname
full$Fsize <- full$SibSp + full$Parch + 1
full$Family <- paste(full$Surname,full$Fsize,sep = '_')


ggplot(full[1:891,],aes(x=Fsize,fill = factor(Survived))) + 
    geom_bar(stat = 'count',position = 'dodge') + 
      scale_x_continuous(breaks = c(1:11)) + 
        labs(x='Family Size') +
          theme_few()