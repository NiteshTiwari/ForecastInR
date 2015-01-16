# calculate the Squared Sum Error
sse <- function(a,b) {
  sum((a-b)^2)
}

setwd("d:/temp/forecasting poc")

a <- read.csv("300 days.csv",header = FALSE)

# assumming that dates are sorted in the csv
dates <- as.vector(unique(a$V1))
products <- sort(as.vector(unique(a$V2)))

i <- 1
entries <- list()
for(date in dates)
{
  entries[[i]] <- a[a$V1 == date,]
  i <- i+1
}

#ensure we have valid numbers
defaultValue <- function(item) {
  
  if( identical(item, numeric(0))) {
    return(0)
  }
  return(item)
}

# filter sales by product id
filterProduct <- function(daySales, prodId) {
  p <- daySales[daySales$V2 == prodId,3]
  p <- defaultValue(p)
  p
}

# generate a vector of all sales for productid=10 for all dates
p1 <- lapply(entries, "filterProduct", 10)

# generate data frame to be used by the neural network
# with each row containing the sales in the last 30 days
m1 <- data.frame()

# append new rows to the data.frame each containing
# the last 30 days of sales starting with the most current
# day in column 1
for(start in c(30:300)) {
  m1 <- rbind(m1, p1[(start-29): start])
}

#set column names
colnames(m1) <- paste0("Day",c(0:29))

library("neuralnet")

results <- data.frame()

# create a results data.frame with proper column names and an initial row
createResults <- function(hidden,training.sse, testing.sse, validation.sse)
{
  results <- data.frame(Hidden=hidden, SSE.Training = training.sse,
                        SSE.Testing = testing.sse, SSE.Validation = validation.sse)
  return(results)
}

