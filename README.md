# Socks proxy with authentication using TOR network to bypass ISP restrictions

## Installation

copy .env.original .env

copy users.env.original users.env

copy tor.env.original tor.env

Change login:password and remove unused users in users.env

Change exit nodes in tor.env

Edit port to connect socks (with authentication), tor (directly without authentication), or ping service in .env

Optionally apply firewall rules from ./ufw.sh (UFW firewall)

## Connecting

You can connect tor directly bypassing any auth on port 9050 from local network

Also you can open socks server to the internet and connect it on port 11080 using credentials from .user.env

Use port open check on port 11081 to monitor tor connectivity status. I usually use it with [uptime robot](https://uptimerobot.com/) service to know if there are any problem with accessing the internet via tor network. If the port is open then tor network works fine.

## Update
To update pull new version from git and run ./update.sh