# Reaction Commerce CI Scripts

Scripts we use across many repositories during continuous integration.

## How to use in circleci

In your `.circleci/config.yml`, in your appropriate job step, add a run command:


```yaml
jobs:
  my-lint-job-name:
    <<: *defaults
    steps:
      - checkout
      - setup_remote_docker:
          docker_layer_caching: true
      - run:
          name: Run Lint Suite
          command: |
            # pin the current latest version explicitly
            # 1.2.0 for example only
            npm install --no-progress --no-package-lock @reactioncommerce/ci-scripts@1.2.0 >/dev/null
            "$(npm bin)/lint-shell-scripts"
```

## How to add new scripts

- Put your script file in the repo root. Use a filename extension. It makes editor syntax highlighting and linting "just work" sometimes.
- `chmod 755 your-script.sh`
- Add an entry to the `package.json` `"bin"` property mapping `"name-without-extension": "./name-with-extension.sh",`
- Commit with semantic release `feat:` message

## Implementation Notes

- Scripts should operate on their current working directory (inherited from the parent process)
  - Meaning the calling code should `cd` into the root of their project git repository (which happens by default on circleci) then invoke the scripts from this repo
- Scripts should enumerate files with `git ls-files`
- Shell scripts should be formatted with `shfmt`
