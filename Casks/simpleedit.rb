# Source of truth for the Homebrew cask published to the pago/homebrew-simpleedit
# tap. `scripts/render-cask.mjs` fills in the version and digests for one release;
# the tap repo only ever holds rendered output, so edit this file, not the tap.
cask "simpleedit" do
  # electron-builder names the x64 disk image without an arch suffix, so the
  # Intel value is deliberately empty rather than "x86_64".
  arch arm: "-arm64", intel: ""

  version "0.24.0"
  sha256 arm:   "cce6715bf775379734768e9e667745874b3ea0de312031014577b4fcfeea2c48",
         intel: "7c6d92eeb2a9be474e54cb202c4c547b47aa5b8368476f6900055920095cf6ed"

  url "https://github.com/pago/simpleedit/releases/download/v#{version}/SimpleEdit-#{version}#{arch}.dmg"
  name "SimpleEdit"
  desc "Opinionated agentic development environment"
  homepage "https://github.com/pago/simpleedit"

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
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/SimpleEdit.app"]
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
