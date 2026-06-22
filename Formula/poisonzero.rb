# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "1.4.3"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "5a9af38ee14a02c11632b0bfe83c65076549cb209fc897381aa4b6ac95fdbeb9"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "9a511e57c4b98f88d27f290dc5395c8467d659da46ae2d451da39a234bf24276"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "be0698a125b65573b843e20487ca0186e1e513986cf50c7bce7f478958d89aec"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "151813f680d51f9ec557973b8678552a92eb066ed6c518d839c547eef4b9f084"
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
