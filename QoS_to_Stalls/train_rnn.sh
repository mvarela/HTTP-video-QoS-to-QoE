#!/bin/bash


for i in 0 1 2 3 4 5 6 7 8 9 ;do pushd $1/$i; $RNN_SCRIPT_ROOT/create_rnn.sh ; (echo "s" | ff_rnn); $RNN_SCRIPT_ROOT/test_rnn.sh
popd
done

