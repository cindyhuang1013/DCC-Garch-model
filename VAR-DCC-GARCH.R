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


#### Read data ####
workpath = getwd()
Binance = read.csv(file.path(workpath, "data", "BinanceCoin.csv"))
Bitcoin = read.csv(file.path(workpath, "data", "bitcoin.csv"))
Ethereum = read.csv(file.path(workpath, "data", "Ethereum.csv"))
View(Binance)

#### Extract 'Close' and 'Date' columns (all three datasets have the same date range) 
Binance = Binance[, c("Date", "Close")]
Bitcoin = Bitcoin$Close
Ethereum = Ethereum$Close
df = data.frame(Date = Binance$Date, 
                Binance_Close = Binance$Close, 
                Bitcoin_Close = Bitcoin, 
                Ethereum_Close = Ethereum)

#### Convert the 'Date' column to Date format 
df$Date = as.Date(df$Date)

#### Missing Values Imputation ####
# Checking if there are missing values
statsNA(df$Binance_Close)
statsNA(df$Bitcoin_Close)
statsNA(df$Ethereum_Close)


#### Compute log return series ####
log_diff_df = data.frame(Date = df$Date[-1])
for (i in 2:ncol(df)){
  col_name <- colnames(df)[i]
  diff_col = diff(log(df[,i]))*100
  log_diff_df[[col_name]] <- diff_col
}
View(log_diff_df)

#### Descriptive data ####
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

desdata = data.frame()
for (i in 2:ncol(log_diff_df)){
  col_des = des(log_diff_df[,i])
  rownames(col_des) = colnames(log_diff_df)[i]
  desdata = rbind(desdata, col_des)
}
desdata

#### Compute correlation matrix ####
cormatrix = cor(log_diff_df[,c(2:4)])
cormatrix

#### Test for stationarity ####
adf.test(log_diff_df[,2]) # stationary
adf.test(log_diff_df[,3]) # stationary
adf.test(log_diff_df[,4]) # stationary

#### Test for ARCH effect ####
at = scale(log_diff_df[,c(2:4)],center = T,scale = F)  #remove sample means
MarchTest(at)

#### Implement VAR model (select order) ####
VARselect(log_diff_df[,c(2:4)] , lag.max = 25) 
fit=vars::VAR(log_diff_df[,c(2:4)],p=1)
stargazer(fit[["varresult"]],type="text",out = "fit_VAR.html")
summary(fit)

#### Fit VAR-DCC-GARCH model ####
spec1 <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
                    mean.model = list(armaOrder = c(1, 1)),distribution.model = "norm")
mspec1 <- multispec(replicate(3,spec1))
modelspec1 = dccspec(uspec = mspec1,VAR = TRUE, lag = 1, dccOrder = c(1,1), distribution = "mvt") #t-distribution
modelfit_all <- dccfit(modelspec1, data = log_diff_df[,c(2:4)])
modelfit_all

modelfit_all@model[["varcoef"]] #get VAR coefficients


#### Plot the result ####
## Covariance plot ##
plot(rcov(modelfit_all)[1,2,], type = 'l', main = 'Binance Coin and Bitcoin covariance', 
     xlab = 'Time', ylab = 'Covariance',xaxt = 'n')
axis(side = 1, at = c(1,277,seq(642,1738,365)),labels = seq(2020,2025,1))

## Correlation plot ##
plot(rcor(modelfit_all)[1,2,], type = 'l', main = 'Binance Coin and Bitcoin correlation', 
     xlab = 'Time', ylab = 'correlation',xaxt = 'n')
axis(side = 1, at = c(1,277,seq(642,1738,365)),labels = seq(2020,2025,1))



#### Extract and store covariance data (individual assets, not pairwise) ####
dim(rcov(modelfit_all))
cov_df = data.frame(log_diff_df$Date)
BNB = rcov(modelfit_all)[1,1,]
BTC = rcov(modelfit_all)[2,2,]
ETH = rcov(modelfit_all)[3,3,]
cov_df$BNB = BNB
cov_df$BTC = BTC
cov_df$ETH = ETH

View(cov_df)

write.csv(cov_df, file.path(workpath, "output","covariance_result.csv"), row.names = FALSE)
