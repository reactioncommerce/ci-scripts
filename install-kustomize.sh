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

KUSTOMIZE_VERSION=3.2.1

# Download kustomize
cd "$(mktemp -d /tmp/kustomize-XXX)"
wget -q "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_kustomize.v${KUSTOMIZE_VERSION}_linux_amd64"
sudo install --mode 755 "kustomize_kustomize.v${KUSTOMIZE_VERSION}_linux_amd64" /usr/local/bin/kustomize
echo '✓' installed "$(kustomize version)"
