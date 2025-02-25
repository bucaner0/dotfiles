#!/usr/bin/env zsh
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# And also installs MacOS Software
# And also installs Homebrew Packages and Casks (Apps)
# And also sets up VS Code
############################


# Run the Homebrew Script
./brew.sh

# Run the macOs Script
./macOS.sh

# Run VS Code Script
./vscode.sh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "==========================================================="
echo "             cloning zsh-autosuggestions                   "
echo "-----------------------------------------------------------"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo "==========================================================="
echo "             cloning zsh-syntax-highlighting               "
echo "-----------------------------------------------------------"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo "==========================================================="
echo "             cloning powerlevel10k                         "
echo "-----------------------------------------------------------"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# dotfiles directory
dotfiledir="${HOME}/.dotfiles"

# list of files/folders to symlink in ${homedir}
files=(zshrc zprofile aliases p10k.zsh)

# change to the dotfiles directory
echo "Changing to the ${dotfiledir} directory"
cd "${dotfiledir}" || exit

# create symlinks (will overwrite old dotfiles)
rm -rf $HOME/.zshrc
for file in "${files[@]}"; do
    echo "Creating symlink to $file in home directory."
    ln -sf "${dotfiledir}/.${file}" "${HOME}/.${file}"
done

echo "Installation Complete!"
