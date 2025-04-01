Cryptocurrency Volatility Analysis using VAR-DCC-GARCH and Wavelet Coherence
---

### Overview
This project analyzes the volatility and co-movement of three major cryptocurrencies: Binance Coin (BNB), Bitcoin (BTC), and Ethereum (ETH). It employs a combination of statistical models, including the VAR-DCC-GARCH framework, and wavelet coherence analysis to study the time-varying relationships and dependencies between these assets.

### Data Source

The historical cryptocurrency data is obtained from CNYES Crypto. The dataset includes daily closing prices of Binance Coin, Bitcoin, and Ethereum over a specified period.
https://crypto.cnyes.com/


### Methodology:

#### 1. Data Preprocessing

- The project reads historical price data for Binance Coin, Bitcoin, and Ethereum.

- Extracts the 'Date' and 'Close' price columns and merges them into a single dataset.

- Converts the 'Date' column to a Date format.

- Checks for missing values and imputes them if necessary.

- Computes log returns for each asset.

#### 2. Exploratory Data Analysis

- Computes descriptive statistics including mean, maximum, minimum, standard deviation, kurtosis, skewness, and the Jarque-Bera test.

- Constructs a correlation matrix to analyze the relationships between asset returns.

- Performs the Augmented Dickey-Fuller (ADF) test to ensure stationarity.

- Tests for ARCH effects to assess volatility clustering.

#### 3. VAR-DCC-GARCH Model

- Selects the optimal lag order for the Vector Autoregression (VAR) model.

- Fits a VAR(1)-DCC-GARCH(1,1) model to estimate dynamic conditional correlations and variances.

- Extracts covariance and correlation estimates.

#### 4. Wavelet Coherence Analysis

- Reads the estimated covariance series.

- Computes wavelet coherence between asset pairs to analyze time-frequency dependencies.

- Visualizes wavelet coherence and phase difference plots to identify lead-lag relationships over different time horizons.

### Usage

- Place the cryptocurrency price data (BinanceCoin.csv, bitcoin.csv, Ethereum.csv) in the data/ folder.

- Run the R script to preprocess the data and estimate the VAR-DCC-GARCH model.

- Extract and visualize covariance dynamics.

- Perform wavelet coherence analysis to study time-frequency relationships.

- View the generated plots for insights into market co-movements.








