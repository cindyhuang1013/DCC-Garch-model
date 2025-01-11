Time Series Analysis with VAR-DCC-GARCH Modeling
---

### Overview
This project implements time series analysis using advanced statistical and econometric techniques. The primary focus is on applying the VAR-DCC-GARCH model to study the dynamic relationships between multiple time series, with key steps including data preprocessing, missing value imputation, and model fitting. The code also includes statistical tests, such as ADF for stationarity and ARCH effect tests, and visualizations of covariance and correlations.



### Key Features:
* Missing data imputation using **imputeTS** package in R.
* Return series computation and descriptive statistics analysis for financial data.
* Stationarity checks and ARCH effect testing.
* **Vector Autoregression (VAR)** modeling for multivariate time series.
* **Dynamic Conditional Correlation (DCC-GARCH) model** fitting for time-varying relationships.
* Visualizations of covariance and correlations to observe dynamic relationship over time.



### Requirements:
The following R libraries are required to run the project:

* **imputeTS**: For missing data imputation.
* **openxlsx**: For reading .xlsx files.
* **vars**: For VAR model fitting.
* **rmgarch**: For DCC-GARCH modeling.
* **MTS**, TSA, FinTS, rugarch: For time series analysis.
* **tseries**, **astsa**, **stargazer**: For statistical testing and results reporting.

Ensure these libraries are installed before running the code.

### Data Preparation
* **Input:** The code expects a dataset in `.xlsx` format with time in the first column and multiple time series variables in subsequent columns.
* **Preprocessing:**
The following steps can be skipped if the dataset does not require these preprocessing procedures.

  -- **Dates** are transformed into time-series format.
-- **Missing values** are imputed using linear **interpolation** here.
（imputeTS package has different methods for imputing univariate    time series data, here we use interpolation）
-- **Return series** are calculated using log-differencing, then multiplying the result by 100（usely for financial data）.

### Key Steps in the Analysis
1. **Descriptive Statistics**:
Mean, standard deviation, skewness, kurtosis, and Jarque-Bera test for each series.
2. **Stationarity Check**:
ADF test is used to verify stationarity.
```
adf.test()
```
3. **ARCH Effect Check**:
ARCH-LM test (MarchTest) is applied to check for volatility clustering.
```
MarchTest()
```
4. **VAR Modeling:**
VAR order is selected based on criteria, and the model is fitted.
> Considering model simplicity, the BIC criterion is used as the standard for selecting the model order.
```
VARselect(data , lag.max = 20) 
fit=vars::VAR(data,p=7) # p is the order you select
```

5. **DCC-GARCH Modeling:**
A VAR-DCC-GARCH model is constructed for multivariate volatility analysis.
> Firstly, construct the univariate garch model. Here we choose the normal distribution and grach(1,1) order to build the model.
```
spec1 <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
                    mean.model = list(armaOrder = c(1, 1)),distribution.model = "norm")
```
> Secondly, construct the dcc-garch model. Here we choose garch(1,1)  to build the model. 
```
mspec1 <- multispec(replicate(n,spec1))
# n here means: the number of multivariate data

modelspec1 = dccspec(uspec = mspec1,VAR = TRUE, lag = 7, 
                     dccOrder = c(1,1), distribution = "mvt") 
# lag = 7 here is based on the var model order selected in step 4.
# distribution = "mvt": use the student t distribution (for fincancial data)

modelfit_all <- dccfit(modelspec1, data = yourData)
modelfit_all
```
6. **Visualization:**
Covariance and correlation matrices are plotted over time.



