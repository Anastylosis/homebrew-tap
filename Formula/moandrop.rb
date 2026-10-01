# Template for the Homebrew formula. The release workflow renders this into
# Anastylosis/homebrew-tap as Formula/moandrop.rb, substituting VERSION and
# the four __SHA256_*__ placeholders with checksums from the release's
# SHA256SUMS.
#
# Binary, not source: a source formula would demand a Go toolchain plus cgo
# and GL headers from every user; the release already publishes per-OS
# binaries built natively.
#
# Keep this file and the workflow's placeholder list in step — the render
# step fails loudly on a leftover placeholder rather than shipping a formula
# that cannot compute a checksum.
class Moandrop < Formula
  desc "Find and share subtitles for your videos by fingerprint, not filename"
  homepage "https://github.com/Anastylosis/MoanDrop"
  # Explicit on purpose: Homebrew's URL scan misreads the arch suffix as the
  # version on macOS (see the fss formula for the full story).
  version "0.2.0"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.2.0/moandrop-v0.2.0-darwin-arm64.tar.gz"
      sha256 "e918d54b8f55f6b2817eb7773ff4a1f124a79c5977f7954fa675cd6efe8af9c9"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.2.0/moandrop-v0.2.0-darwin-amd64.tar.gz"
      sha256 "0b3e21c788397e4ca346a9ae6b1c56f3f16cd0efaffda697d751fc17ff8a892b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.2.0/moandrop-v0.2.0-linux-arm64.tar.gz"
      sha256 "1c056ac444f6f62b02c2a5110da4f0afb92e7017628b5e83625840b4bacd32ed"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.2.0/moandrop-v0.2.0-linux-amd64.tar.gz"
      sha256 "552fe7429e708aca0129fe3bbbf133e1de7d17029fdb886d9735a884049cbb40"
    end
  end

  def install
    bin.install "moandrop"
    generate_completions_from_executable(bin/"moandrop", "completion")
  end

  test do
    # --help is offline; `moandrop` bare would try to open a window, which
    # Homebrew's sandboxed CI has no display for.
    assert_match "fingerprint", shell_output("#{bin}/moandrop --help")
    assert_match version.to_s, shell_output("#{bin}/moandrop --version")
  end
end
