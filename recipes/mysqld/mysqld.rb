MYSQL_PASSWORD=node[ENV['TARGET_HOST']]['mysqld']['password']

execute "yum -t -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm"

%w{
  mysql-community-client
  mysql-community-devel
  mysql-community-server
}.each do |pkg_name|
  package pkg_name do
    action :install
  end 
end

service "mysqld" do
  action [ :enable, :start ]
end

execute "mysql -u root -e \"SET PASSWORD=PASSWORD('#{MYSQL_PASSWORD}');\""
execute "mysql -uroot -p#{MYSQL_PASSWORD} -e \"DELETE FROM mysql.user WHERE User='';\""
execute "mysql -uroot -p#{MYSQL_PASSWORD} -e \"DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');\""
execute "mysql -uroot -p#{MYSQL_PASSWORD} -e \"DROP DATABASE test;\"; echo"
execute "mysql -uroot -p#{MYSQL_PASSWORD} -e \"DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'\""
execute "mysql -uroot -p#{MYSQL_PASSWORD} -e \"FLUSH PRIVILEGES;\""
