#!/usr/bin/env ruby

# we get the input from STDIN, looks like:
# qos_histograms/436_transformers_2_2_False_2_0_15_1.25_0_0_15000_491 15.9512601296, 1173362, 9, 394.302549124, 25.6443109512, 479.38789301
# We need to get the configuration info, the number of stalls, and the total stall time, which we then use to calculate the average stall time.

results = {}
MAX_STALLS = 10
MAX_AVG_STALL_DURATION = 90
BUCKET_SIZE = 5
STDIN.each_line do |line|
  l              = line.split
  conf_data      = l[0]
  stall_count    = l[3].to_i
  stall_duration     = l[4].to_f
  avg_stall_time = 0
  if(stall_count > 0) then
    avg_stall_time = (stall_duration / stall_count).ceil
  end
  conf = conf_data.split "_"
  lr   = conf[8]
  mlbs = conf[9]
  bw   = conf[12]

  key = lr + ", " + mlbs + ", " + bw
  if(!results.has_key?(key)) then
    results[key] = {}
    results[key][:stall_count] = Array.new(MAX_STALLS + 1, 0)
    results[key][:stall_duration] = Array.new((MAX_AVG_STALL_DURATION / BUCKET_SIZE) + 1, 0)
  end
  case stall_count
  when 0..(MAX_STALLS - 1)
    results[key][:stall_count][stall_count] += 1
  else
    results[key][:stall_count][MAX_STALLS] += 1
  end

  case avg_stall_time
  when 0..(MAX_AVG_STALL_DURATION-1)
    results[key][:stall_duration][avg_stall_time.to_i/BUCKET_SIZE] += 1
  else
    results[key][:stall_duration][MAX_AVG_STALL_DURATION/BUCKET_SIZE] += 1
  end
end


fout_h = File.open "stall_histograms.txt", "w"
fout_d = File.open "stall_duration_histograms.txt", "w"

fout_h.printf("#LR, MLBS, BW, stall# 0..#{MAX_STALLS - 1},over_limit\n")
fout_d.printf("#LR, MLBS, BW, avg_stall_duration 0..#{MAX_STALLS - 1}/#{BUCKET_SIZE},over_limit\n")

results.keys.sort.each do |k|
  fout_h.printf("%s, %s\n", k, results[k][:stall_count].map{ |x| x.to_s}.join(", "))
  fout_d.printf("%s, %s\n", k, results[k][:stall_duration].map{ |x| x.to_s}.join(", "))
end

fout_h.close
fout_d.close
