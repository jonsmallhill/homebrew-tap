# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "1.16.64"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "0ca4d218a3d695910975d10bdc74f37dc8f655e14b21ce736734fb715b122e70"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "637e1ef19ded64c3d4665cb772832353805b34ad368634f2776ee68354b28e10"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "5c90dca3a1515990c36d7561b60743ea91f13451efe933ee6918c59c2f0921dd"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "cd63951f4f38550ade3ab5029554597817bbdcc07c045321f372bfd733206791"
    end
  end

  # Drittanbieter-Lizenz-Attribution (Spec §12: llama.cpp-MIT + Qwen3-Apache-2.0)
  # als eigene Resource — brew lädt + verifiziert sie (SHA-256) und install legt
  # sie unter share/doc ab, damit die Attribution auch über den brew-Weg beim
  # Nutzer landet (nicht nur in .deb/.rpm).
  resource "third-party-licenses" do
    url "https://poisonzero.com/dl/v#{version}/THIRD_PARTY_LICENSES"
    sha256 "ce5755d2ce1b1462fcfbd5cbebde80e62222bb1692e8f0ce7e4408d2cbd2fcf5"
  end

  def install
    # Since RC10 poison0 is the program file; poisonzero is a symlink to it
    # for scripts and old hooks. No p0: brew link would fail on another
    # program's p0 (P0 Security CLI).
    bin.install Dir["poisonzero-*"].first => "poison0"
    bin.install_symlink "poison0" => "poisonzero"
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
        ln -s poison0 "$(brew --prefix)/bin/p0"
      Deinstallieren: Homebrew kann beim Entfernen nichts ausfuehren. Die Claude-Code-
      Hooks zuerst entfernen, sonst blockt Claude Code jeden Tool-Aufruf:
        poison0 remove-agent-integration && brew uninstall poisonzero
    EOS
  end

  test do
    assert_match(/poison(zero|0)/, shell_output("#{bin}/poisonzero --version 2>&1", 0))
    assert_match(/poison(zero|0)/, shell_output("#{bin}/poison0 --version 2>&1", 0))
  end
end
