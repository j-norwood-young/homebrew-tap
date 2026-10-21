class Clitorrents < Formula
  include Language::Node::Shebang

  desc "TUI torrent client"
  homepage "https://github.com/j-norwood-young/clitorrents"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/j-norwood-young/clitorrents/releases/download/v0.5.1/clitorrents-0.5.1-darwin-arm64.tar.gz"
      sha256 "8d5dc29c0e62074201ba2389dd5c2d1981eccb6e2a33fd2f03d48759396d8117"
    end
    on_intel do
      url "https://github.com/j-norwood-young/clitorrents/releases/download/v0.5.1/clitorrents-0.5.1-darwin-x64.tar.gz"
      sha256 "b0c6f0eb8c10a52832d270fb0507ee33b072b83007fb2b5a072f3c4f3f95e062"
    end
  end

  def install
    libexec.install "dist", "node_modules", "package.json"
    cli = libexec/"dist/cli.js"
    rewrite_shebang detected_node_shebang, cli
    chmod 0755, cli
    bin.install_symlink cli => "clitorrents"
  end

  test do
    assert_predicate bin/"clitorrents", :executable?
    assert_match "torrent search", shell_output("#{bin}/clitorrents help")
    assert_match "not running", shell_output("#{bin}/clitorrents status")
    node_addon = libexec/"node_modules/node-datachannel/build/Release/node_datachannel.node"
    assert_path_exists node_addon, "node-datachannel native addon must be present in the release tarball"
  end
end
