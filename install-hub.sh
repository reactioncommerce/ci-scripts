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

HUB_VERSION=2.12.8

# Download hub
cd "$(mktemp -d /tmp/hub-XXX)"
wget -q "https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz"
tar xfz hub-linux-amd64-"${HUB_VERSION}".tgz
sudo install --mode 755 hub-linux-amd64-"${HUB_VERSION}"/bin/hub /usr/local/bin/hub
echo '✓' installed "$(hub version)"



