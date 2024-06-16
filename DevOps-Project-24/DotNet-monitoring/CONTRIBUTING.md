# Welcome

Hello! Thanks for taking an interest in this project and code :)

Contributions to this project are welcome of course, otherwise it wouldn't reside on GitHub 😃 however there's a few things to be aware of:

- This is a personal project, it is not maintained by a team or group.
- It might take a long time for the maintainer(s) to reply to issues or review PRs, they will have have a day jobs & might not have looked at the code for a while.
- The code here is likely to not be bullet proof & production grade, there might be a lack of unit tests or other practices missing from the code base.

# Contributing

There's several ways of contributing to this project, and effort has been made to make this as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## All code changes happen though pull requests (PRs)

Pull requests are the best way to propose changes to the codebase (using the standard [Github Flow](https://guides.github.com/introduction/flow/index.html)).

Some PR guidance:

- Please keep PRs small and focused on a single feature or change, with discreet commits. Use multiple PRs if need be.
- If you're thinking of adding a feature via a PR please create an issue first where it can be discussed.

High level steps:

1. Fork the repo and create your branch from `master` or `main`.
2. If you've changed APIs, update the documentation.
3. Ensure the test suite (if any) passes (run `make lint`).
4. Make sure your code lints (run `make lint`).
5. Issue that pull request!

## Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project.

## Report bugs using Github's issues

This project uses GitHub issues to track public bugs. Report a bug by [opening a new issue](./issues/new/choose)

## Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can. Even if it's a snippet
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## Use a consistent coding style

Run `make lint-fix` in order to format the code fix any formatting & linting issues that might be present. A [Prettier](https://prettier.io/) configuration file is included

# References

This document was heavily adapted from the open-source contribution guidelines found in [this gist](https://gist.github.com/briandk/3d2e8b3ec8daf5a27a62)
