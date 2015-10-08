#!/bin/bash

# Process all media types separately
# the first parameter will define the number of hidden neurons in the RNN

rm -r validation/stalls_hist  >/dev/null 2&>1
rm -r validation/totaltime_hist  >/dev/null 2&>1
mkdir -p validation/stalls_hist
mkdir -p validation/totaltime_hist


cat ../stall_histograms.txt | sed -f clean.sed > validation/stall_trn
cat ../stall_duration_histograms.txt | sed -f clean.sed > validation/duration_trn

cat ../validation_stall_histograms.txt | sed -f clean.sed > validation/validation_stall
cat ../validation_stall_duration_histograms.txt | sed -f clean.sed > validation/validation_duration


./do_rnn_hist.R validation/stall_trn validation/validation_stall 0.005
mv tst.predictions.txt validation/predictions_stall.txt


./do_rnn_hist.R validation/duration_trn validation/validation_duration 0.2
mv tst.predictions.txt validation/predictions_duration.txt
