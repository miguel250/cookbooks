include_recipe "apt"
include_recipe "build-essential"
include_recipe "git"
include_recipe "mysql::client"

node['apache']['user']    = "vagrant"
node['apache']['group']   = "vagrant"
include_recipe "apache2"

package "apache2-prefork-dev" do
    action :install
end

node['php']['version'] = '5.3.7' 
node['php']['directives'] = {
    'display_errors' => 'On',
    'date.timezone' => 'America/New_York'}
node['php']['install_method'] = 'source'
node['php']['configure_options'] =  %W{--prefix=#{node['php']['prefix_dir']}
                                          --with-libdir=lib
                                          --with-config-file-path=#{node['php']['conf_dir']}
                                          --with-config-file-scan-dir=#{node['php']['ext_conf_dir']}
                                          --with-pear
                                          --with-fpm-user=#{node['php']['fpm_user']}
                                          --with-fpm-group=#{node['php']['fpm_group']}
                                          --with-zlib
                                          --with-openssl
                                          --with-kerberos
                                          --with-bz2
                                          --with-curl
                                          --enable-ftp
                                          --enable-zip
                                          --enable-exif
                                          --with-gd
                                          --enable-gd-native-ttf
                                          --with-gettext
                                          --with-gmp
                                          --with-mhash
                                          --with-iconv
                                          --with-imap
                                          --with-imap-ssl
                                          --enable-maintainer-zts 
                                          --enable-sockets
                                          --with-apxs2=/usr/bin/apxs2
                                          --with-readline
                                          --enable-soap
                                          --with-xmlrpc
                                          --with-libevent-dir
                                          --with-mcrypt
                                          --enable-mbstring
                                          --with-t1lib
                                          --with-mysql
                                          --with-mysqli=/usr/bin/mysql_config
                                          --with-mysql-sock
                                          --with-sqlite3
                                          --with-pdo-mysql
                                          --with-pdo-sqlite}


directory "/usr/kerberos/" do
  owner "root"
  group "root"
  mode 00755
  action :create
  recursive true
end

execute "add link to kerberos" do
  command "ln -s /usr/lib/x86_64-linux-gnu/ /usr/kerberos/lib"
  not_if { ::File.exists?('/usr/kerberos/lib') }
  action :run
end

execute "add link to libpng" do
  command "ln -s  /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so"
  not_if { ::File.exists?('/usr/lib/libpng.so') }
  action :run
end

execute "add link to libjpeg" do
  command "ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/libjpeg.so"
  not_if { ::File.exists?('/usr/lib/libjpeg.so') }
  action :run
end

execute "add link to libjpeg" do
  command "ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so"
  not_if { ::File.exists?('/usr/lib/libmysqlclient.so') }
  action :run
end

execute "add link to libmysqlclient_r" do
  command "ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient_r.so /usr/lib/libmysqlclient_r.so"
  not_if { ::File.exists?('/usr/lib/libmysqlclient_r.so') }
  action :run
end

include_recipe "php"

file "#{node['apache']['dir']}/conf.d/php.conf" do
  action :delete
  backup false
end

package "apache2-mpm-worker" do
    action :install
end

package "apache2-mpm-prefork" do
    action :remove
end

directory "/var/www/log" do
  owner "vagrant"
  group "vagrant"
  mode 00755
  action :create
  recursive true
end

directory "/var/www/consumer_site" do
  owner "vagrant"
  group "vagrant"
  mode 00755
  action :create
  recursive true
end

web_app "consumer" do
  server_name  node['lamp']['host_name']
  server_aliases [node['lamp']['host_name']]
  docroot node['lamp']['root_directory']
  allow_override "All"
end