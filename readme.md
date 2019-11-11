# Reaction Commerce CI Scripts

Scripts we use across many repositories during continuous integration.

## How to use in circleci

In your `.circleci/config.yml`, in your appropriate job step, add a run command:

```yaml
jobs:
  lint:
    <<: *defaults
    steps:
      - checkout
      - setup_remote_docker:
          docker_layer_caching: true
      - run:
          name: Run Lint Suite
          # pin the current latest version explicitly, 1.8.4 for example only
          command: npx --quiet --package @reactioncommerce/ci-scripts@1.8.4 lint-shell-scripts
```

**Note:** Most `docker-*` scripts as well as `lint-dockerfiles` require the `setup_remote_docker` circleci job step as a prerequisite. Be sure your `config.yml` has that when it's needed.

If you run a bunch of these and want to DRY it up, try this flavor with an environment variable:

```yaml
# The following stanza defines a map named defaults with a variable that may be
# inserted using the YAML merge (<<: *) key later in the file to save some
# typing. See http://yaml.org/type/merge.html for details.
defaults: &defaults
  docker:
    - image: circleci/node:12-stretch
  environment:
    CI_SCRIPTS: 'npx --quiet --package @reactioncommerce/ci-scripts@1.8.4'
jobs:
  docker-build-tag-push:
    <<: *defaults
    steps:
      - checkout
      - setup_remote_docker:
          docker_layer_caching: true
      - run:
          name: 'docker: catalog-publisher'
          command: |
            ${CI_SCRIPTS} docker-labels >> Dockerfile
            ${CI_SCRIPTS} build-metadata
            ${CI_SCRIPTS} docker-build-tag-push . reactioncommerce/catalog-publisher
```

## How to add new scripts

- Put your script file in the repo root. Use a filename extension. It makes editor syntax highlighting and linting "just work" sometimes.
- `chmod 755 your-script.sh`
- Add an entry to the `package.json` `"bin"` property mapping `"name-without-extension": "./name-with-extension.sh",`
- Commit, being sure to prefix your commit message with `feat: ` so semantic release publishes a new minor version properly
- Notes on filename extensions vs no extensions
  - In the `package.json` `bin` keys, we omit the extension. This is slightly nicer as a command line interface. It's just a logical script name.
  - When launching via `npx` on the command line during CI, it's **no extension**
  - In the repo root dir, we **do** use the extension since this is nicer for editor syntax detection, development tools, etc.
  - So in `package.json` `bin` it's **no extension** for the key but **yes extension** for the value
  - When calling one ci-script from another ci-script it's **no extension** because these run from the `node_modules/.bin` directory which only contains no-extension files which npm picks up from `package.json` `bin` key.

## How to troubleshoot script errors

- Launch the docker image your CI job uses locally
  - For example
    - `docker run --rm -it circleci/node:12 bash`
- Install ci-scripts in /tmp so you can debug
- `cd /tmp && npm install @reactioncommerce/ci-scripts`
- Run with debugging
- `bash -x ./node_modules/@reactioncommerce/ci-scripts/script-you-want-to-debug.sh`

## Implementation Notes

- Scripts should operate on their current working directory (inherited from the parent process)
  - Meaning the calling code should `cd` into the root of their project git repository (which happens by default on circleci) then invoke the scripts from this repo
- Scripts should enumerate files with `git ls-files`
- Shell scripts should be formatted with [shfmt](https://github.com/mvdan/sh)
- If you need to call another ci-script from your own ci-script, use this pattern
  1. Make a variable for the directory the script lives in, which is `node_modules/.bin` when running via npx
    - `ci_scripts_dir="$(dirname "${BASH_SOURCE[0]}")"`
  2. Reference sibling scripts with no extension
    - `./some-other-script`
    
