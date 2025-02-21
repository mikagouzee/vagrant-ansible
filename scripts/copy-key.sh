#!/bin/bash -x
index=$1
ip=$2

ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/{$ip}/id_rsa -N ""
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/{$ip}/id_rsa
chmod 644 /home/vagrant/.ssh/{$ip}/id_rsa.pub
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "$ip node0$index" | sudo tee -a /etc/hosts
ssh-keyscan $ip | tee -a /home/vagrant/.ssh/known_hosts
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/{$ip}/id_rsa vagrant@$ip
