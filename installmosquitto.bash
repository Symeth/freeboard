#!/usr/bin/env bash

set -e

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi

sudo apt-get update
sudo apt install \
build-essential \
python \
quilt \
python-setuptools \
libssl-dev \
cmake \
libc-ares-dev \
uuid-dev \
daemon \
libwebsockets-dev

cd $HOME/Downloads
wget http://mosquitto.org/files/source/mosquitto-1.4.10.tar.gz
tar zxvf mosquitto-1.4.10.tar.gz
cd mosquitto-1.4.10
sudo sed -i 's/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/' config.mk
make
sudo make install
sudo cp mosquitto.conf /etc/mosquitto

sudo echo "port 1883" >>  /etc/mosquitto/mosquitto.conf 
sudo echo "listener 9001" >>  /etc/mosquitto/mosquitto.conf 
sudo echo "protocol websockets" >>  /etc/mosquitto/mosquitto.conf 

sudo adduser mosquitto
sudo ln -s /usr/local/sbin/mosquitto /usr/sbin/

echo "Installation done. Reboot your computer now."