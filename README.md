# Colt

A vi text editor written in [Pony](https://www.ponylang.io/).

## Building

Requires `ponyc` (tested with 0.63.0).

```sh
ponyc -o . --linker=cc
```

## Usage

```sh
./Colt [filename]
```

## Features

### Modes

- **Normal** -- default mode for navigation and commands
- **Insert** -- text entry (`i`, `a`, `o`, etc.)
- **Command** -- ex commands via `:`
- **Search** -- find text via `/` or `?`

### Keybindings

#### Movement

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Left, down, up, right |
| Arrow keys | Directional movement |
| `w` `b` `e` | Word forward, backward, end |
| `0` `$` `^` | Line start, end, first non-blank |
| `gg` `G` | File start, end |
| `H` `M` `L` | Screen top, middle, bottom |
| `Ctrl-F` `Ctrl-B` | Page down, up |
| `Ctrl-D` `Ctrl-U` | Half-page down, up |

#### Editing

| Key | Action |
|-----|--------|
| `i` `I` `a` `A` | Insert before/at start/after/at end |
| `o` `O` | Open line below/above |
| `x` `X` | Delete char at/before cursor |
| `dd` | Delete line |
| `D` | Delete to end of line |
| `C` | Change to end of line |
| `J` | Join lines |
| `r` | Replace single character |
| `~` | Toggle case |
| `yy` | Yank line |
| `p` `P` | Paste after/before |
| `u` | Undo (up to 200 levels) |

#### Search

| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` `N` | Next/previous match |

#### Commands

| Command | Action |
|---------|--------|
| `:w` | Save |
| `:q` | Quit |
| `:wq` `:x` | Save and quit |
| `:q!` | Force quit |
| `:w filename` | Save as |
| `:e filename` | Open file |
| `:123` | Go to line 123 |
| `ZZ` | Save and quit |
| `ZQ` | Quit without saving |

All movement commands accept numeric prefixes (e.g. `5j` moves down 5 lines).
