#!/bin/bash -x
#BEWARE! this script will be run on /tmp/vagrant-shell by default, so you need to specify paths

TARGET_IPs=$1
# Install Ansible on the control node
apt update -y
apt install -y ansible

# Ensure the directory exists
if [ ! -d /etc/ansible ]; then
    mkdir -p /etc/ansible
fi

# Ensure the file exists
if [ ! -f /etc/ansible/hosts ]; then
    touch /etc/ansible/hosts
fi

cat <<EOL >> /etc/ansible/hosts
[local]
localhost ansible_connection=local

[nodes]
EOL

index=1
for ip in ${TARGET_IPs[@]}; do
echo $"node0$(index+1) $ip" >> /etc/ansible/hosts
index=$((index+1))
done