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


source("lib/source_all.R", chdir=T)

#raw data
dfrm <- read.csv(training.csv.file, header=FALSE)
colnames(dfrm) <- c("lr","mlbs","bandwidth", "zero_s","one_s","two_s","three_s","four_s","five_s","six_s","seven_s","eight_s", "nine_s", "many_s")

# remove old results
unlink("output", recursive = TRUE)




#######################################################################
print("*** 1 - Train 1-s RNN ***")
dir.create("output/1-RNN-hist-train", recursive=TRUE)

dfrm.norm <- dfrm
dfrm.norm$lr = dfrm.norm$lr/max(dfrm.norm$lr)
dfrm.norm$mlbs = dfrm.norm$mlbs/max(dfrm.norm$mlbs)
dfrm.norm$bandwidth = dfrm.norm$bandwidth/max(dfrm.norm$bandwidth)

form.in <- as.formula('zero_s~lr+mlbs+bandwidth')
mod.zero_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('one_s~lr+mlbs+bandwidth')
mod.one_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('two_s~lr+mlbs+bandwidth')
mod.two_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('three_s~lr+mlbs+bandwidth')
mod.three_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('four_s~lr+mlbs+bandwidth')
mod.four_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('five_s~lr+mlbs+bandwidth')
mod.five_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('six_s~lr+mlbs+bandwidth')
mod.six_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('seven_s~lr+mlbs+bandwidth')
mod.seven_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('eight_s~lr+mlbs+bandwidth')
mod.eight_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('nine_s~lr+mlbs+bandwidth')
mod.nine_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)


form.in <- as.formula('many_s~lr+mlbs+bandwidth')
mod.many_s <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

#######################################################################
print("*** 2 - Test RNN ***")
dir.create("output/2-RNN-test", recursive=TRUE)

dfrm.test <- read.csv(test.csv.file, header=FALSE)
colnames(dfrm.test) <- c("lr","mlbs","bandwidth", "zero_s","one_s","two_s","three_s","four_s","five_s","six_s","seven_s","eight_s", "nine_s", "many_s")

lr <- dfrm.test$lr/15
mlbs <- dfrm.test$mlbs/1.5
bw <- dfrm.test$bandwidth/15000

dfrm.pred <- dfrm.test

net.results <- compute(mod.zero_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.zero_s"

browser()

net.results <- compute(mod.one_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.one_s"

net.results <- compute(mod.two_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.two_s"

net.results <- compute(mod.three_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.three_s"

net.results <- compute(mod.four_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.four_s"

net.results <- compute(mod.five_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.five_s"

net.results <- compute(mod.six_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.six_s"

net.results <- compute(mod.seven_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.seven_s"

net.results <- compute(mod.eight_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.eight_s"

net.results <- compute(mod.nine_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.nine_s"

net.results <- compute(mod.many_s, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.many_s"

write.csv(dfrm.pred, "tst.predictions.txt")

#setEPS()
#postscript(paste(dirname(training.csv.file), "plot.eps", sep="/"))
           
#plot(dfrm.test$IV)
#lines(net.results$net.result)


                                        #legend('topright', c("Random", "Test"), pch=c(19, 1))

#dev.off()

#c.p <- cor.test(dfrm.test$IV, net.results$net.result)
#correlation.filename <- paste(dirname(training.csv.file), "correlation.txt", sep="/")
#write(c("pearson", c.p$estimate), file=correlation.filename)

           




