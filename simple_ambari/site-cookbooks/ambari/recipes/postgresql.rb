# https://github.com/hw-cookbooks/postgresql#chef-solo-note
node.override['postgresql'] = {
  version: "9.4",
  enable_pgdg_yum: true,
  password: { postgres: "md5d7d880f96044b72d0bba108ace96d1e4" }, # testpass
  client: {
    packages: ["postgresql94", "postgresql94-devel"]
  },
  server: {
    packages: ["postgresql94-server"],
    service_name: "postgresql-9.4"
  },
  contrib: {
    packages: "postgresql94-contrib"
  },
  setup_script: "postgresql94-setup",
  config: {
    listen_addresses: "*"
  },
  pg_hba: [
    { type: 'local', db: 'all', user: 'postgres', addr: nil,             method: 'ident' },
    { type: 'local', db: 'all', user: 'all',      addr: nil,             method: 'ident' },
    { type: 'host',  db: 'all', user: 'all',      addr: '127.0.0.1/32',  method: 'md5' },
    { type: 'host',  db: 'all', user: 'all',      addr: '::1/128',       method: 'md5' },
    { type: 'host',  db: 'all', user: 'all',      addr: '10.20.30.0/24', method: 'md5' }
  ]
}

include_recipe 'postgresql::server'
include_recipe 'database::postgresql'

postgresql_connection_info = {host: '127.0.0.1', password: 'testpass' }

# -----------------------------------------------

postgresql_database_user 'hive' do
  connection postgresql_connection_info
  password   'testpass'
  action     :create
end

postgresql_database 'hive' do
  connection postgresql_connection_info
  owner      'hive'
  action     :create
end

# -----------------------------------------------

postgresql_database_user 'oozie' do
  connection postgresql_connection_info
  password   'testpass'
  action     :create
end

postgresql_database 'oozie' do
  connection postgresql_connection_info
  owner      'oozie'
  action     :create
end

# -----------------------------------------------
postgresql_database_user 'ranger' do
  connection postgresql_connection_info
  password   'testpass'
  action     :create
end

postgresql_database 'ranger' do
  connection postgresql_connection_info
  owner      'ranger'
  action     :create
end
