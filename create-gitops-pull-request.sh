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

if [ -z "$SERVICE" ]; then
  echo "Please set the SERVICE environment variable i.e hydra, keto etc"
  exit 1
fi

if [ -z "$ENVIRONMENT" ]; then
  echo "Please set the ENVIRONMENT environment variable i.e dev, staging etc"
  exit 1
fi


if [ -z "$DOCKER_REPOSITORY" ]; then
  echo "Please set the DOCKER_REPOSITORY environment variable i.e dev, staging etc"
  exit 1
fi

if [ -z "$REACTION_GITOPS_GH_TOKEN" ]; then
  echo "Please set the REACTION_GITOPS_GH_TOKEN environment variable."
  exit 1
fi

if [ -z "$GH_USERNAME" ]; then
  echo "Please set the GH_USERNAME environment variable."
  exit 1
fi

if [ -z "$GH_EMAIL" ]; then
  echo "Please set the GH_EMAIL environment variable."
  exit 1
fi

if [ -z "$REACTION_GITOPS_REVIEWERS" ]; then
  echo "Please set the REACTION_GITOPS_REVIEWERS environment variable."
  exit 1
fi


HUB=/usr/local/bin/hub

# Clone reaction-gitops repo and configure username and email for signing off commits
"${HUB}" clone https://"${REACTION_GITOPS_GH_TOKEN}"@github.com/reactioncommerce/reaction-gitops.git
cd reaction-gitops
"${HUB}" config user.name "${GH_USERNAME}"
"${HUB}" config user.email "${GH_EMAIL}"
cd kustomize/${SERVICE}/overlays/"${ENVIRONMENT}"

# Create new branch
"${HUB}" checkout -b update-image-"${SERVICE}"-"${CIRCLE_SHA1}"

# Modify image tag in kustomization.yaml by calling 'kustomize edit set image'
"${HUB}" edit set image docker.io/"${DOCKER_REPOSITORY}":"${CIRCLE_SHA1}"
"${HUB}" add kustomization.yaml

# Commit with sign-off
"${HUB}" commit -s -m "changed "${SERVICE}" image tag to "${CIRCLE_SHA1}"

# Push branch to origin
"${HUB}" push --set-upstream origin update-image-"${SERVICE}"-"${CIRCLE_SHA1}"

# Create PR
"${HUB}" pull-request --no-edit -r "${REACTION_GITOPS_REVIEWERS}"
