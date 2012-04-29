include_recipe "build-essential"
include_recipe "git"
include_recipe "mongodb::10gen_repo"

#mongo config
node.default[:mongodb][:logpath] = "/home/vagrant/logs/mongodb"

#attributes
home_path = node.default[:mlpz][:home]
user      = node.default[:mlz][:user]
group     = node.default[:mlz][:group]

#create log file
directory "#{home_path}/logs/" do
  owner  user
  group  group
  mode "0755"
  action :create
end

#create nginx log file
directory "#{home_path}/logs/nginx" do
  owner user
  group group
  mode "0755"
  action :create
end

include_recipe "nginx::default"

# nginx config
node.default[:nginx][:log_dir]    = "#{home_path}/logs/nginx"
node.default[:nginx][:user]       = user