#!/usr/bin/env bash

# Ask for admin credentials
sudo -v

# Update and upgrade system
sudo apt update
sudo apt upgrade -y

# Install apps
apps=(
    curl
    entr
    git
    guake
    libnotify-bin
    python3-pip
    shellcheck
    silversearcher-ag
    texlive
    texlive-lang-german
    texlive-latex-extra
    thunderbird
    zsh
    zsh-syntax-highlighting
)

sudo apt install -y "${apps[@]}"

# Install Oh-My-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh --quiet --show-progress -O - | sed 's:env zsh -l::g' | sed 's:chsh -s .*$::g')"


# Create autostart file for guake
eval "cat /usr/share/guake/data/guake.template.desktop >> $HOME/.config/autostart/guake.desktop"


# Check if it's a notebook
if [ -d "/sys/class/power_supply" ]
then
    if ! type tlp &> /dev/null && ! type nvidia-settings &> /dev/null
    then
        sudo add-apt-repository ppa:linrunner/tlp
        sudo apt-get update
        sudo apt-get install -y tlp nvidia-driver-390
        sudo tlp start
    fi
    
    # Install libinput-gestures for swiping gestures
    if ! type libinput-gestures &> /dev/null
    then
        sudo gpasswd -a "$USER" input
        sudo apt-get install -y xdotool wmctrl libinput-tools
        
        cd ~ || return
        git clone https://github.com/bulletmark/libinput-gestures.git
        cd libinput-gestures || return
        sudo make install
        cd .. || return
        rm -rf libinput-gestures
        
        libinput-gestures-setup autostart
        libinput-gestures-setup start
    fi
fi

# Check if the installed desktop environment is KDE Plasma
if [  "$XDG_CURRENT_DESKTOP" == "KDE" ]; then
    # Install latte dock
    if ! type latte-dock &> /dev/null
    then
        sudo apt install -y cmake extra-cmake-modules qtdeclarative5-dev libqt5x11extras5-dev libkf5iconthemes-dev libkf5plasma-dev libkf5windowsystem-dev libkf5declarative-dev libkf5xmlgui-dev libkf5activities-dev build-essential libxcb-util-dev libkf5wayland-dev git gettext libkf5archive-dev libkf5notifications-dev libxcb-util0-dev libsm-dev libkf5crash-dev libkf5newstuff-dev
        
        cd ~ || return
        git clone https://github.com/KDE/latte-dock.git
        cd latte-dock || return
        sh install.sh
        cd .. || return
        rm -rf latte-dock
    fi
    
    # Overwrite kde settings
    cat "$HOME/Projects/dotfiles/kde/kcminputrc" > "$HOME/.config/kcminputrc"
    
    if [ -d "/sys/class/power_supply" ]
    then
        cat "$HOME/Projects/dotfiles/kde/kglobalshortcutsrc" > "$HOME/.config/kglobalshortcutsrc"
        cat "$HOME/Projects/dotfiles/kde/touchpadrc" > "$HOME/.config/touchpadrc"
    fi
    
fi

# Install VS Code
if ! code &> /dev/null
then
    sudo apt install apt-transport-https
    eval "wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -"
    
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    
    sudo apt install -y code
fi

# Install .net core
if dotnet &> /dev/null
then
    eval "wget -q https://packages.microsoft.com/config/ubuntu/18.10/packages-microsoft-prod.deb
    "
    sudo dpkg -i packages-microsoft-prod.deb
    
    sudo add-apt-repository universe
    sudo apt-get install apt-transport-https
    sudo apt-get update
    sudo apt-get install dotnet-sdk-2.2
fi

# Install NodeJS
if node &> /dev/null
then
    eval -c "curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -"
    sudo apt-get install -y nodejs
    
    if npm &> /dev/null
    then
        globaldir="$HOME/.config/.npm-global"
        mkdir "$globaldir"
        npm config set prefix "$globaldir"
        export PATH=$globaldir/bin:$PATH
        
        packages=(
            @angular/cli
            coinmon
            express-generator
            phantomjs
            tslint
            typescript
        )
        
        npm i -g "${packages[@]}"
    fi
fi

# Install VS Code extensions
if code &> /dev/null
then
    extensions=(
        Angular.ng-template
        DavidAnson.vscode-markdownlint
        donjayamanne.githistory
        dracula-theme.theme-dracula
        eamodio.gitlens
        eg2.tslint
        James-Yu.latex-workshop
        ms-vscode.csharp
        ms-vsliveshare.vsliveshare
        PKief.material-icon-theme
        quicktype.quicktype
        ritwickdey.LiveServer
        shakram02.bash-beautify
        shd101wyy.markdown-preview-enhanced
        sidneys1.gitconfig
        streetsidesoftware.code-spell-checker
        streetsidesoftware.code-spell-checker-german
        timonwong.shellcheck
        Tyriar.sort-lines
        vmsynkov.colonize
        yycalm.linecount
    )
    for extension in ${extensions[*]}
    do
        code --install-extension "$extension"
    done
fi

# Install youtube-dl
if python3-pip &> /dev/null
then
    pip3 install --upgrade youtube-dl
    echo '--output "~/Music/%(title)s.%(ext)s"' > "/home/$USER/.config/youtube-dl.conf"
fi

# Check if Linux/Windows dual boot system to adjust time
windows=$(sudo os-prober)
if [[ $windows == *"Windows"* ]]; then
    timedatectl set-local-rtc 1 --adjust-system-clock
fi

# Create symbolic links

# git
gitconfig="$HOME/Projects/dotfiles/git/.gitconfig"
gitconfig_location="$HOME/.gitconfig"
ln -sfn "$gitconfig" "$gitconfig_location"

# guake
guake="$HOME/Projects/dotfiles/guake/user"
guake_location="$HOME/.config/dconf/user"
ln -sfn "$guake" "$guake_location"

# nano
nanorc="$HOME/Projects/dotfiles/nano/.nanorc"
nanorc_location="$HOME/.nanorc"
ln -sfn "$nanorc" "$nanorc_location"

# VS Code
vscode_settings="$HOME/Projects/dotfiles/vscode/settings.json"
vscode_settings_location="$HOME/.config/Code/User/settings.json"
ln -sfn "$vscode_settings" "$vscode_settings_location"

vscode_keybindings="$HOME/Projects/dotfiles/vscode/keybindings.json"
vscode_keybindings_location="$HOME/.config/Code/User/keybindings.json"
ln -sfn "$vscode_keybindings" "$vscode_keybindings_location"

# zsh
zshrc="$HOME/Projects/dotfiles/zsh/.zshrc"
zshrc_location="$HOME/.zshrc"
ln -sfn "$zshrc" "$zshrc_location"

theme="$HOME/Projects/dotfiles/zsh/nidzo.zsh-theme"
theme_location="$HOME/.oh-my-zsh/themes/nidzo.zsh-theme"
ln -sfn "$theme" "$theme_location"

# Dotfiles dir with git
mkdir "$HOME/Projects/temp"
cd "$HOME/Projects" || return
git clone https://github.com/nidzov/dotfiles.git "$HOME/Projects/temp"
mv "$HOME/Projects/temp/.git" "$HOME/Projects/dotfiles"
rm -rf "$HOME/Projects/temp"
