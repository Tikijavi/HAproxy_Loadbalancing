#!/bin/bash
sudo apt update -y
sudo apt install git -y
sudo apt install ansible -y
sudo mkdir -p /etc/ansible/roles/haproxy/files/
sudo mkdir -p /etc/ansible/roles/haproxy/tasks/
sudo mkdir -p /etc/ansible/roles/apache/tasks/
sudo mkdir -p /etc/ansible/roles/apache/files/
sudo mkdir -p /etc/ansible/roles/server1/files/
sudo mkdir -p /etc/ansible/roles/server2/files/
sudo mkdir -p /etc/ansible/roles/server1/tasks/
sudo mkdir -p /etc/ansible/roles/server2/tasks/
git clone https://github.com/Tikijavi/HAproxy_Loadbalancing.git
sudo rm /etc/ansible/hosts
cd HAproxy_Loadbalancing
sudo mv apache.yml /etc/ansible/roles/apache/tasks/main.yml
sudo mv haproxy.yml /etc/ansible/roles/haproxy/tasks/main.yml
sudo mv server1.html /etc/ansible/roles/server1/files/index.html
sudo mv server2.html /etc/ansible/roles/server2/files/index.html
sudo mv server1.yml /etc/ansible/roles/server1/tasks/main.yml
sudo mv server2.yml /etc/ansible/roles/server2/tasks/main.yml
mv loadbalancer.yml /home/ubuntu/loadbalancer.yml

cat << EOF |sudo tee -a /etc/ansible/hosts

[loadbalancer]
${ipsrv0} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/mykey

[webservers]
${ipsrv1} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/mykey
${ipsrv2} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/mykey

[servidor1]
${ipsrv1} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/mykey

[servidor2]
${ipsrv2} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/mykey

EOF

cat << EFO |sudo tee -a /etc/ansible/roles/haproxy/files/haproxy.cfg

global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http

frontend http_front
        bind *:80
        stats uri /haproxy?stats
        default_backend http_back

backend http_back
        balance roundrobin
        server server1 ${ipsrv1}:80 check
        server server2 ${ipsrv2}:80 check
EFO
echo "I am ready, you?"
