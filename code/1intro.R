## 
## install.packages("devtools") # if not already installed
## devtools::install_github("tesseradata/datadr")
## devtools::install_github("tesseradata/trelliscope")

## 
## devtools::install_github("hafen/housingData")

## 
library(housingData)
library(datadr)
library(trelliscope)

head(housing)

## 
## byCounty <- divide(housing,
##   by = c("county", "state"), update = TRUE)

## 
byCounty

## 
summary(byCounty)

## 
priceQ <- drQuantile(byCounty, var = "medListPriceSqft")
xyplot(q ~ fval, data = priceQ, scales = list(y = list(log = 10)))

## 
byCounty[[1]]

## 
lmCoef <- function(x) 
  coef(lm(medListPriceSqft ~ time, data = x))[2]

## 
byCountySlope <- addTransform(byCounty, lmCoef)

## 
byCountySlope[[1]]

## 
## countySlopes <- recombine(byCountySlope, combRbind)

## 
head(countySlopes)

## 
head(geoCounty)

## 
## geo <- divide(geoCounty, by = c("county", "state"))

## 
geo[[1]]

## 
byCountyGeo <- drJoin(housing = byCounty, geo = geo)

## 
str(byCountyGeo[[1]])

## 
## vdbConn("vdb", name = "tesseraTutorial")

## 
timePanel <- function(x)
  xyplot(medListPriceSqft + medSoldPriceSqft ~ time,
    data = x, auto.key = TRUE, ylab = "Price / Sq. Ft.")

## 
timePanel(byCounty[[20]]$value)

## 
priceCog <- function(x) { list(
  slope     = cog(lmCoef(x), desc = "list price slope"),
  meanList  = cogMean(x$medListPriceSqft),
  listRange = cogRange(x$medListPriceSqft),
  nObs      = cog(length(which(!is.na(x$medListPriceSqft))),
    desc = "number of non-NA list prices")
)}

## 
priceCog(byCounty[[1]]$value)

## 
## makeDisplay(byCounty,
##   name = "list_sold_vs_time_datadr_tut",
##   desc = "List and sold price over time",
##   panelFn = timePanel,
##   cogFn = priceCog,
##   width = 400, height = 400,
##   lims = list(x = "same"))

## 
## view()

