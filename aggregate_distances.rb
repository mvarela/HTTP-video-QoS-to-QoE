#!/usr/bin/env ruby

require 'json'
require 'ascii_charts'

# A small auxiliary function, because Ruby's library ain't as
# neat as the Haskell prelude yet...
def zip_with(a, b, &op)
  result = []
  a.zip(b){ |aa,bb| result << op.call(aa,bb)}
  result
end

# We will create a hash containing, for each loss rate observed, the observed
# distribution of stall starts over the /S/ seconds that follow
aggregates = {}

# read a file given as an argument, containing the JSON output by the
# "distances" script, and aggregate the data therein. At this first instance, we
# will not consider the different configuration parameters, and just lump everything
# together, to see what the data looks like.

lines = File.readlines ARGV[0]
lines.each do |l| 
  data = JSON.parse l
  d    = data["distances"]
  d.each do |k,v|
    if(!aggregates.has_key?(k.to_i))
      aggregates[k.to_i] = Array.new(v.size, 0)
    end
    aggregates[k.to_i] = zip_with(aggregates[k.to_i], v, &:+)
  end
end

p aggregates.keys.sort

aggregates.keys.sort.each do |k|
  v = aggregates[k]
  distribution = (1..v.size).to_a.zip(v)
  printf("LR = %d\n", k)
  printf("Distribution = %s\n", distribution)
  puts AsciiCharts::Cartesian.new(distribution, :bar => true, :hide_zero => false).draw
end
