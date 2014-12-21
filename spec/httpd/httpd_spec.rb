require 'spec_helper'

describe "Apacheのインストール" do

  describe "Apacheをインストールしている" do
    describe package("httpd") do
      it { should be_installed }
    end 
  end

  describe "PHPのインストール" do
    describe "PHPをインストールしている" do
      describe package("php") do
        it { should be_installed }
      end 
    end

    describe "PHPの関連モジュールをインストールしている" do
      describe package("php-gd") do
        it { should be_installed }
      end 
      describe package("php-mbstring") do
        it { should be_installed }
      end 
      describe package("php-xml") do
        it { should be_installed }
      end 
      describe package("php-pdo") do
        it { should be_installed }
      end 
      describe package("php-mysql") do
        it { should be_installed }
      end 
    end

    describe "php.iniの設定を変更している" do
      describe php_config("date.timezone") do
        its(:value) { should eq "Asia/Tokyo" }
      end 

      describe php_config("mbstring.internal_encoding") do
        its(:value) { should eq "UTF-8" }
      end 
    end
  end

  describe "Apacheを自動起動するようにしている" do
    describe service("httpd") do
      it { should be_enabled }
    end
  end

  describe "Apacheが起動している" do
    describe service("httpd") do
      it { should be_running }
    end
  end

  describe "Apacheが接続を待ち受けている" do
    describe port(80) do
      it { should be_listening }
    end
  end

  describe "ルートディレクトリを取得した際にHTTP 200が返される" do
    describe command('curl http://localhost/') do
      its(:exit_status) { should eq 0 }
    end
  end
end
