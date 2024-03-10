######Support Vector Machines(SVM) 
movie <- read.csv("/home/souvede/Documents/R_course/house_price_ML/Movie_classification.csv", header = TRUE)
summary(movie)
movie$Time_taken[is.na(movie$Time_taken)] <- mean(movie$Time_taken, na.rm = TRUE)

library(caTools)
set.seed(0)
split <- sample.split(movie, SplitRatio = 0.8)
trainc <- subset(movie, split== TRUE)
testc <- subset(movie, split== FALSE)

###Linear Kernel/support vector classifier

trainc$Start_Tech_Oscar<- as.factor(trainc$Start_Tech_Oscar)
testc$Start_Tech_Oscar <- as.factor(testc$Start_Tech_Oscar)

library('e1071')

###dbug from here
svmfit <- svm(Start_Tech_Oscar~., data = trainc, kernel= 'linear',cost =1, scale = TRUE)
#scale means that we will be scaling all variables in train i.e change their values to have mean=0 and std=1
summary(svmfit)

# predicting on test set
ypred <- predict(svmfit,testc)
# create a confusion matrix
table(predict = ypred, truth= testc$Start_Tech_Oscar)

# TO check the support vector
svmfit$index

#finding best value of C/ tuning the hyoer parameter
set.seed(0)
tune.out = tune(svm, Start_Tech_Oscar~.,data=trainc ,kernel="linear", ranges =list(cost=c(0.001 , 0.01, 0.1, 1,10,100)))
bestmod = tune.out$bestmodel

