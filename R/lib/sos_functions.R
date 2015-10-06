
## Calculates the "a" of the fitted SOS function
## Returns the fit of type nls
## input: dfrm, data frame having columns MOS and SD
sos.fit <- function(dfrm) {
  sosf <- function(x, a) {
    -a*x^2 + 6*a*x -5*a
  }
  
  m <- nls(sd^2 ~ sosf(mos, a), data = dfrm, start = list(a = 0), trace = T)

  return(m)
}

sos.plot <- function(dfrm) {
  plot(dfrm$mos, dfrm$sd, xlim=c(1,5), ylim=c(0, 2), xlab="MOS", ylab="Standard deviation", pch=1)
}


sos.plot.line <- function(m, ...) {
  s <- seq(2,5, by=0.1)
  lines(s, sqrt(predict(m, list(mos = s))), ...)
}
