#!/bin/bash

REPO="https://github.com/ConradMearns/transcribe-service"
NAME="transcriber"

sudo useradd -d /home/$NAME $NAME
sudo mkdir /home/$NAME
sudo chown $NAME:$NAME /home/$NAME

git clone $REPO /home/$NAME/

sudo -i -u $NAME ./install.sh

# install service
sudo cp /home/$NAME/$NAME.service /lib/systemd/system/
sudo chmod 644 /lib/systemd/system/$NAME.service

sudo systemctl daemon-reload
sudo systemctl enable $NAME.service

# get creds

sudo chown -R $NAME:$NAME /home/$NAME
