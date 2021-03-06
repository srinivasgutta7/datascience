library(rpart)
library(caret)
library(RWeka)

setwd("C:/Users/Algorithmica/Downloads")
titanic_train = read.csv("train.csv", na.strings = c("NA",""))
class(titanic_train)
dim(titanic_train)
str(titanic_train)
#preparation of data
titanic_train$Survived = as.factor(titanic_train$Survived)
titanic_train$Pclass = as.factor(titanic_train$Pclass)

#model building using formula interface
#In formula interface, caret train function automatically transforms all factor types to continuous types
set.seed(100)
nb_grid = expand.grid(.usekernel=F, .fL=1, .adjust=0)
resampling_strategy = trainControl(method="cv", number = 10)
nb_model1 = train(titanic_train[,c("Sex", "Pclass", "Embarked", "SibSp", "Fare")], titanic_train$Survived, method="nb", trControl = resampling_strategy, tuneGrid = nb_grid)
nb_model1$finalModel$apriori
nb_model1$finalModel$tables

titanic_test = read.csv("test.csv", na.strings = c("NA",""))
dim(titanic_test)
str(titanic_test)
titanic_test$Pclass = as.factor(titanic_test$Pclass)

res = predict(nb_model1, titanic_test[1,], type="prob")

titanic_test$Survivedprob = predict(nb_model1, titanic_test, type="prob")
titanic_test$Survived = predict(nb_model1, titanic_test, type="raw")
write.csv(titanic_test[,c("PassengerId","Survived")],"submission.csv", row.names = F)


