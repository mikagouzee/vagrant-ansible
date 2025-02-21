#!/bin/bash -x
index=$1
ip=$2

mkdir -p /home/vagrant/.ssh/node0$index
ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/node0$index/id_rsa -N ""
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/node0$index/id_rsa
chmod 644 /home/vagrant/.ssh/node0$index/id_rsa.pub
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "$ip node0$index" | sudo tee -a /etc/hosts
ssh-keyscan $ip | tee -a /home/vagrant/.ssh/known_hosts
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/node0$index/id_rsa vagrant@$ip
chmod 644 /home/vagrant/.ssh/known_hosts
chown vagrant:vagrant /home/vagrant/.ssh/known_hosts

touch .ssh/config
echo "Host target" >> .ssh/config
echo "HostName $ip" >> .ssh/config
echo "User vagrant" >> .ssh/config
echo "IdentityFile .ssh/node0$index/id_rsa" >> .ssh/config