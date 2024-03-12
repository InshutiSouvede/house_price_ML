print("Hello world")
x<-10

#Printing variables using paste()
paste("The number I was hiding is",x)
# to browse a certain page 
# browseURL("http://cran.r-project.org/web/views/")

#to install packages,use this way for others to have them when you share your codes
#install.packages()
# to run one line only use: ctl+C+enter
# to comment a line use: ctrl+shift+C
#To get load packages:
#library() or require()
require(LiblineaR)

# To get the list of all the attached packages in R search path:
search()


# to remove library from user libraties:
# remove.packages(LiblineaR)

# to get all R embedded datasets (You can use them for practice):
data()

#To get information on a package:
library(help="datasets")

# to view contents of 'iris' an embedded dataset:
View(iris)
# To load this dataset in your workspace:
data("iris")

# Variab;e value assignment:
x <- 1:10
x2 <- seq(5,50, by = 5)
x2
# To inter data into list x3 manually:
x3 <- scan() # to stop it press enter without putting a value
x3

# Importing data from a file (read.table and read.csv)
txtReport <- read.table("C:/Users/LENOVO/Documents/R/house_price_ML/sometxt.txt", header=TRUE, sep = " ")
# View the table titles as string in console
str(txtReport)
csvReport <- read.csv("C:/Users/LENOVO/Documents/R/house_price_ML/Report.csv", header=TRUE)
View(csvReport)
# Example 2
Product <- read.table("C:/Users/LENOVO/Documents/R/house_price_ML/Product.txt", header=TRUE, sep = '\t')
str(Product)
Customer <- read.csv("C:/Users/LENOVO/Documents/R/house_price_ML/Customer.csv", header=TRUE)
View(Customer)

# Using the data from the files(Regions column and frequency of its data)
y <- table(Customer$Region) # the table() makes a two column table of value and frequency making it eay to plot
View(y)

# To plot y in  a bar-chart
barplot(y)

# Arrange in order of height
barplot(y[order(y)])#to order in descending order, use y[order(-y)]

# Change orientation to horizontal
barplot(y[order(y)],horiz = TRUE)

# Change color of barplot
barplot(y[order(y)], col= c("violet","blue","orange","green"))

# List all colors in R
colors()

#To remove borders on the bars: border = NA
barplot(y[order(y)], col= c("violet","beige","orange","green"), border = NA)

# To add a title: main = "My Title"
barplot(y[order(y)], col= c("violet","beige","orange","green"), border = NA, main = "Frequency of Regions")

# To label x axis: xlab = "x-axis"
barplot(y[order(y)], col= c("violet","beige","orange","green"), border = NA, main = "Frequency of Regions", ylab = "Number of customers", xlab = "Region")

# To export the graph as an image:(in codes instead of using the studio)
# 1:
png(filename = "C:/Users/LENOVO/Documents/R/house_price_ML/frequency.png", width= 888, height = 571 )
# 2:
barplot(y[order(y)], col= c("violet","blue","orange","green"), border = NA, main = "Frequency of Regions", ylab = "Number of customers", xlab = "Region")
# 3: to switch of the graph device
dev.off()


# Creating a histogram
hist(Customer$Age, col = "blue")

# To change number of bars
hist(Customer$Age, col = "blue", breaks = 7)

#You can specify the range of bars
hist(Customer$Age, col = "blue", breaks = c(0,40,60,80),freq = TRUE, main = "Histogram of age", xlab = "Age")
