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
  version "0.1.2"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.1.2/moandrop-v0.1.2-darwin-arm64.tar.gz"
      sha256 "0dcebc60420e5f089046cfcc4b1d9ed6c14fcc67554886358985eb17def23398"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.1.2/moandrop-v0.1.2-darwin-amd64.tar.gz"
      sha256 "65968b86801f4036de3724f9958527b63ef29aee2be0eae30cd45b919918d06f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.1.2/moandrop-v0.1.2-linux-arm64.tar.gz"
      sha256 "00fac03cb8d8321cd5a8f8c38914ef39916906982006cd12eee4c2c43f52af20"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.1.2/moandrop-v0.1.2-linux-amd64.tar.gz"
      sha256 "38f425693fc734247950946e5e0cb87bf71785aafdf1077fcb2b7ef6fdcf77b8"
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
