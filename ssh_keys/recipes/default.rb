# Iterate thru admins to generate new keys 
search(:users, 'groups:sysadmin') do |u|

  hosts = []
  home_dir = "/home/#{u['id']}"

  # Retrieve services to generate keys for
  ssh_keys = data_bag('ssh_keys') 
  ssh_keys.each do |service_name|
    host = data_bag_item('ssh_keys', service_name)
    
    key_name = "#{service_name}_#{node[:ssh_keys][:key_type]}"
    key_path = "#{home_dir}/.ssh/#{key_name}"
    
    execute "generate_keys_for_#{service_name}" do
      user u['id']
      group u['id']
      cwd "#{home_dir}"
      command "ssh-keygen -t #{node[:ssh_keys][:key_type]} -f #{key_path} -q -N ''"
      creates "#{key_path}"
      action :run
    end
    
    host['key_path'] = key_path
    hosts << host
  end

  template "#{home_dir}/.ssh/config" do
    source "config.erb"
    owner u['id']
    group u['id']
    mode "0600"
    variables(
      :hosts => hosts
    )
  end
end

