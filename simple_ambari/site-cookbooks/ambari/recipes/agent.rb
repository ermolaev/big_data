include_recipe 'ambari::setup_package_manager'

package 'ambari-agent' do
  action :install
end

template '/etc/ambari-agent/conf/ambari-agent.ini' do
  source 'ambari-agent.ini.erb'
  mode 0755
  user 'root'
  group 'root'
  variables(ambari_server_fqdn: node['ambari']['server_fqdn'])
end

service 'ambari-agent' do
  action [:enable, :restart]
end
