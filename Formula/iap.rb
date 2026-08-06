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
    # Warn about any other `iap` that will shadow this keg.
    #
    # The formula CANNOT delete these: `install` runs inside Homebrew's sandbox,
    # which permits writes only under the Cellar, so unlinking <prefix>/bin/iap
    # fails with EPERM regardless of file ownership. (`post_install` is no help
    # either -- FormulaInstaller#finish calls link(keg) BEFORE it, so the link
    # has already failed by then; and `pre_install` is not a hook at all.)
    #
    # So the honest thing is to name the file and the exact command. The shell
    # installer removes it automatically, since it runs unsandboxed.
    [HOMEBREW_PREFIX/"bin/iap", Pathname.new("/usr/local/bin/iap")].uniq.each do |other|
      next unless other.exist?
      # A symlink under our own prefix is Homebrew's own link, not a stray copy.
      next if other.symlink? && other.to_s.start_with?("#{HOMEBREW_PREFIX}/")

      opoo <<~WARNING
        Another iap exists at #{other} and will shadow this Homebrew install.
        Remove it, then re-link:
            #{other.writable? ? "" : "sudo "}rm #{other}
            brew link iap
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
