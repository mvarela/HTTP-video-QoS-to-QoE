#!/bin/bash
export RNN_SCRIPT_ROOT=`pwd`
for i in 0 1 2 3 4 5 6 7 8 9 ;do pushd $1/$i; ex - rnn_gen_wts1.dat < $RNN_SCRIPT_ROOT/ex/retrain.ex ; (echo "l" | ff_rnn); test_rnn.sh; popd
done

