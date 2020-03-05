#!/bin/bash

# https://github.com/jguillod/couchdb-on-raspberry-pi

wget http://packages.erlang-solutions.com/debian/erlang_solutions.asc
sudo apt-key add erlang_solutions.asc
sudo apt-get update

sudo apt-get --no-install-recommends -y install build-essential pkg-config erlang libicu-dev libmozjs185-dev libcurl4-openssl-dev

sudo useradd -d /home/couchdb couchdb
sudo mkdir /home/couchdb
sudo chown couchdb:couchdb /home/couchdb

cd

echo "Need to update mirror code"

wget -O apache-couchdb.tar.gz http://mirrors.advancedhosters.com/apache/couchdb/source/3.0.0/apache-couchdb-3.0.0.tar.gz

tar zxvf apache-couchdb.tar.gz
cd apache-couchdb/

./configure
make release

cd ./rel/couchdb/
sudo cp -Rp * /home/couchdb
sudo chown -R couchdb:couchdb /home/couchdb

cd

rm -R apache-couchdb/
rm apache-couchdb.tar.gz
rm erlang_solutions.asc

#prep for logging
mkdir /var/log/couchdb/
sudo chown couchdb:couchdb /var/log/couchdb




echo "Configure for first time run"
echo "Please edit /home/couchdb/etc/local.ini and modify the lines"
echo "#bind_address = 127.0.0.1"
echo "Add an admin account"
echo 

read -n 1 -s -r -p "Press any key to start CouchDB"
clear
sudo -i -u couchdb /home/couchdb/bin/couchdb &
clear
echo
echo "CouchDB is running in the background"
echo

echo "Verify the installation at "
echo "http://$(hostname).local:5984/_utils/"
echo



echo "Navigate to http://$(hostname).local:5984/_utils/#/_config"
echo "Add the following under Add Option"
echo "Section: log"
echo "Name: file"
echo "Value: /var/log/couchdb/couch.log"
echo
echo "Change the writer property from stderr to file"

read -n 1 -s -r -p "Press any key to auto-set up SystemD services"

sudo cp couchdb.service /lib/systemd/system/
sudo chmod 644 /lib/systemd/system/couchdb.service

sudo systemctl daemon-reload
sudo systemctl enable couchdb.service


echo

echo "CouchDB installed, Please restart"
