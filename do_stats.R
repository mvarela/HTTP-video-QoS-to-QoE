#!/usr/bin/Rscript --slave

# The script runs all the R scripts to create the stats and plots for HTTP video
# QoE analysis.
#
# Prerequisites:
# install library doBy: install.packages("doBy")
print("*** 0 - Load data and initialise ***")


source("R/lib/source_all.R", chdir=T)

#raw data
dfrm <- read.csv("data/2015_09_04_amended/results.txt", header=TRUE)

# Remove the incorrect MLBS cases (damn you netem...)
dfrm <- subset(dfrm, mlbs == 5)



# remove old results
unlink("stats-output", recursive = TRUE)

#######################################################################
print("*** 1 - Summary stats ***")
dir.create("stats-output/1-Summary", recursive=TRUE)
#summary
dfrm.stalls.summary <- summarySE(dfrm, "buffer_underrruns", c("segment_length", "buffer_size", "lr", "mlbs", "bandwidth"))
names(dfrm.stalls.summary)[ names(dfrm.stalls.summary) == "mos" ] <- "stalls"

write.table(dfrm.stalls.summary, file="stats-output/1-Summary/stalls_summary.txt", sep = ",", row.names = FALSE)

dfrm.stalltime.summary <- summarySE(dfrm, "stall_time", c("segment_length", "buffer_size", "lr", "mlbs", "bandwidth"))
names(dfrm.stalltime.summary)[ names(dfrm.stalltime.summary) == "mos" ] <- "stalltime"
write.table(dfrm.stalltime.summary, file="stats-output/1-Summary/stalltime_summary.txt", sep = ",", row.names = FALSE)

dfrm.initialdelay.summary <- summarySE(dfrm, "initial_delay", c("segment_length", "buffer_size", "lr", "mlbs", "bandwidth"))
names(dfrm.initialdelay.summary)[ names(dfrm.initialdelay.summary) == "mos" ] <- "initialdelay"
write.table(dfrm.initialdelay.summary, file="stats-output/1-Summary/initialdelay_summary.txt", sep = ",", row.names = FALSE)


#######################################################################
## print("*** 3 - Quantiles ***")
## p1 <- quantiles.p.threshold(dfrm.summary, dfrm, "vote", 1.0)
## p2 <- quantiles.p.threshold(dfrm.summary, dfrm, "vote", 2.0)
## p3 <- quantiles.p.threshold(dfrm.summary, dfrm, "vote", 3.0)
## p4 <- quantiles.p.threshold(dfrm.summary, dfrm, "vote", 4.0)

## dfrm.quantiles <- cbind(dfrm.summary, p1, p2, p3, p4)
## dfrm.quantiles <- dfrm.quantiles[order(dfrm.quantiles$mos, decreasing = FALSE),]
## dfrm.quantiles <- cbind(dfrm.quantiles, 1:nrow(dfrm.quantiles))
## names(dfrm.quantiles)[16] <- "index"

## dir.create("output/3-Quantiles", recursive=TRUE)
## #summary
## write.table(dfrm.quantiles, file="output/3-Quantiles/quantiles.txt")

## setEPS()
## postscript("output/3-Quantiles/plot-p.eps")

## quantiles.plot.p(dfrm.quantiles)

## dev.off()
## system("convert -density 100 output/3-Quantiles/plot-p.eps output/3-Quantiles/plot-p.jpg")

## setEPS()
## postscript("output/3-Quantiles/plot-quantiles.eps")

## quantiles.plot.10.90(dfrm.quantiles)

## dev.off()
## system("convert -density 100 output/3-Quantiles/plot-quantiles.eps output/3-Quantiles/plot-quantiles.jpg")


#######################################################################
print("*** 4 - ANOVA ***")

dir.create("stats-output/4-ANOVA", recursive=TRUE)

# one way
sink(file="stats-output/4-ANOVA/oneway.txt")


