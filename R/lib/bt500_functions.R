# Returns an aggregated dataframe containing the calculated confidence
# intervals of means

DV.Bt500ConfInt.as.function.of.IVs <- function(dfrm, dv, ivs){
  agrg.low <- aggregate(dfrm[,dv], ivs, FUN=Bt500ConfIntLow)

  names(agrg.low)[names(agrg.low)=="x"] <- "c.i.l"
  
  agrg.high <- aggregate(dfrm[,dv], ivs, FUN=Bt500ConfIntHigh)
  
  names(agrg.high)[names(agrg.high)=="x"] <- "c.i.h"

  agrg <- merge(agrg.low, agrg.high)
  return(agrg)
}



Bt500ConfIntLow <- function(x){
  m <- mean(x)
  s <- sd(x)

  low <- m - 1.96*(s/sqrt(length(x)))

  return(low)
}

Bt500ConfIntHigh <- function(x){
  m <- mean(x)
  s <- sd(x)

  high <- m + 1.96*(s/sqrt(length(x)))

  return(high)
}
