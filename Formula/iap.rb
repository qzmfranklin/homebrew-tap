# Homebrew formula for the IAP CLI.
#
# GENERATED — do not edit by hand; the next release overwrites this file.
#
# Placeholders: v1-20260806-061850 10053dadc3e3f7d67a3d006273013894c74f1b520ca9c9a8f5235b4c5904b6df 81c0607aa54d54d25782ad20054b8474abbe162a48b55ee42475521164d1371b f0074bf85a4e8c1970922f0fa268e06cb593690458f583295399c12aad6b8437
class Iap < Formula
  desc "Identity-aware proxy CLI: dev pods, SSH, git, and model access"
  homepage "https://github.com/qzmfranklin/homebrew-tap"
  version "v1-20260806-061850"
  license :cannot_represent

  on_macos do
    # One universal (arm64 + x86_64) binary, matching what is published.
    url "https://github.com/qzmfranklin/homebrew-tap/releases/download/v1-20260806-061850/iap-darwin-universal.tar.xz"
    sha256 "10053dadc3e3f7d67a3d006273013894c74f1b520ca9c9a8f5235b4c5904b6df"
  end

  on_linux do
    on_intel do
      url "https://github.com/qzmfranklin/homebrew-tap/releases/download/v1-20260806-061850/iap-linux-amd64.tar.xz"
      sha256 "81c0607aa54d54d25782ad20054b8474abbe162a48b55ee42475521164d1371b"
    end
    on_arm do
      url "https://github.com/qzmfranklin/homebrew-tap/releases/download/v1-20260806-061850/iap-linux-arm64.tar.xz"
      sha256 "f0074bf85a4e8c1970922f0fa268e06cb593690458f583295399c12aad6b8437"
    end
  end

  def install
    # Clear a foreign `iap` out of Homebrew's bin BEFORE the keg is linked.
    #
    # The shell installer drops a real file at <prefix>/bin/iap. Homebrew
    # refuses to link over anything it does not own, so that file silently
    # wins: the keg installs, `brew link` fails, and `iap version` keeps
    # reporting the old build. Removing it makes `brew install` authoritative,
    # which is the stated policy -- Homebrew beats the script.
    #
    # This must happen in `install`, not `post_install`: FormulaInstaller#finish
    # calls link(keg) BEFORE post_install, so by then the link has already
    # failed. (`pre_install` is not a Homebrew hook at all -- defining one is
    # silently ignored.)
    #
    # Only a NON-symlink is removed. Homebrew's own links are symlinks into the
    # Cellar, so this cannot delete a link brew placed.
    foreign = HOMEBREW_PREFIX/"bin/iap"
    if foreign.exist? && !foreign.symlink?
      opoo "Removing #{foreign} (from the shell installer) so Homebrew can link its own."
      begin
        # chmod first: the installed binary is mode 0555, and unlink on a
        # read-only file raises EPERM even when we own it.
        foreign.chmod 0644
        foreign.unlink
      rescue Errno::EPERM, Errno::EACCES
        # Root-owned (an older sudo install). We cannot remove it unprivileged,
        # and aborting would leave the user with no working install at all, so
        # continue and tell them exactly what to run.
        opoo <<~WARNING
          Could not remove #{foreign} (permission denied).
          It will shadow this Homebrew install. Remove it with:
              sudo rm #{foreign}
          then run: brew link iap
        WARNING
      end
    end

    # A root-owned /usr/local/bin/iap cannot be removed from here (the formula
    # runs unprivileged, by design). Warn instead: whichever directory comes
    # first on PATH wins, so a leftover copy there silently shadows this keg and
    # the user sees an old version with no indication why.
    # Compared by prefix, not by realpath: bin/"iap" does not exist yet at this
    # point, and on Intel Homebrew the prefix IS /usr/local, where that path is
    # our own link rather than a stray copy.
    legacy = Pathname.new("/usr/local/bin/iap")
    if legacy.exist? && !legacy.to_s.start_with?("#{HOMEBREW_PREFIX}/")
      opoo <<~WARNING
        Another iap exists at #{legacy}.
        If it appears earlier in your PATH it will shadow this Homebrew install.
        Remove it with:
            sudo rm #{legacy}
      WARNING
    end

    bin.install "iap"

    # Ad-hoc codesign on macOS. This is INTENTIONAL and load-bearing, not a
    # workaround: the binary is unsigned, and macOS refuses to exec an unsigned
    # or stale-signed Mach-O. Writing the file also invalidates any prior
    # signature, so it must be re-signed after install.
    #
    # chmod first: Homebrew stages files read-only, and both xattr and codesign
    # need to WRITE to the binary (xattr fails with EACCES otherwise).
    if OS.mac?
      chmod 0755, bin/"iap"
      system "/usr/bin/xattr", "-cr", bin/"iap"
      system "/usr/bin/codesign", "--force", "--sign", "-", bin/"iap"
    end

    # `--print SHELL` writes the script to STDOUT and installs nothing; the bare
    # `iap complete` would edit the user's rc file, which a formula must not do.
    (bash_completion/"iap").write Utils.safe_popen_read(bin/"iap", "complete", "--print", "bash")
    (zsh_completion/"_iap").write Utils.safe_popen_read(bin/"iap", "complete", "--print", "zsh")
  end

  def caveats
    <<~EOS
      To sign in:
        iap login

      This install is managed by Homebrew, so upgrade it with:
        brew update && brew upgrade iap
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iap version")
  end
end
