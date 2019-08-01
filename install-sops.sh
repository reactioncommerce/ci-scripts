#!/usr/bin/env bash

# Please Use Google Shell Style: https://google.github.io/styleguide/shell.xml

# ---- Start unofficial bash strict mode boilerplate
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit  # always exit on error
set -o errtrace # trap errors in functions as well
set -o pipefail # don't ignore exit codes when piping output
set -o posix    # more strict failures in subshells
# set -x          # enable debugging

IFS=$'\n\t'
# ---- End unofficial bash strict mode boilerplate

cd "$(mktemp -d /tmp/sops-XXX)"
version=3.2.0
wget -q "https://github.com/mozilla/sops/releases/download/${version}/sops-${version}.linux"
# Use sudo if needed, empty string if not
sudo_command=$(command -v sudo)
"${sudo_command}" install -m 755 "sops-${version}.linux" /usr/local/bin/sops
echo ✓ installed "$(sops --version 2>&1 | head -1)"
