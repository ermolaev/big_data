ambari_server_fqdn = node['ambari']['server_fqdn']

blueprint_name = "ermolaev_blueprint"
cluster_name   = "ermolaev_cluster"
blueprint_headers = {
  "AUTHORIZATION" => "Basic #{Base64.encode64("#{node['ambari']['admin_user']}:#{node['ambari']['admin_password']}")}",
  "X-Requested-By" => "ambari-cookbook"
}
blueprint_api_url = "http://#{ambari_server_fqdn}:8080/api/v1"

http_request 'check_amabari_server' do
  url      "#{blueprint_api_url}/hosts"
  action   :get
  headers  blueprint_headers
  retry_delay 10
  notifies :run, 'ruby_block[check_all_hosts]', :immediately
end


count_all_nodes = JSON.parse(File.read(node['ambari']['blueprints']['cluster_json_file']))["host_groups"].inject(0) { |s, i| s + i["hosts"].size }
ruby_block 'check_all_hosts' do
  block { }
  only_if do
    hosts_json = Zlib::GzipReader.new(  open("#{blueprint_api_url}/hosts", blueprint_headers)  ).read
    count_complete_nodes = JSON.parse(hosts_json)["items"].size
    count_all_nodes == count_complete_nodes
  end
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
