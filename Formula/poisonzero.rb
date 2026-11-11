# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "1.16.74"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "2d9d203692556bd4799e38dd652bdb11fc8b3b30e2bdc3ed486b1f8c306f5294"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "302dd5a03ebbc262a4ba5a0747fc93e660e238f807ec15f71e16837922b484fc"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "c4870272ebac4a355a33a9d8dc452f2aa812cd7eacc1567b821d91b271ba4278"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "989fb999787eac5171e1b9aec402ee27cc1b081db339594ba0f4c6f99eba6ef1"
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
