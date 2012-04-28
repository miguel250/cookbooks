include_recipe "python"
include_recipe "python::pip"


#create python folder
directory "/home/vagrant/python" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
end

#create virtual virtualenv
python_virtualenv "/home/vagrant/python" do
  interpreter "python2.7"
  owner "vagrant"
  group "vagrant"
  action :create
end

python_pip "gunicorn" do
  virtualenv "/home/vagrant/python"
  version "0.14.2"
  action :install
end

python_pip "django" do
  virtualenv "/home/vagrant/python"
  version "1.4"
  action :install
end

python_pip "mongoengine" do
  virtualenv "/home/vagrant/python"
  version "0.6.6"
  action :install
end