#!/usr/bin/env ruby
dname = ARGV[0]
Dir.chdir dname
# Read the file and discard header
line = (File.readlines "dashsimu_output.txt").select{|x| x=~/INFO/}[0].gsub!(/^.*-/,"").chomp.split
# line format is: Avg resp time, Avg throughput, Number of segments, Buffer underruns, Stall time, Initial Delay, Total time
# not interested in the number of segments, so we drop it
line.delete_at 2
results = (line.join ", ")
STDOUT.printf("%s\n", results)
