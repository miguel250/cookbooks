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

python_pip "https://github.com/django-nonrel/django-nonrel/tarball/master" do
  virtualenv "/home/vagrant/python"
  action :install
end

python_pip "https://github.com/django-nonrel/djangotoolbox/tarball/master" do
  virtualenv "/home/vagrant/python"
  action :install
end

python_pip "https://github.com/django-nonrel/mongodb-engine/tarball/master" do
  virtualenv "/home/vagrant/python"
  action :install
end