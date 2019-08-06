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

git ls-files | grep -E '(\bbin/|\.sh$)' | {
  while IFS= read -r file_path; do
    # skip files without a shell script shebang first line
    # if ! head -1 "${file_path}" | grep -qE '^#!.*\b(bash|sh)$'; then
    #   continue
    # fi
    echo -n "shellcheck ${file_path}"
    docker run --rm --interactive koalaman/shellcheck:v0.7.0 \
      --external-sources \
      --exclude=SC1091 \
      /dev/stdin <"${file_path}"
    echo " ✓"
  done
}
