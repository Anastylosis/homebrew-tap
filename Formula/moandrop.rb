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
  version "0.3.0"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.3.0/moandrop-v0.3.0-darwin-arm64.tar.gz"
      sha256 "59fcdd050094f9ad8fb0df9db2179574d6895ae605fd4069b65f492f390f8f09"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.3.0/moandrop-v0.3.0-darwin-amd64.tar.gz"
      sha256 "2a7e6db0bea5faa31a30d1cb48181aab2592da4e5e934e33ead75f1b928b8cdc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.3.0/moandrop-v0.3.0-linux-arm64.tar.gz"
      sha256 "e46d6dd0d1872deef6b31a81a0ff4eef0a8d5aa5d02917c55e91ee19a2feda8c"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.3.0/moandrop-v0.3.0-linux-amd64.tar.gz"
      sha256 "7c9e9d0032264142b378e53740f183f247aea94a6f5d9d671fed6739340de0ab"
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
