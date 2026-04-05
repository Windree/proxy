#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/.env"
set -Eeuo pipefail
shopt -s inherit_errexit

for remote in "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" "fe80::/64"; do
    ufw allow from "$remote" to any port "$XRAY_PORT" proto tcp
done

for remote in "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" "fe80::/64"; do
    ufw allow from "$remote" to any port "$WINDREE_TOR_PORT" proto tcp
done

ufw reload
