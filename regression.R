#pre-processing
houses <- read.csv("C:/Users/LENOVO/Documents/R/house_price_ML/Housing.csv", header = TRUE)

# checking for useless fields from categorical cells
mnrd <- table(houses$mainroad)
guestRoom <- table(houses$guestroom)
basement <- table(houses$basement)
hotwater <- table(houses$hotwaterheating)
airconditioning <- table(houses$airconditioning)
prefare <- table(houses$prefarea)
barplot(mnrd, main = "Main road responses")
barplot(guestRoom, main = "Guest room responses")
barplot(basement, main = "basement responses")
barplot(hotwater, main = "hot water responses") #almost the same responses but after correlation matrix, we willfifgure it out
barplot(airconditioning, main = "air conditioning responses")
barplot(prefare, main = "prefarea responses")

# Check for missing values
summary(houses) #No missing elements
# Check for outliers: plot everything in relation to price
plot(houses$bedrooms)
pairs(price~area+bedrooms+stories+parking, data = houses) #No outliers. relationships are unclear as if there are many missing values or non functional relationships

# Create dummy data for non numericalvariables:
library("fastDummies")
dum <- dummy_cols(houses, select_columns = c("mainroad","guestroom","basement","hotwaterheating", "airconditioning","prefarea"))
dum <- dum[,-6:-10]
houses_dum <- dum[,-7:-8]
# Correlation matrix
cor(houses_dum)

############################### ordinary linear regression (OLS) model using lm()
simple_model <- lm(price~area,data = houses)

#Analyse the quality of this model using the t_value and the Signif. codes
summary(simple_model)
plot(houses$price, houses$area)

#Put a line on plot
abline(h= 1000, simple_model)

# Multiple linear regression
multiple_model = lm(price~.,data = houses)
summary(multiple_model)

# Spliting data into test and train
library("caTools")
set.seed(0)
split = sample.split(houses, SplitRatio = 0.8)
training_set = subset(houses, split == TRUE)
test_set = subset(houses, split == FALSE)

#create a model using training data set
lm_a = lm(price~.,data = training_set)


#take all ind. variables from training_set and put it in lm_a model and predict the value of dep.variable, store it
# Test the model on training dataset
train_a = predict(lm_a, training_set)

#Test the model on test_dataset
test_a = predict(lm_a, test_set)

# MSE on the traing set
mean((training_set$price-train_a)^2) #1.128769e+12

# Same for test
mean((test_set$price - test_a)^2) #1.075278e+12

################ Subset selection ###############
library("leaps")
#####1. Best subset selection
lm_best <- regsubsets(price~.,data= houses_dum, nvmax=11) #nvmax number of maximum variables

summary(lm_best) # list models in oder and use stars and fisrt column to show how many variables we considered

# FInd adjusted R2 values and use the model with highest adjr2 
summary(lm_best)$adjr2
max_r2 = which.max(summary(lm_best)$adjr2) #8

#to get the coeficient: intercept and beta values
coef(lm_best,8) #the max_r2

#####2. Foward subset selection
lm_foward <- regsubsets(price~.,data= houses_dum, nvmax= 17, method="forward")
summary(lm_foward)

#####3. backward subset selection
lm_backward <- regsubsets(price~.,data= houses_dum, nvmax= 17, method="backward")
summary(lm_backward)

###################################### Shrinkage methods (Ridge regression & Lasso Regression) ###############

library("glmnet")
# all independent variables)
x <- model.matrix(price~.,data = houses_dum)[,-1]
y=houses_dum$price
grid = 10^seq(10,-2, length=100)
grid

############### Ridge regression ##########
lm_ridge = glmnet(x,y, alpha=0, lambda = grid)
summary(lm_ridge)

# To find the best lambda
cv_fit = cv.glmnet(x,y,alpha = 0, lambda = grid)
plot(cv_fit)

#to find optimum value of lambda// with minimum meansquare//
opt_lambda <- cv_fit$lambda.min
tss <- sum((y-mean(y))^2)

y_a <- predict(lm_ridge, s = opt_lambda,newx= x) #difference of predicted

rss <- sum((y_a-y)^2)

rsq <- 1- rss/tss

########################### Lasso #########
lm_lasso = glmnet(x,y, alpha=1, lambda = grid)
summary(lm_lasso)

# To find the best lambda
cv_fit_2 = cv.glmnet(x,y,alpha = 1, lambda = grid)
plot(cv_fit_2)

#to find optimum value of lambda// with minimum meansquare//
opt_lambda_2<- cv_fit_2$lambda.min
tss_l <- sum((y-mean(y))^2)

y_a_l <- predict(lm_lasso, s = opt_lambda_2,newx= x) #difference of predicted

rss_l <- sum((y_a_l-y)^2)
rss_l

rsq_l <- 1- rss_l/tss_l
rsq_l
