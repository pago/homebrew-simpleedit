# Source of truth for the Homebrew cask published to the pago/homebrew-simpleedit
# tap. `scripts/render-cask.mjs` fills in the version and digests for one release;
# the tap repo only ever holds rendered output, so edit this file, not the tap.
cask "simpleedit" do
  # electron-builder names the x64 disk image without an arch suffix, so the
  # Intel value is deliberately empty rather than "x86_64".
  arch arm: "-arm64", intel: ""

  version "0.28.0"
  sha256 arm:   "e1cdb3b8aa24d13f792ff862f07c2a35cc1816ee68974af90de22aa8132f47ce",
         intel: "31f21a14acd3dd4dfc13fe8507ba8af9601c9d5c92c87fbd6934168ded7b7b63"

  url "https://github.com/pago/simpleedit-releases/releases/download/v#{version}/SimpleEdit-#{version}#{arch}.dmg"
  name "SimpleEdit"
  desc "Opinionated agentic development environment"
  homepage "https://github.com/pago/simpleedit-releases"

  livecheck do
    url :url
    strategy :github_latest
  end

  # LSMinimumSystemVersion of the packaged bundle is 12.0. The bare symbol means
  # "Monterey or newer" (`maximum_macos:` is the upper-bound form).
  depends_on macos: :monterey

  app "SimpleEdit.app"

  # SimpleEdit is ad-hoc signed (scripts/mac-adhoc-sign.cjs) but not notarized,
  # so macOS blocks a quarantined copy on first launch and sends the user to
  # System Settings. Clearing the flag here is what keeps `brew install` a
  # single step. Runs after the app stanza has moved the bundle into appdir.
  # `{{appdir}}` is a step template token that brew expands when the step runs;
  # the block is not cask Ruby, so `#{appdir}` would not resolve here.
  # `postflight_steps` needs Homebrew 5.1.14+, which adds no requirement: the
  # README's `brew trust` step already needs Homebrew 6.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/SimpleEdit.app"]
  end

  # `brew upgrade` replaces the app in place; these are only removed on
  # `brew uninstall --zap`.
  zap trash: [
    "~/Library/Application Support/SimpleEdit",
    "~/Library/Logs/SimpleEdit",
    "~/Library/Preferences/com.simpleedit.app.plist",
    "~/Library/Saved Application State/com.simpleedit.app.savedState",
  ]
end
