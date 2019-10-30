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

if [ -z $KUSTOMIZE_VERSION ]; then
  echo "Please set the KUSTOMIZE_VERSION environment variable."
  exit 1
fi

# Download kustomize
cd "$(mktemp -d /tmp/kustomize-XXX)"
wget -q "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_kustomize.v${KUSTOMIZE_VERSION}_linux_amd64"
sudo mv kustomize_kustomize.v${KUSTOMIZE_VERSION}_linux_amd64 /usr/local/bin/kustomize
sudo chmod +x /usr/local/bin/kustomize
echo '✓' installed "$(kustomize version)"


