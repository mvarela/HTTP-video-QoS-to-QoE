#!/bin/bash

echo "t" | ff_rnn > out.txt
ex - out.txt < $RNN_SCRIPT_ROOT/ex/out.ex
ex - rnn_gen_tst1.dat < $RNN_SCRIPT_ROOT/ex/tst.ex
