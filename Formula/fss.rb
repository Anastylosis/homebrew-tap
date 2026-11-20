# Template for the Homebrew formula. The release workflow renders this into
# Anastylosis/homebrew-tap as Formula/fss.rb, substituting VERSION and the four
# __SHA256_*__ placeholders with the checksums from the release's SHA256SUMS.
#
# Binary, not source: the release already publishes darwin and linux tarballs,
# so an install is a download and an extract. A source formula would make every
# user build the ~1,900 scrapers with a Go toolchain they may not have.
#
# Keep this file and the workflow's placeholder list in step — the render step
# fails loudly on a leftover placeholder rather than shipping a formula that
# cannot compute a checksum.
class Fss < Formula
  desc "Scrapes all scenes and metadata from a studio URL"
  homepage "https://github.com/Anastylosis/FSS"
  # Explicit on purpose. Homebrew's URL scan reads fss-v1.30.1-darwin-arm64.tar.gz
  # as version "64" on macOS (it takes the trailing number), so without this
  # line `brew test` compares against 64. On Linux the amd64 URL scans
  # correctly, which makes `brew audit` call the line redundant there — the
  # tap's CI runs audit with --except=version for exactly this reason.
  version "1.35.1"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/Anastylosis/FSS/releases/download/v1.35.1/fss-v1.35.1-darwin-arm64.tar.gz"
      sha256 "fec551d20eceb5c26af10ab5137a22118985a185d87ee0c143df0b7adccb4e0b"
    end
    on_intel do
      url "https://github.com/Anastylosis/FSS/releases/download/v1.35.1/fss-v1.35.1-darwin-amd64.tar.gz"
      sha256 "fff0027d2167de77798eb75fa057386c0e6b287372bb201f27de5036e221b74e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Anastylosis/FSS/releases/download/v1.35.1/fss-v1.35.1-linux-arm64.tar.gz"
      sha256 "c9df837f5e349d1a5bef8145e77e8bd68b135b18d317e5b641274ad570e3173a"
    end
    on_intel do
      url "https://github.com/Anastylosis/FSS/releases/download/v1.35.1/fss-v1.35.1-linux-amd64.tar.gz"
      sha256 "44e9e817265fc5fc77e2de5503118070dd720158c6558409dfc5dedb686508f8"
    end
  end

  def install
    bin.install "fss"
    generate_completions_from_executable(bin/"fss", "completion")
  end

  test do
    # `fss version` reaches the network to check for a newer release, so assert
    # against --help, which is offline. A formula test that needs the network
    # fails in Homebrew's sandboxed CI for reasons unrelated to the package.
    assert_match "FullStudioScraper", shell_output("#{bin}/fss --help")
    assert_match version.to_s, shell_output("#{bin}/fss --version")
  end
end
