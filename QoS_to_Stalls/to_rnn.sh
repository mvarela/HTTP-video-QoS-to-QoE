#!/bin/bash

TRN=$1/rnn_gen_trn1.dat
TST=$1/rnn_gen_tst1.dat


echo `wc -l $1/trn.txt | awk '{print $1}'` > $TRN
echo "" >>  $TRN
awk '{print $1, $2, $3, $4}' < $1/trn.txt >> $TRN
echo "" >>  $TRN
awk '{print $5}' < $1/trn.txt >> $TRN


echo `wc -l $1/tst.txt | awk '{print $1}'` > $TST
echo "" >>  $TST
awk '{print $1, $2, $3, $4}' < $1/tst.txt >> $TST
echo "" >>  $TST
awk '{print $5}' < $1/tst.txt >> $TST
