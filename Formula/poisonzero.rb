# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# version + sha256 werden pro Release aktualisiert.
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "0.1.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/jonsmallhill/poisonzero/releases/download/v#{version}/poisonzero-darwin-arm64"
      sha256 "9264df1a1c2fbce7dcd5cd2f90f75f086093fd1b3bae954625206d374dcb3638"
    end
    on_intel do
      url "https://github.com/jonsmallhill/poisonzero/releases/download/v#{version}/poisonzero-darwin-amd64"
      sha256 "076707fc51353e524ba1cc1f520bd681aa102fe4afaef3dcece0dd866d0c4dce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jonsmallhill/poisonzero/releases/download/v#{version}/poisonzero-linux-arm64"
      sha256 "9ccab8573030ed2db97b93b7b15bbb7cb9d126e7fbf24bd299cdcfa5aa7d6dd2"
    end
    on_intel do
      url "https://github.com/jonsmallhill/poisonzero/releases/download/v#{version}/poisonzero-linux-amd64"
      sha256 "37912fafbaca60d369e0482d4a339b195863bc3eac5f7289d48f93464f5ad90b"
    end
  end

  def install
    bin.install Dir["poisonzero-*"].first => "poisonzero"
  end

  def caveats
    <<~EOS
      Daemon-Setup (root) separat — im Panel (app.poisonzero.com) eine App anlegen, dann:
        sudo poisonzero enroll --app <appId> --code <code>
    EOS
  end

  test do
    assert_match "poisonzero", shell_output("#{bin}/poisonzero --version 2>&1", 0)
  end
end
