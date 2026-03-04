# Personal zsh aliases configuration file

This repository provides a minimalistic set of developer configuration aliases to enhance productivity with the `zsh` terminal on macOS. The primary goal is to keep your main `~/.zshrc` file clean by sourcing aliases from a dedicated `~/.zsh_aliases` file.

The setup script now supports **profile selection**, allowing you to install only the specific alias groups you need (e.g., just Git and Homebrew) or everything at once.

## Setup

### Quick Start (Default)
To set up with only the **General** aliases (safe defaults), run:

```sh
./setup.sh
```

### Custom Profiles
You can select specific alias groups using the `--profiles` flag. Available profiles: `general`, `brew`, `git`, `pnpm`, `vscode`.

**Install specific profiles:**
```sh
# Install only Git and Homebrew aliases
./setup.sh --profiles=git,brew

# Install PNPM and VSCode profiles
./setup.sh -p=pnpm,vscprofiles
```

**Install ALL profiles:**
```sh
# Install every available alias group
./setup.sh --profiles=ALL
```

### Manual Setup
If you encounter any issues or prefer manual setup, you can follow these steps:

1. Copy `.zsh_aliases` to your home directory: `cp .zsh_aliases ~/.zsh_aliases`
2. Append the contents of `.zshrc_edit` to your `~/.zshrc`: `cat .zshrc_edit >> ~/.zshrc`
3. Reload your shell: `source ~/.zshrc`

*Note: For manual setup, you may want to edit `.zsh_aliases` manually to remove sections you don't need before copying.*

## Usage
Once the setup is complete, you can start using the shorthand aliases in your terminal. For example, instead of typing `cd ..`, you can simply use `.`.

You can customize the `.zsh_aliases` file at any time to add, remove, or modify aliases. Just remember to reload your shell with `source ~/.zshrc` after making changes.

To change your active profile later, simply re-run the setup script with different arguments (e.g., `./setup.sh --profiles=ALL`).

## Available Profiles & Aliases

The following profiles correspond to the sections in the `.zsh_aliases` file.

### `general` (Default)
| Alias | Command | Description |
| :--- | :--- | :--- |
| `.` | `cd ..` | Go up one directory. |
| `..` | `cd ../../` | Go up two directories. |
| `awake` | `caffeinate -d` | Prevent the Mac from sleeping. |

### `brew`
| Alias | Command | Description |
| :--- | :--- | :--- |
| `bi` | `brew install` | Install a formula. |
| `bic` | `brew install --cask` | Install a cask. |
| `bup` | `brew update` | Update Homebrew. |
| `bupg` | `brew upgrade` | Upgrade all outdated packages. |
| `blist` | `brew list` | List all installed packages. |
| `bfull`| `brew update && brew upgrade && brew cleanup --prune=all` | Perform a full update, upgrade, and cleanup. |

### `git`
| Alias | Command | Description |
| :--- | :--- | :--- |
| `ga` | `git add --all` | Stage all changes. |
| `gb` | `git branch` | List all branches. |
| `gc` | `git clone` | Clone a repository. |
| `gcm` | `git commit -m` | Commit with a message. |
| `gco` | `git checkout` | Switch branches. |
| `gf` | `git fetch` | Fetch changes from the remote. |
| `gp` | `git pull` | Pull changes from the remote. |
| `gd` | `git diff` | Show changes. |
| `gl` | `git log` | View commit history. |
| `gle` | `git log --graph ...` | Display a formatted and decorated git log tree. |

### `pnpm`
These aliases forward `npm` commands to `pnpm` to help preserve disk space.
| Alias | Command | Description |
| :--- | :--- | :--- |
| `npm` | `pnpm` | Use `pnpm` instead of `npm`. |
| `npx`| `pnpx`| Use `pnpx` instead of `npx`. |
| `npm-install` | `pnpm install` | Install dependencies using `pnpm`. |
| `npm-run` | `pnpm run` | Run a script using `pnpm`. |
| `npm-start` | `pnpm start` | Run the start script using `pnpm`. |
| `npm-test` | `pnpm test` | Run tests using `pnpm`. |

### `vscprofiles`
This requires you to have named profiles set up in VSCode first.
| Alias | Command | Description |
| :--- | :--- | :--- |
| `pycode` | `code . --profile python` | Open the current directory in VSCode using the 'python' profile. |

## Troubleshooting

-   **Changes not applied:** If your aliases aren't working, ensure you have correctly added the sourcing line to your `~/.zshrc` file and have reloaded your shell with `source ~/.zshrc`.
-   **File location:** Confirm that the `.zsh_aliases` file is located in your home directory (`~`). You can verify this by running `ls -a ~` and checking for the file in the output list.
-   **Missing aliases after update:** If you switched profiles (e.g., from `general` to `ALL`) and don't see new aliases, try restarting your terminal completely or running `source ~/.zshrc`.
-   **Syntax Errors:** The setup script performs a basic syntax check on `.zshrc`. If it fails, restore from the automatic backup created in your home directory (look for `.zshrc.backup.*`).

## Contributing

Feel free to submit issues or pull requests for additional aliases, fixes, or improvements. If adding new sections to `.zsh_aliases`, please ensure the header comment matches the format `# <Profile Name>` so the setup script can detect it.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
