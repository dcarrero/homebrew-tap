class Crawlforge < Formula
  desc "Technical SEO auditor for sites you own: crawl, audit, store in SQLite and diff two crawls"
  homepage "https://crawlforge.org/"
  version "0.22.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dcarrero/crawlforge/releases/download/v0.22.0/crawlforge-aarch64-apple-darwin.tar.gz"
      sha256 "52d97be5d0009a51c482877636ff692ecc488026b43cf7b59ed61af44d467c76"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dcarrero/crawlforge/releases/download/v0.22.0/crawlforge-x86_64-apple-darwin.tar.gz"
      sha256 "c4fb78c945a0a1a9cf932addba2b8ea36019ad3975745300e0df0436566be98f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dcarrero/crawlforge/releases/download/v0.22.0/crawlforge-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b4d6228cf322ba595fe4ce8afbc33bfd517d4062860ee7f66f73f7f4170e27d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dcarrero/crawlforge/releases/download/v0.22.0/crawlforge-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0c39a8600d535035ee217c95149fe45f49f9a6212b55532f85db6f097533eb39"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "crawlforge"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "crawlforge"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "crawlforge"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "crawlforge"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
