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

mysql_service 'default' do
  version '5.6'
  bind_address 'agent.ambari.ermolaev'
  port '3306'
  data_dir '/mysqldata'
  initial_root_password 'testpass'
  action [:create, :start]
end
