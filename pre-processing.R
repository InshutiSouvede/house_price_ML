Customer <- read.csv("C:/Users/LENOVO/Documents/R/house_price_ML/Customer.csv",header = TRUE)
# View(Customer)# we will take age
# Product <- read.table("/home/souvede/Documents/R_course/Product.txt",header = TRUE, sep = "\t")
# View(Product)# we will take ??
str(Customer)
# To get edd(extended data dictionary), the mean quaters, mode,...:
summary(Customer)
# To plot the scatter plot of certain columns(morethan 2 variables) use ~ and +:
pairs(~Age+Postal.Code, data = Customer)

#to plot scatter plot of 2 variables, one agins the other:
plot(Customer$Postal.Code,Customer$Age)

#Observation from the plots(scatter for quantity and bar plots fo qualitable data)
# eg: x_x_x and y_y_y has outliers
# n_home_beds has missing values
# bus-ter isa useless variable(it has the same value for all cases)

# Outlier Treatment
# 1.Capping and flooring: finding upper and lower limit beyond which we will change values
# 2.exponential smoothing
# Sigma approach

# Lets treeat the outliers found in previous observations
# The finnd a certain percentile value eg P99: 
quantile(Customer$Age,0.99)
uv = 3+quantile(Customer$Age,0.89) #68
uv2= quantile(Customer$Age,0.1) -2 #20
# All values of age greater than uv should get uv
Customer$Age[Customer$Age>uv] <- uv
Customer$Age[Customer$Age<uv2] <- uv2
summary(Customer$Age)

#Missing value imputation
# eg:replace withmean
#1. Get the mean value
mean(Customer$Age, na.rm = TRUE) # while calculating the mean, remove NA values
#2. identiy/list NA/empty cells
which(is.na(Customer$Age))
Customer$Age[is.na(Customer$Age)] <- mean(Customer$Age, na.rm = TRUE)
summary(Customer$Age)

# To have a better linear relationship btn variables, we can use log() or e power x
Customer$Postal.Code = log(1+Customer$Postal.Code) # base e
Customer$Postal.Code
#transforming values of fields that mean almost the samething, egdistance form a certain place, to one vribale:
# Customer$dist <- (dist1+dist2+dist3)/3
Customer2 <- Customer[,-7:-9] #this remove 7th to 9th column ftom customer and assign the rest in customer2

# Creating Dummy variables(with 0 or 1): this comes handy when handling non-numerical variables
install.packages("dummy")
library('dummy')
# Cutomer <- dummy(data.frame(Customer)
Customer3<- dummy(data.frame(Customer$Region))

# Correlation matrix:
cor(Customer)
round(cor(Customer3),2)  
#correlation btn a variable and another variables
cor(Customer$Age,Customer$Postal.Code)
round(cor(Customer$Age),2)  
# remove one of any 2 highly core;ated variables/colums that are not our dependent variablein order to prevent multicollinearity
# Eg ig parks and air-qality had high corelationd remove parks if it has the less collinearity with price(our dependent variable)