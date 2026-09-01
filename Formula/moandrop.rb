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
  version "0.1.1"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.1.1/moandrop-v0.1.1-darwin-arm64.tar.gz"
      sha256 "e8f7d69135e53822233c74ccafffd9d0c7ad43fa7c89a3204281b136ed3f3242"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.1.1/moandrop-v0.1.1-darwin-amd64.tar.gz"
      sha256 "6f70a527577730e25f14c69c2c567201d6a0d5e6b07ae8d5ce17b572d5f1d833"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.1.1/moandrop-v0.1.1-linux-arm64.tar.gz"
      sha256 "6cfcde401a0330355f36fb6cea591276d2ec5f58c17f1fdcfa28125ae1e3a1c1"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.1.1/moandrop-v0.1.1-linux-amd64.tar.gz"
      sha256 "59d49a9a7455bb798a0b7cae65b65383027ebb9fe47addf5584cebc48dc632b0"
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
