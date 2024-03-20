#!/usr/bin/env zsh

# Install Homebrew if it isn't already installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not installed. Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Attempt to set up Homebrew PATH automatically for this session
    if [ -x "/opt/homebrew/bin/brew" ]; then
        # For Apple Silicon Macs
        echo "Configuring Homebrew in PATH for Apple Silicon Mac..."
        export PATH="/opt/homebrew/bin:$PATH"
    fi
else
    echo "Homebrew is already installed."
fi

# Verify brew is now accessible
if ! command -v brew &>/dev/null; then
    echo "Failed to configure Homebrew in PATH. Please add Homebrew to your PATH manually."
    exit 1
fi

# Update Homebrew and Upgrade any already-installed formulae
brew update
brew upgrade
brew upgrade --cask
brew cleanup


# Installing Oh My Zsh
echo "Installing Oh My Zsh"
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Installing powerLevel 10k
# Set ZSH_CUSTOM if not already set
if [ -z "$ZSH_CUSTOM" ]; then
    ZSH_CUSTOM="${ZSH:-$HOME/.oh-my-zsh}/custom"
fi

echo "Cloning Powerlevel10k theme into $ZSH_CUSTOM/themes/powerlevel10k"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Ensure ZSH_THEME is set to "powerlevel10k/powerlevel10k" without duplication or conflicting theme settings
if grep -q 'ZSH_THEME=' ~/.zshrc; then
    # If ZSH_THEME is already set, replace it
    sed -i '' 's/^ZSH_THEME=.*$/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
else
    # If ZSH_THEME is not set, add it
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
fi




# Define an array of packages to install using Homebrew.
packages=(
    "python"
    "bash"
    "zsh"
    "git"
    "wget"
    "tree"
    "pylint"
    "black"
    "node"
    "fzf"
    "zsh-history-substring-search"
    "maccy"
    "bat"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)

# Loop over the array to install each application.
for package in "${packages[@]}"; do
    if brew list --formula | grep -q "^$package\$"; then
        echo "$package is already installed. Skipping..."
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

# Add the Homebrew zsh to allowed shells
echo "Changing default shell to Homebrew zsh"
echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells >/dev/null
# Set the Homebrew zsh as default shell
chsh -s "$(brew --prefix)/bin/zsh"

# Git config name
echo "Please enter your FULL NAME for Git configuration:"
read git_user_name

# Git config email
echo "Please enter your EMAIL for Git configuration:"
read git_user_email

# Set my git credentials
$(brew --prefix)/bin/git config --global user.name "$git_user_name"
$(brew --prefix)/bin/git config --global user.email "$git_user_email"

# Create the tutorial virtual environment I use frequently
$(brew --prefix)/bin/python3 -m venv "${HOME}/tutorial"

# Install Prettier, which I use in both VS Code and Sublime Text
$(brew --prefix)/bin/npm install --global prettier

# Define an array of applications to install using Homebrew Cask.
apps=(
    "google-chrome"
    "brave-browser"
    "sublime-text"
    "visual-studio-code"
    "spotify"
    "numi"
    "warp"
    "pycharm-ce"
    "rectangle"
    "iterm2"
    "postman"
    "docker"
    "whatsapp"
    "raycast"
    "hiddenbar"
)

# Loop over the array to install each application.
for app in "${apps[@]}"; do
    if brew list --cask | grep -q "^$app\$"; then
        echo "$app is already installed. Skipping..."
    else
        echo "Installing $app..."
        brew install --cask "$app"
    fi
done

# Source zsh-history-substring-search and zsh-syntax-highlighting in .zshrc
echo "Adding zsh-history-substring-search and zsh-syntax-highlighting to .zshrc"

# Check if zsh-autosuggestions is already sourced in .zshrc and append if not
if ! grep -q "zsh-autosuggestions.zsh" ~/.zshrc; then
    echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    echo "zsh-autosuggestions sourced in .zshrc"
else
    echo "zsh-autosuggestions is already sourced in .zshrc"
fi

# Check if zsh-history-substring-search is already sourced in .zshrc and append if not
if ! grep -q "zsh-history-substring-search.zsh" ~/.zshrc; then
    echo "source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh" >> ~/.zshrc
    echo "zsh-history-substring-search sourced in .zshrc"
else
    echo "zsh-history-substring-search is already sourced in .zshrc"
fi

# Check if zsh-syntax-highlighting is already sourced in .zshrc and append if not
if ! grep -q "zsh-syntax-highlighting.zsh" ~/.zshrc; then
    echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
    echo "zsh-syntax-highlighting sourced in .zshrc"
else
    echo "zsh-syntax-highlighting is already sourced in .zshrc"
fi
# Install Source Code Pro Font
# Tap the Homebrew font cask repository if not already tapped
brew tap | grep -q "^homebrew/cask-fonts$" || brew tap homebrew/cask-fonts

# Define the font name
font_name="font-source-code-pro"

# Check if the font is already installed
if brew list --cask | grep -q "^$font_name\$"; then
    echo "$font_name is already installed. Skipping..."
else
    echo "Installing $font_name..."
    brew install --cask "$font_name"
fi

# Once font is installed, Import your Terminal Profile
echo "Import your terminal settings..."
echo "Terminal -> Settings -> Profiles -> Import..."
echo "Import from ${HOME}/dotfiles/settings/Pro.terminal"
echo "Press enter to continue..."
read

# Update and clean up again for safe measure
brew update
brew upgrade
brew upgrade --cask
brew cleanup

echo "Sign in to Google Chrome. Press enter to continue..."
read

echo "Sign in to Spotify. Press enter to continue..."
read

echo "Sign in to Discord. Press enter to continue..."
read

echo "Open Rectangle and give it necessary permissions. Press enter to continue..."
read

echo "Import your Rectangle settings located in ~/dotfiles/settings/RectangleConfig.json. Press enter to continue..."
read
