library(doBy)
library(gplots)


quantile10 <- function (x, na.rm=FALSE) {
  quantile(x, c(.10))
}

quantile90 <- function (x, na.rm=FALSE) {
  quantile(x, c(.90))
}


plot.mos.vs.totaltime <- function(dfrm){

  datac <- summaryBy(vote~stall_duration, data=dfrm, FUN=c(mean,sd, quantile10, quantile90))

  names(datac)[ names(datac) == "vote.mean" ] <- "mos"
  names(datac)[ names(datac) == "vote.quantile10" ] <- "q10"
  names(datac)[ names(datac) == "vote.quantile90" ] <- "q90"

  y <- 1:5
  x <- 0:12

  plot(datac$mos~datac$stall_duration, axes=F, xlab="Total duration",
       ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")

  lines(datac$q10~datac$stall_duration)
  lines(datac$q90~datac$stall_duration)
  
  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
  
}

plot.mos.vs.avestall <- function(dfrm){

  
#  dfrm$ave_stall <- dfrm$stall_duration/dfrm$number_stalls
#  dfrm$ave_stall[is.nan(dfrm$ave_stall)] <- 0

  y <- 1:5
  x <- 0:12
    
  datac <- summaryBy(vote~ave_stall, data=subset(dfrm, number_stalls == 3), FUN=c(mean))
  names(datac)[ names(datac) == "vote.mean" ] <- "mos"

  plot(datac$mos~datac$ave_stall, axes=F, xlab="Average Stalling Time", ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")

  datac <- summaryBy(vote~ave_stall, data=subset(dfrm, number_stalls == 2), FUN=c(mean))
  names(datac)[ names(datac) == "vote.mean" ] <- "mos"

  lines(datac$mos~datac$ave_stall, type="b", lty=3)

  datac <- summaryBy(vote~ave_stall, data=subset(dfrm, number_stalls == 1), FUN=c(mean))
  names(datac)[ names(datac) == "vote.mean" ] <- "mos"

  lines(datac$mos~datac$ave_stall, type="b", lty=4)

  
  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
  legend("topright", c("3", "2", "1"), lty=c(1,3,4), title="Number of Stallings")
  
}



plot.mos.vs.numberstalls <- function(dfrm){

  datac <- summaryBy(vote~number_stalls, data=dfrm, FUN=c(mean,sd,quantile10,quantile90))

  names(datac)[ names(datac) == "vote.mean" ] <- "mos"
  names(datac)[ names(datac) == "vote.quantile10" ] <- "q10"
  names(datac)[ names(datac) == "vote.quantile90" ] <- "q90"

  y <- 1:5
  x <- 0:3

  plot(datac$mos~datac$number_stalls, axes=F, xlab="Number of Stalls",
       ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")

  lines(datac$q10~datac$number_stalls)
  lines(datac$q90~datac$number_stalls)
  
  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")

}

plot.mos.vs.stallpattern2 <- function(dfrm){

  datac <- summaryBy(vote~stall_pattern, data=dfrm, FUN=c(length,mean,sd))

  names(datac)[ names(datac) == "vote.length" ] <- "num"
  names(datac)[ names(datac) == "vote.mean" ] <- "mos"
  names(datac)[ names(datac) == "vote.sd" ] <- "sd"

  datac <- subset(datac, stall_pattern==" G-U" | stall_pattern==" U-U" | stall_pattern==" U-G")

  datac$error <- with(datac, qnorm(0.975)*sd/sqrt(num))
  datac$lower <- datac$mos - datac$error
  datac$upper <- datac$mos + datac$error

  barplot2(datac$mos, plot.ci=TRUE, ci.l=datac$lower, ci.u=datac$upper,
           ylim=c(1, 5), xpd=FALSE, names.arg=datac$stall_pattern, ylab="MOS",
           xlab="Pattern")
}


plot.mos.vs.stallpattern3 <- function(dfrm){
  datac <- summaryBy(vote~stall_pattern, data=dfrm, FUN=c(length,mean,sd))
  
  names(datac)[ names(datac) == "vote.length" ] <- "num"
  names(datac)[ names(datac) == "vote.mean" ] <- "mos"
  names(datac)[ names(datac) == "vote.sd" ] <- "sd"
  
  datac <- subset(datac, stall_pattern==" G-U-U" | stall_pattern==" U-U-U" | stall_pattern==" U-U-G")
  
  datac$error <- with(datac, qnorm(0.975)*sd/sqrt(num))
  datac$lower <- datac$mos - datac$error
  datac$upper <- datac$mos + datac$error
  
  barplot2(datac$mos, plot.ci=TRUE, ci.l=datac$lower, ci.u=datac$upper,
           ylim=c(1, 5), xpd=FALSE, names.arg=datac$stall_pattern, ylab="MOS",
           xlab="Pattern")
  browser()
}
