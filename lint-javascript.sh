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

git ls-files | grep -E '(^|/)package\.json$' | {
  while IFS= read -r file_path; do
    dir=$(dirname "${file_path}")
    (
      cd "${dir}" >/dev/null
      [[ -d node_modules ]] || npm install
      echo -n "lint javascript ${dir}"
      npm --silent run lint
    )
    echo " ✓"
  done
}
