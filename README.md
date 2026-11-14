# qzmfranklin/tap

Homebrew tap.

## Formulae

### iap

```sh
brew install qzmfranklin/tap/iap
```

Identity-aware proxy CLI: dev pods, SSH, git, and model access.

Ships all four platforms: darwin-universal plus linux-amd64 and
linux-arm64 via the formula (both static musl — no glibc requirement,
they run on any linux the kernel supports), and a windows-amd64 .zip
release asset on the same tag (Homebrew cannot install on Windows).

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

On Linux both binaries (amd64 and arm64) are fully static (musl) — no
glibc requirement; they run on any linux the kernel supports (since
0.2.0; earlier releases needed glibc >= 2.35, Ubuntu 22.04 or newer,
and releases up to 0.1.11 also carried .deb assets that the naming
sweep retired). The darwin build is universal; there is no windows
build — the FUSE mount surface is unix-only.

### yag

```sh
brew install qzmfranklin/tap/yag
```

Workspace-sync git tooling: the `land`/`sync`/`fold`/`mend`/`view`/
`web`/`serve` collaboration verbs, invoked DIRECTLY as `yag land`,
`yag sync`, and so on — no `git yag` passthrough and no `git-yag`
symlink. Needs git >= 2.38 (the sync model uses `git merge-tree
--write-tree`).

On Linux both binaries (amd64 and arm64) are fully static (musl) — no
glibc requirement; they run on any linux the kernel supports (since
0.18.0; earlier releases needed glibc >= 2.35, Ubuntu 22.04 or
newer). The darwin build is universal, and the same tag carries a
windows-amd64 .zip release asset. Early releases also carried .deb
assets that the naming sweep retired — on Linux, use brew.

### klash

```sh
brew install qzmfranklin/tap/klash
```

Clash-compatible rule-based proxy client: one unprivileged `klash
serve` daemon owning all state, with the CLI as a frontend over a
local socket. The one formula serves macOS and Linux alike — the GUI
cask retired with the GUI (klash is a pure CLI).

On Linux both binaries (amd64 and arm64) are fully static (musl) — no
glibc requirement; they run on any linux the kernel supports (since
0.4.0; releases up to 0.3.0 needed glibc >= 2.35, Ubuntu 22.04 or
newer). The formula carries no dependencies on any host, so plain
`brew install` works everywhere. The darwin build is universal, and
the same tag carries a windows-amd64 .zip release asset.

TUN capture ships in the box: the per-call elevation helper is the
CLI's own hidden `tun-helper` subcommand (the single-binary shape
since 0.3.0), so `klash tun` elevates through it with no sibling
payload to install.

### magika

```sh
brew install qzmfranklin/tap/magika
```

File-content identification with deep learning (the first-party Rust
port of Google's magika): one self-contained binary identifies 294
content types from file bytes — the model is embedded, no runtime
downloads, CPU-only. `magika <file>`, `magika -r <dir>`, `--json`,
`--mime-type`, `--format` with the full placeholder engine.

On Linux both binaries (amd64 and arm64) are fully static (musl) — no
glibc requirement; they run on any linux the kernel supports (since
1.3.0; earlier releases needed glibc >= 2.35, Ubuntu 22.04 or
newer). The formula carries no dependencies on any host, so plain
`brew install` works everywhere. The darwin build is universal, and
the same tag carries a windows-amd64 .zip release asset.

### oyyama

```sh
brew install qzmfranklin/tap/oyyama
```

Large language model runner, interoperable with the community
`ollama`: it reads the same model cache (OLLAMA_MODELS,
~/.ollama/models) and serves the same OpenAI-compatible API, so the
two can coexist on one machine. `oyyama pull`, `oyyama run`,
`oyyama serve`, and the bench/eval/show/list verbs drive local models
(llama-family text and multimodal).

On Linux both binaries (amd64 and arm64) are fully static (musl) — no
glibc requirement; they run on any linux the kernel supports (since
1.1.0; the 1.0.0 release needed glibc >= 2.35, Ubuntu 22.04 or
newer). The formula carries no dependencies on any host, so plain
`brew install` works everywhere. The darwin build is universal, and
the same tag carries a windows-amd64 .zip release asset.

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

On Linux both binaries (amd64 and arm64) are fully static (musl) — no
glibc requirement; they run on any linux the kernel supports (since
0.1.0; the 0.0.x releases needed glibc >= 2.35, Ubuntu 22.04 or
newer). The formula carries no dependencies on any host, so plain
`brew install` works everywhere. The darwin build is universal, and
the same tag carries a windows-amd64 .zip release asset.

### rea

```sh
brew install qzmfranklin/tap/rea
```

Analyze binaries through the REA evidence engine: 279 tools over one
binary -- the clean-room disassembly/pseudocode engine, the executable
format parsers, the analysis lanes, the MCP server and the deep CLI.

On Linux both binaries (amd64 and arm64) are fully static (musl) — no
glibc requirement; they run on any linux the kernel supports (since
0.2.0; the 0.1.0 release needed glibc >= 2.35, Ubuntu 22.04 or
newer). The formula carries no dependencies on any host, so plain
`brew install` works everywhere. The darwin build is universal, and
the same tag carries the windows-amd64 .zip release asset -- Homebrew
cannot install on Windows.

### surf

```sh
brew install qzmfranklin/tap/surf
```

Headless browser engine CLI: fetch, serve CDP, extract design, speak
MCP.

Ships darwin-universal and linux-amd64 (generated asset names since
0.2.7). The linux binary is glibc-dynamic — the embedded v8 engine
pins the glibc lane — so it needs glibc >= 2.35 (Ubuntu 22.04 or
newer; on older hosts, `brew install --ignore-dependencies surf`).
windows-amd64 ships since 0.2.8, and linux-arm64 is pending an
aarch64 engine pin.

## Casks

### courier

```sh
brew install --cask qzmfranklin/tap/courier
```

AI coding agent: a long-lived daemon owns the backend and every
`~/.courier` state write, with the CEF desktop app as its frontend
(the `courier run`/`chat` TUI, `courier web` and the `courier` CLI are
frontends over the same daemon). The cask installs the macOS app —
the current 0.1.15 asset is named "universal" but is arm64-only, and
the next release ships the honest -darwin-arm64 name; the same binary
carries the CLI subcommands.

Also ships linux-amd64 (the `courier` formula) and a windows-amd64
release asset; no linux-arm64 — no static CEF arm64 distribution
exists.

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

### vype

```sh
brew install --cask qzmfranklin/tap/vype
```

Voice-driven input method and dictation for the Mac.

The cask ships darwin arm64 — the current 1.1.1 asset is named
"universal" but is arm64-only, and the next release ships the honest
-darwin-arm64 name. vype is a macOS/iOS/Android product — no linux
or windows on the tap; the iOS and Android builds ship from the
separate channel at github.com/qzmfranklin/vype.

## Note on code signing

Artifacts here are ad-hoc signed, not notarized. Homebrew strips the
`com.apple.quarantine` attribute on install, so they run when installed
via `brew`. Downloading an asset directly from the Releases page and
opening it will NOT work -- Gatekeeper will block it. Use `brew`.

Recipes here are generated and overwritten on every release; do not edit
them by hand.
