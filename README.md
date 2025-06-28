# Personal zsh aliases configuration file

This repository provides a minimalistic set of developer configuration aliases to enhance productivity with the `zsh` terminal on macOS. The primary goal is to keep your main `~/.zshrc` file clean by sourcing aliases from a dedicated `~/.zsh_aliases` file.

## Setup

Follow these steps to set up the configuration.

1.  **Navigate to your home directory.**
    Open your terminal and run `pwd`. It should output `/Users/<username>`. If not, run `cd ~` to go to your home directory.

2.  **Copy the alias file.**
    Copy the `.zsh_aliases` file from this repository to your home directory.
    ```sh
    cp .zsh_aliases ~/.zsh_aliases
    ```

3.  **Update your `.zshrc`.**
    Append the sourcing logic from `.zshrc_edit` to your existing `~/.zshrc` file. This ensures that your aliases are loaded every time you open a new terminal session.
    ```sh
    cat .zshrc_edit >> ~/.zshrc
    ```
    This adds the following lines to your `.zshrc`:
    ```sh
    # Seeks for `.zsh_aliases` file in home directory
    # In case of success, source it
    if [ -f "$HOME/.zsh_aliases" ]; then
        source "$HOME/.zsh_aliases"
    fi
    ```

4.  **Apply the changes.**
    Reload your shell configuration to make the new aliases available immediately.
    ```sh
    source ~/.zshrc
    ```

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
