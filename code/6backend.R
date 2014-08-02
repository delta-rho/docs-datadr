

irisKV <- list(
   list("key1", iris[1:40,]),
   list("key2", iris[41:110,]),
   list("key3", iris[111:150,]))



# initialize a ddf from irisKV
irisDdf <- ddf(irisKV)



# divide in-memory data by species
bySpecies <- divide(irisDdf, 
   by = "Species")



# transform bySpecies to a data frame of lm coefficients
bySpeciesLm <- addTransform(bySpecies, function(x) {
   coefs <- coef(lm(Sepal.Length ~ Petal.Length, data = x))
   data.frame(slope = coefs[2], intercept = coefs[1])
})
# compute lm coefficients for each division and rbind them
recombine(bySpeciesLm, combRbind)



# map returns top 5 rows according to sepal width
top5map <- expression({
   v <- do.call(rbind, map.values)
   collect("top5", v[order(v$Sepal.Width, decreasing = TRUE)[1:5],])
})

# reduce collects map results and then iteratively rbinds them and returns top 5
top5reduce <- expression(
   pre = {
      top5 <- NULL
   }, reduce = {
      top5 <- rbind(top5, do.call(rbind, reduce.values))
      top5 <- top5[order(top5$Sepal.Width, decreasing = TRUE)[1:5],]
   }, post = {
      collect(reduce.key, top5)
   }
)

# execute the job
top5 <- mrExec(bySpecies, map = top5map, reduce = top5reduce)
# get the result
top5[[1]]



# remove files if necessary
try(unlink(file.path(tempdir(), "irisKV"), recursive=TRUE))
try(unlink(file.path(tempdir(), "irisKV"), recursive=TRUE))



# initiate a disk connection to a new directory /__tempdir__/irisKV
irisDiskConn <- localDiskConn(file.path(tempdir(), "irisKV"), autoYes = TRUE)



# print the connection object
irisDiskConn



irisDiskConn <- localDiskConn(file.path(tempdir(), "irisKV"))



irisKV <- list(
   list("key1", iris[1:40,]),
   list("key2", iris[41:110,]),
   list("key3", iris[111:150,]))



addData(irisDiskConn, irisKV[1:2])



list.files(irisDiskConn$loc)



addData(irisDiskConn, irisKV[3])



# initialize a ddf from irisDiskConn
irisDdf <- ddf(irisDiskConn)



# print irisDdf
irisDdf



# update irisDdf attributes
irisDdf <- updateAttributes(irisDdf)



# divide local disk data by species
bySpecies <- divide(irisDdf, 
   by = "Species",
   output = localDiskConn(file.path(tempdir(), "bySpecies"), autoYes = TRUE),
   update = TRUE)



# remove the R object "bySpecies"
rm(bySpecies)
# now reinitialize
bySpecies <- ddf(localDiskConn(file.path(tempdir(), "bySpecies")))



# transform bySpecies to a data frame of lm coefficients
bySpeciesLm <- addTransform(bySpecies, function(x) {
   coefs <- coef(lm(Sepal.Length ~ Petal.Length, data = x))
   data.frame(slope = coefs[2], intercept = coefs[1])
})
# compute lm coefficients for each division and rbind them
recombine(bySpeciesLm, combRbind)



bySpecies[[1]]
bySpecies[["Species=setosa"]]



getKeys(bySpecies)



# map returns top 5 rows according to sepal width
top5map <- expression({
   counter("map", "mapTasks", 1)
   v <- do.call(rbind, map.values)
   collect("top5", v[order(v$Sepal.Width, decreasing = TRUE)[1:5],])
})

# reduce collects map results and then iteratively rbinds them and returns top 5
top5reduce <- expression(
   pre = {
      top5 <- NULL
   }, reduce = {
      top5 <- rbind(top5, do.call(rbind, reduce.values))
      top5 <- top5[order(top5$Sepal.Width, decreasing = TRUE)[1:5],]
   }, post = {
      collect(reduce.key, top5)
   }
)

# execute the job
top5 <- mrExec(bySpecies, map = top5map, reduce = top5reduce)
# get the result
top5[[1]]





# create a 3 core cluster
library(parallel)
cl <- makeCluster(3)

# run MapReduce job with custom control
top5a <- mrExec(bySpecies, 
   map = top5map, reduce = top5reduce,
   control = localDiskControl(cluster = cl))



stopCluster(cl)



