#!/bin/bash

N_IN=4
N_HIDDEN=`cat $RNN_SCRIPT_ROOT/hidden.txt`
N_OUT=1

ff_gen_con $N_IN $N_HIDDEN $N_OUT
