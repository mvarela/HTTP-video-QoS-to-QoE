#!/bin/bash

# Process all media types separately
# the first parameter will define the number of hidden neurons in the RNN

rm -r inputdata/stalls_hist
rm -r inputdata/totaltime_hist
mkdir -p inputdata/stalls_hist
mkdir -p inputdata/totaltime_hist

cat ../stall_histograms.txt | sed -f clean.sed > set1
./split-10.rb set1 inputdata/stalls_hist

cat ../stall_duration_histograms.txt | sed -f clean.sed > set1
./split-10.rb set1 inputdata/totaltime_hist

./do_rnn_hist.R inputdata/stalls_hist/0/trn.txt inputdata/stalls_hist/0/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/0

./do_rnn_hist.R inputdata/stalls_hist/1/trn.txt inputdata/stalls_hist/1/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/1

./do_rnn_hist.R inputdata/stalls_hist/2/trn.txt inputdata/stalls_hist/2/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/2

./do_rnn_hist.R inputdata/stalls_hist/3/trn.txt inputdata/stalls_hist/3/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/3

./do_rnn_hist.R inputdata/stalls_hist/4/trn.txt inputdata/stalls_hist/4/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/4

./do_rnn_hist.R inputdata/stalls_hist/5/trn.txt inputdata/stalls_hist/5/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/5

./do_rnn_hist.R inputdata/stalls_hist/6/trn.txt inputdata/stalls_hist/6/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/6

./do_rnn_hist.R inputdata/stalls_hist/7/trn.txt inputdata/stalls_hist/7/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/7

./do_rnn_hist.R inputdata/stalls_hist/8/trn.txt inputdata/stalls_hist/8/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/8

./do_rnn_hist.R inputdata/stalls_hist/9/trn.txt inputdata/stalls_hist/9/tst.txt 0.005
mv "tst.predictions.txt" inputdata/stalls_hist/9



./do_rnn_tt_hist.R inputdata/totaltime_hist/0/trn.txt inputdata/totaltime_hist/0/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/0

./do_rnn_tt_hist.R inputdata/totaltime_hist/1/trn.txt inputdata/totaltime_hist/1/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/1

./do_rnn_tt_hist.R inputdata/totaltime_hist/2/trn.txt inputdata/totaltime_hist/2/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/2

./do_rnn_tt_hist.R inputdata/totaltime_hist/3/trn.txt inputdata/totaltime_hist/3/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/3

./do_rnn_tt_hist.R inputdata/totaltime_hist/4/trn.txt inputdata/totaltime_hist/4/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/4

./do_rnn_tt_hist.R inputdata/totaltime_hist/5/trn.txt inputdata/totaltime_hist/5/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/5

./do_rnn_tt_hist.R inputdata/totaltime_hist/6/trn.txt inputdata/totaltime_hist/6/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/6

./do_rnn_tt_hist.R inputdata/totaltime_hist/7/trn.txt inputdata/totaltime_hist/7/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/7

./do_rnn_tt_hist.R inputdata/totaltime_hist/8/trn.txt inputdata/totaltime_hist/8/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/8

./do_rnn_tt_hist.R inputdata/totaltime_hist/9/trn.txt inputdata/totaltime_hist/9/tst.txt 0.005
mv "tst.predictions.txt" inputdata/totaltime_hist/9