print("Stallings")
fitted <- simplified.anova(stalls~segment_length, dfrm.stalls.summary)
summary(fitted)
fitted <- simplified.anova(stalls~buffer_size, dfrm.stalls.summary)
summary(fitted)
fitted <- simplified.anova(stalls~lr, dfrm.stalls.summary)
summary(fitted)
fitted <- simplified.anova(stalls~mlbs, dfrm.stalls.summary)
summary(fitted)
fitted <- simplified.anova(stalls~bandwidth, dfrm.stalls.summary)
summary(fitted)

print("Stalltime")
fitted <- simplified.anova(stalltime~segment_length, dfrm.stalltime.summary)
summary(fitted)
fitted <- simplified.anova(stalltime~buffer_size, dfrm.stalltime.summary)
summary(fitted)
fitted <- simplified.anova(stalltime~lr, dfrm.stalltime.summary)
summary(fitted)
fitted <- simplified.anova(stalltime~mlbs, dfrm.stalltime.summary)
summary(fitted)
fitted <- simplified.anova(stalltime~bandwidth, dfrm.stalltime.summary)
summary(fitted)

print("Initial delay")
fitted <- simplified.anova(initialdelay~segment_length, dfrm.initialdelay.summary)
summary(fitted)
fitted <- simplified.anova(initialdelay~buffer_size, dfrm.initialdelay.summary)
summary(fitted)
fitted <- simplified.anova(initialdelay~lr, dfrm.initialdelay.summary)
summary(fitted)
fitted <- simplified.anova(initialdelay~mlbs, dfrm.initialdelay.summary)
summary(fitted)
fitted <- simplified.anova(initialdelay~bandwidth, dfrm.initialdelay.summary)
summary(fitted)

sink(NULL)



sink(file="stats-output/4-ANOVA/interactions_typeI.txt")
## # two way for interactions Type I test
print("Stallings")
anova.two.way(dfrm.stalls.summary, "stalls", c("segment_length", "buffer_size", "lr", "mlbs","bandwidth"))

print("Stallings without mlbs")
anova.two.way(dfrm.stalls.summary, "stalls", c("segment_length", "buffer_size", "lr", "bandwidth"))

print("Stalltime")
anova.two.way(dfrm.stalltime.summary, "stalltime", c("segment_length", "buffer_size", "lr", "mlbs","bandwidth"))

print("Stalltime without mlbs")
anova.two.way(dfrm.stalltime.summary, "stalltime", c("segment_length", "buffer_size", "lr","bandwidth"))

print("Initial delay")
anova.two.way(dfrm.initialdelay.summary, "initialdelay", c("segment_length", "buffer_size", "lr", "mlbs","bandwidth"))

## # three way for interactions Type I test
## fitted <- aov(mos~number_stalls*stall_duration*stall_pattern, dfrm.summary)
## summary(fitted)

sink(NULL)

## sink(file="output/4-ANOVA/main_effects_typeII.txt")
## # assume no interactions (check previous)
## anova.two.way.no.interaction(dfrm.summary, "mos", c("number_stalls", "stall_duration", "stall_pattern", "ave_stall"))

## fitted <- aov(mos~number_stalls+stall_duration+stall_pattern+ave_stall, dfrm.summary)
## Anova(fitted, type="II")


## sink(NULL)


#######################################################################
print("*** 5 - MOS and Interaction plots ***")


dir.create("stats-output/5-MOS-Plots", recursive=TRUE)

pdf("stats-output/5-MOS-Plots/stalls-segmentlength.pdf", fonts=c("serif"))

par(mar=c(5, 4, 4, 6) + 0.1)

