#!/usr/bin/env bash

# Please Use Google Shell Style: https://google.github.io/styleguide/shell.xml

# ---- Start unofficial bash strict mode boilerplate
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit  # always exit on error
set -o errtrace # trap errors in functions as well
set -o pipefail # don't ignore exit codes when piping output
set -o posix    # more strict failures in subshells
# set -x          # enable debugging

IFS="$(printf "\n\t")"
# ---- End unofficial bash strict mode boilerplate

cd "$(mktemp -d /tmp/helm-XXX)"

version=2.12.2
echo -n "Installing helm v${version}…"
url="https://storage.googleapis.com/kubernetes-helm/helm-v${version}-linux-amd64.tar.gz"
curl --silent --location --fail --remote-name "${url}"
tar xfz "helm-v${version}-linux-amd64.tar.gz"
# Use sudo if needed, empty string if not
sudo_command=$(command -v sudo)
"${sudo_command}" install -m 755 linux-amd64/helm /usr/local/bin
echo ✓
