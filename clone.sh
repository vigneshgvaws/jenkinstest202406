#!/bin/bash

# Input release name
RELEASE_NAME="S_7.7.0.25.01"

# Function to clone or update a repository
clone_or_update_repo() {
    REPO_URL="$1"
    REPO_NAME=$(basename "$REPO_URL" ".git")
    
    if [ -d "$REPO_NAME" ]; then
        # Repository already exists, update it
        echo "Updating $REPO_NAME..."
        cd "$REPO_NAME" || exit
        git pull
        cd ..
    else
        # Repository doesn't exist, clone it
        echo "Cloning $REPO_URL..."
        git clone "$REPO_URL"
    fi
}

# Function to check out a branch in a repository
checkout_branch() {
    REPO_PATH="$1"
    BRANCH_NAME="$2"

    echo "Checking out $BRANCH_NAME in $REPO_PATH..."
    cd "$REPO_PATH" || exit
    git checkout "$BRANCH_NAME"
    cd ..
}

# Array of repository URLs
REPO_URLS=(
    "https://github.com/example/repo1.git"
    "https://github.com/example/repo2.git"
    # Add more repository URLs as needed
)

# Clone or update all repositories
for URL in "${REPO_URLS[@]}"; do
    clone_or_update_repo "$URL"
done

# Check out branches related to the release name
for URL in "${REPO_URLS[@]}"; do
    REPO_NAME=$(basename "$URL" ".git")
    checkout_branch "$REPO_NAME" "$RELEASE_NAME"
done

# Create a zip file for the release
echo "Creating release zip file..."
zip -r "$RELEASE_NAME.zip" *
