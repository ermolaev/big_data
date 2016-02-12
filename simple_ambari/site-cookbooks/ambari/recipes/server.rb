include_recipe 'ambari::setup_package_manager'

%w(ambari-server postgresql).each do |pack|
  package pack
end

execute 'setup ambari-server' do
  command 'ambari-server setup -s'
end

service 'postgresql' do
  action [:enable, :start]
end

service 'ambari-server' do
  status_command "/etc/init.d/ambari-server status | grep 'Ambari Server running'"
  action [:enable, :start]
end

mysql_service 'default' do
  version '5.7'
  bind_address 'server.ambari.ermolaev'
  port '3306'
  data_dir '/data'
  initial_root_password 'testpass'
  action [:create, :start]
end
