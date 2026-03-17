#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/.env"
ufw allow "$PORT/tcp"
ufw reload
