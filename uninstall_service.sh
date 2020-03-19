#!/bin/bash

NAME="transcriber"

sudo systemctl disable $NAME.service

sudo rm /lib/systemd/system/$NAME.service

sudo systemctl daemon-reload

sudo rm -rf /home/$NAME
sudo deluser $NAME