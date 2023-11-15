# Socks proxy with authentication using TOR network to bypass ISP restrictions

## Installation

copy .env.original .env

copy users.env.original users.env

copy tor.env.original tor.env

## Configuration

### Docker and IPv6
IPv6 dramatically increased a chance to connect tor network blocked by ISP.
Please add following code to your /etc/docker/daemon.json 
```JSON
{
  "ipv6": true,
  "fixed-cidr-v6": "fd00::/64",
  "experimental": true,
  "ip6tables": true
}
```
Then restart docker service:
```bash
sudo systemctl restart docker.
```

### Users
Change login:password and remove unused users in users.env

### Exit nodes for TOR
Change exit nodes in tor.env. You can use many country codes for exit nodes but some web sites can block you for changing location rapidly.

### Socks server ports
Edit ports to connect socks (with authentication), tor (directly without authentication), or ping service in .env

Optionally apply firewall rules from ./ufw.sh (UFW firewall). The script allow connect tor socks server on port EXTERNAL_TOR_PORT from local networks without authentication and rest clients to port EXTERNAL_SOCKS_PORT with authentication only.


## Connecting

You can connect tor socks server directly without authentication on port EXTERNAL_TOR_PORT

Also socks server can be connected on port EXTERNAL_SOCKS_PORT using credentials from .user.env

Use port open check on port EXTERNAL_PING_PORT to monitor tor connectivity status. I usually use it with [uptime robot](https://uptimerobot.com/) service to know if there are any problem with accessing the internet via tor network. If the port is open then tor network works fine.

## Update
To update pull new version from git and run ./update.sh
