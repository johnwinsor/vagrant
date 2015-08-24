#!/usr/bin/env bash

### update & install base packages
sudo yum update
sudo yum -y install httpd
#sudo yum -y install php php-devel php-intl php-ldap php-mysql php-xsl php-gd php-mbstring php-mcrypt
sudo yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel
sudo yum -y install git
sudo yum -y install zsh
sudo yum -y install mysql-devel
sudo yum -y install mysql-server
sudo service mysqld start

### ScholarSphere Dependencies
sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-6.rpm
sudo yum -y --enablerepo=remi,remi-test install redis
sudo yum -y install libmagick-dev libmagickwand-dev clamav clamd clamav-devel ghostscript

sudo yum -y install curl

### Install Rails
gem update
gem update --system
gem install rails

### Install Node
#curl --silent --location https://rpm.nodesource.com/setup | bash -
#sudo yum -y install nodejs

### Set Up ZSH
if [ ! -d ~vagrant/.oh-my-zsh  ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~vagrant/.oh-my-zsh
fi

### Create a new zsh configuration from the provided template
cp ~vagrant/.oh-my-zsh/templates/zshrc.zsh-template ~vagrant/.zshrc

### Change ownership of .zshrc
chown vagrant: ~vagrant/.zshrc

### Customize theme
sed -i -e 's/ZSH_THEME=".*"/ZSH_THEME="agnoster"/' ~vagrant/.zshrc

### Set zsh as default shell
chsh -s /bin/zsh vagrant

### Set servername in httpd.conf to localhost
sed -i -e 's/#ServerName www\.example\.com:80/ServerName localhost/' /etc/httpd/conf/httpd.conf

### Disable apache SendFile (causing crazy caching in VirtualBox shared directories)
sed -i -e 's/#EnableSendFile off/EnableSendFile off/' /etc/httpd/conf/httpd.conf

### Fix binding in Hosts
sed -i -e 's/127\.0\.0\.1/0\.0\.0\.0/' /etc/hosts

### point /var/www at /vagrant mount
if ! [ -L /var/www  ]; then
    rm -rf /var/www
    ln -fs /webstuff /var/www
fi

### restart apache
/etc/init.d/httpd start

### Install java
wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm" -O jdk-8u45-linux-x64.rpm

rpm -ivh --quiet jdk-8u45-linux-x64.rpm
rm jdk-8u45-linux-x64.rpm

