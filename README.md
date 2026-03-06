# Personal ZSH Aliases Configuration

This repository provides a minimal and modular configuration for managing **ZSH aliases** on macOS.

Instead of cluttering your `~/.zshrc` with many aliases, this setup keeps them in a dedicated file:

```

~/.zsh_aliases

```

The provided `setup.sh` script installs aliases automatically and allows you to enable only the alias groups (profiles) you need.

---

# Features

- Modular **alias profiles**
- Simple CLI installer
- Automatic `.zshrc` integration
- Safe backups before changes
- Profile selection (`--profiles`)
- Dry-run preview (`--dry-run`)
- Profile discovery (`--list-profiles`)
- Profile removal (`--remove`)
- Colored CLI output
- Optional uninstall script

---

# Repository Structure

```

.
├── setup.sh
├── uninstall.sh
├── .zsh_aliases
├── .zshrc_edit
└── README.md

````

### File overview

| File | Purpose |
|-----|------|
| `setup.sh` | Installs and configures aliases |
| `uninstall.sh` | Removes aliases and restores configuration |
| `.zsh_aliases` | Template containing all alias profiles |
| `.zshrc_edit` | Lines appended to `.zshrc` to load aliases |

---

# Installation

Clone the repository:

```bash
git clone <repo-url>
cd zsh-aliases
````

Run the setup script:

```bash
./setup.sh
```

Then reload your shell:

```bash
source ~/.zshrc
```

---

# Setup Options

## Default Setup

Installs only the **general** aliases.

```bash
./setup.sh
```

---

## Install Specific Profiles

You can install only the profiles you need.

```bash
./setup.sh --profiles=git,brew
```

Short form:

```bash
./setup.sh -p=pnpm,vscprofiles
```

The `general` profile is **always installed automatically**.

---

## Install All Profiles

```bash
./setup.sh --profiles=ALL
```

---

## List Available Profiles

```bash
./setup.sh --list-profiles
```

Example output:

```
general
brew
git
pnpm
vscprofiles
```

---

## Preview Changes (Dry Run)

Show what would be generated without modifying files.

```bash
./setup.sh --dry-run --profiles=git
```

---

## Remove Profiles

You can remove profiles from the current configuration.

```bash
./setup.sh --remove=git
```

---

# Manual Setup

If you prefer not to run the script, you can configure aliases manually.

### 1. Copy aliases file

```bash
cp .zsh_aliases ~/.zsh_aliases
```

### 2. Append loader to `.zshrc`

```bash
cat .zshrc_edit >> ~/.zshrc
```

### 3. Reload shell

```bash
source ~/.zshrc
```

You may optionally edit `.zsh_aliases` before copying it.

---

# Usage

Once installed, aliases are available in your terminal.

Example:

Instead of typing:

```bash
cd ..
```

You can simply use:

```bash
.
```

Aliases can be modified anytime by editing:

```
~/.zsh_aliases
```

Then reload:

```bash
source ~/.zshrc
```

---

# Available Profiles

Aliases are grouped into profiles inside `.zsh_aliases`.

---

## `general` (Default)

| Alias   | Command         | Description                 |
| ------- | --------------- | --------------------------- |
| `.`     | `cd ..`         | Move up one directory       |
| `..`    | `cd ../../`     | Move up two directories     |
| `awake` | `caffeinate -d` | Prevent macOS from sleeping |

---

## `brew`

| Alias   | Command                                                   | Description               |
| ------- | --------------------------------------------------------- | ------------------------- |
| `bi`    | `brew install`                                            | Install a package         |
| `bic`   | `brew install --cask`                                     | Install a cask            |
| `bup`   | `brew update`                                             | Update Homebrew           |
| `bupg`  | `brew upgrade`                                            | Upgrade packages          |
| `blist` | `brew list`                                               | List installed packages   |
| `bfull` | `brew update && brew upgrade && brew cleanup --prune=all` | Full Homebrew maintenance |

---

## `git`

| Alias | Command               | Description          |
| ----- | --------------------- | -------------------- |
| `ga`  | `git add --all`       | Stage all changes    |
| `gb`  | `git branch`          | List branches        |
| `gc`  | `git clone`           | Clone repository     |
| `gcm` | `git commit -m`       | Commit with message  |
| `gco` | `git checkout`        | Switch branch        |
| `gf`  | `git fetch`           | Fetch remote changes |
| `gp`  | `git pull`            | Pull remote changes  |
| `gd`  | `git diff`            | Show differences     |
| `gl`  | `git log`             | Commit history       |
| `gle` | `git log --graph ...` | Pretty git tree log  |

---

## `pnpm`

These aliases redirect `npm` commands to `pnpm` to help reduce disk usage.

| Alias         | Command        | Description          |
| ------------- | -------------- | -------------------- |
| `npm`         | `pnpm`         | Replace npm          |
| `npx`         | `pnpx`         | Replace npx          |
| `npm-install` | `pnpm install` | Install dependencies |
| `npm-run`     | `pnpm run`     | Run scripts          |
| `npm-start`   | `pnpm start`   | Start project        |
| `npm-test`    | `pnpm test`    | Run tests            |

---

## `vscprofiles`

Requires named profiles configured in **VSCode**.

| Alias    | Command                          | Description                       |
| -------- | -------------------------------- | --------------------------------- |
| `pycode` | `code . --profile python`        | Open project using Python profile |
| `spring` | `code . --profile "Java Spring"` | Open project using Spring profile |

---

# Uninstall

To completely remove the aliases configuration:

```bash
./uninstall.sh
```

This will:

* remove `~/.zsh_aliases`
* remove sourcing lines from `.zshrc`
* keep backups of modified files

Force uninstall:

```bash
./uninstall.sh --force
```

---

# Troubleshooting

### Aliases not working

Reload your shell:

```bash
source ~/.zshrc
```

Or restart the terminal.

---

### Check alias file location

Ensure the file exists:

```bash
ls -a ~ | grep zsh_aliases
```

---

### Restore backup

If something goes wrong, restore backups created during setup:

```
~/.zsh_aliases.backup.*
~/.zshrc.backup.*
```

---

# Contributing

Contributions are welcome.

You can:

* add useful aliases
* create new profiles
* improve scripts
* fix bugs

When adding profiles, follow the format:

```
# --- profile-name ---
```

so the installer can detect it correctly.

---

# License

MIT License
