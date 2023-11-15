#!/bin/env bash
set -Eeuo pipefail

pid_file=$(mktemp --dry-run --tmpdir=/run)

function main() {
    local expect_code=301
    while [ : ]; do
        sleep 60
        local code=$(curl --proxy socks5h://tor:9050 -s -o /dev/null -w "%{http_code}\n" http://facebook.com || true)
        if [ "$expect_code" != "$code" ]; then
            echo "Connection test faled. Response code: $code". Expected $expect_code.
            stop_watcher
            send_stop
        else
            start_watcher
            echo "Connection test sucsessful."
        fi
    done
}

function start_watcher() {
    [ -f "$pid_file" ] && return
    nc -lk 1081 &
    if [ "$?" -ne 0 ]; then
        echo "Faled to start watcher"
        exit 1
    else
        echo "$!" >"$pid_file"
    fi
}

function stop_watcher() {
    [ ! -f "$pid_file" ] && return
    kill $(cat "$pid_file")
    rm -f "$pid_file"
}

function send_stop(){
   echo stop | nc tor 1111 || true 
}

function stop() {
    pkill curl || true
    stop_watcher
}

trap stop exit

main
