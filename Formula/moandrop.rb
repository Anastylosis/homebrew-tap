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
  version "0.4.0"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.4.0/moandrop-v0.4.0-darwin-arm64.tar.gz"
      sha256 "4e980ad3801ac721cb0988a2d828dd64818578c2922bcd6f905a1336faabb871"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.4.0/moandrop-v0.4.0-darwin-amd64.tar.gz"
      sha256 "181c6a819a576c568cefb6ce9094448af398932b11db8b9810001e48b6ccd2fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.4.0/moandrop-v0.4.0-linux-arm64.tar.gz"
      sha256 "aa5cd88d0ce36fd0976e50915ecaa07bd4ccac21b89bbb90eba0be1306191c48"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.4.0/moandrop-v0.4.0-linux-amd64.tar.gz"
      sha256 "75b4c838a11aa01337e887dd811ed71dbeeced552d11fbed430cf8a3cf6a3220"
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
