#Descision Trees

###### REGRESSION DECISION TREES #######################
#import movie dataset
movie <- read.csv("/home/souvede/Documents/R_course/house_price_ML/Movie_regression.csv", header = TRUE)

summary(movie) #the number of NA in a variable is also shown
#If time taken is null, replace it with the MEAN time_taken
movie$Time_taken[is.na(movie$Time_taken)]<- mean(movie$Time_taken, na.rm = TRUE)

#Test-Train Split
library("caTools")
set.seed(0)
split <- sample.split(movie, SplitRatio = 0.8) # assign 80% True and others false
train = subset(movie, split ==TRUE) #contain the true part of the split. Notice the double equals '=='
test <- subset(movie, split ==FALSE)

#Building a regression tree

#install required packages
install.packages("rpart")
install.packages("rpart.plot")
library("rpart")
library("rpart.plot")

#Run regression tree model on train set
#in regtree, we will get all the information about the regression tree
#COllection is our dependent variable, and we want to find its relationship with other variables
#controll helps to set the length/depth of the decision tree
regtree <- rpart(formula = Collection~., data = train, control = rpart.control(maxdepth = 3) )
#Remember to press F1 for more info on these functions

#Plot the decision tree
# box.palette is optional and is to set the color palatte
#Digit tells how many significant digits should our decision tree have, if 0, it will give numbers in scientific format
rpart.plot(regtree, box.palette = "RdBu", digits = -3)

#predict the value at any point and add a column for them in the test dataset
test$pred <- predict(regtree, test, type = "vector") #type = vestor since this is regression, else it would be calass

MSE2 <- mean((test$pred -test$Collection)^2)

#Tree pruning. To remove weak nodes and reduce MSE

fulltree <- rpart(formula = Collection~., data = train, control = rpart.control(cp = 0)) #Note that we used cp instead of max depth

rpart.plot(fulltree, box.palette = "RdBu", digits = -3)
#To print the values of full tree
printcp(fulltree)
#You can plot the values of trees
plotcp(regtree)

# To find the CP value at which the x-validated relative erro is minimum:
mincp <- regtree$cptable[which.min(regtree$cptable[,"xerror"]), "CP"]

prunedtree <- prune(fulltree, cp = mincp)
rpart.plot(prunedtree, box.palette = "RdBu", digits = -3)

# Check perform of pruned tree and compare it with that of full tree:
test$fulltree <- predict(fulltree, test, type = "vector")
MSE2full = mean((test$fulltree -test$Collection)^2)

test$prunedtree <- predict(prunedtree, test, type = "vector")
MSE2pruned= mean((test$prunedtree -test$Collection)^2)


##################### CLASSIFICATION DECISION TREES ################

movies_c <- read.csv("/home/souvede/Documents/R_course/house_price_ML/Movie_classification.csv", header = TRUE)

#Data preprocession
summary(movies_c)

#Fill NA values
movies_c$Time_taken[is.na(movies_c$Time_taken)] <- mean(movies_c$Time_taken, na.rm = TRUE)

#Test-train split
set.seed(0)
split = sample.split(movies_c, SplitRatio = 0.8)
train_c =subset(movies_c, split == TRUE)
test_c =subset(movies_c, split == FALSE)

#Run classification tree model on train set. NOTE the method option
classtree <- rpart(formula = Start_Tech_Oscar~., data = train_c, method = 'class',  control = rpart.control(maxdepth = 3))

#Plot the decition tree
rpart.plot(classtree, box.palette = "RdBu", digits = -3)

#predict value at any point
test_c$pred <- predict(classtree, test_c, type = "class")

# Identify the errors. where pred = actual and where not
table(test_c$Start_Tech_Oscar, test_c$pred) #63/112 are correct i.e 56.25%


#################### Ensamble Method #########

#Bagging In regression
install.packages('randomForest') ##Cannot
library('randomForest')

set.seed(0)
#mtry means how many predictor variables that we want to consider while building our model
# add 'method' option for classfication
bagging = randomForest(formula = Collection~., data = train, mtry = 17) # all the 17 predicto variables
test$bagging <- predict(begging, test)
MSE2bagging <- mean((test$bagging -test$Collection)^2)


#Random Forest In regression
randomfor <- randomForest(formula = Collection~., data = train, ntree=500) #500 is the max num of trees the model should create
#predict the output
test$random <- predict(randomfor, test)
MSE2random <- mean((test$random -test$Collection)^2)


#Gradient boosting Old way. YOu need to learn new way
install.packages('gbm')
library('gbm')

set.seed(0)
boosting <- gbm(Collection~., data = train, distribution = 'gaussian', n.trees = 5000, interaction.depth = 4, shrinkage = 0.009, verbose = 7)
# destribution = 'Gaussian' for regression and 'bernoulli' for classifiaction
#the varbose parameter prevent getting output at each iteration
test$boost <- predict(boosting,test)
MS2boost <- mean((test$boost- test$Collection)^2)


#ADA boosting. Run on classification trees only
install.packages('adabag')
library('adabag')
train$Start_Tech_Oscar1 <- as.factor(train_c$Start_Tech_Oscar)
adaboost <- boosting(Start_Tech_Oscar1~.-Start_Tech_Oscar, data= train_c, boos=TRUE)
predada <- predict(adaboost, test_c)
table(predada$class, test_c$Start_Tech_Oscar)

t1<- adaboost$trees[[1]]
plot(t1)
text(t1,pretty=100)


#XG boost Find more credible resources for these