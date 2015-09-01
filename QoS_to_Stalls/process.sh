#!/bin/bash

# Process all media types separately
# the first parameter will define the number of hidden neurons in the RNN

export RNN_SCRIPT_ROOT=`pwd`


echo $1 > hidden.txt

##audio
# rm -rf audio_$1 2>&1 >/dev/null
# mkdir audio_$1
# cat data_all.txt | grep -v audiovisual | grep audio | sed -f clean.sed | awk -f normalize.awk > set1
# ./split-10.rb set1 audio_$1
# for i in 0 2 3 4 5 6 7 8 9; do ./to_rnn.sh audio_$1/$i; done
# train_rnn.sh audio_$1


##video
rm -rf video_$1 2>&1 >/dev/null
mkdir video_$1
cat data_all.txt | grep video | sed -f clean.sed | awk -f normalize.awk > set1
./split-10.rb set1 video_$1
for i in 0 1 2 3 4 5 6 7 8 9; do ./to_rnn.sh video_$1/$i; done
./train_rnn.sh video_$1

##audiovisual
rm -rf audiovisual_$1 2>&1 >/dev/null
mkdir audiovisual_$1
cat data_all.txt | grep audiovisual | sed -f clean.sed | awk -f normalize.awk > set1
./split-10.rb set1 audiovisual_$1
for i in 0 1 2 3 4 5 6 7 8 9; do ./to_rnn.sh audiovisual_$1/$i; done
./train_rnn.sh audiovisual_$1

