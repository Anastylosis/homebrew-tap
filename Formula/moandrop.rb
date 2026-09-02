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
      sha256 "554c7e5f0dd0a14ff0b59a742892e956d0e7efc545cc2ce5179332ed4155205e"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.2.0/moandrop-v0.2.0-darwin-amd64.tar.gz"
      sha256 "d57c88507fe6ea30831653221c4e329bf108f381f6b93d49817667fbbd245ebd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.2.0/moandrop-v0.2.0-linux-arm64.tar.gz"
      sha256 "48bb3d7173a7c4dc01ad83670a20bbeb9f96af7e14361981de715e2ecf57ae60"
    end
    on_intel do
      url "https://github.com/Anastylosis/MoanDrop/releases/download/v0.2.0/moandrop-v0.2.0-linux-amd64.tar.gz"
      sha256 "8074f82312ffe72173e998932954fe05bba0e2f0988d93f75fbbbe7ebb8daace"
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
