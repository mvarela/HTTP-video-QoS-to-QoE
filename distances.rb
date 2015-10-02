#!/usr/bin/env ruby

require 'json'

def insert_distance(distances, lr, d)
  if(!distances.has_key?(lr))
    distances[lr] = Array.new(S,0)
  end
  distances[lr][d - 1] += 1
end

# Number of seconds to look at before a stall event
S = 10

distances = {}

dname = ARGV[0]
Dir.chdir dname

# If the file contains only the header, we bail
stalls = File.readlines 'stalls_plot.txt'
exit unless(stalls.size > 0) 

# The first two lines are not useful, if there
# is nothing else, we also bail
losses = File.readlines 'loss_events.txt'
exit unless(losses.size > 2)
losses.shift 2

# Collect start times for stalls: every fourth line, starting from the first
stall_start_times = []
stalls.each_index do |i|
  if(0 == i % 4)
    stall_start_times << stalls[i].split(',')[0].to_f
  end
end

loss_events = []
losses.each do |l|
  loss_events << l.split.map(&:to_f)
end
stall_start_times.each do |s|
  # last loss event before stall
  ll_index = loss_events.rindex{ |l| l[0]< s }
  break unless ll_index
  ts = loss_events[ll_index][0]
  # Get all "first loss" events up to S seconds before the stall
  while((ts > 0) &&  (ts >= (s - S)) && (ll_index >= 0))
    # check whether this was the first monitoring period with a loss,
    # if not, try the previous one
    if(ts - loss_events[ll_index-1][0] > 1.1)
      loss_rate = loss_events[ll_index][1].round
      ellapsed = (s - ts).round
      insert_distance(distances, loss_rate, ellapsed)
    end
    ll_index -= 1
    ts = loss_events[ll_index][0]
  end
end

if(distances.size > 0)
config =  ARGV[0].gsub(/^.*\//,"")
out = {:config => config, :distances => distances}
STDOUT.printf("%s\n", out.to_json)
end
