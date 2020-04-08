#!/usr/bin/env bash

# Please Use Google Shell Style: https://google.github.io/styleguide/shell.xml

# This script will detect and optionally fix sops
# encrypted environment variable files if the
# value includes a trailing newline.
# Since most text editors and even the `echo` shell built-in
# by default append a trailing newline, it's very easy to
# corrupt the values, and most application software does not
# ignore the trailing newline and misbehaves
# (URLs don't work, etc)

# If any errors are detected, this script will exit nonzero.

##### Usage #####
# With no arguments this will check every .sops/*.enc file
# in the git repository and print OK or not OK.
#
# If you pass --fix on the command line, the script will
# generate a new .enc file with the trailing newline removed.
# The file will be left modified in terms of git. Nothing will
# be added or committed by this script.

# ---- Start unofficial bash strict mode boilerplate
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit  # always exit on error
set -o errtrace # trap errors in functions as well
set -o pipefail # don't ignore exit codes when piping output
set -o posix    # more strict failures in subshells
# set -x          # enable debugging

IFS="$(printf "\n\t")"
# ---- End unofficial bash strict mode boilerplate

count_error() {
  error_count=$((error_count + 1))
}

main() {
  git ls-files | grep -E '.*/\.sops/.*\.enc$' | {
    while IFS= read -r file_path; do
      if [[ "$(sops --decrypt "${file_path}" 2>&1 | wc -l)" == "0" ]]; then
        echo "✓ ${file_path}"
      else
        # The test above does not distinguish error cases explicitly
        # because of bash, so explicitly check if the file
        # decrypts successfully
        if sops --decrypt "${file_path}" &>/dev/null; then
          echo "❌ value in sops file ${file_path} includes newline"
          count_error
          if [[ "$1" == "--fix" ]]; then
            value="$(sops --decrypt "${file_path}")"
            echo -n "${value}" >"${file_path}"
            sops --config "$(dirname "${file_path}")/../.sops.yaml" \
              --encrypt --in-place "${file_path}"
          fi
        else
          echo "⚠️  could not decrypt file ${file_path}"
        fi
      fi
    done
  }
  if [[ ${error_count} -gt 0 ]]; then
    exit 10
  fi
}

error_count=0
main "$@"
