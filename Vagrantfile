#https://stackoverflow.com/questions/43235179/how-to-execute-ssh-keygen-without-prompt
#BEWARE : the sshpass considers the default user to be vagrant with default password; because it's a vagrant box.
#
#Define your variables here. You want ONE control plane, but probably multiple targets
CONTROL_NODE_IP = "172.66.1.99"
CONTROL_NODE_IMAGE = "gusztavvargadr/ubuntu-server-2404-lts"
WINDOWS_BOX = "gusztavvargadr/windows-10"

TARGET_IMAGES =  "gusztavvargadr/ubuntu-server-2404-lts"
TARGET_IPs = ["172.16.1.51", "172.16.2.51", "172.16.3.51"]
# TARGET_IPs = ["172.16.1.51"]
     

#Vagrant use the version 2 of the configure module and will use an object named "config" to execute our tasks
Vagrant.configure("2") do |config|
    #now we iterate on the array of targets, and use an object named "winbox" to execute tasks on it.
    #we will define it's network and a few specs.
    TARGET_IPs.each_with_index do |ip, index|
        config.vm.define "target#{index+1}" do |target|
            target.vm.box = TARGET_IMAGES
            target.vm.network "private_network", ip: ip
            target.vm.provider "virtualbox" do |vb|
                vb.memory = "2048"
                vb.cpus = 1
            end
            #the script will be slightly different, we will mostly install python to ensure ansible can work on those targets.
            target.vm.provision "shell", path: './scripts/init-nodes.sh', args:[ip,index]
            target.vm.hostname = "node0#{index+1}"
        end
    end

    config.vm.define "windows-node" do |winbox|
        winbox.vm.box = WINDOWS_BOX
        winbox.vm.network "private_network", ip: "172.16.10.51"
        winbox.vm.network "forwarded_port", guest: 22, host: 2222, auto_correct: true
        winbox.vm.network "forwarded_port", guest:8080, host: 8080, auto_correct: true
        winbox.vm.boot_timeout = 600
        winbox.vm.provider "virtualbox" do |vb|
            vb.memory = "2048"
            vb.cpus = 4
        end
        winbox.vm.hostname = "TestNode"
    end

    #then we create the vm, because it needs the target to exist in order to copy the keys on it.
    config.vm.define "controlnode" do |controlnode|
        controlnode.vm.box = CONTROL_NODE_IMAGE
        controlnode.vm.network "private_network", ip: CONTROL_NODE_IP
        controlnode.vm.network "forwarded_port", guest: 22, host: 2222, auto_correct: true
        controlnode.vm.network "forwarded_port", guest:8080, host: 8080, auto_correct: true
        controlnode.vm.boot_timeout = 600
        controlnode.vm.provider "virtualbox" do |vb|
            vb.memory = "2048"
            vb.cpus = 4
        end
        #We will provision the machine with a shell command; meaning we will execute it on the VM as soon as it's ready.
        #this command is quite simple : update then install ansible and add the DNS name "controlnode", then add the various targets to the ansible inventory
        #BEWARE! there is a line looking like a comment but it will actually be executed because in shell that symbols is not a comment.
        # controlnode.vm.provision "shell", path: "./scripts/init-control.sh", args: [CONTROL_NODE_IP, TARGET_IPs.join(","), "https://github.com/mikagouzee/vagrant-ansible"]
        controlnode.vm.provision "shell", path: "./scripts/init-control-ansible.sh", args: TARGET_IPs
        controlnode.vm.provision "ansible_local" do |ansible|
            ansible.playbook = "./controlplaybook.yaml"
            ansible.inventory_path = "/etc/ansible/hosts"
            ansible.limit = "localhost"
            ansible.extra_vars = {
                control_node_ip: CONTROL_NODE_IP,
                target_ips: TARGET_IPs
            }
        end
        controlnode.vm.hostname = "controlnode"
    end
end
