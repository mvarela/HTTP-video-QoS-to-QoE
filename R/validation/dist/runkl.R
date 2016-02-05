library('entropy')
dokl <- function(df){
  k <- KL.plugin(df$original, df$predicted)
  return(k)
}


dirname      <- commandArgs(trailingOnly = TRUE)[1]
filenames    <- list.files(dirname, pattern="*.txt", full.names=TRUE)
data         <- lapply(filenames, read.csv)
KLdivergence <- lapply(data, dokl)
out          <- cbind(filenames, KLdivergence)
outfile      <- paste("./out_",dirname, sep="")
print(outfile)
print(out)
