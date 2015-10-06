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


if (length(argv) != 1){
  print("Usage: > do_rnn.R <raw data csv>")
  q()
}

csv.file <- argv[1]

print("*** 0 - Load data and initialise ***")


source("../../http-video-quality-results/scripts/R/lib/source_all.R", chdir=T)

#raw data
dfrm <- read.csv(csv.file, header=TRUE)
dfrm <- subset(dfrm, mlbs == 5)

browser()

# remove old results
unlink("inputdata", recursive = TRUE)

dir.create("inputdata/stalls", recursive=TRUE)
dir.create("inputdata/totaltime", recursive=TRUE)

dfrm.stalls <- summarySE(dfrm, "buffer_underrruns", c("lr", "buffer_size","bandwidth", "segment_length"))
write.table(dfrm.stalls, file="inputdata/stalls/aggregated_stalls.txt", sep=",")

dfrm.totaltime <- summarySE(dfrm, "stall_time", c("lr", "buffer_size","bandwidth", "segment_length"))
#dfrm.totaltime <- subset(dfrm.totaltime, mos < 200)

write.table(dfrm.totaltime, file="inputdata/totaltime/aggregated_totaltime.txt", sep=",")

print("*** 1 - Split the data ***")

system("cat inputdata/stalls/aggregated_stalls.txt | sed -f clean.sed > set1")
system("./split-10.rb set1 inputdata/stalls")


system("cat inputdata/totaltime/aggregated_totaltime.txt | sed -f clean.sed > set1")
system("./split-10.rb set1 inputdata/totaltime")




