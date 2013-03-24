include_recipe "apt"
include_recipe "build-essential"
include_recipe "git"

app_name = node['web']['app_name']
home_path = node['web']['home']
app_path = "#{home_path}/#{app_name}"


directory "/var/www" do
  owner "vagrant"
  group "vagrant"
  mode 00755
  action :create
  recursive true
end

apt_repository "nginx" do
  uri "http://ppa.launchpad.net/nginx/development/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C300EE8C"
end

node['nginx']['log_dir']    = "#{app_path}/app/logs/nginx"
node['nginx']['user']       = node['web']['user']
node['nginx']['default_site_enabled'] = false
include_recipe "nginx::default"



template "/etc/nginx/sites-available/site" do
  source "site.erb"
  owner "root"
  group "root"
  mode 00644
  variables(:app_path => "#{app_path}/public")
  notifies :reload, 'service[nginx]'
end

nginx_site 'site' do
  enable true
end