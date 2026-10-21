class Clitorrents < Formula
  include Language::Node::Shebang

  desc "TUI torrent client"
  homepage "https://github.com/j-norwood-young/clitorrents"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/j-norwood-young/clitorrents/releases/download/v0.5.2/clitorrents-0.5.2-darwin-arm64.tar.gz"
      sha256 "e2d5066f550dbe62542626c9ef37d72e4c56399aecef6ed33a9dfcf6fd8c2b99"
    end
    on_intel do
      url "https://github.com/j-norwood-young/clitorrents/releases/download/v0.5.2/clitorrents-0.5.2-darwin-x64.tar.gz"
      sha256 "daa98aeededf769cea0d7adcbe98276566d225e0af273e4329736d633a8d8fa4"
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
