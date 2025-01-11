library(imputeTS)
library(openxlsx)
library(vars)
library(astsa)
library(tseries)
library(stargazer)
library(MTS)
library(TSA)
library(FinTS)
library(rmgarch)
library(rugarch)
library(lattice)
library(ggplot2)


#### Read data and data processing ####
price <- read.xlsx("data.xlsx")


#transform to numeric and date format
price$time = strptime(price$time,format = "%Y/%m/%d")
i=seq(2,10)
price[ , i] <- apply(price[, i], 2,           
                     function(x) as.numeric(as.character(x)))

#transform to time series data (daily data frequency = 365)
for(i in 2:ncol(price)){
  price[,i]=ts(price[,i],start=c(2011,1,1),frequency = 365)
}

#### Missing Values Imputation ####
imp_price=data.frame(price$time)
for (i in 2:length(colnames(price))){
  new=data.frame(na_interpolation(price[,i]))
  imp_price=cbind(imp_price,new)
}

#### Get return series ####
diff_imp_price=data.frame(diff(log(imp_price[,2]))*100)
for (i in 3:length(colnames(imp_price))){
  a=diff(log(imp_price[,i]))*100
  new=data.frame(a)
  diff_imp_price=cbind(diff_imp_price,new)
}

#### descriptive data ####
des = function(x){
  mu = mean(x)
  max = max(x)
  min = min(x)
  std = sd(x)
  kur = kurtosis(x)
  ske = skewness(x)
  JB = jarque.bera.test(x)$statistic
  list = data.frame(mu,max,min,std,kur,ske,JB)
  return(list)
}
desdata = des(diff_imp_price[,1])
for (i in 2:9){
  t = des(diff_imp_price[,i])
  desdata = rbind(desdata,t)
}

#### correlation matrix ####
cormatrix = cor(diff_imp_price)

#### check stationary ####
adf.test(diff_imp_price[,1])

#### check Arch effect ####
at = scale(diff_imp_price,center = T,scale = F) #remove sample means
MarchTest(at)

#### Build Var model (choose order) ####
VARselect(diff_imp_price , lag.max = 20) 
fit=vars::VAR(diff_imp_price,p=7)
stargazer(fit[["varresult"]],type="text",out = "fit_VAR.html")
fit$varresult$EN1
summary(fit)

#### VAR-DCC-GARCH model ####
spec1 <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
                    mean.model = list(armaOrder = c(1, 1)),distribution.model = "norm")
mspec1 <- multispec(replicate(9,spec1))
modelspec1 = dccspec(uspec = mspec1,VAR = TRUE, lag = 7, dccOrder = c(1,1), distribution = "mvt") #t-distribution
modelfit_all <- dccfit(modelspec1, data = diff_imp_price)
modelfit_all

modelfit_all@model[["varcoef"]] #get VAR coefficient

#### plot the result ####
## covariance ##
plot(rcov(modelfit_all)[2,3,])

## correlation ##
plot(rcor(modelfit_all)[2,3,])

