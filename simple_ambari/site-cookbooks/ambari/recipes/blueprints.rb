ambari_server_fqdn = node['ambari']['server_fqdn']

blueprint_name = "ermolaev_blueprint"
cluster_name   = "ermolaev_cluster"
basic_auth_parameters = "#{node['ambari']['admin_user']}:#{node['ambari']['admin_password']}"


http_request 'Init Blueprints' do
  url      "#{ambari_server_fqdn}:8080/api/v1/blueprints/#{blueprint_name}"
  action   :post
  headers  { "AUTHORIZATION" => "Basic #{basic_auth_parameters}", "X-Requested-By" => "ambari-cookbook" })
  message  File.read(node['ambari']['blueprints']['blueprint_json_file'])
end


http_request 'Init Cluster' do
  url      "#{ambari_server_fqdn}:8080/api/v1/clusters/#{cluster_name}"
  action   :post
  headers  { "AUTHORIZATION" => "Basic #{basic_auth_parameters}", "X-Requested-By" => "ambari-cookbook" })
  message  File.read(node['ambari']['blueprints']['cluster_json_file'])
end
