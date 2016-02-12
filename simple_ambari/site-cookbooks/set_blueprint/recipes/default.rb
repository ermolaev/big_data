
node.set["ambari"]["blueprints"]["blueprint_json"] = JSON.parse(Pathname(__FILE__).dirname.join('blueprint.json').read)
node.set["ambari"]["blueprints"]["cluster_json"]   = JSON.parse(Pathname(__FILE__).dirname.join('cluster.json').read)
