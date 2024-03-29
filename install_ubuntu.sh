#!/bin/bash

CMK_VERSION=2.2.0p24
CMK_SUBVERSION=0
CMK_TYPE=raw
CMK_OS=$(cat /etc/lsb-release | grep DISTRIB_CODENAME | cut -d "=" -f 2)
CMK_ARCH=$(dpkg --print-architecture)
CMK_DEB=$(check-mk-${CMK_TYPE}-${CMK_VERSION}_${CMK_SUBVERSION}.${CMK_OS}_${CMK_ARCH}.deb)

apt update
apt install openssh-server dpkg-sig -y
mkdir -p /temp/
wget https://download.checkmk.com/checkmk/Check_MK-pubkey.gpg -P /temp/
gpg --import /temp/Check_MK-pubkey.gpg

wget https://download.checkmk.com/checkmk/${CMK_VERSION}/${CMK_DEB}
dpkg-sig --verify /temp/check-mk-raw-2.2.0p1_0.jammy_amd64.deb || gpg --verify /temp/check-mk-raw-2.2.0p1_0.jammy_amd64.deb || echo "Error to check CMK package signature"
