#!/usr/bin/env ruby

require 'ascii_charts'


def do_histogram(a)
  data = ((0..(a.size - 1)).to_a).zip a
  return AsciiCharts::Cartesian.new(data, :bar => true).draw
end

def clean_negatives(v)
  v.map {|x| if(x<0) then 0 else x end}
end

def normalize(v)
  e = clean_negatives(v)
  sum = e.reduce(:+)
  e.map{|x| x/sum}
end

def draw(h)
  acc = 0
  value = rand
  h.each_index do |i|
    acc += h[i]
    if value < acc then
      return i
    end
  end
end


lines = STDIN.readlines

h_out = File.open("normalized_plots.txt", "w")

#discard header
lines.shift

lines.each do |l|
  config = []
  data = l.chomp.gsub(" ","").split(",").map{ |x| a = x.to_f * 100; a = 0 unless (a>0); a }
  # discard id
  data.shift
  3.times do
    config << data.shift
  end
  key = config.map{ |x| (x/100).to_i.to_s }.join", "
  _original = data[0..(data.size/2 - 1)]
  original = normalize(_original)
  _predicted = data[data.size/2, data.size - 1]
  predicted = normalize(_predicted)

  p original
  p predicted

  dist_out = File.open("dist/distributions_#{key}.txt", "w")
  dist_out.printf("original, predicted\n")
  original.each_index { |i| 
  dist_out.printf("%f, %f\n",original[i],predicted[i])
  }
  dist_out.close

  h_out.printf("#{key}\nOriginal\n")
  h_out.puts(do_histogram(original))
  h_out.printf("\nPredicted\n\n")
  h_out.puts(do_histogram(predicted))

  # o_out = File.open("samples_original_dist_#{key}.txt", "w")
  # p_out = File.open("samples_predicted_dist_#{key}.txt", "w")
  # 10000.times do
  #   o_drawn = draw(original)
  #   p_drawn = draw(predicted)
  #   o_out.printf("%d\n",o_drawn)
  #   p_out.printf("%d\n",p_drawn)
  # end 
  # o_out.close
  # p_out.close
 end

  h_out.close
