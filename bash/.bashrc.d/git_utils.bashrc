#!/bin/bash

# quickcommit - quickly create a git commit, for when message does not matter
quickcommit() {
    if [[ $(git status --porcelain) ]]; then
        if confirm "Are you sure you want to create an autocommit?"; then
            git add .
            git commit -m 'Autocommit'
            git push
        fi
    else
        echo "No changes to commit."
    fi
}
