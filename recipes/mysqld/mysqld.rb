MYSQL_PASSWORD="hoge"

execute "install_mysql_repo" do
  command "yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm"
end

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

execute "mysql_set_password" do
  command "mysql -u root -e \"SET PASSWORD=PASSWORD('#{MYSQL_PASSWORD}');\""
end

execute "mysql_delete_anonymous_user" do
  command "mysql -uroot -p#{MYSQL_PASSWORD} -e \"DELETE FROM mysql.user WHERE User='';\""
end

execute "mysql_disable_root_remotelogin" do
  command "mysql -uroot -p#{MYSQL_PASSWORD} -e \"DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');\""
end

execute "mysql_drop_testdb" do
  command "mysql -uroot -p#{MYSQL_PASSWORD} -e \"DROP DATABASE test;\"; echo"
end

execute "mysql_delete_testuser" do
  command "mysql -uroot -p#{MYSQL_PASSWORD} -e \"DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'\""
end

execute "mysql_secure_installation" do
  command "mysql -uroot -p#{MYSQL_PASSWORD} -e \"FLUSH PRIVILEGES;\""
end
