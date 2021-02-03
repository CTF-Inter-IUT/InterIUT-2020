#!/bin/sh

sed -i '3s/#//' /etc/apk/repositories

apk add --no-cache open-vm-tools-plugins-all docker
rc-update add open-vm-tools
rc-update add docker
service open-vm-tools start

sed -i "/#PermitRootLogin/c\PermitRootLogin yes" /etc/ssh/sshd_config
service sshd restart
