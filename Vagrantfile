# -*- mode: ruby -*-
# vi: set ft=ruby :

# require necessary plugins
# for sshfs on windows, follow:
# https://docs.microsoft.com/de-de/windows-server/administration/openssh/openssh_install_firstuse
required_plugins = %w( vagrant-vbguest vagrant-sshfs )
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure("2") do |config|

  #config.trigger.before :destroy do |trigger|
  #  trigger.warn = "Cleaning all AWS Resources"
  #  trigger.run_remote = {inline: "/home/vagrant/destroy_aws.sh"}
  #end

  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = "1"
  end

  config.vm.provider "hyperv" do |hv|
      hv.memory = "1024"
      hv.cpus = "1"
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "ansible_vagrant", "/vagrant/ansible_vagrant", type: "sshfs", create: true, owner: "vagrant", group: "vagrant", mount_options: ["dmode=775,fmode=775"]
  config.vm.synced_folder "aws_provisioning/terraform", "/home/vagrant/terraform", type: "sshfs", create: true, owner: "vagrant", group: "vagrant", mount_options: ["dmode=775,fmode=775"]
  config.vm.synced_folder "aws_provisioning/ansible", "/home/vagrant/ansible", type: "sshfs", create: true, owner: "vagrant", group: "vagrant", mount_options: ["dmode=775,fmode=775"]

  # auto update guest additions
  config.vbguest.auto_update = true

  # provision the vagrant machine using ansible
  # install ansible from its default repo
  config.vm.provision "ansible_local" do |ansible|
      ansible.install = true
      ansible.install_mode = :default
      ansible.verbose = "vvvv"
      ansible.playbook = "ansible_vagrant/playbook.yml"
      ansible.galaxy_role_file = "ansible_vagrant/requirements.yml"
      ansible.config_file = "ansible_vagrant/ansible.cfg"
      ansible.extra_vars = {
        ansible_python_interpreter:"/usr/bin/python3"
      }
  end
end
