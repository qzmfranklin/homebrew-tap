# rea — the rules_native reverse-engineering CLI (plan
# modules/rules_native/plan/0003-03, row 3.3): 279 tools over one binary —
# the clean-room disassembly/pseudocode engine, the parsers, the analysis
# lanes, the MCP server and the deep CLI. Prebuilt-binary formula (the
# surf shape): each platform downloads a release tarball from the tap
# repo's GitHub releases; the darwin artifact ships unsigned and is
# ad-hoc codesigned at install (the obscura pattern). The Windows build
# is a release asset (rea-windows-amd64.zip), not a formula — Homebrew
# cannot install on Windows (the courier 0004-03 ruling).
class Rea < Formula
  desc "Reverse-engineering CLI: 279 tools over one binary — disassembly, formats, analysis, MCP"
  homepage "https://github.com/qzmfranklin/homebrew-tap"
  url on_system_conditional(
    macos: on_arch_conditional(
      arm: "https://github.com/qzmfranklin/homebrew-tap/releases/download/rea-v1.0.0/rea-1.0.0-aarch64-apple-darwin.tar.gz",
    ),
    linux: on_arch_conditional(
      intel: "https://github.com/qzmfranklin/homebrew-tap/releases/download/rea-v1.0.0/rea-1.0.0-x86_64-unknown-linux-gnu.tar.gz",
    ),
  )
  version "1.0.0"
  sha256 on_system_conditional(
    macos: on_arch_conditional(
      arm: "277a786698c6d06d1ee0e58c16340b673bd4111a250d879cdbde751d32a34449",
    ),
    linux: on_arch_conditional(
      intel: "bf12bf422f91c04c316722c06979be3db76e59372b6bf490b81b1e661fc79255",
    ),
  )
  license :cannot_represent

  def install
    bin.install "rea-linux" => "rea" if OS.linux?
    bin.install "rea-darwin" => "rea" if OS.mac?

    # Ad-hoc codesign on macOS (the obscura pattern): the darwin artifact
    # ships unsigned and macOS refuses to exec an unsigned binary; writing
    # the file at install also invalidates any prior signature.
    if OS.mac?
      chmod 0755, bin/"rea"
      system "codesign", "--force", "--sign", "-", bin/"rea"
    end
  end

  def caveats
    on_macos do
      "The darwin build is arm64-only (no x86_64-mac artifact is built)."
    end
  end

  test do
    assert_match "rea", shell_output("#{bin}/rea --version")
  end
end
