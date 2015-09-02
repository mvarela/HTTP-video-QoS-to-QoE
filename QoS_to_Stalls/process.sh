#!/bin/bash

# Process all media types separately
# the first parameter will define the number of hidden neurons in the RNN

export RNN_SCRIPT_ROOT=`pwd`


echo $1 > hidden.txt

##
rm -rf stall_numbers_$1 2>&1 >/dev/null
mkdir stall_numbers_$1
cat data_all.txt |  sed -f clean.sed  > set1
./split-10.rb set1 stall_numbers_$1
for i in 0 1 2 3 4 5 6 7 8 9; do ./to_rnn.sh stall_numbers_$1/$i; done
./train_rnn.sh stall_numbers_$1
