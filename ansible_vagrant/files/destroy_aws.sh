#!/bin/bash
# https://www.linuxjournal.com/article/2807
dialog --title "Destroy all aws resources"  --yesno "Are you sure?\nThis action will destroy all AWS resources!" 8 30

do_destroy=$?

clear

if [ $do_destroy = 0 ]
then
  ansible-playbook /vagrant/ansible_vagrant/destroy.yml -i /vagrant/inventory -e 'ansible_python_interpreter=/usr/bin/python3'
  ansible_result=$?
  if [ $ansible_result -eq 0 ]; then
    clear
    dialog --title 'AWS Resources Destroyed' --msgbox 'All AWS Resources have been destroyed.\nYou can destroy the vagrant machine now.' 10 30
    exit
  else
    echo "Ansible failed"
  fi
else
  dialog --msgbox 'No Resources have been destroyed.' 10 30
  clear
fi
