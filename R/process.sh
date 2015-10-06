#!/bin/bash

# Process all media types separately
# the first parameter will define the number of hidden neurons in the RNN




./aggr_data.R ../data/2015_09_04_amended/results.txt

./do_rnn.R inputdata/stalls/0/trn.txt inputdata/stalls/0/tst.txt 0.01
./do_rnn.R inputdata/totaltime/0/trn.txt inputdata/totaltime/0/tst.txt 0.2

./do_rnn.R inputdata/stalls/1/trn.txt inputdata/stalls/1/tst.txt 0.01
./do_rnn.R inputdata/totaltime/1/trn.txt inputdata/totaltime/1/tst.txt 0.2

./do_rnn.R inputdata/stalls/2/trn.txt inputdata/stalls/2/tst.txt 0.01
./do_rnn.R inputdata/totaltime/2/trn.txt inputdata/totaltime/2/tst.txt 0.2

./do_rnn.R inputdata/stalls/3/trn.txt inputdata/stalls/2/tst.txt 0.01
./do_rnn.R inputdata/totaltime/3/trn.txt inputdata/totaltime/2/tst.txt 0.2

./do_rnn.R inputdata/stalls/4/trn.txt inputdata/stalls/4/tst.txt 0.01
./do_rnn.R inputdata/totaltime/4/trn.txt inputdata/totaltime/4/tst.txt 0.2

./do_rnn.R inputdata/stalls/5/trn.txt inputdata/stalls/5/tst.txt 0.01
./do_rnn.R inputdata/totaltime/5/trn.txt inputdata/totaltime/5/tst.txt 0.2

./do_rnn.R inputdata/stalls/6/trn.txt inputdata/stalls/6/tst.txt 0.01
./do_rnn.R inputdata/totaltime/6/trn.txt inputdata/totaltime/6/tst.txt 0.2

./do_rnn.R inputdata/stalls/7/trn.txt inputdata/stalls/7/tst.txt 0.01
./do_rnn.R inputdata/totaltime/7/trn.txt inputdata/totaltime/7/tst.txt 0.2

./do_rnn.R inputdata/stalls/8/trn.txt inputdata/stalls/8/tst.txt 0.01
./do_rnn.R inputdata/totaltime/8/trn.txt inputdata/totaltime/8/tst.txt 0.2

./do_rnn.R inputdata/stalls/9/trn.txt inputdata/stalls/9/tst.txt 0.01
./do_rnn.R inputdata/totaltime/9/trn.txt inputdata/totaltime/9/tst.txt 0.2

