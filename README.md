This repository contains minimalistic dev configuration alias files to be productive with `zsh` terminal on MacOS. 

### Explaining the problem

In order to contain cleaniness of `~/.zshrc` file we're going to use `~/.zsh_aliases` file as a primary source file.

### Setup

1. Open the terminal and make sure you're in the home directory:
    Running `pwd` terminal command should respond with `/Users/<username>/`. In case of the failure, run `cd ~`

2. Copy the `.zsh_aliases` file from this cloned repository to your home directory:
    `cp .zsh_aliases ~/.zsh_aliases`

3. Append the contents of `.zshrc_edit` to your `~/.zshrc` file:
    `cat .zshrc_edit >> ~/.zshrc`

4. Reload your `~/.zshrc` and `~/.zshrc_aliases` files to apply the changes:
    `source ~/.zshrc && source ~/.zshrc_aliases`

### Usage

Upon successful setup outcome, you will be able to execute aliases without typing out entire command. As an example try using `.` and it should return with folder name that is level above of your current directory.

Now, you can use all the aliases specified in `.zsh_aliases` right from your terminal. Customize .zsh_aliases anytime to add or update aliases, and simply reload `~/.zshrc` to see the changes.


###  Troubleshooting

- **Changes not applied:** If your aliases are not recognized, ensure that you’ve correctly sourced `~/.zsh_aliases` in your `~/.zshrc` file and that `source ~/.zshrc` was run.
- **File location:** Confirm that `.zsh_aliases` is in the the home directory after executing step 2 in setup section. Make sure file is there by running `ls -a ~` to list all hidden files.

### Notes

Configuration files are not meant to be finite and therefore editing and saving changes will require to perform `source <filename>` command to make system aware about the changes in configuration files.
In case of failure running `source <filename>` command latest changes will be reverted to previous state.

### Contributions

Feel free to submit issues or pull requests for additional aliases, fixes, or improvements. Happy coding!
