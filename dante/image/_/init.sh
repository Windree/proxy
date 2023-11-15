#!/bin/env bash
set -Eeuo pipefail

function init() {
    cat /etc/passwd | awk -F: '$3>=1000 && $3<65534' | cut --delimiter=: --fields=1 | while read -r user; do
        userdel "$user"
    done
    env | awk -F= '{ if($1 ~ /USER_[0-9]+/) print $2 }' | while read -r auth; do
        local user="${auth%%:*}"
        local password="${auth#*:}"
        echo "Adding user: $user"
        useradd --no-create-home --no-user-group --shell /usr/bin/false "$user"
        echo "$user:$password" | chpasswd
    done
}

function main() {
    danted
}

function stop(){
    pkill danted || true
}

trap stop exit

init
main
