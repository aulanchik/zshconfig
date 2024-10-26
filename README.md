This repository contains minimalistic dev configuration alias files to be productive with `zsh` terminal on MacOS.

### Explaining the problem

In order to contain cleaniness of `~/.zshrc` file we're going to use `~/.zsh_aliases` file as a primary source file.

### Setup

1. Open the terminal and make sure you're in the home directory:
    Running `pwd` terminal command should respond with `/Users/<username>/`. In case of the failure, run `cd ~`

2. Copy the `~/.zsh_aliases` file from this cloned repository to your home directory using the terminal:
    `cp .zsh_aliases ~/.zsh_aliases`
3. 

### Notes

Configuration files are not meant to be finite and therefore editing and saving changes will require to perform `source <filename>` command to make system aware about the changes in configuration files. In case of failure running `source <filename>` command latest changes will be reverted to previous state.
