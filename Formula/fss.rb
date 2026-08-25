# Template for the Homebrew formula. The release workflow renders this into
# Anastylosis/homebrew-tap as Formula/fss.rb, substituting VERSION and the four
# __SHA256_*__ placeholders with the checksums from the release's SHA256SUMS.
#
# Binary, not source: the release already publishes darwin and linux tarballs,
# so an install is a download and an extract. A source formula would make every
# user build the ~290 scrapers with a Go toolchain they may not have.
#
# Keep this file and the workflow's placeholder list in step — the render step
# fails loudly on a leftover placeholder rather than shipping a formula that
# cannot compute a checksum.
class Fss < Formula
  desc "Scrapes all scenes and metadata from a studio URL"
  # Explicit on purpose. Homebrew's URL scan reads fss-v1.30.1-darwin-arm64.tar.gz
  # as version "64" on macOS (it takes the trailing number), so without this
  # line `brew test` compares against 64. On Linux the amd64 URL scans
  # correctly, which makes `brew audit` call the line redundant there — the
  # tap's CI runs audit with --except=version for exactly this reason.
  version "1.30.1"
  homepage "https://github.com/Anastylosis/FSS"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/Anastylosis/FSS/releases/download/v1.30.1/fss-v1.30.1-darwin-arm64.tar.gz"
      sha256 "ec1e89563a631268615a60391c1de71c6c507a1bdd33d2ac992d52373cfa6949"
    end
    on_intel do
      url "https://github.com/Anastylosis/FSS/releases/download/v1.30.1/fss-v1.30.1-darwin-amd64.tar.gz"
      sha256 "3929590533ad6f5ee46e1d87e800a1285cae5c29989b6d6c9a7689deb775e8b0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Anastylosis/FSS/releases/download/v1.30.1/fss-v1.30.1-linux-arm64.tar.gz"
      sha256 "4a88284a01c9063595a9973e3eb91e5e9119f98c3154ebe10f6ba2ff4885fd84"
    end
    on_intel do
      url "https://github.com/Anastylosis/FSS/releases/download/v1.30.1/fss-v1.30.1-linux-amd64.tar.gz"
      sha256 "13bcad317caef96567a1670840bdcf3840f8b0f728c9f7789a9efda460f7c0f4"
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
