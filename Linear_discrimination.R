#############################METHOD2 Linear discriminationa
df <-read.csv("C:/Users/LENOVO/Documents/R/house_price_ML/house_prices.csv", header = TRUE) #the preprocessed data

library(MASS)
lda.fit <- lda(Sold~., data = df)
lda.fit
#find the prdicted probabilities
lda.pred <- predict(lda.fit, df)
lda.pred$posterior
lda.class <- lda.pred$class

#confusion matrix:
table(lda.class,df$Sold) #Accuracy in this case is 65%

#To change boundry condition eg num of classes that belong to one if we take boundry condition of 0.8
sum(lda.pred$posterior[,1]>0.8) #76 i.e for 76 values, the probability ofbelonging to 1 is more than 0.8

#for qda,the process is the same as that in lda
qda.fit <- qda(Sold~., data = df)
qda.pred <- predict(qda.fit, df)
qda.pred$posterior
qda.class <- qda.pred$class

table(qda.class,df$Sold)

sum(qda.pred$posterior[,1]>0.8) 


