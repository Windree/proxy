# proxy
Tor based proxy with authentification and dynamic brigde connection to the tor network to avoid block by ISP plus watchdog to reset tor on connection lost

copy users.env.original users.env
copy tor.env.original tor.env

edit users in users.env
edit exit nodes in tor.env

add firewall rules from ./ufw.sh (UFW firewall)
