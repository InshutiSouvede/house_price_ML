# Method1: Logistic regression 
df <-read.csv("/home/souvede/Documents/R_course/house_prices.csv", header = TRUE) #the preprocessed data
str(df)

#Logistic regressionn with single predictor
glm.fit <- glm(Sold~price, data = df, family = binomial)
summary(glm.fit)

#Logistic regressionn with multiple predictor
glm.fit <- glm(Sold~., data = df, family = binomial)
summary(glm.fit)

#whether a house will be sold in 3 months

glm.prob <- predict(glm.fit,type = "response")
glm.prob[1:10]

glm.predict <- rep("NO",506)
glm.predict[glm.prob>0.5] <- "YES"

#confusion matrix
table(glm.predict,df$Sold) #accuracy in this case is 65%
