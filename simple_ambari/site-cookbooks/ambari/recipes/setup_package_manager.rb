remote_file '/etc/yum.repos.d/ambari.repo' do
  source 'http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0/ambari.repo'
  not_if { ::File.exist?('/etc/yum.repos.d/ambari.repo') }
end
