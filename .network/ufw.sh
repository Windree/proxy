#!/bin/sh

set -ex

# 1. Safely locate the parent directory
PARENT_DIR=$(cd "$(dirname "$0")/.." && pwd)
ENV_FILE="$PARENT_DIR/.env"

# 2. Check if the .env file exists and is readable
if [ ! -f "$ENV_FILE" ] ; then
    echo "Error: .env file does not exist '$ENV_FILE'" >&2
    exit 1
fi

if [ ! -r "$ENV_FILE" ]; then
    echo "Error: .env file is not readable '$ENV_FILE'" >&2
    exit 1
fi

# 3. Source the file into the environment
. "$ENV_FILE"


get_port_prefixes() {
    awk -F= '/^[A-Za-z_][A-Za-z0-9_]*_PORT=/ {sub(/_PORT$/, "", $1); print $1}' "$ENV_FILE"
}

get_port_options() {
    error=0
    port_prefixes=$(get_port_prefixes)
    for prefix in $port_prefixes; do
        eval "port=\${${prefix}_PORT}"
        eval "scope=\${${prefix}_PORT_SCOPE}"
        eval "proto=\${${prefix}_PORT_PROTO}"
        [ -z "$port" ] || [ -z "$scope" ] && continue
        if ! check_port_value "$port"; then
            echo "Error: ${prefix} port should be the valid network port range (1 - 65535)"
            error=1
        fi
        if ! check_scope_value "$scope"; then
            echo "Error: ${prefix} scope should be 'local' or 'global'"
            error=1
        fi
        if [ -n "$proto" ]; then
            protocols="$(parse_list "$proto" ",")"
            for proto in $protocols; do
                if ! check_protocol_value "$proto"; then
                    echo "Error: ${prefix} protocols should be comma separated list of 'tcp' and 'udp'"
                    error=1
                fi
            done
        fi
        protocols_string="$(join_list "$protocols" ",")"
        echo "$port $scope $protocols_string"
    done
    [ "$error" -eq 0 ] || exit 1
}

check_port_value() {
    case "$1" in
        *[!0-9]*|"" ) 
        return 1 ;;
        * )
            [ "$1" -ge 0 ] && [ "$1" -lt 65536 ] && return ;;
    esac
    return 1
}

check_scope_value() {
    case "$1" in
        local|global)
            return ;;
        *)
            return 1 ;;
    esac
}

parse_list() {
    OLD_IFS="$IFS"
    IFS="$2"
    for value in $1; do
        value=$(echo "$value" | tr -d '[:space:]')
        echo "$value"
    done
    IFS="$OLD_IFS"
}

join_list() {
    echo "$1" | awk -v separator="$2" '{printf "%s%s", (NR==1?"":separator), $0} END {print ""}'
}

check_protocol_value() {
    case "$1" in
        tcp|udp)
            return
            ;;
        *)
            return 1
            ;;
    esac
}

options="$(get_port_options)"


# 5. Loop through found prefixes
OLD_IFS="$IFS"
IFS=$"\n"
for option in $options; do
    echo "$option" | while IFS=" " read -r port scope proto; do
        echo "First: $port, Second: $scope, Third: $proto"
        
    done
    # eval "port_val=\${${prefix}_PORT}"
    # eval "scope_val=\${${prefix}_PORT_SCOPE}"
    # eval "proto_val=\${${prefix}_PORT_PROTOCOLS}"

    # if [ -n "$port_val" ] && [ -n "$scope_val" ]; then
        
    #     if [ "$scope_val" = "LOCAL" ]; then
    #         # Initialize positional parameters with the base command arguments
    #         set -- allow from "$scope_val" to any port "$port_val"
    #     fi
    #     # If protocols are defined, append them safely to our arguments list
    #     if [ -n "$proto_val" ]; then
    #         OLD_IFS="$IFS"
    #         IFS=","
    #         for proto in $proto_val; do
    #             proto=$(echo "$proto" | tr -d '[:space:]')
    #             if [ -n "$proto" ]; then
    #                 # Append 'proto <name>' to our existing command array
    #                 set -- "$@" proto "$proto"
    #             fi
    #         done
    #         IFS="$OLD_IFS"
    #     fi

    #     # Execute ufw exactly ONCE using the constructed positional arguments "$@"
    #     echo "Executing: sudo ufw $@"
    #     # sudo ufw "$@"
    # fi
done
IFS="$OLD_IFS"
