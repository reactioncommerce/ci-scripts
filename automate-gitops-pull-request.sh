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

error=""
for VAR in SERVICE DOCKER_REPOSITORY GITHUB_TOKEN GH_USERNAME GH_EMAIL REACTION_GITOPS_REVIEWERS; do
  if [[ -z "${!VAR}" ]]; then
    error="${error}Missing required environment variable: ${VAR}\n"
  fi
done
if [[ -n "${error}" ]]; then
  echo -e "${error}" 1>&2
  exit 1
fi

ci_scripts_dir="$(dirname "${BASH_SOURCE[0]}")"

# Install Kustomize
"${ci_scripts_dir}"/install-kustomize.sh

# Install Hub
"${ci_scripts_dir}"/install-hub.sh

# Clone reaction-gitops repository and configure username and email for signing off commits
hub clone "https://${GITHUB_TOKEN}@github.com/reactioncommerce/reaction-gitops.git"
cd reaction-gitops
hub config user.name "${GH_USERNAME}"
hub config user.email "${GH_EMAIL}"
cd kustomize/"${SERVICE}"/overlays/"${ENVIRONMENT:-dev}"

# Create new branch
hub checkout -b update-image-"${SERVICE}"-"${CIRCLE_SHA1}"

# Modify image tag in kustomization.yaml by calling 'kustomize edit set image'
kustomize edit set image docker.io/"${DOCKER_REPOSITORY}":"${CIRCLE_SHA1}"
hub add kustomization.yaml

# Commit with sign-off
hub commit -s -m "changed ${SERVICE} image tag to ${CIRCLE_SHA1}"

# Push branch to origin
hub push --set-upstream origin update-image-"${SERVICE}"-"${CIRCLE_SHA1}"

# Create PR
hub pull-request --no-edit -r "${REACTION_GITOPS_REVIEWERS}"



