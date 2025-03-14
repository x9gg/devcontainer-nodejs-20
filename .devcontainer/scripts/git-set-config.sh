#!/bin/bash
# ~/scripts/git-set-config.sh

git-set-config() {
    local email="$1"
    local name="$2"
    
    # If no parameters are provided, show usage
    if [ -z "$email" ] || [ -z "$name" ]; then
        echo "Usage: git-set-config <email> <name>"
        echo "Example: git-set-config 'user@example.com' 'First Last'"
        return 1
    fi
    
    # Set user name and email
    git config user.name "$name"
    git config user.email "$email"
    echo "GitHub config set for user $name ($email) in current repository."
    
    # Find GPG key for the email
    local gpg_key
    gpg_key=$(gpg --list-secret-keys --keyid-format LONG "$email" 2>/dev/null | grep '^sec' | awk '{print $2}' | cut -d'/' -f2)
    
    if [ -n "$gpg_key" ]; then
        git config user.signingkey "$gpg_key"
        git config commit.gpgSign true
        git config tag.gpgSign true
        git config push.gpgSign false
        echo "GPG signing key set to $gpg_key."
    else
        echo "No GPG key found for $email."
    fi
    
    # Set some recommended Git configurations
    git config core.editor "vim" # or your preferred editor
    git config core.autocrlf input
    git config pull.rebase true
    git config fetch.prune true
    git config rebase.autoStash true
    git config color.ui true
    git config core.ignorecase false
    echo "Additional Git configurations set for best practices."
}
