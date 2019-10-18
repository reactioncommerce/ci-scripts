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

cd "$(mktemp -d /tmp/aws-cli-XXX)"
file="awscli-bundle.zip"
url="https://s3.amazonaws.com/aws-cli/${file}"
curl --silent --location --fail --show-error --output "${file}" "${url}"
unzip -q ${file}
./awscli-bundle/install -b ~/bin/aws
echo ✓ installed "$(aws --version)"
