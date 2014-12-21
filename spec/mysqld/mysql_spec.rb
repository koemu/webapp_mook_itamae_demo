require 'spec_helper'

describe "MySQLのインストール" do

  describe "MySQLをインストールしている" do
    describe package("mysql-community-server") do
      it { should be_installed }
    end 
    describe package("mysql-community-client") do
      it { should be_installed }
    end 
    describe package("mysql-community-libs") do
      it { should be_installed }
    end 
    describe package("mysql-community-common") do
      it { should be_installed }
    end 
  end

  describe "MySQLを自動起動するようにしている" do
    describe service("mysqld") do
      it { should be_enabled }
    end
  end

  describe "MySQLが起動している" do
    describe service("mysqld") do
      it { should be_running }
    end
  end

  describe "MySQLが接続を待ち受けている" do
    describe port(3306) do
      it { should be_listening }
    end
  end

  describe "MySQLにrootユーザでログインできる" do
    describe command('mysql -uroot -pCHANGE_ME~ -e "SELECT user FROM mysql.user"') do
      its(:exit_status) { should eq 0 }
    end
  end
end
