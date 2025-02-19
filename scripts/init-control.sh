#!/bin/bash

# Define variables
CONTROL_NODE_IP=$1
TARGET_IPs=(${2//,/ })


# Update and install required packages
apt-get update -y
apt-get install -y ansible sshpass git

# Add control node and target nodes to /etc/hosts and Ansible inventory
# mkdir -p /etc/ansible/hosts
echo "$CONTROL_NODE_IP controlnode" >> /etc/hosts
echo "[targets]" >> /etc/ansible/hosts
for ip in ${TARGET_IPs[@]}; do
  echo "$ip" | sudo tee -a /etc/ansible/hosts
done


###THIS SECTION DOES NOT WORK FOR SOME REASON. 
###EACH INDIVIDUAL OPERATION WORKS ON THE MACHINE, BUT THE RESULTING SSH CONNECTION REQUIRES TO PASS THE PASSWORD FOR SOME REASON.
# # Generate SSH key
# ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa
# sudo chmod 700 /home/vagrant/.ssh
# sudo chmod 600 /home/vagrant/.ssh/id_rsa
# sudo chmod 644 /home/vagrant/.ssh/id_rsa.pub
# sudo chown -R vagrant:vagrant /home/vagrant/.ssh

# #Copy the public key to targets
# index = 1
# for ip in ${TARGET_IPs_ARRAY[@]}; do
#   index=$((index+1))
#   echo "working on adding $ip to control node configs"
#   echo "$ip node0$index" | sudo tee -a /etc/hosts
#   sudo ssh-keyscan $ip >> /home/vagrant/.ssh/known_hosts
#   echo "$ip" | sudo tee -a /etc/ansible/hosts
#   sudo sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub vagrant@$ip
# done
# sudo chmod 644 /home/vagrant/.ssh/known_hosts
# sudo chown vagrant:vagrant /home/vagrant/.ssh/known_hosts