#pre-processing
houses <- read.csv("/home/souvede/Documents/R_course/Housing.csv", header = TRUE)
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

# Check for outliers: plot everything in relation to price
plot(houses$bedrooms)
pairs(price~area+bedrooms+stories+parking, data = houses) #No outliers. relationships are unclear as if there are many missing values or non functional relationships

# Create dummy data for non numericalvariables:
install.packages("fastDummies")
library("fastDummies")
dum <- dummy_cols(houses, select_columns = c("mainroad","guestroom","basement","hotwaterheating", "airconditioning","prefarea"))
dum <- dum[,-6:-10]
houses_dum <- dum[,-7:-8]
# Correlation matrix
cor(houses_dum)
#linear regression model

simple_model <- lm(price~area,data = houses)
summary(simple_model)
plot(houses$price, houses$area)
abline(simple_model)

# Multiple linear regression
multiple_model = lm(price~.,data = houses)
summary(multiple_model)

# Spliting data into test and train
install.packages("caTools")
set.seed(0)
split = sample.split(houses, SplitRatio = 0.8)
training_set = subset(houses, split == TRUE)
test_set = subset(houses, split == FALSE)
lm_a = lm(price~.,data = training_set)
#take all ind. variables from training_set and put it in lm_a model and predict the value of dep.variable, store it
train_a = predict(lm_a, training_set)
#Do the same for test
test_a = predict(lm_a, test_set)

# MSE or the traing set
mean((training_set$price-train_a)^2) #1.096974e+12
# Same for test
mean((test_set$price - test_a)^2) #1.242045e+12

# Subset selection
install.packages("leaps")
library("leaps")
lm_best <- regsubsets(price~.,data= houses_dum, nvmax=17)
summary(lm_best)
# FInd adjusted R2 value
summary(lm_best)$adjr2
max_r2 = which.max(summary(lm_best)$adjr2) #8
#to get the coeficient
coef(lm_best,8) #the max_r2

lm_foward <- regsubsets(price~.,data= houses_dum, nvmax= 17, method="forward")
summary(lm_foward)

lm_backward <- regsubsets(price~.,data= houses_dum, nvmax= 17, method="backward")
summary(lm_backward)

# Shrinkage methods (Ridge regrssion & LassoRegression)
install.packages("glmnet")
library("glmnet")
# all independent variables)
x <-model.matrix(price~.,data = houses_dum)[,-1]
y=houses_dum$price
grid = 10^seq(10,-2, length=100)
grid

#Ridge
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

#Lasso
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

rsq_l <- 1- rss_l/tss_l

