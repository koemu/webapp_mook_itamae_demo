%w{
  httpd
  php
  php-gd
  php-mbstring
  php-xml
  php-pdo
  php-mysql
}.each do |pkg_name|
  package pkg_name do
    action :install
  end 
end

template "/etc/php.ini" do
  source "php.ini.erb"
end

service "httpd" do
  action [ :enable, :start ]
end

execute "firewall-cmd --permanent --add-service=http"
execute "firewall-cmd --reload"
execute "setsebool -P httpd_can_network_connect 1"

