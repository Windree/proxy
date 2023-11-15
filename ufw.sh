#!/bin/sh
ufw allow from 10.22.0.0/24 to any port 9050
ufw allow from fe80::/64 to any port 9050
ufw allow 1080/tcp
ufw allow 1081/tcp
ufw reload