datac <- summaryBy(stalls~segment_length, data=dfrm.stalls.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalls.mean" ] <- "stalls"
plot(datac$stalls~datac$segment_length, axes=FALSE, xlab="Segment length",
       ylab="", pch=16, type="b", ylim=c(0,5), family="serif", lty=1, cex.lab=1.5, cex.main=1.5)

axis(2, ylim=c(0,5),las=1,cex.axis = 1.5)
mtext("Stalls",side=2,line=2.5, family="serif", cex=1.5)
box()
par(new=TRUE)

datac <- summaryBy(stalltime~segment_length, data=dfrm.stalltime.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalltime.mean" ] <- "stalltime"

plot(datac$stalltime~datac$segment_length, axes=FALSE, xlab="",
       ylab="", pch=15, type="b", ylim=c(0,130), family="serif", lty=4)



axis(4, ylim=c(0,130),las=1, cex.axis=1.5)
mtext("Total stalling time",side=4,line=4, family="serif", cex=1.5)

axis(1,datac$segment_length,cex.axis=1.5)

op <- par(family = "serif")

legend("topright",legend=c("Stalls","Total stalling time"), lty=c(1,4), pch=c(16, 15), cex=1.5)

par(op)

dev.off()


pdf("stats-output/5-MOS-Plots/stalls-buffersize.pdf", fonts=c("serif"))

par(mar=c(5, 4, 4, 6) + 0.1)

datac <- summaryBy(stalls~buffer_size, data=dfrm.stalls.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalls.mean" ] <- "stalls"
plot(datac$stalls~datac$buffer_size, axes=FALSE, xlab="Buffer size",
       ylab="", pch=16, type="b", ylim=c(0,5), family="serif", lty=1, cex.lab=1.5, cex.main=1.5)
axis(2, ylim=c(0,5),las=1,cex.axis = 1.5)
mtext("Stalls",side=2,line=2.5, family="serif", cex=1.5)
box()
par(new=TRUE)

datac <- summaryBy(stalltime~buffer_size, data=dfrm.stalltime.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalltime.mean" ] <- "stalltime"
plot(datac$stalltime~datac$buffer_size, axes=FALSE, xlab="",
       ylab="", pch=15, type="b", ylim=c(0,130), family="serif", lty=4)
axis(4, ylim=c(0,130),las=1,cex.axis = 1.5)
mtext("Total stalling time",side=4,line=4, family="serif", cex=1.5)

axis(1,datac$buffer_size,cex.axis = 1.5)

op <- par(family = "serif")
legend("topright",legend=c("Stalls","Total stalling time"), lty=c(1,4), pch=c(16, 15), cex=1.5)
par(op)


dev.off()

pdf("stats-output/5-MOS-Plots/stalls-lr.pdf", fonts=c("serif"))

par(mar=c(5, 4, 4, 6) + 0.1)

datac <- summaryBy(stalls~lr, data=dfrm.stalls.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalls.mean" ] <- "stalls"
plot(datac$stalls~datac$lr, axes=FALSE, xlab="Loss rate",
       ylab="", pch=16, type="b", ylim=c(0,6), family="serif", lty=1, cex.lab=1.5, cex.main=1.5)
axis(2, ylim=c(0,6),las=1,cex.axis = 1.5)
mtext("Stalls",side=2,line=2.5, family="serif", cex=1.5)
box()
par(new=TRUE)

datac <- summaryBy(stalltime~lr, data=dfrm.stalltime.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalltime.mean" ] <- "stalltime"
plot(datac$stalltime~datac$lr, axes=FALSE, xlab="",
       ylab="", pch=15, type="b", ylim=c(0,500), family="serif", lty=4)
axis(4, ylim=c(0,500),las=1,cex.axis = 1.5)
mtext("Total stalling time",side=4,line=4, family="serif", cex=1.5)

axis(1,datac$lr,cex.axis = 1.5)

op <- par(family = "serif")
legend("topleft",legend=c("Stalls","Total stalling time"), lty=c(1,4), pch=c(16, 15), cex=1.5)
par(op)



dev.off()

pdf("stats-output/5-MOS-Plots/stalls-mlbs.pdf", fonts=c("serif"))

par(mar=c(5, 4, 4, 6) + 0.1)

datac <- summaryBy(stalls~mlbs, data=dfrm.stalls.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalls.mean" ] <- "stalls"
plot(datac$stalls~datac$mlbs, axes=FALSE, xlab="MLBS",
     ylab="", pch=16, type="b", ylim=c(0,5), family="serif",
     lty=1, cex.lab=1.5, cex.main=1.5, xaxt="n")
axis(2, ylim=c(0,5),las=1,cex.axis = 1.5)
mtext("Stalls",side=2,line=2.5, family="serif", cex=1.5)
box()
par(new=TRUE)

datac <- summaryBy(stalltime~mlbs, data=dfrm.stalltime.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalltime.mean" ] <- "stalltime"
plot(datac$stalltime~datac$mlbs, axes=FALSE, xlab="",
       ylab="", pch=15, type="b", ylim=c(0,110), family="serif", lty=4)
axis(4, ylim=c(0,110),las=1,cex.axis = 1.5)
mtext("Total stalling time",side=4,line=4, family="serif", cex=1.5)

axis(1, at=c(5,30, 50),labels=c("1", "1.5", "2"), cex.axis = 1.5)

op <- par(family = "serif")
legend("topright",legend=c("Stalls","Total stalling time"), lty=c(1,4), pch=c(16, 15), cex=1.5)
par(op)


dev.off()

pdf("stats-output/5-MOS-Plots/stalls-bandwidth.pdf", fonts=c("serif"))

par(mar=c(5, 4, 4, 6) + 0.1)

datac <- summaryBy(stalls~bandwidth, data=dfrm.stalls.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalls.mean" ] <- "stalls"
plot(datac$stalls~datac$bandwidth, axes=FALSE, xlab="Bandwidth",
       ylab="", pch=16, type="b", ylim=c(0,5), family="serif", lty=1, cex.lab=1.5, cex.main=1.5)
axis(2, ylim=c(0,5),las=1,cex.axis = 1.5)
mtext("Stalls",side=2,line=2.5, family="serif", cex=1.5)
box()
par(new=TRUE)

datac <- summaryBy(stalltime~bandwidth, data=dfrm.stalltime.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalltime.mean" ] <- "stalltime"
plot(datac$stalltime~datac$bandwidth, axes=FALSE, xlab="",
       ylab="", pch=15, type="b", ylim=c(0,140), family="serif", lty=4)
axis(4, ylim=c(0,140),las=1,cex.axis = 1.5)
mtext("Total stalling time",side=4,line=4, family="serif", cex=1.5)

axis(1,datac$bandwidth,cex.axis = 1.5)

op <- par(family = "serif")
legend("topright",legend=c("Stalls","Total stalling time"), lty=c(1,4), pch=c(16, 15), cex=1.5)
par(op)


dev.off()


pdf("stats-output/5-MOS-Plots/stalls-lr-mlbs.pdf", fonts=c("serif"))

par(mar=c(5, 4, 4, 6) + 0.1)

datac <- summaryBy(stalls~lr+mlbs, data=dfrm.stalls.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalls.mean" ] <- "stalls"

plotada <- subset(datac, mlbs == 5)
#plot(plotada$stalls~plotada$lr, axes=T, xlab="Loss rate",
#       ylab="Stalls", pch=16, type="b", ylim=c(0,7), family="serif", main="Stalls by loss rate and mlbs", lty=1)


plot(plotada$stalls~plotada$lr, axes=FALSE, xlab="Loss rate",
       ylab="", pch=15, type="b", ylim=c(0,8), family="serif", lty=1, cex.lab=1.5, cex.main=1.5)
plotada <- subset(datac, mlbs == 50)
lines(plotada$stalls~plotada$lr, lty=1, type="b", pch=16)

axis(2, ylim=c(0,8),las=1,cex.axis = 1.5)
mtext("Stalls",side=2,line=2.5, family="serif", cex=1.5)
box()
par(new=TRUE)


datac <- summaryBy(stalltime~lr+mlbs, data=dfrm.stalltime.summary, FUN=c(mean,sd))
names(datac)[ names(datac) == "stalltime.mean" ] <- "stalltime"

plotada <- subset(datac, mlbs == 5)
plot(plotada$stalltime~plotada$lr, axes=FALSE, xlab="",
       ylab="", pch=0, type="b", ylim=c(0,500), family="serif", lty=4)
plotada <- subset(datac, mlbs == 50)
lines(plotada$stalltime~plotada$lr, lty=4, type="b", pch=1)


axis(4, ylim=c(0,500),las=1,cex.axis = 1.5)
mtext("Total stalling time",side=4,line=4, family="serif", cex=1.5)

axis(1,datac$lr,cex.axis = 1.5)

op <- par(family = "serif")
legend("topleft",legend=c("Stalls,  MLBS = 1", "Stalls, MLBS = 2", "Total stalling time, MLBS = 1", "Total stalling time, MLBS = 2"), lty=c(1,1, 4, 4), pch=c(15, 16, 0, 1), cex=1.5)
par(op)


dev.off()



## names(datac)[ names(datac) == "stalltime.mean" ] <- "stalltime"

## plotada <- subset(datac, mlbs == 5)
## plot(plotada$stalltime~plotada$lr, axes=T, xlab="Loss rate",
##        ylab="Stalltime", pch=16, type="b", ylim=c(0,460), family="serif", main="Loss rate - MLBS")

## plotada <- subset(datac, mlbs == 30)
## lines(plotada$stalltime~plotada$lr, lty=3)

## plotada <- subset(datac, mlbs == 50)
## lines(plotada$stalltime~plotada$lr)

## dev.off()

# Initial delay
#segment_length:lr    1   8849    8849   131.5 <2e-16 ***
#segment_length:mlbs    1   3585    3585   43.19 6.6e-11 ***
#lr:mlbs        1  43456   43456   836.5 <2e-16 ***
  
## dir.create("output/5-MOS-Plots", recursive=TRUE)
## setEPS()
## postscript("output/5-MOS-Plots/plot-mos-vs-totaltime.eps", fonts=c("serif"))
## plot.mos.vs.totaltime(dfrm)
## dev.off()
## system("convert -density 100 output/5-MOS-Plots/plot-mos-vs-totaltime.eps output/5-MOS-Plots/plot-mos-vs-totaltime.jpg")


## setEPS()
## postscript("output/5-MOS-Plots/plot-mos-vs-numberstalls.eps", fonts=c("serif"))
## plot.mos.vs.numberstalls(dfrm)
## dev.off()
## system("convert -density 100 output/5-MOS-Plots/plot-mos-vs-numberstalls.eps output/5-MOS-Plots/plot-mos-vs-numberstalls.jpg")

## setEPS()
## postscript("output/5-MOS-Plots/plot-mos-vs-stallpattern2.eps", fonts=c("serif"))
## plot.mos.vs.stallpattern2(dfrm)
## dev.off()
## system("convert -density 100 output/5-MOS-Plots/plot-mos-vs-stallpattern2.eps output/5-MOS-Plots/plot-mos-vs-stallpattern2.jpg")


## setEPS()
## postscript("output/5-MOS-Plots/plot-mos-vs-stallpattern3.eps", fonts=c("serif"))
## plot.mos.vs.stallpattern3(dfrm)
## dev.off()
## system("convert -density 100 output/5-MOS-Plots/plot-mos-vs-stallpattern3.eps output/5-MOS-Plots/plot-mos-vs-stallpattern3.jpg")

## setEPS()
## postscript("output/5-MOS-Plots/plot-mos-vs-avestall.eps", fonts=c("serif"))
## plot.mos.vs.avestall(dfrm)
## dev.off()
## system("convert -density 100 output/5-MOS-Plots/plot-mos-vs-avestall.eps output/5-MOS-Plots/plot-mos-vs-avestall.jpg")

#######################################################################
## print("*** 6 - Demographics ***")

## dir.create("output/6-Demographics", recursive=TRUE)

## source("R/load_demographics.R")
## dfrm.likings <- merge(dfrm, likings)


## setEPS()
## postscript("output/6-Demographics/plot-mos-vs-liking.eps", fonts=c("serif"))
## plot.mos.vs.likings(dfrm.likings)
## dev.off()
## system("convert -density 100 output/6-Demographics/plot-mos-vs-liking.eps output/6-Demographics/plot-mos-vs-liking.jpg")

## dfrm.demographics <- merge(dfrm, dfrm.demographics)


## sink(file="output/6-Demographics/main_effects_typeI.txt")

## fitted <- simplified.anova(vote~Gender, dfrm.demographics)
## summary(fitted)
## fitted <- simplified.anova(vote~Age, dfrm.demographics)
## summary(fitted)
## fitted <- simplified.anova(vote~http.video.familiarity, dfrm.demographics)
## summary(fitted)
## fitted <- simplified.anova(vote~service.usage, dfrm.demographics)
## summary(fitted)
## fitted <- simplified.anova(vote~paid.service.usage, dfrm.demographics)
## summary(fitted)

## sink(NULL)

## sink(file="output/6-Demographics/interactions_typeI.txt")

## dfrm.interactions <- summarySE(dfrm.demographics, "vote", c("number_stalls", "stall_duration", "Gender"))
## anova.two.way(dfrm.interactions, "mos", c("number_stalls", "stall_duration", "Gender"))

## dfrm.interactions <- summarySE(dfrm.demographics, "vote", c("number_stalls", "stall_duration", "Age"))
## anova.two.way(dfrm.interactions, "mos", c("number_stalls", "stall_duration", "Age"))

## dfrm.interactions <- summarySE(dfrm.demographics, "vote", c("number_stalls", "stall_duration", "http.video.familiarity"))
## anova.two.way(dfrm.interactions, "mos", c("number_stalls", "stall_duration", "http.video.familiarity"))

## dfrm.interactions <- summarySE(dfrm.demographics, "vote", c("number_stalls", "stall_duration", "service.usage"))
## anova.two.way(dfrm.interactions, "mos", c("number_stalls", "stall_duration", "service.usage"))

## dfrm.interactions <- summarySE(dfrm.demographics, "vote", c("number_stalls", "stall_duration", "paid.service.usage"))
## anova.two.way(dfrm.interactions, "mos", c("number_stalls", "stall_duration", "paid.service.usage"))

## fitted <- simplified.anova(vote~number_stalls*stall_duration*Gender*Age*http.video.familiarity*service.usage*paid.service.usage, dfrm.demographics)
## summary(fitted)

## sink(NULL)


## # plotting the interactions

## setEPS()
## postscript("output/6-Demographics/plot-mos-vs-age-number-stalls.eps", fonts=c("serif"))
## dfrm.ages.number.stalls <- summarySE(dfrm.demographics, "vote", c("number_stalls", "Age"))
## plot.mos.vs.age.groups.number.stalls(dfrm.ages.number.stalls)
## dev.off()
## system("convert -density 100 output/6-Demographics/plot-mos-vs-age-number-stalls.eps output/6-Demographics/plot-mos-vs-age-number-stalls.jpg")



## setEPS()
## postscript("output/6-Demographics/plot-mos-vs-http-video-familiarity-number-stalls.eps", fonts=c("serif"))
## dfrm.http.video.familiarity.number.stalls <- summarySE(dfrm.demographics, "vote", c("number_stalls", "http.video.familiarity"))
## plot.mos.vs.http.video.familiarity.groups.number.stalls(dfrm.http.video.familiarity.number.stalls)
## dev.off()
## system("convert -density 100 output/6-Demographics/plot-mos-vs-http-video-familiarity-number-stalls.eps output/6-Demographics/plot-mos-vs-http-video-familiarity-number-stalls.jpg")

## # main effect plots

## setEPS()
## postscript("output/6-Demographics/plot-mos-vs-age.eps", fonts=c("serif"))
## dfrm.ages <- summarySE(dfrm.demographics, "vote", c("Age"))
## plot.mos.vs.age(dfrm.ages)
## dev.off()
## system("convert -density 100 output/6-Demographics/plot-mos-vs-age.eps output/6-Demographics/plot-mos-vs-age.jpg")

## setEPS()
## postscript("output/6-Demographics/plot-mos-vs-http-video-familiarity.eps", fonts=c("serif"))
## dfrm.http.video.familiarity <- summarySE(dfrm.demographics, "vote", c("http.video.familiarity"))
## plot.mos.vs.http.video.familiarity(dfrm.http.video.familiarity)
## dev.off()
## system("convert -density 100 output/6-Demographics/plot-mos-vs-http-video-familiarity.eps output/6-Demographics/plot-mos-vs-http-video-familiarity.jpg")




