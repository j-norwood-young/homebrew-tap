class Clitorrents < Formula
  include Language::Node::Shebang

  desc "TUI torrent client"
  homepage "https://github.com/j-norwood-young/clitorrents"
  license "MIT"

  depends_on "node"
  depends_on macos: :arm64

  on_macos do
    on_arm do
      url "https://github.com/j-norwood-young/clitorrents/releases/download/v0.4.2/clitorrents-0.4.2-darwin-arm64.tar.gz"
      sha256 "PLACEHOLDER_ARM64"
    end
  end

  def install
    libexec.install "dist", "node_modules", "package.json"
    rewrite_shebang detected_node_shebang, libexec/"dist/cli.js"
    bin.install_symlink libexec/"dist/cli.js"
  end

  test do
    assert_match "torrent search", shell_output("#{bin}/clitorrents help")
    assert_match "not running", shell_output("#{bin}/clitorrents status")
    node_addon = libexec/"node_modules/node-datachannel/build/Release/node_datachannel.node"
    assert_path_exists node_addon, "node-datachannel native addon must be present in the release tarball"
  end
end
