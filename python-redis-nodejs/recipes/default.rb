include_recipe "apt"
include_recipe "build-essential"
include_recipe "git"
include_recipe "nodejs"
include_recipe "nodejs::npm"
include_recipe "python"
include_recipe "python::pip"
include_recipe "redisio"
include_recipe "redisio::install"
include_recipe "redisio::enable"


app_name = node['web']['app_name']
home_path = node['web']['home']
app_path = "#{home_path}/#{app_name}"


directory "#{home_path}/python" do
  owner node['web']['user']
  group node['web']['group']
  mode "0755"
  action :create
end

#create virtual virtualenv
python_virtualenv "#{home_path}/python" do
  interpreter "python2.7"
  owner node['web']['user']
  group node['web']['group']
  action :create
end

apt_repository "nginx" do
  uri "http://ppa.launchpad.net/nginx/development/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C300EE8C"
end

node.override['nginx']['sendfile'] = 'off'
node.override['nginx']['log_dir']    = "#{app_path}/logs/nginx"
node.override['nginx']['user']       = node['web']['user']
node.override['nginx']['default_site_enabled'] = false
include_recipe "nginx::default"

template "/etc/nginx/sites-available/site" do
  source "site.erb"
  owner "root"
  group "root"
  mode 00644
  variables(:app_path => "#{app_path}/assets")
  notifies :reload, 'service[nginx]'
end


node.override['supervisor']['inet_port'] = '*:9001'
include_recipe "supervisor"

environment = {'PYTHONPATH'=> app_path, 'ENVIRONMENT'=> 'development'}

execute "Install app requirements" do
    command "cd #{app_path} && make requirement"
    user node['web']['user']
end

supervisor_service "web-server" do
  command "#{app_path}/../python/bin/python #{app_path}/jukebox/server.py"
  action [:enable, :start]
  startretries 10
  redirect_stderr=true
  environment environment
  stopasgroup true
  directory app_path
  stdout_logfile "#{app_path}/logs/server.log"
  stderr_logfile "#{app_path}/logs/server.log"
  autostart true
  user node['web']['user']
end

supervisor_service "workers" do
  command "#{app_path}/../python/bin/celery worker --app=jukebox.tasks -l info"
  action [:enable, :start]
  startretries 10
  redirect_stderr=true
  environment environment
  stopasgroup true
  directory app_path
  stdout_logfile "#{app_path}/logs/celery.log"
  stderr_logfile "#{app_path}/logs/celery.log"
  autostart true
  user node['web']['user']
end

nginx_site 'site' do
  enable true
end