#https://stackoverflow.com/questions/43235179/how-to-execute-ssh-keygen-without-prompt
#BEWARE : the sshpass considers the default user to be vagrant with default password; because it's a vagrant box.
#


#Define your variables here. You want ONE control plane, but probably multiple targets
CONTROL_NODE_IP = "172.66.1.99"
CONTROL_NODE_IMAGE = "ubuntu/bionic64"
TARGET_IPs = ["172.16.1.51", "172.16.2.51", "172.16.3.51"]

#Vagrant use the version 2 of the configure module and will use an object named "config" to execute our tasks
Vagrant.configure("2") do |config|
    #the config object will create a VM; named "controlnode" (you can change the name to whatever) and use an object named "vm1" to execute tasks on it.
    #we will define it's network and a few specs.
    config.vm.define "controlnode" do |vm1|
        vm1.vm.box = CONTROL_NODE_IMAGE
        vm1.vm.network "private_network", ip: CONTROL_NODE_IP
        vm1.vm.provider "virtualbox" do |vb|
            vb.memory = "512"
            vb.cpus = 1
        end
        #We will provision the machine with a shell command; meaning we will execute it on the VM as soon as it's ready.
        #this command is quite simple : update then install ansible and add the DNS name "controlnode", then add the various targets to the ansible inventory
        #BEWARE! there is a line looking like a comment but it will actually be executed because in shell that symbols is not a comment.
        vm1.vm.provision "shell", inline: <<-SHELL
            apt-get update -y
            apt-get install -y ansible
            echo "#{CONTROL_NODE_IP} controlnode" >> /etc/hosts
            echo "[targets]" >> /etc/ansible/hosts
            #{TARGET_IPs.each_with_index.map { |ip, index| "echo \"#{ip}\" >> /etc/ansible/hosts" }.join("\n")}

            # Generate SSH key
            ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa -N ""

            # Create a script to copy the public key to targets
            echo '#!/bin/bash' > /home/vagrant/copy_key.sh
            echo 'for ip in #{TARGET_IPs.join(' ')}; do' >> /home/vagrant/copy_key.sh
            echo '  sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no vagrant@$ip' >> /home/vagrant/copy_key.sh
            echo 'done' >> /home/vagrant/copy_key.sh
            chmod +x /home/vagrant/copy_key.sh
        SHELL
        vm1.vm.hostname = "Controlnode"
    end
    
    #now we iterate on the array of targets, and do the same kind of operations
    TARGET_IPs.each_with_index do |ip, index|
        config.vm.define "target#{index+1}" do |target|
            target.vm.box = "ubuntu/bionic64"
            target.vm.network "private_network", ip: ip
            target.vm.provider "virtualbox" do |vb|
                vb.memory = "512"
                vb.cpus = 1
            end
            #the script will be slightly different, we will mostly install python to ensure ansible can work on those targets.
            target.vm.provision "shell", inline: <<-SHELL
                apt-get update -y
                echo "#{ip} node0#{index + 1}" >> /etc/hosts
                apt-get install -y python

                # Add the SSH public key to authorized_keys
                mkdir -p /home/vagrant/.ssh
                chown vagrant:vagrant /home/vagrant/.ssh
                chmod 700 /home/vagrant/.ssh
                
                #Lock the vagrant user to prevent easy login
                passwd -l vagrant
            SHELL
            target.vm.hostname = "Slave-#{index+1}"
        end
    end
end
