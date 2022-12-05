#!/usr/bin/env bash
set -e

apt-get update
apt-get install -y curl unzip tmux
curl -fsSL https://deno.land/x/install/install.sh | sh
PATH=$PATH:/.deno/bin/
deno install -f --name silverbullet -A --unstable https://get.silverbullet.md

