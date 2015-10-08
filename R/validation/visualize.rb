#!/usr/bin/env ruby

require 'ascii_charts'


def do_histogram(a)
  data = ((0..(a.size - 1)).to_a).zip a
  return AsciiCharts::Cartesian.new(data, :bar => true).draw
end


lines = STDIN.readlines

#discard header
lines.shift

fout = File.open ("plots/"+ ARGV[0] + ".txt"), "w"

lines.each do |l|
  config = []
  data = l.chomp.gsub(" ","").split(",").map{ |x| a = x.to_f * 100; a = 0 unless (a>0); a }
  # discard id
  data.shift
  3.times do
    config << data.shift
  end
  key = config.map{ |x| (x/100).to_i.to_s }.join", "
  original = data[0..(data.size/2 - 1)]
  predicted = data[data.size/2, data.size - 1]
  o_hist = do_histogram(original)
  p_hist = do_histogram(predicted)
  fout.printf("#{key}\nOriginal:\n\n")
  fout.puts o_hist
  fout.printf("\nPredicted:\n\n")
  fout.puts p_hist
end


fout.close
