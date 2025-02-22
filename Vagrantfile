CONTROL_NODE_IP = "172.66.10.99"

  machines = {
    "server-frontend" => "172.16.11.51",
    "server-database" => "172.16.13.59",
  }

Vagrant.configure("2") do |config|
  machines.each do |name, ip|
    config.vm.define name do |vm|
      vm.vm.box = "ubuntu/bionic64"
      vm.vm.network "private_network", ip: ip
      vm.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1

      vm.vm.provision "shell", inline: <<-SHELL
        sudo apt update
        sudo apt install -y python
	sudo sed -i '/^PasswordAuthentication/c\PasswordAuthentication yes' /etc/ssh/sshd_config
	sudo sed -i '/^#PubkeyAuthentication/c\PubkeyAuthentication yes' /etc/ssh/sshd_config
	sudo systemctl restart sshd
      SHELL
      end
    end
  end


    config.vm.define "ControlNode" do |vm1|
        vm1.vm.box = "ubuntu/bionic64"
        vm1.vm.network "private_network", ip: CONTROL_NODE_IP
        vm1.vm.provider "virtualbox" do |vb|
            vb.memory = "1024"
            vb.cpus = 1
        vm1.vm.synced_folder "./Partage", "/home/vagrant/guest_dir", type: "virtualbox"
        vm1.vm.provision "shell", inline: <<-SHELL
	  sudo apt update 
	  sudo apt install ansible -y 
	  sudo apt install python
	  sudo ssh-keygen -t rsa -b 4096 -N "" -f /root/.ssh/id_rsa
	  sudo ssh-keygen -t rsa -b 4096 -N "" -f /home/vagrant/.ssh/id_rsa
 	  sudo cp /root/.ssh/id_rsa /home/vagrant/.ssh
	  sudo cp /root/.ssh/id_rsa.pub /home/vagrant/.ssh
   	  sudo chmod 700 ~/.ssh
	  sudo chmod 600 ~/.ssh/id_rsa
	  sudo chmod 600 ~/.ssh/id_rsa.pub
	  sudo apt install sshpass
	  sudo sshpass -p "vagrant" ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no vagrant@172.16.11.51
	  sudo sshpass -p "vagrant" ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no vagrant@172.16.12.55
	  sudo sshpass -p "vagrant" ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no vagrant@172.16.13.59
	  sudo sh -c 'echo "
[server-frontend]
172.16.11.51

[server-backend]
172.16.12.55

[server-database]
172.16.13.59" >> /etc/ansible/hosts'
	   chown -R vagrant:vagrant /home/vagrant/.ssh
	   cd /home/vagrant/guest_dir
	   sudo sh -c 'echo "[all:vars]\nansible_ssh_common_args=\"-o StrictHostKeyChecking=no\"" >> /etc/ansible/hosts'
	  echo "
[defaults]
host_key_checking = False" | sudo tee -a /etc/ansible/ansible.cfg

	  ansible-playbook installNGINX.yaml
	  ansible-playbook installApacheTomcat.yaml
	  ansible-playbook installmysql.yaml
          SHELL
        end
    end
end


