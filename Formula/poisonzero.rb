# Homebrew-Formula (CLI) für PoisonZero. `brew install jonsmallhill/tap/poisonzero`.
# NICHT von Hand pflegen: wird vom Release-Workflow regeneriert
# (scripts/update-homebrew-formula.js im Haupt-Repo).
class Poisonzero < Formula
  desc "Protects AI agent memory files from poisoning (fail-closed, AI-scored)"
  homepage "https://poisonzero.com"
  version "0.6.2"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-arm64"
      sha256 "0829da0c1a1cfea9cf949a8f0cee1c95cedbfd80d598db7468685e65b7ed8311"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-darwin-amd64"
      sha256 "0817933658deda2b42af77d94f705e0aca4b8ad66948b66d1eb3a4087c750092"
    end
  end

  on_linux do
    on_arm do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-arm64"
      sha256 "576f3e56db3fddd896a2ba54f2287cccd9f449760f9783846e70afba37c310c3"
    end
    on_intel do
      url "https://poisonzero.com/dl/v#{version}/poisonzero-linux-amd64"
      sha256 "8663378786d07bee202b67fc4e190cc810f18bdcfc8ae65c91e483fd3a9d657c"
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
