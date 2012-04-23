include_recipe "build-essential"
include_recipe "git"
include_recipe "mongodb::10gen_repo"

#mongo config
node.default[:mongodb][:logpath] = "/home/vagrant/logs/mongodb"


#create log file
directory "/home/vagrant/logs/" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
end

#create nginx log file
directory "/home/vagrant/logs/nginx" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
end

include_recipe "nginx::default"

# nginx config
node.default[:nginx][:log_dir]    = "/home/vagrant/logs/nginx"
node.default[:nginx][:user]       = "vagrant"