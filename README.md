# Personal zsh aliases configuration file

This repository provides a minimalistic set of developer configuration aliases to enhance productivity with the `zsh` terminal on macOS. The primary goal is to keep your main `~/.zshrc` file clean by sourcing aliases from a dedicated `~/.zsh_aliases` file.

## Setup

To set up the zsh aliases, run the setup script from the repository directory:

```sh
./setup.sh
```

This script will automatically copy the alias file to your home directory, update your `.zshrc`, and apply the changes.

If you encounter any issues or prefer manual setup, you can follow these steps:

1. Copy `.zsh_aliases` to your home directory: `cp .zsh_aliases ~/.zsh_aliases`
2. Append the contents of `.zshrc_edit` to your `~/.zshrc`: `cat .zshrc_edit >> ~/.zshrc`
3. Reload your shell: `source ~/.zshrc`

## Usage
Once the setup is complete, you can start using the shorthand aliases in your terminal. For example, instead of typing `cd ..`, you can simply use `.`.

You can customize the `.zsh_aliases` file at any time to add, remove, or modify aliases. Just remember to reload your shell with `source ~/.zshrc` after making changes.

## Available Aliases

Here is a list of aliases included in the `.zsh_aliases` file.

### General
| Alias | Command | Description |
| :--- | :--- | :--- |
| `.` | `cd ..` | Go up one directory. |
| `..` | `cd ../../` | Go up two directories. |
| `awake` | `caffeinate -d` | Prevent the Mac from sleeping. |

### Homebrew
| Alias | Command | Description |
| :--- | :--- | :--- |
| `bi` | `brew install` | Install a formula. |
| `bic` | `brew install --cask` | Install a cask. |
| `bup` | `brew update` | Update Homebrew. |
| `bupg` | `brew upgrade` | Upgrade all outdated packages. |
| `blist` | `brew list` | List all installed packages. |
| `bfull`| `brew update && brew upgrade && brew cleanup --prune=all` | Perform a full update, upgrade, and cleanup. |

### Git
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

### PNPM
These aliases forward `npm` commands to `pnpm` to help preserve disk space.
| Alias | Command | Description |
| :--- | :--- | :--- |
| `npm` | `pnpm` | Use `pnpm` instead of `npm`. |
| `npx`| `pnpx`| Use `pnpx` instead of `npx`. |
| `npm-install` | `pnpm install` | Install dependencies using `pnpm`. |
| `npm-run` | `pnpm run` | Run a script using `pnpm`. |
| `npm-start` | `pnpm start` | Run the start script using `pnpm`. |
| `npm-test` | `pnpm test` | Run tests using `pnpm`. |

### VSCode Profiles
This requires you to have named profiles set up in VSCode first.
| Alias | Command | Description |
| :--- | :--- | :--- |
| `pycode` | `code . --profile python` | Open the current directory in VSCode using the 'python' profile. |

## Troubleshooting

-   **Changes not applied:** If your aliases aren't working, ensure you have correctly added the sourcing line to your `~/.zshrc` file and have reloaded your shell with `source ~/.zshrc`.
-   **File location:** Confirm that the `.zsh_aliases` file is located in your home directory (`~`). You can verify this by running `ls -a ~` and checking for the file in the output list.

## Contributing

Feel free to submit issues or pull requests for additional aliases, fixes, or improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
