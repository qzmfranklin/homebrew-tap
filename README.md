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

On Linux the binary is fully static (musl) — no glibc requirement; it
runs on any linux the kernel supports (since 0.2.0; earlier releases
needed glibc >= 2.35, Ubuntu 22.04 or newer, and releases up to 0.1.11
also carried .deb assets that the naming sweep retired).

### yag

```sh
brew install qzmfranklin/tap/yag
```

Workspace-sync git tooling: the `land`/`sync`/`fold`/`mend`/`view`/
`web`/`serve` collaboration verbs, invoked DIRECTLY as `yag land`,
`yag sync`, and so on — no `git yag` passthrough and no `git-yag`
symlink. Needs git >= 2.38 (the sync model uses `git merge-tree
--write-tree`).

On Linux the binary is fully static (musl) — no glibc requirement; it
runs on any linux the kernel supports (since 0.18.0; earlier releases
needed glibc >= 2.35, Ubuntu 22.04 or newer).

The same binary ships as .deb release assets — install directly:

```sh
curl -LO https://github.com/qzmfranklin/homebrew-tap/releases/download/yag-0.1.0/yag-0.1.0-linux-amd64.deb
sudo dpkg -i yag-0.1.0-linux-amd64.deb
```

(arm64: the same lines with `yag-0.1.0-linux-arm64.deb`.)

### klash

```sh
brew install qzmfranklin/tap/klash
```

Clash-compatible rule-based proxy client: one unprivileged `klash
serve` daemon owning all state, with the CLI as a frontend over a
local socket. On macOS the same token is a cask —
`brew install --cask qzmfranklin/tap/klash` — installing the GUI app
with the CLI linked into `$(brew --prefix)/bin`.

On Linux the formula is a single prebuilt binary against glibc >= 2.35
(Ubuntu 22.04 or newer). On glibc >= 2.39 hosts (Ubuntu 24.04+) a
plain `brew install qzmfranklin/tap/klash` works; on older glibc use
`brew install --ignore-dependencies qzmfranklin/tap/klash` — the
formula carries no real dependencies, so Homebrew's synthetic global
gcc/glibc deps are safe to skip.

TUN capture is not available in the brew install: the per-call
elevation helper does not ship beside the binary, so `klash tun`
reports that it cannot locate klash-tun-helper. Every other verb
(serve, status, profile, proxy, conn, traffic, ...) is fully
functional.

### magika

```sh
brew install qzmfranklin/tap/magika
```

File-content identification with deep learning (the first-party Rust
port of Google's magika): one self-contained binary identifies 294
content types from file bytes — the model is embedded, no runtime
downloads, CPU-only. `magika <file>`, `magika -r <dir>`, `--json`,
`--mime-type`, `--format` with the full placeholder engine.

On Linux the binary is fully static (musl) — no glibc requirement; it
runs on any linux the kernel supports (since 1.3.0; earlier releases
needed glibc >= 2.35, Ubuntu 22.04 or newer). The formula carries no
dependencies on any host, so plain `brew install` works everywhere.

### obscura

```sh
brew install qzmfranklin/tap/obscura
```

Headless browser engine: CDP and MCP servers with a fetch/scrape CLI.
Two binaries install side by side -- `obscura` and the `obscura-worker`
its scrape path spawns internally (nothing to run or configure by hand).
Rendering uses the system's own font collection; no fonts are bundled.

On Linux the formula is a single prebuilt binary against glibc >= 2.35
(Ubuntu 22.04 or newer). On glibc >= 2.39 hosts (Ubuntu 24.04+) a
plain `brew install qzmfranklin/tap/obscura` works; on older glibc use
`brew install --ignore-dependencies qzmfranklin/tap/obscura` -- the
formula carries no real dependencies, so Homebrew's synthetic global
gcc/glibc deps are safe to skip.

### aseprite

```sh
brew install qzmfranklin/tap/aseprite
```

Sprite animation and batch-export CLI (the pure-Rust aseprite port):
headless pixel-animation authoring -- build sprites (layers, cels,
frames, tags, palettes), draw, composite, quantize and dither, and
export .aseprite / PNG / GIF / spritesheets deterministically, all in
one self-contained binary (every codec compiled in, no runtime
downloads). The GUI is not part of the port; `aseprite -b` is batch
mode.

On Linux the binary is fully static (musl) — no glibc requirement; it
runs on any linux the kernel supports (since 0.1.0; the 0.0.x releases
needed glibc >= 2.35, Ubuntu 22.04 or newer). The formula carries no
dependencies on any host, so plain `brew install` works everywhere.

### rea

```sh
brew install qzmfranklin/tap/rea
```

Analyze binaries through the REA evidence engine: 279 tools over one
binary -- the clean-room disassembly/pseudocode engine, the executable
format parsers, the analysis lanes, the MCP server and the deep CLI.

On Linux the binary is fully static (musl) — no glibc requirement; it
runs on any linux the kernel supports (since 0.2.0; the 0.1.0 release
needed glibc >= 2.35, Ubuntu 22.04 or newer). The formula carries no
dependencies on any host, so plain `brew install` works everywhere.
The Windows build is a release asset (rea-windows-amd64.zip), not a
formula -- Homebrew cannot install on Windows.

## Casks

### courier

```sh
brew install --cask qzmfranklin/tap/courier
```

AI coding agent: a long-lived daemon owns the backend and every
`~/.courier` state write, with the CEF desktop app as its frontend
(the `courier run`/`chat` TUI, `courier web` and the `courier` CLI are
frontends over the same daemon). The cask installs the macOS app
(universal arm64 + x86_64); the same binary carries the CLI subcommands.

### ftop

```sh
brew install --cask qzmfranklin/tap/ftop
```

Floating macOS status-monitor panel (Apple Silicon, macOS 15+): per-core
CPU and frequency, memory, GPU, power and the top processes, drawn in one
compact always-available window. The app installs into `/Applications` and
the `ftop` command is linked into your PATH; `ftop` opens the panel,
`ftop update` upgrades the brew copy in place (it runs
`brew upgrade --cask ftop`), `ftop doctor` reports which readings are
available, and one `sudo ftop grant` extends the process list to every user
(the setuid helper lives outside the bundle, so updates never change what
runs as root).

## Note on code signing

Artifacts here are ad-hoc signed, not notarized. Homebrew strips the
`com.apple.quarantine` attribute on install, so they run when installed
via `brew`. Downloading an asset directly from the Releases page and
opening it will NOT work -- Gatekeeper will block it. Use `brew`.

Recipes here are generated and overwritten on every release; do not edit
them by hand.
