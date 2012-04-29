include_recipe "python"
include_recipe "python::pip"

#attributes
home_path = node.default[:mlpz][:home]
user      = node.default[:mlz][:user]
group     = node.default[:mlz][:group]
environment = node.default[:mlz][:env]

#create python folder
directory "#{home_path}/python" do
  owner user
  group group
  mode "0755"
  action :create
end

#create virtual virtualenv
python_virtualenv "#{home_path}/python" do
  interpreter "python2.7"
  owner user
  group group
  action :create
end

#Auto reload for gunicorn
if environment == "development"
  package "libevent-dev"
  python_pip "gevent" do
    virtualenv "#{home_path}/python"
    action :install
  end
end

python_pip "gunicorn" do
  virtualenv "#{home_path}/python"
  version "0.14.2"
  action :install
end

python_pip "django" do
  virtualenv "#{home_path}/python"
  version "1.4"
  action :install
end

python_pip "mongoengine" do
  virtualenv "#{home_path}/python"
  version "0.6.6"
  action :install
end