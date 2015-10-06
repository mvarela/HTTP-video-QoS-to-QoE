

# Returns an aggregated dataframe containing the calculated MOS values (Dependent variable)
#      dfrm, dataframe containing the raw data
#      ifactors, vector of column names used as influence factors (Independent variables)
MOS.as.function.of.IFs <- function(dfrm, ifactors){
  agrg <- aggregate(dfrm$score, ifactors, FUN=mean)
  names(agrg)[names(agrg)=="x"] <- "MOS"

  agrg.sd <- aggregate(dfrm$score, ifactors, FUN=sd)
  names(agrg.sd)[names(agrg.sd)=="x"] <- "SD"

  agrg.num <- aggregate(dfrm$score, ifactors, NROW)
  names(agrg.num)[names(agrg.num)=="x"] <- "Num"

  agrg.ready <- cbind(agrg, agrg.sd["SD"], agrg.num["Num"])
  
  return(agrg.ready)
}

# Returns an aggregated dataframe containing the calculated DV values (Dependent variable)
#      dfrm, dataframe containing the raw data
#      dv,  name of the column used as dependent variable
#      ivs, vector of column names used as independent variables
# MOS.as.function.of.DV.IVs <- function(dfrm, dv, ivs){
DV.stats.as.function.of.IVs <- function(dfrm, dv, ivs){
  
  agrg <- aggregate(dfrm[,dv], ivs, FUN=mean)
  names(agrg)[names(agrg)=="x"] <- dv

  agrg.sd <- aggregate(dfrm[,dv], ivs, FUN=sd)
  names(agrg.sd)[names(agrg.sd)=="x"] <- "SD"

  agrg.num <- aggregate(dfrm[,dv], ivs, NROW)
  names(agrg.num)[names(agrg.num)=="x"] <- "Num"

  agrg.ready <- cbind(agrg, agrg.sd["SD"], agrg.num["Num"])
  
  return(agrg.ready)
}




SvagaShapiroNormality <- function(dfrm){
  agrg <- aggregate(dfrm$vote, by=list(number_stalls=dfrm$number_stalls,
                                 stall_duration=dfrm$stall_duration,
                                 stall_pattern=dfrm$stall_pattern), FUN=GetShapiroValue)
  names(agrg)[names(agrg)=="x"] <- "p.value"
#  agrg <- agrg[order(agrg$Order), ]
  
  return(agrg)
}

GetShapiroValue <- function(x){
  compare <- function(v) all(sapply( as.list(v[-1]), FUN=function(z) {identical(z, v[1])}))

  p.value <- 0
  if ( compare(x) == FALSE) {
    sh <- shapiro.test(x)
    p.value <- sh$p.value
  }
  return(p.value)
}



#Calculates Pearson and Spearman correlation between two vectors stored in single-column files of form
#  2.1
#  1.3
#  3.0
# The first file contains the estimated values and the second one the actual realised values.
mos_calc_correlation_vectors <- function(estimates_file, actual_file, m="pearson"){
	out <- read.table(estimates_file)
	actual <- read.table(actual_file)
	outv <- unlist(out)
	actualv <- unlist(actual)
	cor.test(outv, actualv, method=m)
}
