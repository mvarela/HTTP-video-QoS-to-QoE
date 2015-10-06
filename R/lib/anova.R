library("car")
##
# Generic method for performing anova
#
#      formula, the model used in anova. variables refer to the column names of the given dataframe E.g. MOS ~ Loss*MLBS
#      df, the dataframe containing rows with instances of independent variables and the dependent variable
anova.eta.squared <- function(formula, df){
  mydata.aov = aov(formula,data=df)  # do the analysis of variance
  mydata.anova <- anova.lm(mydata.aov) # calculate type I ANOVA table
  mydata.ss <- mydata.anova$"Sum Sq" # sums of squares
  mydata.pes <- mydata.ss/(mydata.ss+mydata.ss[length(mydata.ss)]) # partial eta squared
  mydata.pes[length(mydata.pes)] <- "" # clear effect size for residual
  mydata.anova$"Partial Eta Sq" <- mydata.pes # add effect size data to ANOVA table
  mydata.anova # display Type I ANOVA table with effect size column
#  r <- summary.lm(mydata.aov) # summary of linear model
#  r$"r.squared" # display R squared
#  r$"adj.r.squared" # display Adjusted R squared

}

simplified.anova <- function(formula, df){
  return(aov(formula, data=df))
}


anova.perform.two.way <- function(IV1, IV.main, DV, dfrm){
  fm <- as.formula(paste(DV, "~", IV.main, "*", IV1))
  fitted <- simplified.anova(fm, dfrm)
  summary(fitted)
}

anova.perform.two.way.no.interaction <- function(IV1, IV.main, DV, dfrm){
  fm <- as.formula(paste(DV, "~", IV.main, "+", IV1))
  fitted <- simplified.anova(fm, dfrm)
  Anova(fitted, type="II")
}


anova.two.way.as.main <- function(IV.main, IV, DV, dfrm) {
  IV <- IV[which(IV!=IV.main)]

  lapply(IV, anova.perform.two.way, IV.main, DV, dfrm)
}

anova.two.way.as.main.no.interaction <- function(IV.main, IV, DV, dfrm) {
  IV <- IV[which(IV!=IV.main)]

  lapply(IV, anova.perform.two.way.no.interaction, IV.main, DV, dfrm)
}


##
# Calculates two-way anova for every combination of the given independent variables
#
#  dfrm: The data frame containing the data
#  IV:   The name of independent variable. E.g. MOS
#  DV:   Vector of dependent variable names
#
anova.two.way <- function(dfrm, DV, IV) {

  lapply(IV, anova.two.way.as.main, IV, DV, dfrm)

}

anova.two.way.no.interaction <- function(dfrm, DV, IV) {

  lapply(IV, anova.two.way.as.main.no.interaction, IV, DV, dfrm)

}
