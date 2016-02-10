library("scatterplot3d")
library("ggplot2")

#filter MOS values outside the [1,5] range
doBounds <- function(i){
  if(i<0){
    return(0)
  }else{
    if(i>5){
      return(5)
    }
    return(i)
  }
}

# QoEp = 4.56 − 0.36Ns − 0.09Ts,total
MOS <- function(stalls, duration){

  tmp <- 4.56 - 0.36 * stalls - 0.08*duration
  res <- sapply(tmp, doBounds)
  return(res)
}

datastall <- read.csv("stall/distributions_3.0, 1.3, 12000.0.txt")
dataduration <- read.csv("duration/distributions_3.0, 1.3, 12000.0.txt")


stallpredictions <- datastall$predicted
durationpredictions <- dataduration$predicted

stallrange <- 0:10
durationrange <-1:19

ssamples <- sample(stallrange, size=10000, prob=stallpredictions, replace=TRUE)
dsamples <- sample(durationrange, size=10000, prob=durationpredictions, replace=TRUE)

smoothScatter(ssamples,dsamples,bandwidth=2.5,xlab='Number of stalls',ylab='Stall duration (s) / 5',main='Scatter plot for number of stalls and their duration \n(10K samples, LR=3%, MLBS=1.3pkt, BW=12Mbps)',xlim=c(0,10))
mosValues <- MOS(ssamples,dsamples)
#hist(mosValues, breaks=30,xlim=c(0,5),ylim=c(0,8000),xlab='MOS',ylab='Count',main='Histogram of MOS values \n(10K samples, LR=3%, MLBS=1.3pkt, BW=8Mbps)')
x <- seq(0,10,0.1)
y <- seq(0,18,0.1)
z <- outer(x,y,MOS)
contour(x,y,z,axes=FALSE)
qplot(mosValues,geom="histogram",binwidth=0.25,main='Histogram of MOS values \n(10K samples, LR=3%, MLBS=1.3pkt, BW=12Mbps)',xlim=c(0,5),ylim=c(0,8000),xlab='MOS',ylab='Count',fill=I('blue'),alpha=I(0.4))





datastall <- read.csv("stall/distributions_8.0, 1.3, 8000.0.txt")
dataduration <- read.csv("duration/distributions_8.0, 1.3, 8000.0.txt")


stallpredictions <- datastall$predicted
durationpredictions <- dataduration$predicted

stallrange <- 0:10
durationrange <-1:19

ssamples <- sample(stallrange, size=10000, prob=stallpredictions, replace=TRUE)
dsamples <- sample(durationrange, size=10000, prob=durationpredictions, replace=TRUE)

smoothScatter(ssamples,dsamples,bandwidth=2.5,xlab='Number of stalls',ylab='Stall duration (s) / 5',main='Scatter plot for number of stalls and their duration \n(10K samples, LR=8%, MLBS=1.3pkt, BW=8Mbps)',xlim=c(0,10))
mosValues <- MOS(ssamples,dsamples)
#hist(mosValues, breaks=30,xlim=c(0,5),ylim=c(0,8000),xlab='MOS',ylab='Count',main='Histogram of MOS values \n(10K samples, LR=8%, MLBS=1.3pkt, BW=8Mbps)')
x <- seq(0,10,0.1)
y <- seq(0,18,0.1)
z <- outer(x,y,MOS)
contour(x,y,z,axes=FALSE)
qplot(mosValues,geom="histogram",binwidth=0.25,main='Histogram of MOS values \n(10K samples, LR=8%, MLBS=1.3pkt, BW=8Mbps)',xlim=c(0,5),ylim=c(0,8000),xlab='MOS',ylab='Count',fill=I('blue'),alpha=I(0.4))
