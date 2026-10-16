# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "1.16.49"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "e0eaa458e33504cc89d69828ac74b3342a1e6467e2882912ecec544161ce599a"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "714c087a90165fddf524551d8829c093575e89349c7aeebc979455df91afe3ae"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "2fd8b22185e8bb4d171945075d37a83998fb0a29c87294a580a6efb47f902fb9"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "fdefbdcd684ccce22e835148013d7431a569c632e6951eb695616d1f5b90ce8e"
    end
  end

  # Drittanbieter-Lizenz-Attribution (Spec §12: llama.cpp-MIT + Qwen3-Apache-2.0)
  # als eigene Resource — brew lädt + verifiziert sie (SHA-256) und install legt
  # sie unter share/doc ab, damit die Attribution auch über den brew-Weg beim
  # Nutzer landet (nicht nur in .deb/.rpm).
  resource "third-party-licenses" do
    url "https://poisonzero.com/dl/v#{version}/THIRD_PARTY_LICENSES"
    sha256 "be49f64a4b5376e5117d7fbcf3c9b4c2106a9bae7d74d8e092ffc172a634e636"
  end

  def install
    bin.install Dir["poisonzero-*"].first => "poisonzero"
    # Command name poison0 (poisonzero stays the real file). No p0: brew link
    # would fail on another program's p0 (P0 Security CLI).
    bin.install_symlink "poisonzero" => "poison0"
    resource("third-party-licenses").stage do
      doc.install "THIRD_PARTY_LICENSES"
    end
  end

  def caveats
    <<~EOS
      Daemon-Setup (root) separat — im Panel (console.poisonzero.com) eine App anlegen, dann:
        sudo poison0 enroll  (nach Anlegen der enroll-Datei, siehe docs/INSTALL.md)
      Befehl: poison0 (poisonzero bleibt fuer bestehende Skripte). Kurzform p0 nur
      per Hand und nur, wenn der Name frei ist:
        ln -s poisonzero "$(brew --prefix)/bin/p0"
      Deinstallieren: Homebrew kann beim Entfernen nichts ausfuehren. Die Claude-Code-
      Hooks zuerst entfernen, sonst blockt Claude Code jeden Tool-Aufruf:
        poison0 remove-agent-integration && brew uninstall poisonzero
    EOS
  end

  test do
    assert_match "poisonzero", shell_output("#{bin}/poisonzero --version 2>&1", 0)
    assert_match "poisonzero", shell_output("#{bin}/poison0 --version 2>&1", 0)
  end
end
