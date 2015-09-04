#!/usr/bin/env ruby

# Read the Qosmet output, and discard the header lines at the top (19)
dname = ARGV[0]
Dir.chdir dname
fname = Dir.glob("averages*")[0]
lines = File.readlines(fname).drop 19

# We are interested only in some DL columns: total LR (30), total packets (33), Connection break count (43), and Load (32)
# for the Connection break count we need the sum, and for the Load the average
sum_cb = 0
sum_l  = 0
lines.each_index do |i|
  lines[i] = lines[i].split 
  sum_cb += lines[i][42].to_f
  sum_l += lines[i][30].to_f
end
if(0 == sum_cb) then
  sum_cb = 1
end
n = lines.size
average_load = sum_l / n
total_lr = lines[n - 1][29].to_f
total_packets = lines[n - 1][32].to_f
lost_packets = (total_packets * total_lr).ceil
mlbs = lost_packets / sum_cb
if(0<mlbs && mlbs<1) then 
  STDERR.printf("Something's fishy here... MLBS < 1\n")
end
fout = File.open("overall_qos.csv", "w")
fout.printf("LR, MLBS, Throughput\n")
fout.printf("%.5f, %.5f, %.5f\n", total_lr, mlbs, average_load)
fout.close
