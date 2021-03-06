

library(ggplot2)
library(ggthemes)
library(scales)
library(dplyr)
library(randomForest)
library(mice)
install.packages("RODBC")
library(RODBC)


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

full$FsizeD[full$Fsize == 1] <- 'singleton'
full$FsizeD[full$Fsize < 5 & full$Fsize > 1] <- 'small'
full$FsizeD[full$Fsize > 4] <- 'large'

mosaicplot(table(full$FsizeD,full$Survived),main = 'Family Size by Survival', shade = T)

full$Cabin[1:28]
strsplit(full$Cabin[2],NULL)[[1]]

full[c(62,830),'Embarked']
subset(full,'Survived' = 1)
str(full)
full[full$Survived = 0,]
full[,'Embarked']
full[full$Fare > 500,]
table(full$Sex,full$Survived)

embark_fare <- full %>% filter(PassengerId !=62 & PassengerId != 830)

ggplot(embark_fare,aes(x=Embarked,y= Fare,fill = factor(Pclass))) + 
  geom_boxplot() + 
  geom_hline(aes(yintercept=80),
             colour='red',linetype='dashed',lwd=2) + 
  scale_y_continuous(labels=dollar_format()) +
  theme_few()

full$Embarked[c(62,830)] <- 'C'

full[1044,]

ggplot(full[full$Pclass == '3' & full$Embarked == 'S', ],
       aes(x=Fare)) +
      geom_density(fill = '#99d6ff',alpha=0.4) + 
      geom_vline(aes(xintercept=median(Fare,na.rm = T)),
      colour= 'red', linetype='dashed',lwd=1) + 
      scale_x_continuous(labels=dollar_format()) + theme_few()
