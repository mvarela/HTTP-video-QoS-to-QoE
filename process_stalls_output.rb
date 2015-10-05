#!/usr/bin/env ruby
dname = ARGV[0]
Dir.chdir dname
logfile = Dir.glob("play*log")[0]
lines = File.readlines(logfile)
outf  = File.open("stalls.csv", "w")
plotf = File.open("stalls_plot.txt" ,"w")
lines.select!{|l| l=~/(Stall|Playback) starts/}
#skip the first "Playback starts" line, as it indicates the beginning of playback, not a stall
if(lines.size < 1) then exit end
lines.shift 
outf.printf("stall_start, playback_start, relative_stall, relative_playback, stall_duration\n") 
while(lines.size > 1) do
    stall = lines.shift.sub(",",".").gsub("-"," ").gsub(":"," ").chomp.split" "
    stall_start_time = Time.new stall[0], stall[1], stall[2], stall[3], stall[4], stall[5].to_f
    stall_relative_start_time = stall[-1].to_f
    playback = lines.shift.sub(",",".").gsub("-"," ").gsub(":"," ").chomp.split" "
    playback_start_time = Time.new playback[0], playback[1], playback[2], playback[3], playback[4], playback[5].to_f
    playback_relative_start_time = playback[-1].to_f
    duration = playback_relative_start_time - stall_relative_start_time
    outf.printf("%s, %s, %f, %f, %f\n", stall_start_time, playback_start_time, stall_relative_start_time, playback_relative_start_time, duration)
    plotf.printf("%f, 0\n %f, 1\n", stall_start_time.to_f, stall_start_time.to_f)
    plotf.printf("%f, 1\n %f, 0\n", playback_start_time.to_f, playback_start_time.to_f)
end
outf.close
plotf.close
