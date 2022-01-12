# Contributing to EVE Indy Watch

- [Introduction](#introduction)
- [Contributing Code](#contributing-code)
- [Disclosing vulnerabilities](#disclosing-vulnerabilities)
- [Code Style](#code-style)
- [Pull request procedure](#pull-request-procedure)
- [Communication](#communication)
- [Conduct](#conduct)

## Introduction

Please note: We take EVE Indy Watch's security and our users' trust very seriously. If you believe you have found a security issue in EVE Indy Watch, please responsibly disclose by contacting us at [shahni@bokobo.space](mailto:shahni@bokobo.space).

First: if you're unsure or afraid of anything, just ask or submit the issue or pull request anyways. You won't be yelled at for giving it your best effort. The worst that can happen is that you'll be politely asked to change something. We appreciate any sort of contributions, and don't want a wall of rules to get in the way of that.

That said, if you want to ensure that a pull request is likely to be merged, talk to us! You can find out our thoughts and ensure that your contribution won't clash or be obviated by EVE Indy Watch's normal direction. A great way to do this is via the [bokobo.space Discord](https://discord.gg/CJmCwTdm).

## Contributing Code

Unless you are fixing a known bug, we **strongly** recommend discussing it with the core team via a GitHub issue or [in our chat](https://discord.gg/CJmCwTdm) before getting started to ensure your work is consistent with EVE Indy Watch's roadmap and architecture.

All contributions are made via pull request. Note that **all patches from all contributors get reviewed**. After a pull request is made other contributors will offer feedback, and if the patch passes review a maintainer will accept it with a comment. When pull requests fail testing, authors are expected to update their pull requests to address the failures until the tests pass and the pull request merges successfully.

At least one review from a maintainer is required for all patches (even patches from maintainers).

Reviewers should leave an approving GitHub pull request review once they are satisfied with the patch. If the patch was submitted by a maintainer with write access, the pull request should be merged by the submitter after review.

## Disclosing vulnerabilities

Please disclose vulnerabilities exclusively to [shahni@bokobo.space](mailto:shahni@bokobo.space). Do not use GitHub issues.

## Code Style

Please follow these guidelines when formatting source code:

- Ruby code should not have any failures for `bundle exec rubocop`
- JavaScript code should not have any failures for `yarn eslint`
- Stylesheets should not have any failures for `yarn stylelint app/javascript/**/*.scss`
- JavaScript code and stylesheets should not have any failures for `yarn prettier --check app/javascript/**/*.{scss,js}

## Pull request procedure

To make a pull request, you will need a GitHub account; if you are unclear on this process, see GitHub's documentation on [forking](https://help.github.com/articles/fork-a-repo) and [pull requests](https://help.github.com/articles/using-pull-requests). Pull requests should be targeted at the `main` branch. Before creating a pull request, go through this checklist:

1. Create a feature branch off of `main` so that changes do not get mixed up.
1. [Rebase](http://git-scm.com/book/en/Git-Branching-Rebasing) your local changes against the `main` branch.
1. Run the full project test suite with the `bundle exec rspec` command and confirm that it passes.
1. Run `bundle exec rubocop -A`.
1. Run `yarn prettier --write app/javascript/**/*.{scss,js}
1. Ensure that each commit has the proper prefix for semantic versioning subsystem prefix (ex: `feat:`). We follow the [Angular commit message conventions](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#type).

Pull requests will be treated as "review requests," and maintainers will give feedback on the style and substance of the patch.

Normally, all pull requests must include tests that test your change. Occasionally, a change will be very difficult to test for. In those cases, please include a note in your commit message explaining why.

## Communication

We use [Discord](https://discord.gg/CJmCwTdm). You are welcome to drop in and ask questions, discuss bugs, etc.

## Conduct

Whether you are a regular contributor or a newcomer, we care about making this community a safe place for you and we've got your back.

- We are committed to providing a friendly, safe and welcoming environment for all, regardless of gender, sexual orientation, disability, ethnicity religion, or similar personal characteristic.
- Please avoid using nicknames that might detract from a friendly, safe and welcoming environment for all.
- Be kind and courteous. There is no need to be mean or rude.
- We will exclude you from interaction if you insult, demean or harass anyone. In particular, we do not tolerate behavior that excludes people in socially marginalized groups.
- Private harassment is also unacceptable. No matter who you are, if you feel you have been or are being harassed or made uncomfortable by a community member, please contact one of the channel ops immediately.
- Likewise any spamming, trolling, flaming, baiting or other attention-stealing behaviour is not welcome.

We welcome discussion about creating a welcoming, safe, and productive environment for the community. If you have any questions, feedback, or concerns
[please let us know](https://discord.gg/CJmCwTdm).
