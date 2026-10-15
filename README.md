# qzmfranklin/tap

Homebrew tap.

## Formulae

### iap

```sh
brew install qzmfranklin/tap/iap
```

Identity-aware proxy CLI: dev pods, SSH, git, and model access.

### g4

```sh
brew install qzmfranklin/tap/g4
```

Linear-trunk version control: a FUSE virtual filesystem for mounting the
repository, plus the `git` collaboration commands (`git land`, `git sync`,
`git fold`, `git mend`, `git view`, `git web`) usable on any plain git
repository. The git commands need NOTHING installed — no macFUSE, no
libfuse. Only `g4 mount`'s disk flavor uses the FUSE library, loading it
at runtime when you mount; when it is absent the mount refuses with the
one-line remedy (`brew install --cask macfuse`) instead of crashing, and
`g4 mount --flavor=bypass` needs no macFUSE at all.

#### Ubuntu (amd64 / arm64)

The same binary ships as .deb release assets — install directly:

```sh
curl -LO https://github.com/qzmfranklin/homebrew-tap/releases/download/g4-0.1.1/g4-0.1.1-linux-amd64.deb
sudo dpkg -i g4-0.1.1-linux-amd64.deb
```

(arm64: the same lines with `g4-0.1.1-linux-arm64.deb`.)

## Note on code signing

Artifacts here are ad-hoc signed, not notarized. Homebrew strips the
`com.apple.quarantine` attribute on install, so they run when installed
via `brew`. Downloading an asset directly from the Releases page and
opening it will NOT work -- Gatekeeper will block it. Use `brew`.

Recipes here are generated and overwritten on every release; do not edit
them by hand.
