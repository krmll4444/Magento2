#!/usr/bin/env bash
MAGENTO_VERSION="2.3.4"
PROJECT_DIR="magento2ee"
WEBSITE_URL="https://magento2ee.loc/"
INSTALL_SAMPLE_DATA_FIXTURES="1"
DB_NAME="magento2ee"
DB_QUERY="DROP DATABASE IF EXISTS \`${DB_NAME}\`;CREATE DATABASE \`${DB_NAME}\`;show databases;"
COMPOSER_MAGE_USERNAME="xxxxxxx"
COMPOSER_MAGE_PWD="xxxxxxx"
####################################################
echo -e "\e[91m Folder \e[39m/var/www/${PROJECT_DIR} \e[91m and database \e[39m ${DB_NAME} \e[91m will be CLEANED! \e[39m" &&
read -p "Are you sure?  y|n " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

cd /vagrant/mage2kishbox/ && 
echo -e "\e[32m Start containers \e[39m" &&
docker-compose up -d && 
sleep 20 &&
echo -e "\e[32m Setup directory \e[39m ${PROJECT_DIR}" &&
cd /vagrant/www/ &&
sudo rm -rf ./${PROJECT_DIR} &&
mkdir ./${PROJECT_DIR} &&
chmod -R 777 ./${PROJECT_DIR} &&
echo -e "\e[32m Create Database \e[39m" &&
docker exec -i mysql57 mysql -u root --password=root -e "${DB_QUERY}" && \
echo -e "\e[32m Install Magento \e[39m" &&
docker exec -u www-data php7.2 bash -c \
"cd /var/www/${PROJECT_DIR}/ && \
composer config -a -g http-basic.repo.magento.com ${COMPOSER_MAGE_USERNAME} ${COMPOSER_MAGE_PWD} && \
composer create-project --repository-url=https://repo.magento.com/ magento/project-enterprise-edition:${MAGENTO_VERSION} .
" && \
sleep 5 && \
docker exec -u www-data php7.2 bash -c \
"cd /var/www/${PROJECT_DIR}/ && \
php bin/magento setup:install --base-url=${WEBSITE_URL} --db-host=mysql57 --db-name=${DB_NAME} --db-user=root --db-password=root --admin-firstname=Magento --admin-lastname=User --admin-email=user@example.com --admin-user=admin --admin-password=1qwerty --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1 --backend-frontname=admin
" && \
echo -e "\e[32m Finished! \e[39m"
echo -e "\e[32m Install sample data fixtures \e[39m" && \
if [ ${INSTALL_SAMPLE_DATA_FIXTURES} == "1" ]
then
	docker exec -u www-data php7.2 bash -c \
"cd /var/www/${PROJECT_DIR}/ && \
php bin/magento setup:perf:generate-fixtures ./setup/performance-toolkit/profiles/ee/small.xml
"
fi &&
echo -e "\e[32m Finished! \e[39m"