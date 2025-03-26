This repo is a basic demo how what can be done with vagrant and ansible.

The entrypoint is the Vagrantfile. 

In this vagrant file, we define a few things:
ControlNodeIp, the main machine's access. 
ControlNodeImage : I picked one with the latest ubuntu version, but feel free to use whatever you want.

TargetImages: there too I used the latest ubuntu version, again, it depends on your usecase.
TargetIps: I've decided for a very simple array of ip; but it could be improved by creating key-pairs of ip/images so that each node has its own images if needed.

The first section is quite commented and will generate the nodes and run a script called "init-slaves" on them. 
That script will simply install python and change the SSH config to allow the control machine to connect via its own keys.

The second section is less commented, but it's very similar : it's a windows box to host selenium. That is still a wip, but the generation of the image and box are working.

The third section contains the "controlnode" definition. It works exactly like the nodes, except the init script we run is a bit meatier : we install ansible, sshpass and git.
We will also init the host inventory for ansible with the node's IPs and prep that each machine has it's own ssh key available.