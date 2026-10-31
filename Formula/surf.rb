# surf — the in-house union browser engine CLI (plan modules/surf 0002-04,
# row publish-row; operator decisions 2026-10-30: tap qzmfranklin/homebrew-tap,
# prebuilt-binary delivery).
#
# PREBUILT BINARY FORMULA. Each platform downloads a release tarball from the
# tap repo's GitHub releases (surf-<ver>-<triple>.tar.gz — `surf` + `worker`
# at the archive root): the linux one is assembled and verified by
# modules/surf/publish/package.sh, the darwin-arm64 one by the same-flags
# deterministic assembly from the cross-built hardened pair (tip 7b63368af,
# preserved on g0733 at /cache/quzhongming/surf-dist).
#
# THE WORKER INSTALLS INTO bin BESIDE surf — ON PURPOSE. The CLI locates its
# worker sibling at <exe_dir>/worker (private/cli/fetch/scrape's
# worker_binary_candidates: the install layout, "a Homebrew pour", checked
# FIRST, before the Bazel runfiles layout). A worker in libexec without a bin
# entry, or renamed, ships a broken `surf fetch --file` batch mode — so
# `bin.install "worker"` it is, generic name and all.
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
      arm: "https://github.com/qzmfranklin/homebrew-tap/releases/download/surf-v0.2.4/surf-0.2.4-aarch64-apple-darwin.tar.gz",
    ),
    linux: on_arch_conditional(
      intel: "https://github.com/qzmfranklin/homebrew-tap/releases/download/surf-v0.2.4/surf-0.2.4-x86_64-unknown-linux-gnu.tar.gz",
    ),
  )
  version "0.2.4"
  sha256 on_system_conditional(
    macos: on_arch_conditional(
      arm: "e41fff27e77b0f78ed91cbfa142106f76819ca4efd30f390cddb58f55ba2bb67",
    ),
    linux: on_arch_conditional(
      intel: "976c264f76690e606f549927d8d419836bdb3dc1b57c839efb57c984e43faa6a",
    ),
  )
  license :cannot_represent

  def install
    # Install layout: both binaries in the SAME bin (the class comment says
    # why the worker cannot live elsewhere).
    bin.install "surf"
    bin.install "worker"

    # Ad-hoc codesign on macOS for BOTH binaries (the obscura pattern). This
    # is INTENTIONAL and load-bearing, not a workaround: the darwin artifacts
    # are unsigned Mach-O, and macOS refuses to exec an unsigned or
    # stale-signed binary. Writing the file also invalidates any prior
    # signature, so each must be re-signed after install.
    #
    # chmod first: Homebrew stages files read-only, and both xattr and
    # codesign need to WRITE to the binary (xattr fails with EACCES
    # otherwise).
    if OS.mac?
      ["surf", "worker"].each do |b|
        chmod 0755, bin/b
        system "/usr/bin/xattr", "-cr", bin/b
        system "/usr/bin/codesign", "--force", "--sign", "-", bin/b
      end
    end
  end

  # The version check is the CLI's own --version (clap prints
  # "surf <SURF_BUILD_VERSION>"; the pin lives in impl/surf/BUILD.bazel).
  test do
    assert_match "surf #{version}", shell_output("#{bin}/surf --version")
    assert_predicate bin/"worker", :exist?, "the worker must sit beside the CLI"
  end
end
