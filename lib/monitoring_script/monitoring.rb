require 'net/ssh'

unless ARGV.size == 3
  puts '# Usage:'
  puts '> ruby monitoring.rb [hostname] [user] [path to the key file]'
  exit
end

hostname = ARGV[0]
user = ARGV[1]
keys_file = ARGV[2]
  
cpu_stdout = ''
mem_stdout = ''
Net::SSH.start(hostname,user,:keys=>keys_file) do |ssh|
  ssh.exec!("ps --no-headers -eo pcpu | sort -k1 -r | head -10") do |channel,stream,data|
    cpu_stdout << data 
  end
  ssh.exec!("free -m -t") do |channel,stream,data|
    mem_stdout << data 
  end
end

cpu_usage = 0.0
cpu_output = cpu_stdout.split("\n")
cpu_output.each do |line|
  cpu_usage += line.gsub!(/\s+/,"").to_f
end

mem_usage = 0.0
mem_output = mem_stdout.split("\n")
mem_output.each do |line|
  next if line !~ /Total/
  line.match(/otal:\s+(\d+)\s+(\d+)\s+(\d+)$/)
  mem_usage = ($2.to_f / $1.to_f * 100.0).round(1)
end

puts cpu_usage
puts mem_usage  
  
