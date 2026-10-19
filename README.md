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

Linear-trunk version control: the FUSE virtual filesystem for
mounting the repository. Only `g4 mount`'s disk flavor uses the FUSE
library, loading it at runtime when you mount; when it is absent the
mount refuses with the one-line remedy (`brew install --cask macfuse`)
instead of crashing, and `g4 mount --flavor=bypass` needs no macFUSE at
all. The git collaboration commands live in their own product — the
`yag` formula below.

#### Ubuntu (amd64 / arm64)

The same binary ships as .deb release assets — install directly:

```sh
curl -LO https://github.com/qzmfranklin/homebrew-tap/releases/download/g4-0.1.9/g4-0.1.9-linux-amd64.deb
sudo dpkg -i g4-0.1.9-linux-amd64.deb
```

(arm64: the same lines with `g4-0.1.9-linux-arm64.deb`.)

### yag

```sh
brew install qzmfranklin/tap/yag
```

Workspace-sync git tooling: the `land`/`sync`/`fold`/`mend`/`view`/
`web`/`serve` collaboration verbs, invoked DIRECTLY as `yag land`,
`yag sync`, and so on — no `git yag` passthrough and no `git-yag`
symlink. Needs git >= 2.38 (the sync model uses `git merge-tree
--write-tree`).

On Linux the formula is a single prebuilt binary against glibc >= 2.35
(Ubuntu 22.04 or newer). On glibc >= 2.39 hosts (Ubuntu 24.04+) a
plain `brew install qzmfranklin/tap/yag` works; on older glibc use
`brew install --ignore-dependencies qzmfranklin/tap/yag` — the
formula carries no real dependencies, so Homebrew's synthetic global
gcc/glibc deps are safe to skip.

The same binary ships as .deb release assets — install directly:

```sh
curl -LO https://github.com/qzmfranklin/homebrew-tap/releases/download/yag-0.1.0/yag-0.1.0-linux-amd64.deb
sudo dpkg -i yag-0.1.0-linux-amd64.deb
```

(arm64: the same lines with `yag-0.1.0-linux-arm64.deb`.)

## Note on code signing

Artifacts here are ad-hoc signed, not notarized. Homebrew strips the
`com.apple.quarantine` attribute on install, so they run when installed
via `brew`. Downloading an asset directly from the Releases page and
opening it will NOT work -- Gatekeeper will block it. Use `brew`.

Recipes here are generated and overwritten on every release; do not edit
them by hand.
