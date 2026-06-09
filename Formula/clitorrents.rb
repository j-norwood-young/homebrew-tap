class Clitorrents < Formula
  desc "TUI torrent client"
  homepage "https://github.com/j-norwood-young/clitorrents"
  url "https://registry.npmjs.org/clitorrents/-/clitorrents-0.4.1.tgz"
  sha256 "3e1f25ac91ad06700ec313e63601156d95039365a738f517b34eb65200048f05"
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
