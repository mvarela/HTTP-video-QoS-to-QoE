library(doBy)


quantile10 <- function (x, na.rm=FALSE) {
  quantile(x, c(.10))
}

quantile90 <- function (x, na.rm=FALSE) {
  quantile(x, c(.90))
}


plot.mos.vs.likings <- function(dfrm){

  datac <- summaryBy(vote~liking, data=dfrm, FUN=c(mean,sd, quantile10, quantile90))

  names(datac)[ names(datac) == "vote.mean" ] <- "mos"
  names(datac)[ names(datac) == "vote.quantile10" ] <- "q10"
  names(datac)[ names(datac) == "vote.quantile90" ] <- "q90"


  y <- 1:5
  x <- 1:5

  plot(datac$mos~datac$liking, axes=F, xlab="Content preference",
       ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")

  lines(datac$q10~datac$liking)
  lines(datac$q90~datac$liking)
  
  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
  
}


plot.mos.vs.age.groups.number.stalls <- function(dfrm){
  y <- 1:5
  x <- 0:3
    
  datac <- subset(dfrm, Age == "20-29")

  plot(datac$mos~datac$number_stalls, axes=F, xlab="Number of Stallings", ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")

  datac <- subset(dfrm, Age == "30-39")

  lines(datac$mos~datac$number_stalls, type="b", lty=3)

  datac <- subset(dfrm, Age == "40-50")

  lines(datac$mos~datac$number_stalls, type="b", lty=4)

  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
  legend("topright", c("20-29", "30-39", "40-50"), lty=c(1,3,4), title="Age")

  
}

plot.mos.vs.age.groups.stall.duration <- function(dfrm){
  y <- 1:5
  x <- 0:12
    
  datac <- subset(dfrm, Age == "20-29")

  plot(datac$mos~datac$stall_duration, axes=F, xlab="Total Stalling Time", ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")

  datac <- subset(dfrm, Age == "30-39")

  lines(datac$mos~datac$stall_duration, type="b", lty=3)

  datac <- subset(dfrm, Age == "40-50")

  lines(datac$mos~datac$stall_duration, type="b", lty=4)

  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
  legend("topright", c("20-29", "30-39", "40-50"), lty=c(1,3,4), title="Age")  
}

plot.mos.vs.http.video.familiarity.groups.number.stalls <- function(dfrm){
  y <- 1:5
  x <- 0:3

  datac <- subset(dfrm, http.video.familiarity == "Extremenly familiar")
  plot(datac$mos~datac$number_stalls, axes=F, xlab="Number of Stallings", ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")

  datac <- subset(dfrm, http.video.familiarity == "Very familiar")
  lines(datac$mos~datac$number_stalls, type="b", lty=3)

  datac <- subset(dfrm, http.video.familiarity == "Moderately familiar")
  lines(datac$mos~datac$number_stalls, type="b", lty=4)

  datac <- subset(dfrm, http.video.familiarity == "Slightly familiar")
  lines(datac$mos~datac$number_stalls, type="b", lty=5)

  datac <- subset(dfrm, http.video.familiarity == "Not  at all familiar")
  lines(datac$mos~datac$number_stalls, type="b", lty=2)
  
  
  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
  legend("topright", c("Extremely familiar", "Very", "Moderately", "Slightly", "Not at all familiar"), lty=c(1,3,4,5,2), title="HTTP Video Familiarity")

  browser()
}


plot.mos.vs.age <- function(dfrm){
  y <- 1:5
  x <- dfrm$Age
    
  plot(dfrm$mos~dfrm$Age, axes=F, xlab="Age", ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")


  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
}

plot.mos.vs.gender <- function(dfrm){
  y <- 1:5
  x <- dfrm$Gender
    
  plot(dfrm$mos~dfrm$Gender, axes=F, xlab="Gender", ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")


  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
}

plot.mos.vs.http.video.familiarity <- function(dfrm){
  y <- 1:5
  x <- dfrm$http.video.familiarity
    
  plot(dfrm$mos~dfrm$http.video.familiarity, axes=F, xlab="HTTP Video Familiarity", ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")


  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
}

plot.mos.vs.service.usage <- function(dfrm){
  y <- 1:5
  x <- dfrm$service.usage
    
  plot(dfrm$mos~dfrm$service.usage, axes=F, xlab="Service Usage", ylab="MOS", pch=16, type="b", ylim=c(1,5), family="serif")


  axis(1, at=x, label=x, tick=F, family="serif")
  axis(2, at=y, label=y, tick=F, las=2, family="serif")
}
