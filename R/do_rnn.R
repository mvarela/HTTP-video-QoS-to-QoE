#!/usr/bin/Rscript --slave

# The script runs all the R scripts to create the stats and plots for HTTP video
# QoE analysis.
#
# Prerequisites:
# install library doBy: install.packages("doBy")
# install library neuralnet
if(!exists("argv")){
  argv <- commandArgs(TRUE)
}


if (length(argv) != 3){
  print("Usage: > do_rnn.R <training data csv> <test data csv> <threshold>")
  q()
}

training.csv.file <- argv[1]
test.csv.file <- argv[2]
arg.threshold <- as.numeric(argv[3])





library(neuralnet)

print("*** 0 - Load data and initialise ***")


source("../../http-video-quality-results/scripts/R/lib/source_all.R", chdir=T)

#raw data
dfrm <- read.csv(training.csv.file, header=FALSE)
colnames(dfrm) <- c("id", "lr","buffer_size","bandwidth","segment_length","N","IV","sd","q10th","q90th","se","ci")

# remove old results
unlink("output", recursive = TRUE)




#######################################################################
print("*** 1 - Train RNN ***")
dir.create("output/1-RNN-train", recursive=TRUE)


form.in <- as.formula('IV~lr+buffer_size+bandwidth+segment_length')

dfrm.norm <- dfrm
dfrm.norm$lr = dfrm.norm$lr/max(dfrm.norm$lr)
dfrm.norm$buffer_size = dfrm.norm$buffer_size/max(dfrm.norm$buffer_size)
dfrm.norm$bandwidth = dfrm.norm$bandwidth/max(dfrm.norm$bandwidth)
dfrm.norm$segment_length = dfrm.norm$segment_length/max(dfrm.norm$segment_length)

mod <- neuralnet(form.in, data=dfrm.norm, hidden=10, stepmax=3000000,threshold=arg.threshold)



#######################################################################
print("*** 2 - Test RNN ***")
dir.create("output/2-RNN-test", recursive=TRUE)

dfrm.test <- read.csv(test.csv.file, header=FALSE)
colnames(dfrm.test) <- c("id", "lr","buffer_size","bandwidth","segment_length","N","IV","sd","q10th","q90th","se","ci")

lr <- dfrm.test$lr/max(dfrm.test$lr)
buffer_size <- dfrm.test$buffer_size/max(dfrm.test$buffer_size)
bw <- dfrm.test$bandwidth/max(dfrm.test$bandwidth)
sl <- dfrm.test$segment_length/max(dfrm.test$segment_length)

net.results <- compute(mod, cbind(lr,buffer_size,bw,sl))

setEPS()
postscript(paste(dirname(training.csv.file), "plot.eps", sep="/"))
           
plot(dfrm.test$IV)
lines(net.results$net.result)


                                        #legend('topright', c("Random", "Test"), pch=c(19, 1))

dev.off()

c.p <- cor.test(dfrm.test$IV, net.results$net.result)
correlation.filename <- paste(dirname(training.csv.file), "correlation.txt", sep="/")
write(c("pearson", c.p$estimate), file=correlation.filename)

           




