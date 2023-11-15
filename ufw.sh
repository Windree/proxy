#!/bin/sh
ufw allow from 10.0.0.0/8 to any port 9050
ufw allow from 172.16.0.0/12 to any port 9050
ufw allow from 192.168.0.0/16 to any port 9050
ufw allow from fe80::/64 to any port 9050
ufw allow 11080/tcp
ufw allow 11081/tcp
ufw reload
