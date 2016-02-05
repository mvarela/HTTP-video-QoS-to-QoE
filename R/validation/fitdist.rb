#!/usr/bin/env ruby

# Given a histogram, provide a way to emulate the histogram's distribution, with
# some randomization added in the buckets


lin = File.readlines ARGV[0]

histogram = []

lin.each do |x|
  histogram << x.chomp.split.map{|x| x.to_i}
end

total = 0

histogram.map{|h| total += h[1]}

normalized = []

acc = 0.0
histogram.each_index do |i|

  high = if(i<histogram.size-1) then histogram[i+1][0]-1 else histogram[i][0] end
  acc+=histogram[i][1]
  threshold = acc/total
  low = histogram[i][0]#if(i>0) then histogram[i-1][0] else histogram[0][0] end

  normalized << {:low => low, :high => high, :threshold => threshold}
end

def find_bucket(r, norm_vec)
  norm_vec.each_index do |i|
    if(r < norm_vec[i][:threshold])
      return i
    end
  end
  return norm_vec.size
end

def draw(count, norm_vec)
  rng = Random.new
  result = []
  count.times do
    b = find_bucket(rng.rand, norm_vec)
    result << rng.rand((norm_vec[b][:low])..norm_vec[b][:high])
  end
  return result
end

#p normalized

a = draw(10000, normalized)
printf("drawn\n")
a.each do |s|
  printf "%d\n", s
end


b = draw(6,normalized)
p b
