#!/usr/bin/env zsh

# Check if Homebrew's bin exists and if it's not already in the PATH
if [ -x "/opt/homebrew/bin/brew" ] && [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Install VS Code Extensions
extensions=(
    amazonwebservices.aws-toolkit-vscode
    angular.ng-template
    anseki.vscode-color
    bmewburn.vscode-intelephense-client
    dbaeumer.vscode-eslint
    devsense.composer-php-vscode
    devsense.intelli-php-vscode
    devsense.phptools-vscode
    devsense.profiler-php-vscode
    editorconfig.editorconfig
    esbenp.prettier-vscode
    github.copilot
    github.copilot-chat
    golang.go
    hashicorp.terraform
    ms-vscode-remote.remote-containers
    ms-vsliveshare.vsliveshare
    redhat.vscode-commons
    redhat.vscode-xml
    redhat.vscode-yaml
    streetsidesoftware.code-spell-checker
    uctakeoff.vscode-counter
    wallabyjs.quokka-vscode
    xdebug.php-debug
    yoavbls.pretty-ts-errors
)

# Get a list of all currently installed extensions.
installed_extensions=$(code --list-extensions)

for extension in "${extensions[@]}"; do
    if echo "$installed_extensions" | grep -qi "^$extension$"; then
        echo "$extension is already installed. Skipping..."
    else
        echo "Installing $extension..."
        code --install-extension "$extension"
    fi
done

echo "VS Code extensions have been installed."

# Define the target directory for VS Code user settings on macOS
VSCODE_USER_SETTINGS_DIR="${HOME}/Library/Application Support/Code/User"

# Check if VS Code settings directory exists
if [ -d "$VSCODE_USER_SETTINGS_DIR" ]; then
    # Copy your custom settings.json and keybindings.json to the VS Code settings directory
    ln -sf "${HOME}/.dotfiles/settings/VSCode-Settings.json" "${VSCODE_USER_SETTINGS_DIR}/settings.json"
    ln -sf "${HOME}/.dotfiles/settings/VSCode-Keybindings.json" "${VSCODE_USER_SETTINGS_DIR}/keybindings.json"

    echo "VS Code settings and keybindings have been updated."
else
    echo "VS Code user settings directory does not exist. Please ensure VS Code is installed."
fi

# Open VS Code to sign-in to extensions
code .
echo "Login to extensions (Copilot, Grammarly, etc) within VS Code."
echo "Press enter to continue..."
read
