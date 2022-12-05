![image](https://github.com/akhoma/mage2kishbox/blob/master/mage2kishbox/magento_dev_env_logo.png?raw=true)

# Magento 2 (and 1) Development Environment for Windows/Linux based on Vagrant and Docker
- nginx
- php: 5.6, 7.1, 7.2
- mysql: 5.6, 5.7
- elasticsearch: 6.8.1
- varnish
- rabbitmq
- mailhog

#### Required soft to install
1. Vagrant 2.0.1
https://releases.hashicorp.com/vagrant/2.0.1/
https://cestmonvoyage.wordpress.com/2015/12/22/installing-vagrant-virtualbox/
2. Virtual Box 5.2.6
https://www.virtualbox.org/wiki/Download_Old_Builds_5_2

(ALSO IT SHOULD WORK WITH LATEST VERSIONS)

## Start 
1. Open console gitbash in current folder
2. vagrant up
3. ssh vagrant@127.0.0.1 -p 2222 (pwd:vagrant)
4. cd /vagrant/mage2kishbox/ && docker-compose up -d
5. docker ps -a
6. Edit windows hosts files:
C:\Windows\System32\drivers\etc\hosts
add new line: 192.168.33.11	magento2ce.loc  magento1ce.loc

7. Open in browser: https://magento2ce.loc/ https://magento1ce.loc

Note: https (port 443) will be used, because varnish is used on http (port 80)


#### Vagrant VM switch

Turn off: vagrant halt

Turn sleep: vagrant suspend

Turn on: vagrant up

## Additional tools and configs:

#### XDEBUG PHP STORM config:
(use magento2ce.loc)
1. https://prnt.sc/tkrp0i
2. https://prnt.sc/tkrpb4
3. https://prnt.sc/tkrpwb
4. Open PHPSTORM -> file -> Settings -> PHP -> Debug
( Set Debug port to: 9001 )
http://joxi.ru/Vrw48wNi7kjyxm

5. Open DBGp Proxy (Set IDE key to: PHPSTORM)
http://joxi.ru/Q2KNY6GHLqyBym

6. Enable debug in PhpStorm (https://prnt.sc/tks42a)

7. Open in browser: https://magento2ce.loc/  PHPStorm should catch debug automatically

#### Enable/Disable XDebug
In Vagrant VM:
1. docker exec -u root php7.2 bash -c "phpenmod xdebug && service php7.2-fpm reload"
2. docker exec -u root php7.2 bash -c "phpdismod xdebug && service php7.2-fpm reload"


#### Install magento

##### 1. Install magento Script 
1. ssh vagrant@127.0.0.1 -p 2222
	vagrant

2. cd /vagrant/mage2kishbox/ && docker-compose up -d

3. nano magento_install.sh
update version if needed

4. bash magento_install.sh

5. Open https://magento2ce.loc/

##### 2. Install magento Manual


1. ssh vagrant@127.0.0.1 -p 2222
	vagrant

2. if needed: cd /vagrant/mage2kishbox/ && docker-compose up -d
3. cd /vagrant/www
4. sudo rm -rf ./magento2ce
5. mkdir magento2ce
6. sudo chmod -R 777 ./magento2ce
7. create db: docker exec -i mysql57 mysql -u root --password=root -e 'DROP DATABASE IF EXISTS `magento2ce`; CREATE DATABASE `magento2ce`; show databases;'
8. docker exec -u www-data -ti php7.2 bash
9. cd /var/www/magento2ce/
10. composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition:2.3.5 .
13. php bin/magento setup:install --base-url=https://magento2ce.loc/ --db-host=mysql57 --db-name=magento2ce --db-user=root --db-password=root --admin-firstname=Magento --admin-lastname=User --admin-email=user@example.com --admin-user=admin --admin-password=1qwerty --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1 --backend-frontname=admin
14. Optional install data: php bin/magento setup:perf:generate-fixtures ./setup/performance-toolkit/profiles/ce/small.xml
15. chmod -R 777 var pub app/etc generated
16. exit
17. docker exec -u root php7.2 bash -c "phpdismod xdebug && service php7.2-fpm reload"
18. Open in browser: https://magento2ce.loc/
19. Wait for varnish init some time (1 min +-). Refresh browser page
20. To enable varnish use Varnish Config topic

https://magento2ce.loc/admin/
admin
1qwerty



#### Debug CLI:
(use magento2ce.loc)
1. https://prnt.sc/tkrp0i
2. https://prnt.sc/tkrpb4
3. https://prnt.sc/tkrpwb
4. docker exec -u www-data -ti php7.2 bash
5. export XDEBUG_CONFIG="idekey=PHPSTORM"
6. export PHP_IDE_CONFIG="serverName=magento2ce.loc"
7. cd /var/www/m2ee234/pub/
8. php -dxdebug.remote_enable=1 -dxdebug.remote_mode=req -dxdebug.remote_port=9001 -dxdebug.remote_host=192.168.33.1 -dxdebug.remote_connect_back=0 ./index.php
9. php -dxdebug.remote_enable=1 -dxdebug.remote_mode=req -dxdebug.remote_port=9001 -dxdebug.remote_host=192.168.33.1 -dxdebug.remote_connect_back=0 bin/magento c:status

#### Mysql import
1. docker exec -u www-data -ti php7.2 bash
2. mysql -hmysql57 -uroot -proot hydro_emea_dev_local < hot_emea_dev2020_06_16_06_28_35.sql

#### Connect to mysql57 from windows using HeidiSQL
1. https://prnt.sc/tksay6
2. Data
host: 192.168.33.11
user: root
pwd: root

in php fpm container (php7.2, ...):
host: mysql57
user: root
pwd: root



#### Mailhog url
magento2ce.loc:1025

#### Varnish Config
https://prnt.sc/toarsj
https://prnt.sc/to7rlp
bin/magento setup:config:set --http-cache-hosts=145.23.1.5

View config and logs:

docker exec -ti varnish bash

cat /etc/varnish/default.vcl

varnishlog -g request -q 'ReqMethod eq "PURGE"'

varnishlog


To diable varnish cache set cookie in browser console
document.cookie = "varnish_cache_off=0";

Restart varnish container(clean all data):

docker container restart varnish

#### Ip addresses in vm 
(see mage2kishbox\docker-compose.yml)

nginx:
145.23.1.1

mysql56:
145.23.1.2

mysql57:
145.23.1.3

mail:
145.23.1.4

elasticsearch:
145.23.1.23
ports: 9200 9300


docker-network-magento:subnet: 145.23.0.0/16
