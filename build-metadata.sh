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

cat <<EOF >build-metadata.txt
BUILD_COMPARE_URL=${CIRCLE_COMPARE_URL}
BUILD_DATE=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
BUILD_NUMBER=${CIRCLE_BUILD_NUM}
BUILD_PLATFORM=circleci
BUILD_PLATFORM_PROJECT_REPONAME=${CIRCLE_PROJECT_REPONAME}
BUILD_PLATFORM_PROJECT_USERNAME=${CIRCLE_PROJECT_USERNAME}
BUILD_PULL_REQUESTS=${CI_PULL_REQUESTS}
BUILD_TRIGGERED_BY_TAG=${CIRCLE_TAG}
BUILD_URL=${CIRCLE_BUILD_URL}
CIRCLE_WORKFLOW_ID=${CIRCLE_WORKFLOW_ID}
CIRCLE_WORKFLOW_JOB_ID=${CIRCLE_WORKFLOW_JOB_ID}
CIRCLE_WORKFLOW_UPSTREAM_JOB_IDS=${CIRCLE_WORKFLOW_UPSTREAM_JOB_IDS}
CIRCLE_WORKSPACE_ID=${CIRCLE_WORKSPACE_ID}
GIT_REPOSITORY_URL=${CIRCLE_REPOSITORY_URL}
GIT_SHA1=$(git rev-parse HEAD)
VCS_REF=${CIRCLE_SHA1}
VENDOR=Reaction Commerce
EOF
