

# simple key-value pair example
list(1:5, rnorm(10))



# create by-species key-value pairs
irisKV <- kvPairs(
   list("setosa", subset(iris, Species == "setosa")),
   list("versicolor", subset(iris, Species == "versicolor")),
   list("virginica", subset(iris, Species == "virginica"))
)
irisKV



irisKV <- kvPairs(
   list("setosa", subset(iris, Species == "setosa")),
   list("versicolor", subset(iris, Species == "versicolor")),
   list("virginica", subset(iris, Species == "virginica"))
)



# create ddo object from irisKV
irisDdo <- ddo(irisKV)



irisDdo



# look at irisDdo keys
getKeys(irisDdo)



# look at an example key-value pair of irisDdo
kvExample(irisDdo)



# update irisDdo attributes
irisDdo <- updateAttributes(irisDdo)
irisDdo



par(mar = c(4.1, 4.1, 1, 0.2))
# plot distribution of the size of the key-value pairs
qplot(y = splitSizeDistn(irisDdo), 
   xlab = "percentile", ylab = "subset size (kb)")



# update at the time ddo() is called
irisDdo <- ddo(irisKV, update = TRUE)



irisDdo[["setosa"]]
irisDdo[[1]]



irisDdo[c("setosa", "virginica")]
irisDdo[1:2]



# create ddf object from irisKV
irisDdf <- ddf(irisKV, update = TRUE)
irisDdf



# look at irisDdf summary stats
summary(irisDdf)



summary(irisDdf)$Sepal.Length$stats



summary(irisDdf)$Species$freqTable



nrow(irisDdf)



ncol(irisDdf)



names(irisDdf)



# initialize ddf from a data frame
irisDf <- ddf(iris, update = TRUE)



# iris ddf by Species
irisKV <- kvPairs(
   list("setosa", subset(iris, Species == "setosa")),
   list("versicolor", subset(iris, Species == "versicolor")),
   list("virginica", subset(iris, Species == "virginica"))
)
irisDdf <- ddf(irisKV)



irisSL <- addTransform(irisDdf, function(x) mean(x$Sepal.Width))



meanSL <- function(x) mean(x$Sepal.Width)
irisSL <- addTransform(irisDdf, meanSL)



irisSL



irisSL[[1]]



# set a global variable
globalVar <- 7
# define a function that depends on this global variable
meanSLplus7 <- function(x) mean(x$Sepal.Width) + globalVar
# add this transformation to irisDdf
irisSLplus7 <- addTransform(irisDdf, meanSLplus7)
# look at the first key-value pair (invokes transformation)
irisSLplus7[[1]]
# remove globalVar
rm(globalVar)
# look at the first key-value pair (invokes transformation)
irisSLplus7[[1]]



# get the mean Sepal.Width for each key-value pair in irisDdf
means <- drLapply(irisDdf, function(x) mean(x$Sepal.Width))
# turn the resulting ddo into a list
as.list(means)



# keep subsets with mean sepal width less than 3
drFilter(irisDdf, function(v) mean(v$Sepal.Width) < 3)



# create two new ddo objects that contain sepal width and sepal length
sw <- drLapply(irisDdf, function(x) x$Sepal.Width)
sl <- drLapply(irisDdf, function(x) x$Sepal.Length)



sw[[1]]



# join sw and sl by key
joinRes <- drJoin(Sepal.Width = sw, Sepal.Length = sl)
# look at first key-value pair
joinRes[[1]]



set.seed(1234)
drSample(irisDdf, fraction = 0.25)


