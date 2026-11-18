# Source of truth for the Homebrew cask published to the pago/homebrew-simpleedit
# tap. `scripts/render-cask.mjs` fills in the version and digests for one release;
# the tap repo only ever holds rendered output, so edit this file, not the tap.
cask "simpleedit" do
  # electron-builder names the x64 disk image without an arch suffix, so the
  # Intel value is deliberately empty rather than "x86_64".
  arch arm: "-arm64", intel: ""

  version "0.31.0"
  sha256 arm:   "3f9b93d73d60bcfceef57bdd45708d66c1dedc8f2ce65f0d55603a5c3f32f66a",
         intel: "8d24a7ed62d4641d15cee0fa5cf0a147bb03e3a1e73c6f9f630a9eff0536f9b5"

  url "https://github.com/pago/simpleedit-releases/releases/download/v#{version}/SimpleEdit-#{version}#{arch}.dmg"
  name "SimpleEdit"
  desc "Opinionated agentic development environment"
  homepage "https://github.com/pago/simpleedit-releases"

  livecheck do
    url :url
    strategy :github_latest
  end

  # LSMinimumSystemVersion of the packaged bundle is 13.0 (Electron 44 dropped
  # macOS 12). The bare symbol means "Ventura or newer" (`maximum_macos:` is the
  # upper-bound form).
  depends_on macos: :ventura

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
