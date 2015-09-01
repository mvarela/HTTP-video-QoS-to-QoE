#!/usr/bin/env ruby
#Splits data set (1st argument) into 10 random groups of 10% test and 90%
#training data in the given output directory (2nd argument)

inputs     = ARGV[0]
output_dir = ARGV[1]


def make_output_dirs(od)
  current = Dir.pwd
  Dir.chdir od
  0.upto(9) do |i|
    Dir.mkdir i.to_s
  end
  Dir.chdir current
end



def read_inputs(f_in)
  f = File.readlines(f_in)
  res = []
  0.upto(9) do
    res << []
  end
  i = 0
  while(f.size > 0) do
    res[i%10] << f.delete_at(rand(f.size))
    i+=1
  end
  res
end


def do_combinations(od,data)
  0.upto(9) do |i|
    tmp = data.dup
    tst = tmp.delete_at(i).inject{|a,b| a+b}
    trn = tmp.flatten.inject{|a,b| a+b}
    f_tst = File.new("#{od}/#{i}/tst.txt","w")
    f_tst.write(tst)
    f_tst.close
    f_trn = File.new("#{od}/#{i}/trn.txt","w")
    f_trn.write(trn)
    f_trn.close
  end
end

make_output_dirs(output_dir)
data = read_inputs(inputs)
do_combinations(output_dir,data)


