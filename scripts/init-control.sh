#!/bin/bash -x

# Define variables
CONTROL_NODE_IP=$1
TARGET_IPs=(${2//,/ })
GITSOURCE=$3

# Update and install required packages
apt-get update -y
apt-get install -y ansible=2.9.6 sshpass git

# Add control node and target nodes to /etc/hosts and Ansible inventory
# mkdir -p /etc/ansible/hosts
echo "$CONTROL_NODE_IP controlnode" >> /etc/hosts
echo "[targets]" >> /etc/ansible/hosts
iteration=1
for ip in ${TARGET_IPs[@]}; do
  echo "$ip ansible_ssh_private_key_file=.ssh/node0$iteration/id_rsa" | sudo tee -a /etc/ansible/hosts
  iteration=($iteration+1)
done

git clone $GITSOURCE

#Copy the public key to targets
# index=1
# for ip in ${TARGET_IPs[@]}; do
#   echo "working on adding $ip to control node configs"
#   #execute the copy-keys.sh script from the source
#   bash ./vagrant-ansible/scripts/copy-key.sh $index $ip
#   index=$((index+1))
# done
