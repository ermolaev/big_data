ambari_server_fqdn = node['ambari']['server_fqdn']

blueprint_name = "ermolaev_blueprint"
cluster_name   = "ermolaev_cluster"
basic_auth_parameters = "--user #{node['ambari']['admin_user']}:#{node['ambari']['admin_password']}"


execute 'Init Blueprints' do
  command "curl #{basic_auth_parameters} -H 'X-Requested-By:ambari-cookbook' --data @#{node['ambari']['blueprints']['blueprint_json_file']} #{ambari_server_fqdn}:8080/api/v1/blueprints/#{blueprint_name}"
end

execute 'Init Cluster' do
  command "curl #{basic_auth_parameters} -H 'X-Requested-By:ambari-cookbook' --data @#{node['ambari']['blueprints']['cluster_json_file']} #{ambari_server_fqdn}:8080/api/v1/clusters/#{cluster_name}"
end
