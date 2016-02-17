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

package 'postgresql-jdbc'

# depends ambari[server]
execute 'jdbc to ambari-server' do
  command 'ambari-server setup --jdbc-db=postgres --jdbc-driver=/usr/share/java/postgresql-jdbc.jar'
end
