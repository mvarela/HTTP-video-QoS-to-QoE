#!/bin/bash

# trains several RNN architectures with the number of hidden networks indicated below

for i in 9 10 11 15; do ./process.sh $i; done

