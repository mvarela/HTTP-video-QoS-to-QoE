
quantiles.p.single.threshold <- function(data=NULL, threshold.name, threshold.value, groupvars, groupvarvalues) {
    library(doBy)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    res.set = data
    # create the expression
    for (i in 1:length(groupvars)) {
      cond <- paste(groupvars[i], groupvarvalues[i], sep="==")
      res.set <- subset(res.set, eval(parse(text = cond)))
    }

    cfgs.total <- nrow(res.set)
    cond <- paste(threshold.name, threshold.value, sep="<=")
    res.set <- subset(res.set, eval(parse(text=cond)))

    cfgs.threshold <- nrow(res.set)

    p <- cfgs.threshold / cfgs.total
    
    
    return(p)
}

quantiles.p.row <- function(row, dfrm.raw, threshold.name, threshold.value){


  p <- quantiles.p.single.threshold(dfrm.raw, threshold.name, threshold.value,
                               c("number_stalls", "stall_duration", "stall_pattern"),
                               c(row['number_stalls'], row['stall_duration'], paste("", row['stall_pattern'], "", sep="'")))
  return(p)
}


## Calculates the likelyhood of user to be dissatisfied with given threshold
##   dfrm.summary: the summary data containing aggregated mos etc.
##   dfrm.raw: data frame containing raw data.
##   threshold.name: the name of a column that contain the studied variable
##   threshold.value: the value used as threshold
##   groupvars: now hard coded to
quantiles.p.threshold <- function(dfrm.summary, dfrm.raw, threshold.name, threshold.value){

  p <- apply(dfrm.summary,1, quantiles.p.row, dfrm.raw = dfrm.raw, threshold.name = threshold.name, threshold.value = threshold.value)

  return(p)
}




quantiles.plot.p <- function(dfrm.quantiles) {

  par(mar=c(5,4,4,5)+.1)
  
  plot(dfrm.quantiles$index, dfrm.quantiles$p1, ylim=c(0,1), type="l", ylab="P(U <= threshold)", xlab="Index")

  lines(dfrm.quantiles$index, dfrm.quantiles$p2)
  lines(dfrm.quantiles$index, dfrm.quantiles$p3)
  lines(dfrm.quantiles$index, dfrm.quantiles$p4)

  par(new=TRUE)
  plot(dfrm.quantiles$index, dfrm.quantiles$mos, xaxt="n", yaxt="n", xlab="", ylab="", pch=1)
  axis(4)
  mtext("MOS", side=4, line=3)
}

quantiles.plot.10.90 <- function(dfrm.summary) {

  dfrm.summary <- dfrm.summary[order(dfrm.summary$mos, decreasing=TRUE),]
  plot(dfrm.summary$mos, xlab="Index", ylab="MOS", type="l", ylim=c(1,5))

  points(dfrm.summary$q10th, pch=15)
  points(dfrm.summary$q90th, pch=22)
}

