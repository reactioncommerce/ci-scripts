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

dir="$1"
push_to="$2"
ci_scripts_dir="$(dirname "${BASH_SOURCE[0]}")"

##### build #####
git_hash=$(git rev-parse HEAD)
git_branch=$(git rev-parse --abbrev-ref HEAD)
tags_file="docker-cache/docker-tags.txt"
docker build -t "${push_to}:${git_hash}" "${dir}"

##### tag #####
mkdir -p docker-cache
"${ci_scripts_dir}/node_modules/.bin/docker-tags" "${git_hash}" "${git_branch}" |
  sed 's/\//-/g' >"${tags_file}"
xargs -t -I % docker tag "${push_to}:${git_hash}" "${push_to}:%" <"${tags_file}"

##### push #####
override="./.circleci/bin/docker-push-override.sh"
if [[ -x "${override}" ]]; then
  exec "${override}" "${push_to}"
fi
if [[ -z "${CIRCLE_PR_USERNAME}" && -n "${DOCKER_USER}" && -n "${DOCKER_PASS}" ]]; then
  docker login -u "${DOCKER_USER}" -p "${DOCKER_PASS}"
  docker push "${push_to}:${git_hash}"
  xargs -t -I % docker push "${push_to}:%" <"${tags_file}"
else
  echo "No deploy for forks"
fi
