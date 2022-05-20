#!/bin/bash
sudo apt update -y
sudo apt install wget -y
sudo apt install ansible -y
sudo mkdir -p /etc/ansible/roles/haproxy/files/
sudo mkdir -p /etc/ansible/roles/haproxy/tasks/
sudo mkdir -p /etc/ansible/roles/apache/tasks/
sudo mkdir -p /etc/ansible/roles/apache/files/
sudo mkdir -p /etc/ansible/roles/server1/files/
sudo mkdir -p /etc/ansible/roles/server2/files/
sudo mkdir -p /etc/ansible/roles/server1/tasks/
sudo mkdir -p /etc/ansible/roles/server2/tasks/
wget https://raw.githubusercontent.com/Tikijavi/HAproxy_Loadbalancing/main/apache.yml
wget https://raw.githubusercontent.com/Tikijavi/HAproxy_Loadbalancing/main/haproxy.cfg
wget https://raw.githubusercontent.com/Tikijavi/HAproxy_Loadbalancing/main/haproxy.yml
wget https://raw.githubusercontent.com/Tikijavi/HAproxy_Loadbalancing/main/loadbalancer.yml
wget https://raw.githubusercontent.com/Tikijavi/HAproxy_Loadbalancing/main/hosts
wget https://raw.githubusercontent.com/Tikijavi/HAproxy_Loadbalancing/main/server1.html
wget https://raw.githubusercontent.com/Tikijavi/HAproxy_Loadbalancing/main/server2.html
sudo rm /etc/ansible/hosts
sudo mv hosts /etc/ansible/hosts
sudo mv apache.yml /etc/ansible/roles/apache/tasks/main.yml
sudo mv haproxy.yml /etc/ansible/roles/haproxy/tasks/main.yml
sudo mv haproxy.cfg /etc/ansible/roles/haproxy/files/haproxy.cfg
sudo mv server1.html /etc/ansible/roles/apache/files/index.html
sudo mv server2.html /etc/ansible/roles/apache/files/index.html
echo "I am ready, you?"
