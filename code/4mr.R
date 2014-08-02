

# split iris data randomly into 4 key-value pairs
set.seed(1234)
irisRR <- divide(iris, by = rrDiv(nrows = 40))







# map expression to emit max petal length for each k/v pair
maxMap <- expression({
   for(curMapVal in map.values)
      collect("max", max(curMapVal$Petal.Length))
})



# reduce expression to compute global max petal length
maxReduce <- expression(
   pre = {
      globalMax <- NULL
   },
   reduce = {
      globalMax <- max(c(globalMax, unlist(reduce.values)))
   },
   post = {
      collect(reduce.key, globalMax)
   }
)



# execute the job
maxRes <- mrExec(irisRR,
   map = maxMap,
   reduce = maxReduce
)



# look at the result
maxRes[["max"]]



# another map expression to emit max petal length
maxMap2 <- expression(
   collect(
      "max",
      max(sapply(map.values, function(x) max(x$Petal.Length))))
)



# map expression to emit sum and length of Petal.Length by species
meanMap <- expression({
   v <- do.call(rbind, map.values)
   tmp <- by(v, v$Species, function(x) {
      collect(
         as.character(x$Species[1]),
         cbind(tot = sum(x$Petal.Length), n = nrow(x)))
   })
})



# reduce to compute mean Petal.Length
meanReduce <- expression(
   pre = {
      total <- 0
      nn <- 0
   },
   reduce = {
      tmp <- do.call(rbind, reduce.values)
      total <- total + sum(tmp[, "tot"])
      nn <- nn + sum(tmp[, "n"])
   },
   post = {
      collect(reduce.key, total / nn)
   }
)



# execute the job
meanRes <- mrExec(irisRR,
   map = meanMap,
   reduce = meanReduce
)



# look at the result for virginica and versicolor
meanRes[c("virginica", "versicolor")]



# example of a setup expression
setup <- expression({
   suppressMessages(library(plyr))
})



# alternative to meanMap using plyr
meanMap2 <- expression({
   v <- do.call(rbind, map.values)
   dlply(v, .(Species), function(x) {
      collect(
         as.character(x$Species[1]),
         cbind(tot = sum(x$Petal.Length), n = nrow(x)))
   })
})



meanRes <- mrExec(irisRR,
   setup = setup,
   map = meanMap2,
   reduce = meanReduce
)



cm2mm <- 10

meanMap3 <- expression({
   v <- do.call(rbind, map.values)
   dlply(v, .(Species), function(x) {
      collect(
         as.character(x$Species[1]),
         cbind(tot = sum(x$Petal.Length) * cm2mm, n = nrow(x)))
   })
})

meanRes <- mrExec(irisRR,
   setup = setup,
   map = meanMap3,
   reduce = meanReduce,
   params = list(cm2mm = cm2mm)
)



meanMap4 <- expression({
   counter("counterTest", "mapValuesProcessed", length(map.values))
   
   v <- do.call(rbind, map.values)
   dlply(v, .(Species), function(x) {
      collect(
         as.character(x$Species[1]),
         cbind(tot = sum(x$Petal.Length) * cm2mm, n = nrow(x)))
   })
})

meanRes <- mrExec(irisRR,
   setup = setup,
   map = meanMap4,
   reduce = meanReduce,
   params = list(cm2mm = cm2mm)
)



counters(meanRes)


