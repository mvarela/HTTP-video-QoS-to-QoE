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



# ./do_rnn.R inputdata/totaltime/0/trn.txt inputdata/totaltime/0/tst.txt 0.2

# ./do_rnn.R inputdata/stalls/1/trn.txt inputdata/stalls/1/tst.txt 0.01
# ./do_rnn.R inputdata/totaltime/1/trn.txt inputdata/totaltime/1/tst.txt 0.2

# ./do_rnn.R inputdata/stalls/2/trn.txt inputdata/stalls/2/tst.txt 0.01
# ./do_rnn.R inputdata/totaltime/2/trn.txt inputdata/totaltime/2/tst.txt 0.2

# ./do_rnn.R inputdata/stalls/3/trn.txt inputdata/stalls/2/tst.txt 0.01
# ./do_rnn.R inputdata/totaltime/3/trn.txt inputdata/totaltime/2/tst.txt 0.2

# ./do_rnn.R inputdata/stalls/4/trn.txt inputdata/stalls/4/tst.txt 0.01
# ./do_rnn.R inputdata/totaltime/4/trn.txt inputdata/totaltime/4/tst.txt 0.2

# ./do_rnn.R inputdata/stalls/5/trn.txt inputdata/stalls/5/tst.txt 0.01
# ./do_rnn.R inputdata/totaltime/5/trn.txt inputdata/totaltime/5/tst.txt 0.2

# ./do_rnn.R inputdata/stalls/6/trn.txt inputdata/stalls/6/tst.txt 0.01
# ./do_rnn.R inputdata/totaltime/6/trn.txt inputdata/totaltime/6/tst.txt 0.2

# ./do_rnn.R inputdata/stalls/7/trn.txt inputdata/stalls/7/tst.txt 0.01
# ./do_rnn.R inputdata/totaltime/7/trn.txt inputdata/totaltime/7/tst.txt 0.2

# ./do_rnn.R inputdata/stalls/8/trn.txt inputdata/stalls/8/tst.txt 0.01
# ./do_rnn.R inputdata/totaltime/8/trn.txt inputdata/totaltime/8/tst.txt 0.2

# ./do_rnn.R inputdata/stalls/9/trn.txt inputdata/stalls/9/tst.txt 0.01
# ./do_rnn.R inputdata/totaltime/9/trn.txt inputdata/totaltime/9/tst.txt 0.2

