# surf — the in-house union browser engine CLI (plan modules/surf 0002-04,
# row publish-row; operator decisions 2026-10-30: tap qzmfranklin/homebrew-tap,
# prebuilt-binary delivery).
#
# PREBUILT BINARY FORMULA. Each platform downloads a release tarball from the
# tap repo's GitHub releases (surf-<ver>-<triple>.tar.gz — .tar.xz on linux,
# 0002-10 row linux-artifact-form — the SINGLE `surf` binary at the archive
# root): the linux one is assembled and verified by
# modules/surf/publish/package.sh, the darwin-arm64 one by the same script's
# darwin leg — both built through the in-graph cross targets
# (@surf//surf:surf_linux_amd64 / surf_darwin_arm64, plan modules/surf
# 0002-09 rows publish-cross-targets + publish-windows-pair).
#
# ONE BINARY, NO WORKER INSTALL (plan modules/surf 0002-09 row
# worker-absorption): the worker rides inside the CLI as a hidden `worker`
# subcommand the batch mode re-execs, so there is no sibling binary to
# place — the old `bin.install "worker"` and its <exe_dir>/worker lookup
# are gone.
#
# NO WINDOWS STANZA — homebrew does not serve windows. The windows-amd64
# tarball (surf-<ver>-x86_64-pc-windows-msvc.tar.gz, the same package.sh
# assembly with the pe() shape check) rides the same release — the PLAIN
# surf-<ver> tag (0002-10 row tag-without-v; no 'v') — as a release ASSET
# only; modules/surf/publish/README.md records that channel.
#
# Platform choice lives in on_system_conditional, NOT in on_macos/on_linux
# blocks: brew does not allow `url`/`sha256` inside an on_system block (the
# tap's convention — see the yag/obscura formulas). The macos side is
# arm-only (the darwin artifact is aarch64; no x86_64-mac or linux-arm
# artifact is built), so intel macs and linux-arm fail at fetch time
# instead of silently installing a wrong-arch binary.
class Surf < Formula
  desc "Headless browser engine CLI: fetch, serve CDP, extract design, speak MCP"
  homepage "https://github.com/qzmfranklin/homebrew-tap"
  url on_system_conditional(
    macos: on_arch_conditional(
      arm: "https://github.com/qzmfranklin/homebrew-tap/releases/download/surf-0.2.6/surf-0.2.6-aarch64-apple-darwin.tar.gz",
    ),
    linux: on_arch_conditional(
      intel: "https://github.com/qzmfranklin/homebrew-tap/releases/download/surf-0.2.6/surf-0.2.6-x86_64-unknown-linux-gnu.tar.xz",
    ),
  )
  version "0.2.6"
  sha256 on_system_conditional(
    macos: on_arch_conditional(
      arm: "fd4a8fbe907b559cf07e0c5c8d94438012b83c7766c632d7a1e7f6e0510ff11b",
    ),
    linux: on_arch_conditional(
      intel: "d50c917e461b1b65dc0ca431b4e21d4b77674ebe52b1a7df7e28f9551acdc405",
    ),
  )
  license :cannot_represent

  def install
    # ONE binary — the worker rides inside it as the hidden `worker`
    # subcommand the batch mode re-execs (plan modules/surf 0002-09 row
    # worker-absorption), so there is no sibling to place.
    bin.install "surf"

    # Ad-hoc codesign on macOS (the obscura pattern). This is INTENTIONAL
    # and load-bearing, not a workaround: the darwin artifacts are unsigned
    # Mach-O, and macOS refuses to exec an unsigned or stale-signed binary.
    # Writing the file also invalidates any prior signature, so it must be
    # re-signed after install.
    #
    # chmod first: Homebrew stages files read-only, and both xattr and
    # codesign need to WRITE to the binary (xattr fails with EACCES
    # otherwise).
    if OS.mac?
      chmod 0755, bin/"surf"
      system "/usr/bin/xattr", "-cr", bin/"surf"
      system "/usr/bin/codesign", "--force", "--sign", "-", bin/"surf"
    end
  end

  # The version check is the CLI's own --version (clap prints
  # "surf <SURF_BUILD_VERSION>"; the pin lives in impl/surf/BUILD.bazel).
  # The absorbed worker subcommand is not exercised here — its stdin
  # protocol is package.sh's --check, not brew's smoke test.
  test do
    assert_match "surf #{version}", shell_output("#{bin}/surf --version")
  end
end
