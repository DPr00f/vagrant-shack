#!/bin/sh

#
# Remove any existance of apache
#
sudo apt-get purge apache2*
sudo apt-get autoremove -y

#
# Properties so we can use add-apt-repository
#
sudo apt-get install -y software-properties-common python-software-properties

#
# Add php5.6 repo, mariadb key and repo and phalcon repo
#
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository -y 'deb http://mirrors.coreix.net/mariadb/repo/10.0/ubuntu utopic main'
sudo add-apt-repository ppa:ondrej/php5-5.6
sudo add-apt-repository ppa:phalcon/stable
sudo apt-get update -y

#
# Install nginx
#
cd /tmp/ && wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo sh -c 'echo "deb http://nginx.org/packages/mainline/ubuntu/ utopic nginx" >> /etc/apt/sources.list.d/nginx.list'
sudo sh -c 'echo "deb-src http://nginx.org/packages/mainline/ubuntu/ utopic nginx" >> /etc/apt/sources.list.d/nginx.list'
sudo apt-get install -y nginx

#
# Install MariaDB
#
echo 'mariadb-server-10.0 mysql-server/root_password password root' | sudo debconf-set-selections
echo 'mariadb-server-10.0 mysql-server/root_password_again password root' | sudo debconf-set-selections
sudo apt-get install -y mariadb-server mariadb-client

#
# Install PHP 5.6
#
sudo apt-get install -y php5-fpm php5-mysql php5-dev gcc libpcre3-dev
sudo apt-get install -y php5-mcrypt php5-curl php5-intl php5-memcached

#
# Memcached
#
sudo apt-get install -y memcached

#
# Redis
#
sudo apt-get install -y redis-server

#
# MongoDB
#
sudo apt-get install -y mongodb-clients mongodb-server

#
# Install nodejs
#
sudo apt-get install -y nodejs npm

#
# Install ruby
#
sudo apt-get install ruby-full

#
# Utilities
#
sudo apt-get install -y make curl htop git-core vim

#
# Redis Configuration
# Allow us to Remote from Vagrant with Port
#
sudo cp /etc/redis/redis.conf /etc/redis/redis.bkup.conf
sudo sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
sudo /etc/init.d/redis-server restart

#
# MySQL Configuration
# Allow us to Remote from Vagrant with Port
#
sudo cp /etc/mysql/my.cnf /etc/mysql/my.bkup.cnf
# Note: Since the MySQL bind-address has a tab cahracter I comment out the end line
sudo sed -i 's/bind-address/bind-address = 0.0.0.0#/' /etc/mysql/my.cnf

#
# Add shack:secret user with grant privileges
#
mysql -uroot -proot -Bse "CREATE USER 'shack'@'localhost' IDENTIFIED BY 'secret'; GRANT ALL PRIVILEGES ON *.* TO 'shack'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION; GRANT ALL PRIVILEGES ON *.* TO 'shack'@'::1' IDENTIFIED BY 'secret' WITH GRANT OPTION; GRANT ALL PRIVILEGES ON *.* TO 'shack'@'127.0.0.1' IDENTIFIED BY 'secret' WITH GRANT OPTION; GRANT ALL PRIVILEGES ON *.* TO 'shack'@'localhost' IDENTIFIED BY 'secret' WITH GRANT OPTION; FLUSH PRIVILEGES;"
sudo service mysql restart

#
# Composer for PHP
#
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

#
# Install phalcon
#
git clone --depth=1 git://github.com/phalcon/cphalcon.git
cd cphalcon/build
sudo ./install

echo "extension=phalcon.so" > phalcon.ini
sudo mv phalcon.ini /etc/php5/mods-available

# Configure PHP5-FPM
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' /etc/php5/fpm/php.ini
sudo sed -i 's/^user = www-data/user = vagrant/' /etc/php5/fpm/pool.d/www.conf
sudo sed -i 's/^group = www-data/group = vagrant/' /etc/php5/fpm/pool.d/www.conf
sudo service php5-fpm restart


#
# Install PhalconPHP DevTools
#
cd ~
echo '{"require": {"phalcon/devtools": "dev-master"}}' > composer.json
composer install
rm composer.json
rm composer.lock

sudo mkdir /opt/phalcon-tools
sudo mv ~/vendor/phalcon/devtools/* /opt/phalcon-tools
sudo ln -s /opt/phalcon-tools/phalcon.php /usr/bin/phalcon
sudo rm -rf ~/vendor

#
# Enable PHP5 Mods
#
sudo php5enmod phalcon curl mcrypt intl

#
# Update PHP Error Reporting
#
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php5/fpm/php.ini
sudo sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php5/fpm/php.ini
sudo sed -i 's/display_errors = Off/display_errors = On/' /etc/php5/fpm/php.ini 
# Append session save location to /tmp to prevent errors in an odd situation..
sudo sed -i '/\[Session\]/a session.save_path = "/tmp"' /etc/php5/fpm/php.ini

#
# Remove default website
#
sudo rm -f /etc/nginx/sites-available/default
sudo rm -f /etc/nginx/sites-enabled/default