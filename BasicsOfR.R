print("Hello world")
browseURL("http://cran.r-project.org/web/views/")
#to install packages,use this way for others to have them when you share your codes
#install.packages("LiblineaR")
# to run one line only use: ctl+C+enter
# to comment a line use: ctrl+shift+C
library()
search()

require(LiblineaR)
# to remove library from user libraties:
# remove.packages(LiblineaR)
?? igraph
# to get all R embedded dataset:
data()
library(help="datasets")
?? iris
# to view contents of 'iris'dataset:
iris
# To load this dataset in your workspace:
data("iris")
x <- 1:10
x2 <- seq(5,50, by = 5)
x2
# To inter data into list x3 manually:
x3 <- scan()
x3

# Importing data from txt file()
txtReport <- read.table("/home/souvede/Documents/R_course/sometxt.txt", header=TRUE, sep = " ")
str(txtReport)
csvReport <- read.csv("/home/souvede/Documents/R_course/Report.csv", header=TRUE)
View(csvReport)
# Example 2
Product <- read.table("/home/souvede/Documents/R_course/Product.txt", header=TRUE, sep = " ")
str(txtReport)
Customer <- read.csv("/home/souvede/Documents/R_course/Customer.csv", header=TRUE)
View(Customer)
# Using the data from the files(Regions column and frequency of its data)
y <- table(Customer$Region)
View(y)
# To plot y in  a barchart
barplot(y)
# Arrang in order of height
barplot(y[order(y)])#to order in descending order, use y[order(-y)]
# Change orientation to horizontal
barplot(y[order(y)],horiz = TRUE)
# Chanfe color of barplot
barplot(y[order(y)], col= c("violet","blue","orange","green"))
# List all colors in R
colors()
#To remove borders on the bars
barplot(y[order(y)], col= c("violet","beige","orange","green"), border = NA)
# To add a title
barplot(y[order(y)], col= c("violet","beige","orange","green"), border = NA, main = "Frequency of Regions")
# To label x axis
barplot(y[order(y)], col= c("violet","beige","orange","green"), border = NA, main = "Frequency of Regions", ylab = "Number of customers", xlab = "Region")
# To export the graph as an image:
# 1:
png(filename = "/home/souvede/Documents/R_course/frequency.png", width= 888, height = 571 )
# 2:
barplot(y[order(y)], col= c("violet","blue","orange","green"), border = NA, main = "Frequency of Regions", ylab = "Number of customers", xlab = "Region")
# 3: to switch of the graph device
dev.off()


# Creating a histogram
hist(Customer$Age, col = "blue")
# To change file packetsi. number of bars
hist(Customer$Age, col = "blue", breaks = 7)
#You can specify the range of bars
hist(Customer$Age, col = "blue", breaks = c(0,40,60,100),freq = TRUE, main = "Histogram of age", xlab = "Age")
