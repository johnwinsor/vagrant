#!/usr/bin/env bash

### update & install base packages
sudo yum update
sudo yum -y install httpd
sudo yum -y install php php-devel php-intl php-ldap php-mysql php-xsl php-gd php-mbstring php-mcrypt
sudo yum -y install git
sudo yum -y install zsh
sudo yum -y install mysql-server
sudo service mysqld start

sudo yum -y install patch libyaml-devel libffi-devel glibc-headers autoconf gcc-c++ glibc-devel readline-devel zlib-devel openssl-devel bzip2 automake libtool bison

### Install RVM and Ruby 1.9.3
#sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
#sudo yum -y install curl
#curl -quiet -L get.rvm.io | sudo bash -s stable
#source /etc/profile.d/rvm.sh
#rvm requirements
#rvm install 1.9.3
#rvm use 1.9.3 --default
#rvm rubygems current

### Install Rails
#gem update
#gem update --system
#gem install rails

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

### Fix binding in Hosts
sed -i -e 's/127\.0\.0\.1/0\.0\.0\.0/' /etc/hosts

### point /var/www at /vagrant mount
if ! [ -L /var/www  ]; then
    rm -rf /var/www
    ln -fs /vagrant /var/www
fi

### restart apache
/etc/init.d/httpd start

### Install java
#cd /opt
#sudo wget --quiet --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz" -O jdk-8u25-linux-x64.tar.gz
#sudo tar xvf jdk-8u25-linux-x64.tar.gz
#sudo chown -R root: jdk1.8.0_25

#sudo alternatives --install /usr/bin/java java /opt/jdk1.8.0_25/bin/java 1
#sudo alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_25/bin/javac 1
#sudo alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_25/bin/jar 1

#sudo rm /opt/jdk-8u25-linux-x64.tar.gz
