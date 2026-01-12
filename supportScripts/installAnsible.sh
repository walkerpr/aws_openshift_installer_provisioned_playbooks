#!/bin/bash

## Run this script if Ansible and all of its dependencies are not already installed on the system

sudo su ec2-user

sudo dnf install wget -y
sudo dnf install python3.12 -y
sudo dnf install tmux -y
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3.12 /usr/bin/python

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

~/.local/bin/pip install pipx
~/.local/bin/pipx install --include-deps ansible
~/.local/bin/pipx ensurepath

reboot