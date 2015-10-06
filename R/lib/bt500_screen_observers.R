CompareSingleVote <- function(v){
  sv <- unlist(v["subjectvote"])
  mos <- unlist(v["mos"])
  sd <- unlist(v["sd"])

  ##########  NOTE NOTE ##########
  p.value <- 0.1 # hard coding the normality. Shapiro-Wilk test gives unexpected and differing results from Wizard.
                 # Wizard shows clear normality.

  if (p.value < 0.05) {
    if (sv >= (mos + sqrt(20)*sd))
      return(list(1,0))
    if (sv <= (mos - sqrt(20)*sd))
      return(list(0,1))
  } else {
    if (sv >= (mos + 2*sd))
      return(list(1,0))
    if (sv <= (mos - 2*sd))
      return(list(0,1))
  }
  return(list(0,0))
}

Condition1 <- function(pi, qi, JKR){
  cat('Condition1: ', (pi + qi)/JKR, '\n')
  return ((pi + qi)/JKR > 0.05)
}
Condition2 <- function(pi, qi){
  cat('Condition2: ', abs((pi - qi)/(pi + qi)), '\n\n')
  return (abs((pi - qi)/(pi + qi)) < 0.3)
}


CalcOutlierness <- function(s, mos.values){


  names(s)[names(s)=="vote"] <- "subjectvote"
  s <- merge(s, mos.values)

  pqs <- by(s, 1:nrow(s),CompareSingleVote)

  pqfr <- data.frame(t(sapply(pqs,c)))
  
  pi <- sum(unlist(pqfr[[1]]))
  qi <- sum(unlist(pqfr[[2]]))

  c1 <- Condition1(pi, qi, nrow(mos.values))
  c2 <- Condition2(pi,qi)

  return (c1 && c2)
}


CheckOutliers <- function(dfrm, dfrm.summary){

# Go through the votes of each user
bysubject <- split(dfrm, dfrm$subject_id)

lst <- lapply(bysubject, CalcOutlierness, dfrm.summary)

cat('Results of outlier screening (TRUE -> Outlier):\n', names(lst), '\n', unlist(lst), '\n')
}
