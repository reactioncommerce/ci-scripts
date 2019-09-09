#!/usr/bin/env bash

# The purpose of this script is to generate a Dockerfile "LABEL" statement.
# We use a lot of labels so this handles automating this in one place mostly.
# The intention is in your project's Dockerfile you have a LABEL statement
# for project-specific stuff like name and description, and use this script
# to spit out the boilerplate we use for CI, URLs, tags, etc.
# This script writes to stdout so you should append it to your Dockerfile
# before running your docker build like this:
#
# $(npm bin)/docker-labels >> Dockerfile
# docker build .

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

label() {
  local prefix=com.reactioncommerce
  local suffix="$1"
  local value="$2"
  if [[ -z "${value}" ]]; then
    return
  fi
  echo "LABEL \"${prefix}.${suffix}\"=\"${value}\""
}

main() {
  label maintainer "Reaction Commerce <engineering@reactioncommerce.com>"
  label build-date "${BUILD_DATE}"
  label vcs-url "${VCS_URL}"
  label vcs-ref "${VCS_REF}"
  label vendor "${VENDOR:-Reaction Commerce}"
  label docker.build.compare-url "${BUILD_COMPARE_URL}"
  label docker.build.number "${BUILD_NUMBER}"
  label docker.build.platform "${BUILD_PLATFORM}"
  label docker.build.platform.project.username "${BUILD_PLATFORM_PROJECT_USERNAME}"
  label docker.build.platform.project.reponame "${BUILD_PLATFORM_PROJECT_REPONAME}"
  label docker.build.pull-requests "${BUILD_PULL_REQUESTS}"
  label docker.build.triggered-by-tag "${BUILD_TRIGGERED_BY_TAG}"
  label docker.build.url "${BUILD_URL}"
  label docker.build.circle.workflow.id "${CIRCLE_WORKFLOW_ID}"
  label docker.build.circle.workflow.job.id "${CIRCLE_WORKFLOW_JOB_ID}"
  label docker.build.circle.workflow.upstream.job.ids "${CIRCLE_WORKFLOW_UPSTREAM_JOB_IDS}"
  if [[ -n "${CIRCLE_WORKFLOW_ID}" ]]; then
    label docker.build.circle.workflow.url https://circleci.com/workflow-run/"${CIRCLE_WORKFLOW_ID}"
  fi
  label docker.build.circle.workspace.id "${CIRCLE_WORKSPACE_ID}"
  label docker.git.repository.url "${GIT_REPOSITORY_URL}"
  label docker.git.sha1 "$(git rev-parse HEAD)"
  label docker.license "${LICENSE}"
}

main "$@"
