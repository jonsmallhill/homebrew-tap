# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "1.4.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "746e9b76153488317ee8db21cd417063630536992517170d2e98c6241f6fb8a7"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "e10f50a43b4d614f3bc6d7a693b8905e31222fd06398d13529c5062de9e1ffdc"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "00f24d48826dc23974818ca02e4d3053ae5234850d979265b1e840e6015e9e03"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "c1a78be323ef2ef860ab1a6c22643d78697fdb8df52dbd3a4c16cf70cdb2b30d"
    end
  end

  # Drittanbieter-Lizenz-Attribution (Spec §12: llama.cpp-MIT + Qwen3-Apache-2.0)
  # als eigene Resource — brew lädt + verifiziert sie (SHA-256) und install legt
  # sie unter share/doc ab, damit die Attribution auch über den brew-Weg beim
  # Nutzer landet (nicht nur in .deb/.rpm).
  resource "third-party-licenses" do
    url "https://poisonzero.com/dl/v#{version}/THIRD_PARTY_LICENSES"
    sha256 "dd93bed05e8433c8207ac52b271d8625085aa74273347fa2af3f0c0832e7bc50"
  end

  def install
    bin.install Dir["poisonzero-*"].first => "poisonzero"
    resource("third-party-licenses").stage do
      doc.install "THIRD_PARTY_LICENSES"
    end
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
