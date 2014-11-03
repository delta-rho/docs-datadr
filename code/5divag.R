

# load adult data for quantile example
data(adult)
adultDdf <- ddf(adult)
# divide it by education
# must have update = TRUE to get range of variables
byEd <- divide(adultDdf, by = "education", update = TRUE)



# compute quantiles of hoursperweek
hpwQuant <- drQuantile(byEd, var = "hoursperweek")
head(hpwQuant)



plot(hpwQuant)



# compute quantiles of hoursperweek by sex
hpwBySexQuant <- drQuantile(byEd, var = "hoursperweek", by = "sex")
xyplot(q ~ fval, groups = sex, data = hpwBySexQuant, auto.key = TRUE)



# load adult data for aggregate example
data(adult)
adultDdf <- ddf(adult)
# divide it by education, for fun
byEd <- divide(adultDdf, by = "education", update = TRUE)

# get counts by race and gender
raceGender <- drAggregate(~ race + sex, data = byEd)
raceGender

# aggregate age by race and gender
totAge <- drAggregate(age ~ race + sex, data = byEd)
totAge



library(hexbin)
# do hexbin aggregation on age and education
res <- drHexbin(byEd, "educationnum", "age", xbins = 15)
plot(res, xlab = "education", ylab = "age")

