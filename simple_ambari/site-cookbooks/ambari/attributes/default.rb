default['ambari']['server_fqdn'] = "server.ambari.ermolaev"

default['ambari']['admin_user']     = 'admin'
default['ambari']['admin_password'] = 'admin'

default["ambari"]["blueprints"]["blueprint_json_file"] = Pathname(__FILE__).dirname.join('../files/blueprint.json')
default["ambari"]["blueprints"]["cluster_json_file"]   = Pathname(__FILE__).dirname.join('../files/cluster.json')
