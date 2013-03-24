maintainer       "Miguel Perez"
maintainer_email "miguel@miguelpz.com"
license          "Apache 2.0"
description      "Installs python and nginx with nodejs"
version          "0.0.1"
name             "python-redis-nodejs"
provides         "python-redis-nodejs"

recipe "python-redis-nodejs", "Installs python, nodejs and redis"

depends "build-essential"
depends "apt"
depends "nginx"


%w{ debian ubuntu centos redhat smartos }.each do |os|
    supports os
end