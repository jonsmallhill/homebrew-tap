# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "1.16.86"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "c58d9bd92bcc1c86808def22acd9c10905d1c9655b1fa5bce0595946c856c7c7"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "0f908b2afe8362131471bf967334c03f8aa6af1a6e39ee376eea0566f5f5f8ce"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "fb523a1adaa85c79afb3e70c17f6b665e98b189d05a6645f11adbb4259075c81"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "f4f03d95cb77f4f750d06d5fdb9f67dfdaa1789e69bd5fd95576edae48f9e3d2"
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
