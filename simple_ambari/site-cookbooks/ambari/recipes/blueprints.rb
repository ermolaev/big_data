ambari_server_fqdn = node['ambari']['server_fqdn']

blueprint_name = "ermolaev_blueprint"
cluster_name   = "ermolaev_cluster"
blueprint_headers = {
  "AUTHORIZATION" => "Basic #{Base64.encode64("#{node['ambari']['admin_user']}:#{node['ambari']['admin_password']}")}",
  "X-Requested-By" => "ambari-cookbook"
}
blueprint_api_url = "http://#{ambari_server_fqdn}:8080/api/v1"

http_request 'check_host' do
  url      "#{blueprint_api_url}/hosts/agent.ambari.ermolaev"
  action   :get
  headers  blueprint_headers
  retry_delay 10
  notifies :post, 'http_request[init_blueprint]', :delayed
  notifies :post, 'http_request[init_cluster]', :delayed
end

http_request 'init_blueprint' do
  url      "#{blueprint_api_url}/blueprints/#{blueprint_name}"
  action   :nothing
  headers  blueprint_headers
  message  File.read(node['ambari']['blueprints']['blueprint_json_file'])
  # если не равно 200 то накатываем, open кидает exeption при 40Х и 50Х статусах
  not_if   { open("#{blueprint_api_url}/blueprints/#{blueprint_name}", blueprint_headers).status[0] == "200" rescue false }
end


http_request 'init_cluster' do
  url      "#{blueprint_api_url}/clusters/#{cluster_name}"
  action   :nothing
  headers  blueprint_headers
  message  File.read(node['ambari']['blueprints']['cluster_json_file'])
  not_if   { open("#{blueprint_api_url}/clusters/#{cluster_name}", blueprint_headers).status[0] == "200" rescue false }
end
