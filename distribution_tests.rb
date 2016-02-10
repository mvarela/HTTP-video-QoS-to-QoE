#!/usr/bin/env ruby

def clean_negatives(v)
  v.map {|x| if(x<0) then 0 else x end}
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
  p clean_negatives(predicted)
