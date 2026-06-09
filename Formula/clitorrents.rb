class Clitorrents < Formula
  desc "TUI torrent client"
  homepage "https://github.com/j-norwood-young/clitorrents"
  url "https://registry.npmjs.org/clitorrents/-/clitorrents-0.4.0.tgz"
  sha256 "803cbbed9caa35dae45687350e75e760871e9e029669788e3c2707dfb3141c12"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "torrent search", shell_output("#{bin}/clitorrents help")
  end
end