# how many map tasks were there before using a 3-core cluster
counters(top5)$map$mapTasks
# how many map tasks were there after using a 3-core cluster
counters(top5a)$map$mapTasks



library(Rhipe)
rhinit()



# list files in the base directory of HDFS
rhls("/")



# make a directory /tmp/testfile
rhmkdir("/tmp/testfile")



# write a couple of key-value pairs to /tmp/testfile/1
rhwrite(list(list(1, 1), list(2, 2)), file = "/tmp/testfile/1")



# read those values back in
a <- rhread("/tmp/testfile/1")



# create an R object and save a .Rdata file containing it to HDFS
d <- rnorm(10)
rhsave(d, file = "/tmp/testfile/d.Rdata")
# load that object back into the session
rhload("/tmp/testfile/d.Rdata")
# list the files in /tmp/testfile
rhls("/tmp/testfile")



# set the HDFS working directory (like R's setwd())
hdfs.setwd("/tmp/testfile")
# now commands like rhls() go on paths relative to the HDFS working directory
rhls()



# change permissions of /tmp/testfile/1
rhchmod("1", 777)
# see how permissions chagned
rhls()



# delete everything we just did
rhdel("/tmp/testfile")



# initiate an HDFS connection to a new HDFS directory /tmp/irisKV
irisHDFSconn <- hdfsConn("/tmp/irisKV", autoYes = TRUE)



# print the connection object
irisHDFSconn



irisKV <- list(
   list("key1", iris[1:40,]),
   list("key2", iris[41:110,]),
   list("key3", iris[111:150,]))

addData(irisHDFSconn, irisKV)



# initialize a ddf from hdfsConn
irisDdf <- ddf(irisHDFSconn)
irisDdf



# update irisDdf attributes
irisDdf <- updateAttributes(irisDdf)



# divide HDFS data by species
bySpecies <- divide(irisDdf, 
   by = "Species", 
   output = hdfsConn("/tmp/bySpecies", autoYes=TRUE),
   update = TRUE)



# reinitialize "bySpecies" by connecting to its path on HDFS
bySpecies <- ddf(hdfsConn("/tmp/bySpecies"))



# transform bySpecies to a data frame of lm coefficients
bySpeciesLm <- addTransform(bySpecies, function(x) {
   coefs <- coef(lm(Sepal.Length ~ Petal.Length, data = x))
   data.frame(slope = coefs[2], intercept = coefs[1])
})
# compute lm coefficients for each division and rbind them
recombine(bySpeciesLm, combRbind)



bySpecies[[1]]
bySpecies[["Species=setosa"]]



irisDdf[["key1"]]



# make data into a mapfile
irisDdf <- makeExtractable(irisDdf)



irisDdf[["key1"]]



# map returns top 5 rows according to sepal width
top5map <- expression({
   counter("map", "mapTasks", 1)
   v <- do.call(rbind, map.values)
   collect("top5", v[order(v$Sepal.Width, decreasing=TRUE)[1:5],])
})

# reduce collects map results and then iteratively rbinds them and returns top 5
top5reduce <- expression(
   pre = {
      top5 <- NULL
   }, reduce = {
      top5 <- rbind(top5, do.call(rbind, reduce.values))
      top5 <- top5[order(top5$Sepal.Width, decreasing=TRUE)[1:5],]
   }, post = {
      collect(reduce.key, top5)
   }
)

# execute the job
top5 <- mrExec(bySpecies, map = top5map, reduce = top5reduce)
# get the result
top5[[1]]



rhipeControl()



# initialize irisDdf HDFS ddf object
irisDdf <- ddo(hdfsConn("/tmp/irisKV"))
# convert from HDFS to in-memory ddf
irisDdfMem <- convert(from = irisDdf)
# convert from HDFS to local disk ddf
irisDdfDisk <- convert(from = irisDdf, 
   to = localDiskConn(file.path(tempdir(), "irisKVdisk"), autoYes=TRUE))



# create a csv file to treat as text input
csvFile <- file.path(tempdir(), "iris.csv")
write.csv(iris, file = csvFile, row.names = FALSE, quote = FALSE)
# see what the file looks like
system(paste("head", csvFile))



# connection for where to store output
irisConn <- localDiskConn(file.path(tempdir(), "iris"), autoYes = TRUE)
# read in iris data
irisData <- drRead.csv(csvFile, rowsPerBlock = 20, output = irisConn)
# look at resulting object
irisData
# look at a subset
irisData[[1]]


