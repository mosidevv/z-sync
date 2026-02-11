# ~/.custom_zsh_functions

# Function to push configuration files to the repository
function pushConf() {
    local original_dir=$(pwd)
    local date=$(date +"%Y-%m-%d")
    local custom_dir="$HOME/.oh-my-zsh/custom"
    local zshrc_file="$HOME/.zshrc"
    local vimrc_file="$HOME/.vimrc"
    local vscode_settings_file="$HOME/Library/Application Support/Code/User/settings.json"
    local vscode_keybindings_file="$HOME/Library/Application Support/Code/User/keybindings.json"
    local target_dir="$HOME/Documents/PRIVATE-Config"
    local target_custom_dir="$target_dir/custom"
    local target_vscode_dir="$target_dir/vscode"

    # Create target custom directory if it doesn't exist
    mkdir -p "$target_custom_dir"
    mkdir -p "$target_vscode_dir"
    
    # Copy files excluding the plugins directory
    rsync -av --delete --exclude 'plugins' "$custom_dir/" "$target_custom_dir/"
    cp "$zshrc_file" "$target_dir"
    cp "$vimrc_file" "$target_dir"
    cp "$vscode_settings_file" "$target_vscode_dir"
    cp "$vscode_keybindings_file" "$target_vscode_dir"
    # Navigate to the target directory
    cd "$target_dir" || { echo "Failed to navigate to target directory"; return 1; }

    # Git add, commit, and push
    git add .
    git commit -m "pushConf - $date"
    git push

    # Return to the original directory
    cd "$original_dir" || { echo "Failed to return to the original directory"; return 1; }
}

# Function to pull configuration files from the repository
function pullConf() {
    local original_dir=$(pwd)
    local origin_dir="$HOME/Documents/PRIVATE-Config"
    local origin_vscode_dir="$origin_dir/vscode"
    local origin_custom_dir="$origin_dir/custom"
    local origin_zshrc_file="$origin_dir/.zshrc"
    local origin_vimrc_file="$origin_dir/.vimrc"
    local origin_vscode_settings_file="$origin_vscode_dir/settings.json"
    local origin_vscode_keybindings_file="$origin_vscode_dir/keybindings.json"

    local target_custom_dir="$HOME/.oh-my-zsh/custom"
    local target_home_zshrc="$HOME/.zshrc"
    local target_home_vimrc="$HOME/.vimrc"
    local target_vscode_settings_file="$HOME/Library/Application Support/Code/User/settings.json"
    local target_vscode_keybindings_file="$HOME/Library/Application Support/Code/User/keybindings.json"

    # Navigate to the origin (backup) directory to pull updates
    cd "$origin_dir" || { echo "Failed to navigate to origin directory"; return 1; }

    # Git stash and pull
    git stash
    git pull

    # Copy/replace files from origin into the local target locations
    cp "$origin_zshrc_file" "$target_home_zshrc"
    cp "$origin_vimrc_file" "$target_home_vimrc"
    cp "$origin_vscode_settings_file" "$target_vscode_settings_file"
    cp "$origin_vscode_keybindings_file" "$target_vscode_keybindings_file"
    rsync -av --exclude 'plugins' "$origin_custom_dir/" "$target_custom_dir/"

    # Return to the original directory
    cd "$original_dir" || { echo "Failed to return to the original directory"; return 1; }
}
