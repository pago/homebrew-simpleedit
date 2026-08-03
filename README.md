# SimpleEdit Homebrew tap

Homebrew cask for [SimpleEdit](https://github.com/pago/simpleedit), an
opinionated agentic development environment.

## Install

```bash
brew trust pago/simpleedit
brew install --cask pago/simpleedit/simpleedit
```

Then, to update:

```bash
brew upgrade --cask simpleedit
```

Both lines of the install matter. Homebrew 6 refuses to load casks from
non-official taps unless you either trust the tap or name it in full on the
command line — so without `brew trust`, a plain `brew upgrade` **silently skips
SimpleEdit** rather than updating it. You only run it once.

## About Gatekeeper

SimpleEdit is ad-hoc signed but not notarized by Apple, so macOS would normally
block it on first launch and send you to System Settings. The cask clears the
download quarantine flag for you, so it launches straight away.

This is also why installing via Homebrew is recommended over the `.dmg`: Apple
notarization is what the in-app updater's signature check wants, so a manually
downloaded copy can download an update but not install it. A Homebrew copy is
updated by `brew upgrade`, and SimpleEdit detects that and tells you so instead
of offering a restart that could never work.

## Contents

`Casks/simpleedit.rb` is **generated**. Do not edit it here — it is rendered from
`scripts/homebrew/simpleedit.rb.template` in the
[main repository](https://github.com/pago/simpleedit) and pushed here by that
repo's `Homebrew Cask` workflow whenever a release is published.
