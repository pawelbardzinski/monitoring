scheduler = Rufus::Scheduler.new

scheduler.every("1m") do
  puts "HELLO WORLD!"
  machines = Machine.find(:all)
  if machines.size > 0
    machines.each do |machine|
      output = `ruby ./lib/monitoring_script/monitoring.rb #{machine.hostname} #{machine.user} #{machine.keys_file}`.split("\n")
      DataPoint.new(cpu_usage: output[0].to_f, mem_usage: output[1].to_f, machine_id: machine.id).save
    end
  end
end