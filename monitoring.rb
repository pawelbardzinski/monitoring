require 'net/ssh'

unless File.exists?('config.txt') 
  puts
  puts '> config.txt file not found in the current directory!'
  puts '> config.txt sample contents:'
  puts '##### config.txt file STARTS HERE #####'
  puts '# Commented lines start with a hash character'
  puts 'hostname: ec2-54-201-56-134.us-west-1.compute.amazonaws.com'
  puts 'user: ec2-user'
  puts 'keys-file: /Users/bardzinskip/.ssh/AWS_demo_key_pair.pem'
  puts '##### config.txt file ENDS HERE #####'
  puts
  exit
end

config = File.open('config.txt','r') 
contents = config.read
contents.match(/hostname:(.+)/)
hostname = $1.gsub!(/\s+/,"")
contents.match(/user:(.+)/)
user = $1.gsub!(/\s+/,"")
contents.match(/keys-file:(.+)/)
keys_file = $1.gsub!(/\s+/,"")

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
  
