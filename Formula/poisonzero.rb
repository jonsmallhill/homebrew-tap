# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "1.16.50"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "37116b328205532b3e94fd0ce3d7ddd34c360357ec48a7177e28b40c956bff6a"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "11f59d465548ddefd461cef6716ba993423b7c612757cf9f6db03c91a4fcd7a5"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "f82a61df8568e7e7032cc83e4fc17435fb6d8a96f490a112a0162037f1d817cb"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "3ef82489b75c9f3dd7eca14a69b924e91fdce4edb87304a7fb4c2581a511a1d5"
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
