#!/usr/bin/env bash

###############################
## Ask for admin credentials ##
###############################

sudo -v

echo -ne '                                                                                       0%\r'

##########################
## Install apt packages ##
##########################

apps=(
    curl                    # Make sure curl is installed
    entr                    # Rebuild project if sources change
    ffmpeg                  # Needed for youtube-dl to work
    fzf                     # General-purpose command-line fuzzy finder
    git                     # Versioncontrol
    neovim                  # Text editor
    python3-pip             # Python package manager
    silversearcher-ag       # A code searching tool
    ripgrep                 # Search tool
    translate-shell         # Command-line translator
    zsh                     # Shell
    zsh-syntax-highlighting # Syntax highlighting for zsh
    xsel                    # Clipboard support in cli
)

sudo apt-get install -y "${apps[@]}" || true

echo -ne '########                                                                              10%\r'

##########################################
## Install youtube-dl, pylint, autopep8 ##
##########################################

# Check if pip3 is installed
if type "pip3" &>/dev/null; then
    pip3 install youtube-dl pylint autopep8 pandocfilters jupyter pandas eyed3

    echo '--output "~/Downloads/%(title)s.%(ext)s"' >"/home/$USER/.config/youtube-dl.conf"
fi

echo -ne "################                                                                      20%\r"
echo -ne "########################                                                              30%\r"
echo -ne "################################################                                      60%\r"

#######################
## Install Oh-My-zsh ##
#######################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

echo -ne "########################################################                              70%\r"
echo -ne "################################################################                      80%\r"


###########################
## Create symbolic links ##
###########################

# git
gitconfig="$HOME/dev/dotfiles/git/.gitconfig"
gitconfig_location="$HOME/.gitconfig"
ln -sfn "$gitconfig" "$gitconfig_location"

# nano
nanorc="$HOME/dev/dotfiles/nano/.nanorc"
nanorc_location="$HOME/.nanorc"
ln -sfn "$nanorc" "$nanorc_location"

# neovim
neovim_init="$HOME/dev/dotfiles/nvim/init.vim"
coc_settings="$HOME/dev/dotfiles/nvim/coc-settings.json"
plug_config="$HOME/dev/dotfiles/nvim/plug-config"

neovim_init_location="$HOME/.config/nvim/init.vim"
coc_settings_location="$HOME/.config/nvim/coc-settings.json"
plug_config_location="$HOME/.config/nvim/plug-config"

ln -sfn "$neovim_init" "$neovim_init_location"
ln -sfn "$coc_settings" "$coc_settings_location"
ln -sfn "$plug_config" "$plug_config_location"

# zsh
zshrc="$HOME/dev/dotfiles/zsh/.zshrc"
zshrc_location="$HOME/.zshrc"
ln -sfn "$zshrc" "$zshrc_location"

theme="$HOME/dev/dotfiles/zsh/nidzo.zsh-theme"
theme_location="$HOME/.oh-my-zsh/themes/nidzo.zsh-theme"
ln -sfn "$theme" "$theme_location"

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Dotfiles dir with git
mkdir "$HOME/dev/temp"
cd "$HOME/dev" || return
git clone -b wsl https://github.com/ndz-v/dotfiles.git "$HOME/dev/temp"
mv "$HOME/dev/temp/.git" "$HOME/dev/dotfiles"
rm -rf "$HOME/dev/temp"

# Change remote url of dotfiles
cd "$HOME/dev/dotfiles" || return
git remote set-url origin git@github.com:ndz-v/dotfiles.git

echo -ne "################################################################################      95%\r"
echo -ne "#################################################################################### 100%\r"
echo -ne "\n"
