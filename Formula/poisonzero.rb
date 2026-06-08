# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "0.7.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "74bd83bd14ec46bbd8c3fd6b0957f0c345d42fc1f3b449fdda4e5e5251bbc096"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "ad72dc9db8f354c7117488068bf5cd165ebbbe52b6b935472d04b477e2ce53ae"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "b38d11fbe4bf018c07006ad537275a36f6d62d18de83ffca5ded34f5cc023d9b"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "0f69a8fd3feba7509a5d06baa07c3c99725b168a1f7722decc1e43d0307056b2"
    end
  end

  def install
    bin.install Dir["poisonzero-*"].first => "poisonzero"
  end

  def caveats
    <<~EOS
      Daemon-Setup (root) separat — im Panel (console.poisonzero.com) eine App anlegen, dann:
        sudo poisonzero enroll  (nach Anlegen der enroll-Datei, siehe docs/INSTALL.md)
    EOS
  end

  test do
    assert_match "poisonzero", shell_output("#{bin}/poisonzero --version 2>&1", 0)
  end
end
