class Crawlforge < Formula
  desc "Technical SEO auditor for the command line"
  homepage "https://crawlforge.org/"
  version "0.21.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dcarrero/crawlforge/releases/download/v0.21.2/crawlforge-cli-aarch64-apple-darwin.tar.gz"
      sha256 "df43ed49f3505006acec3cc1bbdde8b8982c903ed3a13435a8c5d211e22d2c42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dcarrero/crawlforge/releases/download/v0.21.2/crawlforge-cli-x86_64-apple-darwin.tar.gz"
      sha256 "1d3a7ee83ac040053b4d5c83ebba1f82a6129d47613fbdeb93a254b349fe6b7a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dcarrero/crawlforge/releases/download/v0.21.2/crawlforge-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c6e95fb96a1638b3a009e19d527038c326bc862ab80ffa8b2ea7f29dcb770abe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dcarrero/crawlforge/releases/download/v0.21.2/crawlforge-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e4ff716c9ea7b72a6ef45e208dec6ae49518329047a4bfabf3ab480f2e22952a"
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
