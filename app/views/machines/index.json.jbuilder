json.array!(@machines) do |machine|
  json.extract! machine, :nickname, :hostname, :user, :keys_file
  json.url machine_url(machine, format: :json)
end
