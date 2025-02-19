#!/bin/bash

# Define variables
IP=$1
INDEX=$2

apt-get update -y
echo "#$ip node0#$INDEX" >> /etc/hosts
apt-get install -y python

# Update sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Add the SSH public key to authorized_keys
mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Restart SSH service
sudo systemctl restart ssh


