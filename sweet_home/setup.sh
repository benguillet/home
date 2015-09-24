#!/bin/sh

# Fail fast.
set -e

HOSTNAME='sweet-home'

echo $HOSTNAME > /tmp/hostname
sudo cp /tmp/hostname /etc/hostname
sudo hostname $HOSTNAME

[ ! -h /home/vagrant/Projects ] && ln -s /vagrant /home/vagrant/Projects
sudo apt-get update
sudo apt-get -y install wget gnupg git silversearcher-ag lua5.2 vim-nox mercurial unzip autojump
if ! pip --help > /dev/null
then
    curl https://bootstrap.pypa.io/get-pip.py | sudo python
fi
sudo pip install httpie
sudo pip install virtualenv

if ! which docker
then
    sudo apt-get -y install docker.io
    sudo service docker.io stop
    wget https://get.docker.com/builds/Linux/x86_64/docker-latest -O /tmp/docker
    sudo cp /tmp/docker /usr/bin
    sudo service docker.io start
    sudo usermod -a -G docker $USER
fi

CONSULZIP=0.4.1_linux_amd64.zip
if ! which consul
then
    wget https://dl.bintray.com/mitchellh/consul/${CONSULZIP} && sudo unzip -d /usr/local/bin ${CONSULZIP}
fi

rm $CONSULZIP

GOTAR=go1.3.3.linux-amd64.tar.gz

if [ ! -d /usr/local/go ]
then
    wget --quiet https://storage.googleapis.com/golang/$GOTAR && sudo tar -C /usr/local -xzf $GOTAR
fi

rm $GOTAR
