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
colnames(dfrm) <- c("lr","mlbs","bandwidth", "sd.0.5","sd.6.10","sd.11.15","sd.16.20","sd.21.25","sd.26.30","sd.31.35","sd.36.40","sd.41.45", "sd.46.50", "sd.51.55", "sd.56.60", "sd.61.65",
                    "sd.66.70","sd.71.75","sd.76.80","sd.81.85","sd.86.90", "sd.91.inf")
#LR, MLBS, BW, avg_stall_duration 0..9/5,over_limit
# remove old results
unlink("output", recursive = TRUE)


#######################################################################
print("*** 1 - Train 1-s RNN ***")
dir.create("output/1-RNN-hist-train", recursive=TRUE)

dfrm.norm <- dfrm
dfrm.norm$lr = dfrm.norm$lr/max(dfrm.norm$lr)
dfrm.norm$mlbs = dfrm.norm$mlbs/max(dfrm.norm$mlbs)
dfrm.norm$bandwidth = dfrm.norm$bandwidth/max(dfrm.norm$bandwidth)

form.in <- as.formula('sd.0.5~lr+mlbs+bandwidth')
mod.sd.0.5 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.6.10~lr+mlbs+bandwidth')
mod.sd.6.10 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.11.15~lr+mlbs+bandwidth')
mod.sd.11.15 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.16.20~lr+mlbs+bandwidth')
mod.sd.16.20 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.21.25~lr+mlbs+bandwidth')
mod.sd.21.25 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.26.30~lr+mlbs+bandwidth')
mod.sd.26.30 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.31.35~lr+mlbs+bandwidth')
mod.sd.31.35 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.36.40~lr+mlbs+bandwidth')
mod.sd.36.40 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.41.45~lr+mlbs+bandwidth')
mod.sd.41.45 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.46.50~lr+mlbs+bandwidth')
mod.sd.46.50 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.51.55~lr+mlbs+bandwidth')
mod.sd.51.55 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.56.60~lr+mlbs+bandwidth')
mod.sd.56.60 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.61.65~lr+mlbs+bandwidth')
mod.sd.61.65 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.66.70~lr+mlbs+bandwidth')
mod.sd.66.70 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.71.75~lr+mlbs+bandwidth')
mod.sd.71.75 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.76.80~lr+mlbs+bandwidth')
mod.sd.76.80 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.81.85~lr+mlbs+bandwidth')
mod.sd.81.85 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.86.90~lr+mlbs+bandwidth')
mod.sd.86.90 <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

form.in <- as.formula('sd.91.inf~lr+mlbs+bandwidth')
mod.sd.91.inf <- neuralnet(form.in, data=dfrm.norm, hidden=7, stepmax=30000,threshold=arg.threshold)

browser()


#######################################################################
print("*** 2 - Test RNN ***")
dir.create("output/2-RNN-test", recursive=TRUE)

dfrm.test <- read.csv(test.csv.file, header=FALSE)

colnames(dfrm.test) <- c("lr","mlbs","bandwidth",
                         "sd.0.5","sd.6.10","sd.11.15","sd.16.20","sd.21.25","sd.26.30","sd.31.35","sd.36.40","sd.41.45",
                         "sd.46.50", "sd.51.55", "sd.56.60", "sd.61.65",
                         "sd.66.70","sd.71.75","sd.76.80","sd.81.85","sd.86.90", "sd.91.inf")


lr <- dfrm.test$lr/15
mlbs <- dfrm.test$mlbs/1.5
bw <- dfrm.test$bandwidth/15000

dfrm.pred <- dfrm.test

net.results <- compute(mod.sd.0.5, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.0.5"


net.results <- compute(mod.sd.6.10, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.6.10"

net.results <- compute(mod.sd.11.15, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.11.15"

net.results <- compute(mod.sd.16.20, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.16.20"

net.results <- compute(mod.sd.21.25, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.21.25"

net.results <- compute(mod.sd.26.30, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.26.30"

net.results <- compute(mod.sd.31.35, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.31.35"

net.results <- compute(mod.sd.36.40, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.36.40"

net.results <- compute(mod.sd.41.45, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.41.45"

net.results <- compute(mod.sd.46.50, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.46.50"

net.results <- compute(mod.sd.51.55, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.51.55"

net.results <- compute(mod.sd.56.60, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.56.60"

net.results <- compute(mod.sd.61.65, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.61.65"

net.results <- compute(mod.sd.66.70, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.66.70"

net.results <- compute(mod.sd.71.75, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.71.75"

net.results <- compute(mod.sd.76.80, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.76.80"

net.results <- compute(mod.sd.81.85, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.81.85"

net.results <- compute(mod.sd.86.90, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.86.90"

net.results <- compute(mod.sd.91.inf, cbind(lr,mlbs,bw))
dfrm.pred <- cbind(dfrm.pred, net.results$net.result)
colnames(dfrm.pred)[length(dfrm.pred)] = "pred.mod.sd.91.inf"


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

           




