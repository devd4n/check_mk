#!/bin/bash

CMK_VERSION=2.2.0p24
CMK_SUBVERSION=0
CMK_TYPE=raw
CMK_OS=$(cat /etc/lsb-release | grep DISTRIB_CODENAME | cut -d "=" -f 2)
CMK_ARCH=$(dpkg --print-architecture)
CMK_DEB=$(echo check-mk-${CMK_TYPE}-${CMK_VERSION}_${CMK_SUBVERSION}.${CMK_OS}_${CMK_ARCH}.deb)

apt update
apt install apache2 openssh-server dpkg-sig -y
mkdir -p /temp/
wget https://download.checkmk.com/checkmk/Check_MK-pubkey.gpg -P /temp/
gpg --import /temp/Check_MK-pubkey.gpg

wget https://download.checkmk.com/checkmk/${CMK_VERSION}/${CMK_DEB} -P /temp/
dpkg-sig --verify /temp/${CMK_DEB} || gpg --verify /temp/${CMK_DEB} || echo "Error to check CMK package signature"

apt install /tmp/${CMK_DEB} -y

a2enmod headers
a2enmod ssl
systemctl restart apache2

