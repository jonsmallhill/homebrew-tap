# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "1.16.78"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "9e99f1786f8e871b8d253e8ebf7e6c948ccbad58c26188f6b2d9af3ea0af263c"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "6bc7cb1c721ddabc85f0bdc83b7beb9bbd4ab0e80dbf34cc48c88c5936339440"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "44e8043c48093e282f5354d52d520458bdca317328464cec93f8df3cd0be3407"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "e0517695b28410ebbb738a6e1b7f78f51b67258c31678eee9a72746f3ac66444"
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
