library(biwavelet)
library(WaveletComp)

#### Read covariance data ####
workpath = getwd()
cov_df = read.csv(file.path(workpath, "output", "covariance_result.csv"))
View(cov_df)


#### Visualize Wavelet coherence plot ####
## Wavelet coherence plot between BNB and BTC
cwt_one = cbind(1:1824,cov_df$BNB) # 1824: length of covariance
cwt_oth = cbind(1:1824,cov_df$BTC)
wtc= wtc(cwt_one,cwt_oth,nrands = 20,param = 6,max.scale =512)
par(oma =c(0,0,0,1), mar = c(5,4,4,5)+0.2)
plot(wtc,plot.phase = T,lty.coi=1,col.coi='white',lwd.coi=2,lwd.sig = 1,arrow.lwd = 0.03,
     arrow.len = 0.07,plot.cb = TRUE,ylab = 'Period',xlab='Time',xaxt = "n",
     main = 'BNB and BTC Wavelet Coherence')
axis(side = 1, at = c(1,277,seq(642,1738,365)),labels = seq(2020,2025,1))

## Wavelet coherence plot between BNB and ETH
cwt_one = cbind(1:1824,cov_df$BNB) # 1824: length of covariance
cwt_oth = cbind(1:1824,cov_df$ETH)
wtc= wtc(cwt_one,cwt_oth,nrands = 20,param = 6,max.scale =512)
par(oma =c(0,0,0,1), mar = c(5,4,4,5)+0.2)
plot(wtc,plot.phase = T,lty.coi=1,col.coi='white',lwd.coi=2,lwd.sig = 1,arrow.lwd = 0.03,
     arrow.len = 0.07,plot.cb = TRUE,ylab = 'Period',xlab='Time',xaxt = "n",
     main = 'BNB and ETH Wavelet Coherence')
axis(side = 1, at = c(1,277,seq(642,1738,365)),labels = seq(2020,2025,1))

## Wavelet coherence plot between BNB and ETH
cwt_one = cbind(1:1824,cov_df$BTC) # 1824: length of covariance
cwt_oth = cbind(1:1824,cov_df$ETH)
wtc= wtc(cwt_one,cwt_oth,nrands = 20,param = 6,max.scale =512)
par(oma =c(0,0,0,1), mar = c(5,4,4,5)+0.2)
plot(wtc,plot.phase = T,lty.coi=1,col.coi='white',lwd.coi=2,lwd.sig = 1,arrow.lwd = 0.03,
     arrow.len = 0.07,plot.cb = TRUE,ylab = 'Period',xlab='Time',xaxt = "n",
     main = 'BTC and ETH Wavelet Coherence')
axis(side = 1, at = c(1,277,seq(642,1738,365)),labels = seq(2020,2025,1))

dev.off()

#### Visualize phase difference
## Phase difference plot between BNB and BTC
cwt_one = cbind(1:1824,cov_df$BNB) # 1824: length of covariance
cwt_oth = cbind(1:1824,cov_df$BTC)
wtc= wtc(cwt_one,cwt_oth,nrands = 20,param = 6,max.scale =512)

## phase difference
View(wtc$phase) # 97 rows means: period index
wtc$period

# choose the period index we want to analyze its phase difference
idx = 26
plot(wtc$phase[idx,], type = "l",xaxt = 'n', yaxt = 'n', 
     main = 'BNB and BTC phase difference at period = 8.76', ylab = '')
axis(side = 1, at = c(1,277,seq(642,1738,365)),labels = seq(2020,2025,1))
axis(side = 2, at = c(-pi, -pi/2, 0, pi/2, pi),
     labels = expression(-pi, -pi/2, 0, pi/2, pi), cex.axis = 1.5)
abline(h = 0, col = "black", lwd = 1, lty = 1)
abline(h = c(-pi, -pi/2, pi/2, pi), col = "gray", lwd = 1, lty = 2)
