# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "0.7.2"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "687c890d83b7191d473fee09f619f287bb8b983e66f142304275dd4ef781a416"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "669faa419c8cd1d8ee672395c4ed9fe2b344f51356ac7c6487412f7ab45ea3ea"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "fbd7ad57d21b19edae6818d3ca257c3a34dd99f3c73af5070b38355222f23f75"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "5a17b9b2e2c75d7fc8f3f4c1cd7932c29cf7c69cc8bce06edcdd15f1832b9475"
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
