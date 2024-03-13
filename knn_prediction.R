#################################### KNN ###########################
df <-read.csv("C:/Users/LENOVO/Documents/R/house_price_ML/house_prices.csv", header = TRUE) #the preprocessed data

library("caTools")
library('glmnet')
set.seed(0)
split <- sample.split(df, SplitRatio = 0.8)
train_set <- subset(df, split == TRUE)
test_set <- subset(df, split == FALSE)

train.fit <- glm(Sold~.,data = train_set, family = binomial)
test.probs <- predict(train.fit, test_set, type = 'response')

test.pred = rep('NO',120)
test.pred[test.probs > 0.5] = 'YES' # whenever the probability is > 0.5

table(test.pred, test_set$Sold) #something is wrong here

#METHOD 3 KNN bases classifiers 
library("class")

trainX <- train_set[,-16] #all except the Sold column
testX <-  test_set[,-16]

trainY <- train_set$Sold
testY <- test_set$Sold

k = 3

trainX_a = scale(trainX)
testX_a = scale(testX)
set.seed(0)

knn.pred <- knn(trainX_a, testX_a, trainY, k=k)
table(knn.pred, testY)  #accuracy in this case is 55%

