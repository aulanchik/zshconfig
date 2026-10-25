# Personal zsh config files

Modular zsh aliases for macOS. Each group of aliases is a **profile**: one file in `profiles/`.
Enabling a profile symlinks it into `~/.zsh_aliases.d/`, and a small loader block in `~/.zshrc` sources everything in that folder.

## Layout

```
zshconfig/
├── setup.sh              # install / remove profiles
├── uninstall.sh          # remove everything
├── zshrc_loader.zsh      # block appended to ~/.zshrc
└── profiles/             # general, brew, git, pnpm, functions
```

## Install

```sh
git clone https://github.com/aulanchik/zshconfig.git
cd zshconfig
chmod +x setup.sh uninstall.sh
./setup.sh
source ~/.zshrc
```

Because profiles are symlinks, `git pull` in this repo updates your aliases without re-running setup.

## Options

```sh
./setup.sh                          # general profile only
./setup.sh --profiles=git,brew      # general + git + brew (short form: -p=git,brew)
./setup.sh --profiles=ALL           # everything in profiles/ (personal/ is never included)
./setup.sh --remove=git             # disable a profile (short form: -r=git)
./setup.sh --list-profiles          # show available profiles
./setup.sh --dry-run -p=git         # preview, change nothing
```

_Note:_ `general` profile is always installed. `~/.zshrc` is backed up (`~/.zshrc.backup.<timestamp>`) before the loader is added, and the loader is only added once.

## Add a profile (How to bring your own aliases)

1. Create `profiles/<name>.zsh`.
2. Make the first line `# profile: <name> - short description` (shown by `--list-profiles`).
3. Add your aliases or functions.
4. Run `./setup.sh --profiles=<name>`.

## Uninstall

```sh
./uninstall.sh          # asks for confirmation
./uninstall.sh --force  # no prompt
```

This removes the symlinks and the loader block, and keeps a backup of `~/.zshrc`.

## License

MIT
