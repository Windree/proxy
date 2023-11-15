#!/bin/env bash
set -Eeuo pipefail

stop_file=$(mktemp --dry-run --tmpdir=/run)

function init() {
    # local hash=$(echo "$PASSWORD" | tor --hash-password - | grep ^16:)
    # echo "HashedControlPassword $hash" >/etc/tor/password.conf
    # echo "TOR control password: $hash"
    local exit_nodes_conf=/data/exit-nodes.conf
    echo -n "ExitNodes " > "$exit_nodes_conf"
    IFS=',' read -ra exit_nodes <<< "$EXIT_NODES"
    for exit_node in "${exit_nodes[@]}"; do
        echo -n "{$exit_node} " >> "$exit_nodes_conf"
    done 
}

function main() {
    while [ : ]; do
        server &
        python3 /tor-relay-scanner-*.pyz --torrc -o /data/bridges.conf
        tor
    done
}

function server() {
    local command=$(nc -l -w1 1111)
    if [ "$command" == "stop" ]; then
        stop
    fi
}

function stop() {
    pkill python3 || true
    pkill tor || true
}

trap stop exit

init
main
