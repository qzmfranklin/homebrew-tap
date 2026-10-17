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
repository, plus the `g4 git` collaboration command group (`g4 git land`,
`g4 git sync`, `g4 git fold`, `g4 git mend`, `g4 git view`, `g4 git web`)
usable on any plain git repository. The formula links ONE `git-g4`
symlink, so the group is also reachable through git itself as
`git g4 land`, `git g4 sync`, and so on — no per-repo configuration. The
plain `git land` form is deliberately NOT installed: a `git-<cmd>`
external on PATH would beat a repository's own aliases.

The git commands need NOTHING installed — no macFUSE, no
libfuse. Only `g4 mount`'s disk flavor uses the FUSE library, loading it
at runtime when you mount; when it is absent the mount refuses with the
one-line remedy (`brew install --cask macfuse`) instead of crashing, and
`g4 mount --flavor=bypass` needs no macFUSE at all.

#### Ubuntu (amd64 / arm64)

The same binary ships as .deb release assets — install directly:

```sh
curl -LO https://github.com/qzmfranklin/homebrew-tap/releases/download/g4-0.1.4/g4-0.1.4-linux-amd64.deb
sudo dpkg -i g4-0.1.4-linux-amd64.deb
```

(arm64: the same lines with `g4-0.1.4-linux-arm64.deb`.)

## Note on code signing

Artifacts here are ad-hoc signed, not notarized. Homebrew strips the
`com.apple.quarantine` attribute on install, so they run when installed
via `brew`. Downloading an asset directly from the Releases page and
opening it will NOT work -- Gatekeeper will block it. Use `brew`.

Recipes here are generated and overwritten on every release; do not edit
them by hand.
